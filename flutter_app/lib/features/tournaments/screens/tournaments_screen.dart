import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_client.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/models/tournament.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/loading_overlay.dart';
import '../../../shared/widgets/spark_badge.dart';
import 'package:intl/intl.dart';

final _tournamentsProvider = FutureProvider<List<Tournament>>((ref) async {
  final api = ref.read(apiClientProvider);
  final res = await api.get<List<dynamic>>('/api/tournaments');
  return (res.data as List).map((j) => Tournament.fromJson(j as Map<String, dynamic>)).toList();
});

class TournamentsScreen extends ConsumerWidget {
  const TournamentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTournaments = ref.watch(_tournamentsProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournaments'),
        leading: BackButton(onPressed: () => Navigator.of(context).maybePop()),
      ),
      body: asyncTournaments.when(
        loading: () => const LoadingOverlay(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (tournaments) {
          if (tournaments.isEmpty) {
            return const Center(
              child: Text('No tournaments available yet.',
                  style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: tournaments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) =>
                _TournamentCard(tournament: tournaments[i], user: user),
          );
        },
      ),
    );
  }
}

class _TournamentCard extends ConsumerStatefulWidget {
  final Tournament tournament;
  final dynamic user;

  const _TournamentCard({required this.tournament, required this.user});

  @override
  ConsumerState<_TournamentCard> createState() => _TournamentCardState();
}

class _TournamentCardState extends ConsumerState<_TournamentCard> {
  bool _registering = false;

  Future<void> _register() async {
    final teamName = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final ctrl = TextEditingController();
        return AlertDialog(
          title: const Text('Register your team'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(labelText: 'Team name'),
            autofocus: true,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Register'),
            ),
          ],
        );
      },
    );

    if (teamName == null || teamName.isEmpty) return;
    setState(() => _registering = true);

    try {
      final api = ref.read(apiClientProvider);
      await api.post<dynamic>(
        '/api/tournaments/${widget.tournament.id}/register',
        data: {'teamName': teamName},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully!')),
        );
        ref.invalidate(_tournamentsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _registering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tournament;
    final fmt = DateFormat('d MMM yyyy');
    final canRegister = widget.user?.isAthlete == true && !t.isFull && t.status == 'UPCOMING';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(t.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                SparkBadge(label: t.status, color: statusColor(t.status)),
              ],
            ),
            const SizedBox(height: 6),
            Text(t.sport,
                style: const TextStyle(
                    color: Color(0xFF4F46E5), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _InfoRow(Icons.location_on_outlined, t.location),
            _InfoRow(Icons.calendar_today_outlined,
                '${fmt.format(t.startDate)} — ${fmt.format(t.endDate)}'),
            _InfoRow(Icons.group_outlined,
                '${t.registrationCount} / ${t.maxTeams} teams'),
            if (canRegister) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _registering ? null : _register,
                  child: _registering
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Register'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey),
            const SizedBox(width: 6),
            Expanded(
              child: Text(text, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ),
          ],
        ),
      );
}
