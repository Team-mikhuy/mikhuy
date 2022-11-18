import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

enum ReservationStatus {
  active,
  canceled,
  delivered,
}

class Reservation extends Equatable {
  const Reservation({
    required this.id,
    required this.userId,
    required this.establishmentId,
    required this.establishmentName,
    required this.establishmentAddress,
    this.dateIssued,
    this.expirationDate,
    required this.total,
    required this.productsCount,
    required this.status,
    this.details = const [],
  });

  factory Reservation.fromJson(Map<String, dynamic> json, [String? id]) {
    return Reservation(
      id: id ?? json['id'] as String,
      userId: json['user_Id'] as String,
      establishmentId: json['establishment_Id'] as String,
      establishmentName: json['establishment'] as String,
      establishmentAddress: json['address'] as String,
      dateIssued: DateTime.fromMicrosecondsSinceEpoch(
        (json['date_issued'] as Timestamp).microsecondsSinceEpoch,
      ),
      expirationDate: DateTime.fromMicrosecondsSinceEpoch(
        (json['expiration_date'] as Timestamp).microsecondsSinceEpoch,
      ),
      total: (json['total'] as num).toDouble(),
      productsCount: json['products_count'] as int,
      status: _mapStatusFromFirebase(json['status'] as String),
    );
  }

  final String id;
  final String userId;
  final String establishmentId;
  final String establishmentName;
  final String establishmentAddress;
  final DateTime? dateIssued;
  final DateTime? expirationDate;
  final double total;
  final int productsCount;
  final ReservationStatus status;
  final List<ReservationDetail> details;

  static const empty = Reservation(
    id: '',
    userId: '',
    establishmentId: '',
    establishmentName: '',
    establishmentAddress: '',
    total: 0,
    productsCount: 0,
    status: ReservationStatus.active,
  );

  @override
  List<Object?> get props => [
        id,
        userId,
        establishmentId,
        establishmentName,
        establishmentAddress,
        dateIssued,
        expirationDate,
        total,
        productsCount,
        status,
        details,
      ];

  static ReservationStatus _mapStatusFromFirebase(String status) {
    final mapper = {
      'ACT': ReservationStatus.active,
      'CAN': ReservationStatus.canceled,
      'DEL': ReservationStatus.delivered,
    };

    return mapper[status]!;
  }

  String _mapStatusToFirebase() {
    final mapper = {
      ReservationStatus.active: 'ACT',
      ReservationStatus.canceled: 'CAN',
      ReservationStatus.delivered: 'DEL',
    };

    return mapper[status]!;
  }

  Map<String, dynamic> toJson() {
    return {
      'address': establishmentAddress,
      'date_issued': dateIssued,
      'establishment': establishmentName,
      'establishment_Id': establishmentId,
      'expiration_date': expirationDate,
      'products_count': productsCount,
      'status': _mapStatusToFirebase(),
      'total': total,
      'user_Id': userId,
    };
  }

  Reservation copyWith({
    String? id,
    String? userId,
    String? establishmentId,
    String? establishmentName,
    String? establishmentAddress,
    DateTime? dateIssued,
    DateTime? expirationDate,
    double? total,
    int? productsCount,
    ReservationStatus? status,
    List<ReservationDetail>? details,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      establishmentId: establishmentId ?? this.establishmentId,
      establishmentName: establishmentName ?? this.establishmentName,
      establishmentAddress: establishmentAddress ?? this.establishmentAddress,
      dateIssued: dateIssued ?? this.dateIssued,
      expirationDate: expirationDate ?? this.expirationDate,
      total: total ?? this.total,
      productsCount: productsCount ?? this.productsCount,
      status: status ?? this.status,
      details: details ?? this.details,
    );
  }
}
