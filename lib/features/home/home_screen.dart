import 'dart:ui';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Remove nested Scaffold to avoid layout conflicts with MainScaffold
    // Use Container as the root
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Theme.of(context).primaryColor.withOpacity(0.2),
            Colors.black,
          ],
        ),
      ),
      child: ListView(
        // Add top padding for status bar and bottom padding for BottomAppBar
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top + 16,
          16,
          100, // Space for BottomAppBar
        ),
        children: [
          const _AppHeaderInfo(),
          const SizedBox(height: 24),
          Text(
            'LATEST EVENTS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 12),
          const _EventCard(
            title: 'Double Star Rating!',
            subtitle: 'Get 2x stars this weekend.',
            icon: Icons.star,
            color: Colors.amber,
          ),
          const _EventCard(
            title: 'New Series Launch',
            subtitle: 'Series 4 is now available in arcades.',
            icon: Icons.new_releases,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 24),
          Text(
            'QUICK ACTIONS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Expanded(
                child: _QuickActionCard(
                  label: 'Type Calc',
                  icon: Icons.calculate,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _QuickActionCard(label: 'My Tags', icon: Icons.style),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppHeaderInfo extends StatelessWidget {
  const _AppHeaderInfo();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.info_outline, size: 30),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MezaHelper v1.0',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Welcome back, Trainer!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _EventCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String label;
  final IconData icon;

  const _QuickActionCard({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
