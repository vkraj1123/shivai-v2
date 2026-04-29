# Shivai v2

A chat-first Flutter study planner with natural-language task capture, Hive local storage, Riverpod state management, task filters, progress stats, and a challenge-based Pomodoro timer.

## Run

```bash
flutter pub get
flutter run
```

## Android

This project now includes Android platform files.

```bash
flutter pub get
flutter build apk
flutter install
```

If your local Flutter install wants to refresh generated Android wrapper files:

```bash
flutter create . --platforms=android
flutter build apk
```

Try commands like:

```text
Study economy for 2 hours
Read polity for 45 minutes tomorrow
Revise geography by 2026-05-02
Revise economy urgent 3 pomodoros focus 30 minutes break 10 #revision
Solve mock test high priority 2 cycles #practice challenge
Inflation depends on demand and supply #economy
Fiscal deficit is caused by higher government spending #economy
Revise inflation theory for 1 hour
```

## Features

- WhatsApp-style task input.
- Natural-language parsing for duration, deadlines, priority, Pomodoro count, focus length, break length, and tags.
- Challenge Pomodoro flow: finish a focus round, submit proof of progress, then unlock the break.
- Local persistence with Hive.
- Filters for all, active, high-priority, and completed tasks.
- Progress stats and per-task Pomodoro completion.
- Knowledge Engine with notes, tags, concept detection, and simple relationship extraction.
- Wiki screen for browsing concepts and related knowledge links.
- Memory Engine with confidence score, last accessed, usage count, startup decay, and weak knowledge review.
- Graph System with concept nodes, relationship edges, dependency/cause queries, and task-to-concept links.
- Intelligence Layer with task pattern analysis, best-time suggestions, priority recommendations, and in-app smart reminders.
- Dark mode, system theme support, high contrast, adjustable text size, reduced motion, larger touch targets, and Android platform support.
