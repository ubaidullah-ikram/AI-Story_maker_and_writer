import 'package:get/get.dart';

class QuerymodelRemote {
  final int weekly;
  final int monthly;
  final int yearly;

  QuerymodelRemote({
    required this.weekly,
    required this.monthly,
    required this.yearly,
  });

  factory QuerymodelRemote.fromJson(Map<dynamic, dynamic> json) {
    return QuerymodelRemote(
      weekly: json['weekly'] ?? 10,
      monthly: json['monthly'] ?? 10,
      yearly: json['yearly'] ?? 10,
    );
  }
}
