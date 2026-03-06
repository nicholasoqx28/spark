import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';
import '../models/user.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? error;

  const AuthState({required this.status, this.user, this.error});
  const AuthState.loading() : this(status: AuthStatus.loading);
  const AuthState.unauthenticated({String? error})
      : this(status: AuthStatus.unauthenticated, error: error);
  const AuthState.authenticated(AppUser user)
      : this(status: AuthStatus.authenticated, user: user);

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
}

Role _parseRole(String r) => switch (r) {
      'ADMIN' => Role.admin,
      'ATHLETE' => Role.athlete,
      _ => Role.enthusiast,
    };

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(apiClientProvider)),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _api;
  final _storage = const FlutterSecureStorage();

  AuthNotifier(this._api) : super(const AuthState.loading()) {
    _restore();
  }

  Future<void> _restore() async {
    try {
      final stored = await _storage.read(key: 'user_json');
      if (stored != null) {
        final parts = stored.split('|');
        if (parts.length == 4) {
          state = AuthState.authenticated(AppUser(
            id: parts[0],
            name: parts[1],
            email: parts[2],
            role: _parseRole(parts[3]),
          ));
          return;
        }
      }
    } catch (_) {}
    state = const AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final csrfRes = await _api.get<Map<String, dynamic>>('/api/auth/csrf');
      final csrfToken =
          (csrfRes.data as Map<String, dynamic>)['csrfToken'] as String;

      await _api.post<dynamic>(
        '/api/auth/callback/credentials',
        data: {
          'csrfToken': csrfToken,
          'email': email,
          'password': password,
          'redirect': 'false',
          'json': 'true',
        },
      );

      final sessionRes =
          await _api.get<Map<String, dynamic>>('/api/auth/session');
      final userData =
          (sessionRes.data as Map<String, dynamic>)['user'] as Map<String, dynamic>?;

      if (userData == null) {
        state = const AuthState.unauthenticated(error: 'Invalid email or password.');
        return;
      }

      final user = AppUser.fromJson(userData);
      await _persistUser(user);
      state = AuthState.authenticated(user);
    } on DioException catch (e) {
      state = AuthState.unauthenticated(
          error: _extractError(e) ?? 'Login failed. Please try again.');
    }
  }

  Future<void> register(
      String name, String email, String password, String role) async {
    state = const AuthState.loading();
    try {
      await _api.post<dynamic>('/api/auth/register',
          data: {'name': name, 'email': email, 'password': password, 'role': role});
      await login(email, password);
    } on DioException catch (e) {
      state = AuthState.unauthenticated(
          error: _extractError(e) ?? 'Registration failed. Please try again.');
    }
  }

  Future<void> logout() async {
    try {
      await _api.post<dynamic>('/api/auth/signout', data: {'callbackUrl': '/'});
    } catch (_) {}
    await _api.clearToken();
    await _storage.delete(key: 'user_json');
    state = const AuthState.unauthenticated();
  }

  Future<void> _persistUser(AppUser user) async {
    await _storage.write(
      key: 'user_json',
      value: '${user.id}|${user.name}|${user.email}|${user.roleLabel}',
    );
  }

  String? _extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map) return data['error'] as String?;
    } catch (_) {}
    return null;
  }
}
