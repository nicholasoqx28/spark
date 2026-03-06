import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/models/user.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ Spark'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Sign out'),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.name}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Signed in as ${user.roleLabel}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _DashCard(
              icon: '🏆',
              title: 'Tournaments',
              description:
                  'Browse upcoming events and manage your registrations.',
              onTap: () => context.go('/tournaments'),
            ),
            const SizedBox(height: 12),
            _DashCard(
              icon: '🛒',
              title: 'Shop',
              description: 'Explore gear and track your orders.',
              onTap: () => context.go('/shop'),
            ),
            const SizedBox(height: 12),
            _DashCard(
              icon: '🎓',
              title: 'Academy',
              description: 'Continue your training courses.',
              onTap: () => context.go('/academy'),
            ),
            if (user.isAdmin) ...[
              const SizedBox(height: 12),
              _DashCard(
                icon: '⚙️',
                title: 'Admin Panel',
                description: 'Manage tournaments, products, and users.',
                onTap: () => context.go('/admin'),
                highlight: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final bool highlight;

  const _DashCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: highlight
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
}
