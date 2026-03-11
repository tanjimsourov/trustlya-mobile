/// Represents an eco‑achievement or badge that users earn by offsetting
/// carbon emissions. Each achievement tracks progress toward a goal
/// and whether it has been completed.
class Achievement {
  final String id;
  final String title;
  final String description;
  final double progress; // 0.0–1.0
  final bool achieved;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.achieved,
  });
}
