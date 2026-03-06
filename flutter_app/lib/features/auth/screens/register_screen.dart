import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../shared/widgets/error_banner.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _role = 'ENTHUSIAST';
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(authProvider.notifier).register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
          _role,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final isLoading = auth.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('⚡', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(
                      'Create your account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('Already have an account? ',
                            style: TextStyle(color: Colors.grey)),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                                color: Color(0xFF4F46E5),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    if (auth.error != null) ...[
                      ErrorBanner(auth.error!),
                      const SizedBox(height: 16),
                    ],

                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: 'Full name'),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordCtrl,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obscure ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                      obscureText: _obscure,
                      validator: (v) => (v == null || v.length < 8)
                          ? 'Password must be at least 8 characters'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _role,
                      decoration: const InputDecoration(labelText: 'I am a…'),
                      items: const [
                        DropdownMenuItem(
                          value: 'ENTHUSIAST',
                          child: Text('Enthusiast — casual fan & shopper'),
                        ),
                        DropdownMenuItem(
                          value: 'ATHLETE',
                          child: Text('Athlete — active competitor'),
                        ),
                      ],
                      onChanged: (v) => setState(() => _role = v ?? _role),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: isLoading ? null : _submit,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Create account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
