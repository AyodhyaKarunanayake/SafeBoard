class RouteModel {
  final String routeId;
  final String routeName;
  final String startPoint;
  final String endPoint;
  final int totalStops;
  final double distanceKm;
  final String routeType;
  final String status;
  final List<String> stops;

  RouteModel({
    required this.routeId,
    required this.routeName,
    required this.startPoint,
    required this.endPoint,
    required this.totalStops,
    required this.distanceKm,
    required this.routeType,
    required this.status,
    required this.stops,
  });

  Map<String, dynamic> toMap() {
    return {
      'route_id': routeId,
      'route_name': routeName,
      'start_point': startPoint,
      'end_point': endPoint,
      'total_stops': totalStops,
      'distance_km': distanceKm,
      'route_type': routeType,
      'status': status,
      'stops': stops,
    };
  }

  factory RouteModel.fromMap(Map<String, dynamic> map, String docId) {
    return RouteModel(
      routeId: map['route_id'] ?? docId,
      routeName: map['route_name'] ?? '',
      startPoint: map['start_point'] ?? '',
      endPoint: map['end_point'] ?? '',
      totalStops: map['total_stops'] ?? 0,
      distanceKm: (map['distance_km'] ?? 0.0).toDouble(),
      routeType: map['route_type'] ?? 'Normal',
      status: map['status'] ?? 'active',
      stops: List<String>.from(map['stops'] ?? []),
    );
  }
}
