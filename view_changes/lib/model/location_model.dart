import 'dart:convert';

class LocationModel {
  double? latitude;
  double? longitude;
  String? time;
  LocationModel({
    this.latitude,
    this.longitude,
    this.time,
  });

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? time,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (latitude != null) {
      result.addAll({'latitude': latitude});
    }
    if (longitude != null) {
      result.addAll({'longitude': longitude});
    }
    if (time != null) {
      result.addAll({'time': time});
    }

    return result;
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationModel.fromJson(String source) =>
      LocationModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LocationModel(latitude: $latitude, longitude: $longitude, time: $time)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationModel &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.time == time;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ time.hashCode;
}
