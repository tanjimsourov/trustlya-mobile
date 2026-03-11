/// Information relating to responsible gaming settings and guidelines.
class ResponsibleGamingInfo {
  /// Maximum amount (in the user’s currency) that can be deposited per day.
  final double dailyDepositLimit;

  /// Amount already deposited today.
  final double usedDeposit;

  /// Whether session reminders are enabled.
  final bool sessionReminderEnabled;

  /// Additional educational or informational text about safe play.
  final String info;

  ResponsibleGamingInfo({
    required this.dailyDepositLimit,
    required this.usedDeposit,
    required this.sessionReminderEnabled,
    required this.info,
  });
}
