import 'dart:math';

enum EventCategory { work, study, personal, noise }

class PersonalProfile {
  final Map<String, double> categoryAffinity;
  final Map<String, double> sourceTrust;
  final Map<String, int> openedCount;
  final Map<String, int> dismissedCount;

  PersonalProfile({
    Map<String, double>? categoryAffinity,
    Map<String, double>? sourceTrust,
    Map<String, int>? openedCount,
    Map<String, int>? dismissedCount,
  })  : categoryAffinity = categoryAffinity ?? {},
        sourceTrust = sourceTrust ?? {},
        openedCount = openedCount ?? {},
        dismissedCount = dismissedCount ?? {};
}

class PersonalEvent {
  final String id;
  final String title;
  final String source;
  final EventCategory category;
  final double genericImportance;
  final DateTime createdAt;

  const PersonalEvent({
    required this.id,
    required this.title,
    required this.source,
    required this.category,
    required this.genericImportance,
    required this.createdAt,
  });
}

class Decision {
  final PersonalEvent event;
  final double personalImportance;
  final String action;

  const Decision({
    required this.event,
    required this.personalImportance,
    required this.action,
  });
}

double clamp01(double value) => max(0, min(1, value));
