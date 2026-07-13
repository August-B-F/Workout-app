# Astra

A Flutter workout tracker. Build workouts as a sequence of timed tasks, run them
through a timer, and track how often you train.

Data is stored locally with Hive. No account, no backend.

## Screens

- **Workouts** — create and edit workouts. Each workout is a name plus a list of
  tasks; each task has a name and a duration. Tasks can be reordered or deleted.
- **Timer** — run a saved workout. Shows time left for the current task and the
  whole workout, with a progress bar and a skip button. Completed sessions are
  logged to statistics.
- **Statistics** — weekly and monthly training frequency, drawn as sparklines.
  Step back through past periods.

## Run

```sh
flutter pub get
flutter run
```

## Dependencies

hive_flutter, flutter_tabler_icons, chart_sparkline,
custom_sliding_segmented_control, url_launcher.
