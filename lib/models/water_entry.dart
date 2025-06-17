// models/water_entry.dart

class WaterEntry {
  final String wellId;
  final String state;
  final String village;
  final String date;
  final double waterLevel;

  WaterEntry({
    required this.wellId,
    required this.state,
    required this.village,
    required this.date,
    required this.waterLevel,
  });

  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      wellId: json['well_id'],
      state: json['state'],
      village: json['village'],
      date: json['date'],
      waterLevel: (json['water_level'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'well_id': wellId,
      'state': state,
      'village': village,
      'date': date,
      'water_level': waterLevel,
    };
  }
}
