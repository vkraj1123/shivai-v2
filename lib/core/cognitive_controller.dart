import 'experience.dart';

/// PASS-inspired software stages. These labels organise computation; they do
/// not imply that the software reproduces human cognition biologically.
enum PassStage {
  planning,
  attention,
  simultaneousProcessing,
  successiveProcessing,
}

/// One possible strategy considered for a task.
class CandidateAction {
  const CandidateAction({
    required this.strategy,
    required this.expectedBenefit,
    this.cost = 0,
    this.risk = 0,
    this.safe = true,
  });

  final String strategy;
  final double expectedBenefit;
  final double cost;
  final double risk;
  final bool safe;

  double baseUtility() => expectedBenefit - cost - risk;
}

class CognitiveDecision {
  const CognitiveDecision({
    required this.stage,
    required this.rankedCandidates,
    required this.rationale,
  });

  final PassStage stage;
  final List<CandidateAction> rankedCandidates;
  final String rationale;

  CandidateAction? get selected =>
      rankedCandidates.isEmpty ? null : rankedCandidates.first;
}

/// Lightweight controller that learns strategy preferences from experience.
///
/// This first version adapts strategy priors, not neural language-model
/// parameters. All scoring is deterministic and can run offline.
class CognitiveController {
  CognitiveController({
    this.learningRate = 0.25,
    this.maxExperiences = 500,
  })  : assert(learningRate >= 0 && learningRate <= 1),
        assert(maxExperiences > 0);

  final double learningRate;
  final int maxExperiences;
  final List<Experience> _experiences = [];

  List<Experience> get experiences => List.unmodifiable(_experiences);

  void recordOutcome(Experience experience) {
    _experiences.add(experience);
    if (_experiences.length > maxExperiences) {
      _experiences.removeRange(0, _experiences.length - maxExperiences);
    }
  }

  /// Mean reward for a strategy, shrunk toward zero when evidence is sparse.
  double strategyPrior(String strategy) {
    final matches = _experiences
        .where((item) => item.strategy == strategy)
        .toList(growable: false);
    if (matches.isEmpty) return 0;

    final total = matches.fold<double>(0, (sum, item) => sum + item.reward);
    final mean = total / matches.length;
    // Evidence grows gradually; a single noisy outcome has limited influence.
    final evidenceFactor = matches.length / (matches.length + 2.0);
    return mean * evidenceFactor;
  }

  /// Explore the available candidates, reject unsafe options, and rank the
  /// remaining strategies using immediate utility plus learned experience.
  CognitiveDecision decide({
    required String goal,
    required List<CandidateAction> candidates,
    PassStage stage = PassStage.planning,
  }) {
    final safe = candidates.where((candidate) => candidate.safe).toList();
    safe.sort((a, b) {
      final scoreA = a.baseUtility() +
          learningRate * strategyPrior(a.strategy);
      final scoreB = b.baseUtility() +
          learningRate * strategyPrior(b.strategy);
      return scoreB.compareTo(scoreA);
    });

    return CognitiveDecision(
      stage: stage,
      rankedCandidates: List.unmodifiable(safe),
      rationale: safe.isEmpty
          ? 'No safe candidate found for: ' + goal +
              '. Ask for clarification or help.'
          : 'Ranked ' + safe.length.toString() +
              ' safe candidate(s) by expected benefit, cost, risk, and prior outcomes.',
    );
  }
}
