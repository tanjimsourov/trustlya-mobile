/// Represents a mission or quest that spans different modules.
/// [title] and [description] describe the task, [progress] is a
/// value between 0 and 1, and [reward] defines the points or
/// benefit earned upon completion. [module] categorises the mission.
class Mission {
  final String id;
  final String title;
  final String description;
  final double progress;
  final double required;
  final double current;
  final String reward;
  final String module;
  final bool claimed;

  const Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.required,
    required this.current,
    required this.reward,
    required this.module,
    this.claimed = false,
  });

  Mission copyWith({
    double? progress,
    double? current,
    bool? claimed,
  }) {
    return Mission(
      id: id,
      title: title,
      description: description,
      progress: progress ?? this.progress,
      required: required,
      current: current ?? this.current,
      reward: reward,
      module: module,
      claimed: claimed ?? this.claimed,
    );
  }
}
