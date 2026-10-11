import 'package:flutter_test/flutter_test.dart';
import 'package:shivai_v2/core/cognitive_controller.dart';
import 'package:shivai_v2/core/experience.dart';

void main() {
  group('CognitiveController', () {
    test('rejects unsafe candidates', () {
      final controller = CognitiveController();
      final decision = controller.decide(
        goal: 'complete task',
        candidates: const [
          CandidateAction(
            strategy: 'unsafe',
            expectedBenefit: 100,
            safe: false,
          ),
          CandidateAction(
            strategy: 'safe',
            expectedBenefit: 1,
          ),
        ],
      );

      expect(decision.selected?.strategy, 'safe');
      expect(decision.rankedCandidates.map((a) => a.strategy), ['safe']);
    });

    test('returns no selected action when every candidate is unsafe', () {
      final controller = CognitiveController();
      final decision = controller.decide(
        goal: 'high-risk task',
        candidates: const [
          CandidateAction(
            strategy: 'unsafe',
            expectedBenefit: 10,
            safe: false,
          ),
        ],
      );

      expect(decision.selected, isNull);
      expect(decision.rationale, contains('No safe candidate'));
    });

    test('uses repeated experience to improve strategy ranking', () {
      final controller = CognitiveController(learningRate: 1);
      controller
        ..recordOutcome(const Experience(
          task: 'task 1',
          strategy: 'careful',
          reward: 1,
          verified: true,
        ))
        ..recordOutcome(const Experience(
          task: 'task 2',
          strategy: 'careful',
          reward: 1,
          verified: true,
        ))
        ..recordOutcome(const Experience(
          task: 'task 3',
          strategy: 'rushed',
          reward: -1,
          verified: true,
        ));

      final decision = controller.decide(
        goal: 'choose a strategy',
        candidates: const [
          CandidateAction(
            strategy: 'rushed',
            expectedBenefit: 1.2,
          ),
          CandidateAction(
            strategy: 'careful',
            expectedBenefit: 1,
          ),
        ],
      );

      expect(decision.selected?.strategy, 'careful');
    });

    test('bounds retained experiences', () {
      final controller = CognitiveController(maxExperiences: 2);
      for (var i = 0; i < 3; i++) {
        controller.recordOutcome(Experience(
          task: 'task ' + i.toString(),
          strategy: 'strategy',
          reward: 0,
        ));
      }

      expect(controller.experiences, hasLength(2));
      expect(controller.experiences.first.task, 'task 1');
    });
  });
}
