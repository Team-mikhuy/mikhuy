import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Establishment extends Equatable {
  const Establishment({
    required this.id,
    required this.address,
    required this.closingTime,
    required this.googleMapsUrl,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.openingTime,
    required this.referenceNumber,
  });

  factory Establishment.fromJson(Map<String, dynamic> json, [String? id]) {
    return Establishment(
      id: id ?? json['id'] as String,
      address: json['address'] as String,
      closingTime: DateTime.fromMicrosecondsSinceEpoch(
        (json['closing_time'] as Timestamp).microsecondsSinceEpoch,
      ),
      googleMapsUrl: json['google_maps_url'] as String,
      latitude: (json['location'] as GeoPoint).latitude,
      longitude: (json['location'] as GeoPoint).longitude,
      name: json['name'] as String,
      openingTime: DateTime.fromMicrosecondsSinceEpoch(
        (json['opening_time'] as Timestamp).microsecondsSinceEpoch,
      ),
      referenceNumber: json['reference_number'] as String,
    );
  }

  final String id;
  final String address;
  final DateTime closingTime;
  final String googleMapsUrl;
  final double latitude;
  final double longitude;
  final String name;
  final DateTime openingTime;
  final String referenceNumber;

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'closing_time': closingTime,
      'google_maps_url': googleMapsUrl,
      'location': GeoPoint(latitude, longitude),
      'name': name,
      'opening_time': openingTime,
      'reference_number': referenceNumber,
    };
  }

  @override
  List<Object?> get props => [
        id,
        address,
        closingTime,
        googleMapsUrl,
        latitude,
        longitude,
        name,
        openingTime,
        referenceNumber,
      ];
}
