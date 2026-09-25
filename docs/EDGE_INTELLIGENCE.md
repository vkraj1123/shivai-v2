# SHIVAI Edge Intelligence MVP

## Product thesis

SHIVAI is an edge-first personal intelligence layer. It observes events, maintains a personal state model, classifies incoming information, applies deterministic policy, and learns from user feedback.

## Learning model

The MVP separates four concerns:

1. Base model — generic classification logic.
2. Personal state — continuously updated from user behaviour.
3. Policy — converts scores into actions.
4. Optional future training — accumulated feedback can later personalize model weights.

The first MVP does not fine-tune neural-network weights. It demonstrates continuous personalization through online state updates.

## Laya integration boundary

Laya should be a pluggable local classifier, not the whole assistant.

Recommended pipeline:

event -> Laya/classifier -> personal calibration -> policy -> action -> feedback -> personal state

The current MVP uses a deterministic classifier placeholder so the architecture can be tested without downloading a model. A future LayaAdapter can replace that classifier without changing the dashboard or personal-state layer.

## Edge-first principles

- Local by default.
- Cloud AI optional.
- No conversational LLM required for routine decisions.
- Explainable scores and actions.
- User feedback is explicit.
- Personal state is separable from model weights.
