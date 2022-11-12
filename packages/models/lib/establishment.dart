import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:models/product.dart';

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
    this.products = const [],
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
  final List<Product> products;

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
        products,
      ];

  Establishment copyWith({
    String? id,
    String? address,
    DateTime? closingTime,
    String? googleMapsUrl,
    double? latitude,
    double? longitude,
    String? name,
    DateTime? openingTime,
    String? referenceNumber,
    List<Product>? products,
  }) {
    return Establishment(
      id: id ?? this.id,
      address: address ?? this.address,
      closingTime: closingTime ?? this.closingTime,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      openingTime: openingTime ?? this.openingTime,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      products: products ?? this.products,
    );
  }
}
