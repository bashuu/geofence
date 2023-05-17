class PlaceLocation {
  final String name;
  final double latitude;
  final double longitude;
  final double radius;
  final String address;
  final String userId;
  String id;
  final DateTime create_date;
  final DateTime update_date;

  PlaceLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.address,
    required this.userId,
    required this.id,
    required this.create_date,
    required this.update_date,
  });

  factory PlaceLocation.fromJson(Map<String, dynamic> json) {
    return PlaceLocation(
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        radius: json['radius'],
        address: json['address'],
        userId: json['userId'],
        id: json['id'],
        create_date: DateTime.fromMillisecondsSinceEpoch(json['create_date']),
        update_date: DateTime.fromMicrosecondsSinceEpoch(json['update_date']));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        "latitude": latitude,
        'longitude': longitude,
        'radius': radius,
        'address': address,
        'userId': userId,
        'id': id,
        "create_date": create_date,
        "update_date": update_date
      };
}
