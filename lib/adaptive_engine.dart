import 'models.dart';

class AdaptiveEngine {
  final PersonalProfile profile;

  AdaptiveEngine(this.profile);

  Decision classify(PersonalEvent event) {
    final categoryKey = event.category.name;
    final affinity = profile.categoryAffinity[categoryKey] ?? 0.5;
    final sourceTrust = profile.sourceTrust[event.source] ?? 0.5;

    final score = clamp01(
      event.genericImportance * 0.60 +
          affinity * 0.25 +
          sourceTrust * 0.15,
    );

    final action = score >= 0.75
        ? 'ACT NOW'
        : score >= 0.45
            ? 'QUEUE'
            : 'FILTER';

    return Decision(
      event: event,
      personalImportance: score,
      action: action,
    );
  }

  void learn(PersonalEvent event, {required bool opened}) {
    final key = event.category.name;
    final oldAffinity = profile.categoryAffinity[key] ?? 0.5;
    final oldTrust = profile.sourceTrust[event.source] ?? 0.5;
    final target = opened ? 1.0 : 0.0;

    profile.categoryAffinity[key] =
        clamp01(oldAffinity * 0.9 + target * 0.1);
    profile.sourceTrust[event.source] =
        clamp01(oldTrust * 0.9 + target * 0.1);

    final counts = opened ? profile.openedCount : profile.dismissedCount;
    counts[event.source] = (counts[event.source] ?? 0) + 1;
  }
}
