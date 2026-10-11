# Mini AI — Adaptive Cognitive Engine

## Vision

Build a mobile-first, extremely lightweight assistant that learns from experience, learns from stronger teacher models, and can operate online or offline. The first implementation uses the existing Flutter project and keeps its core cognitive logic independent of any language model.

## Design principles

1. **Local-first:** task decisions, memory records, scoring, and evaluation work without network access.
2. **PASS-inspired orchestration:** Planning, Attention, Simultaneous Processing, and Successive Processing are functional software stages, not claims of biological equivalence.
3. **Diffusion-inspired thought:** expand a problem into multiple candidate strategies, compare them, refine promising options, then select one. This is a search/decision metaphor, not a diffusion neural network.
4. **Experience learning:** record task, chosen strategy, outcome/reward, context, evidence, and timestamp. Use repeated outcomes to update strategy priors.
5. **Guru–pupil learning:** a future teacher adapter may propose explanations and candidate lessons. Treat them as unverified until practice/evaluation supports them.
6. **Model replaceability:** local and remote language models are adapters. The cognitive controller must remain useful without a model.
7. **Safe adaptation:** never promote a single failure or untrusted teacher output directly into permanent knowledge or executable actions.

## First milestone: cognitive foundation

Implement a small, deterministic Dart core:

- `Experience`: a compact record of an attempt and its outcome.
- `CandidateAction`: a candidate strategy with benefit, cost, risk, and safety fields.
- `CognitiveController`: PASS-stage-labelled choice, safe-candidate filtering, utility scoring, and a lightweight experience-derived strategy prior.
- Unit tests proving safe selection, no-safe-action behaviour, and learning from repeated positive/negative outcomes.

This milestone uses adaptive **policy/strategy weights**, not neural language-model weight training.

## Learning layers

### Layer 1 — experience and policy adaptation (initial)
Store outcomes and update strategy scores. Keep this deterministic, inspectable, bounded, and reversible.

### Layer 2 — teacher-guided distillation
A teacher model can propose rules, examples, and exercises. Store source/provenance and verification state. Validate lessons on held-out tasks before they influence policy.

### Layer 3 — optional neural weight adaptation (later)
Continuous neural-weight updates are not a suitable first mobile milestone: they require training data, a training-capable runtime, compute/memory budgeting, evaluation, and rollback. Later experiments should use a replay buffer, bounded updates or adapters, offline validation, regression tests, and a versioned checkpoint. Never update deployed weights directly from raw conversation without evaluation.

## Planned architecture

- **Flutter UI:** Android + web.
- **Cognitive core (Dart):** PASS stages, candidate evaluation, policy adaptation.
- **Local persistence:** Hive already exists in the project; add a versioned experience repository after the pure core is tested.
- **Teacher gateway:** optional server-side adapter; secrets never ship in the app.
- **Local inference:** optional quantised model adapter after target-device benchmarks.
- **Evaluation:** deterministic unit tests plus a small held-out task set.

## Stage gates

1. Cognitive core tests pass.
2. Experiences persist across restarts and can be inspected/deleted.
3. Teacher lessons include provenance and are tested before promotion.
4. Policy adaptation improves held-out task success over a baseline.
5. Offline inference meets measured device RAM, latency, storage, and battery limits.
6. Neural-weight experiments demonstrate measurable improvement without unacceptable regressions.

## Non-goals for milestone 1

- Training a language model from scratch.
- Bundling a large model in the Android app.
- Automatic execution of arbitrary teacher-generated code.
- Claiming human-like consciousness or human brain equivalence.
