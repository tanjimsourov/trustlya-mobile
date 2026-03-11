import 'package:equatable/equatable.dart';

/// Notification about upcoming servicing actions or events related to a
/// tokenised asset programme, such as coupon payments or governance
/// votes.
class ServicingAlert extends Equatable {
  final String id;
  final String message;
  final AlertSeverity severity;
  final DateTime date;

  const ServicingAlert({
    required this.id,
    required this.message,
    required this.severity,
    required this.date,
  });

  @override
  List<Object?> get props => [id, message, severity, date];
}

/// Severity levels for alerts.
enum AlertSeverity { info, warning, critical }
