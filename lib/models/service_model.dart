enum ServiceType { pathology, doctor }

class Service {
  final String id;
  final String name;
  final String imageUrl;
  final double distance; 
  final int bookings;
  final String location;
  final ServiceType type;

  Service({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.distance,
    required this.bookings,
    required this.location,
    required this.type,
  });
}