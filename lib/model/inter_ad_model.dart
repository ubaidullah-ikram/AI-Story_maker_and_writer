import 'package:get/get.dart';

class IntersitialModel {
  final bool splashIntersitial;
  final bool home_tool;
  final bool generateButton;

  IntersitialModel({
    required this.splashIntersitial,
    required this.home_tool,
    required this.generateButton,
  });

  factory IntersitialModel.fromJson(Map<dynamic, dynamic> json) {
    return IntersitialModel(
      splashIntersitial: json['splash_view'] ?? false,
      home_tool: json['home_tool'] ?? false,
      generateButton: json['generate_button'] ?? false,
    );
  }

  /// default empty
  factory IntersitialModel.empty() {
    return IntersitialModel(
      splashIntersitial: false,
      home_tool: false,
      generateButton: false,
    );
  }
}
