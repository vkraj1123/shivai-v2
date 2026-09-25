import 'package:flutter/material.dart';
import 'adaptive_engine.dart';
import 'models.dart';

void main() => runApp(const ShivaiApp());

class ShivaiApp extends StatelessWidget {
  const ShivaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHIVAI Edge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final profile = PersonalProfile(
    categoryAffinity: {
      'study': 0.90,
      'work': 0.75,
      'personal': 0.55,
      'noise': 0.15,
    },
    sourceTrust: {
      'RPSC': 0.95,
      'Office': 0.80,
      'Calendar': 0.85,
      'Promo': 0.10,
    },
  );

  late final AdaptiveEngine engine = AdaptiveEngine(profile);

  final events = <PersonalEvent>[
    PersonalEvent(
      id: '1',
      title: 'RPSC examination notification',
      source: 'RPSC',
      category: EventCategory.study,
      genericImportance: 0.72,
      createdAt: DateTime.now(),
    ),
    PersonalEvent(
      id: '2',
      title: 'Office document requires review',
      source: 'Office',
      category: EventCategory.work,
      genericImportance: 0.70,
      createdAt: DateTime.now(),
    ),
    PersonalEvent(
      id: '3',
      title: 'Calendar: PSIR study block',
      source: 'Calendar',
      category: EventCategory.study,
      genericImportance: 0.65,
      createdAt: DateTime.now(),
    ),
    PersonalEvent(
      id: '4',
      title: 'Limited-time shopping promotion',
      source: 'Promo',
      category: EventCategory.noise,
      genericImportance: 0.40,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final decisions = events.map(engine.classify).toList();
    final actions = decisions.where((d) => d.action != 'FILTER').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SHIVAI Edge'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Local • $actions active')),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _stateCard(),
          const SizedBox(height: 16),
          const Text(
            'ATTENTION QUEUE',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          const SizedBox(height: 8),
          ...decisions.map(_decisionCard),
          const SizedBox(height: 16),
          _learningCard(),
        ],
      ),
    );
  }

  Widget _stateCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('PERSONAL STATE',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Metric(label: 'Focus', value: 'HIGH'),
                  _Metric(label: 'Workload', value: 'MEDIUM'),
                  _Metric(label: 'Adaptation', value: 'ON'),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _decisionCard(Decision decision) {
    final d = decision.personalImportance;
    final color = decision.action == 'ACT NOW'
        ? Colors.red
        : decision.action == 'QUEUE'
            ? Colors.orange
            : Colors.grey;

    return Card(
      child: ListTile(
        title: Text(decision.event.title),
        subtitle: Text(
          '${decision.event.source} • personal importance ${(d * 100).round()}%',
        ),
        trailing: Chip(
          label: Text(decision.action),
          side: BorderSide(color: color),
        ),
        onTap: () => _feedback(decision.event, true),
      ),
    );
  }

  Widget _learningCard() => Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('CLOSED-LOOP LEARNING',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Tap an event to simulate opening it. SHIVAI updates personal state; the base classifier is unchanged.',
              ),
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: () => _feedback(events.last, false),
                child: const Text('Dismiss last event'),
              ),
            ],
          ),
        ),
      );

  void _feedback(PersonalEvent event, bool opened) {
    setState(() => engine.learn(event, opened: opened));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          opened
              ? 'Learned: ${event.source} / ${event.category.name} matters more.'
              : 'Learned: ${event.source} / ${event.category.name} matters less.',
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label),
        ],
      );
}
