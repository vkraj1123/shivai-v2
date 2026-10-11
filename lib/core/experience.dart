/// A compact, inspectable record of one attempt and its observed outcome.
///
/// Reward is bounded to [-1, 1]. This is an experience signal, not proof that
/// the underlying explanation is universally true.
class Experience {
  const Experience({
    required this.task,
    required this.strategy,
    required this.reward,
    this.context = '',
    this.evidence = '',
    this.source = 'user_or_environment',
    this.verified = false,
    this.occurredAt,
  }) : assert(reward >= -1 && reward <= 1);

  final String task;
  final String strategy;
  final double reward;
  final String context;
  final String evidence;
  final String source;
  final bool verified;
  final DateTime? occurredAt;

  Map<String, Object?> toJson() => {
        'task': task,
        'strategy': strategy,
        'reward': reward,
        'context': context,
        'evidence': evidence,
        'source': source,
        'verified': verified,
        'occurredAt': occurredAt?.toIso8601String(),
      };

  factory Experience.fromJson(Map<String, Object?> json) => Experience(
        task: json['task'] as String,
        strategy: json['strategy'] as String,
        reward: (json['reward'] as num).toDouble(),
        context: json['context'] as String? ?? '',
        evidence: json['evidence'] as String? ?? '',
        source: json['source'] as String? ?? 'user_or_environment',
        verified: json['verified'] as bool? ?? false,
        occurredAt: json['occurredAt'] == null
            ? null
            : DateTime.parse(json['occurredAt'] as String),
      );
}
