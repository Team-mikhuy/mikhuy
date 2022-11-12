import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:models/models.dart';

part 'google_maps_state.dart';

class GoogleMapsCubit extends Cubit<GoogleMapsState> {
  GoogleMapsCubit() : super(const GoogleMapsState());

  final Location _location = Location();
  final _establishmentsRef = FirebaseFirestore.instance
      .collection('establishment')
      .withConverter<Establishment>(
        fromFirestore: (snapshots, _) => Establishment.fromJson(
          snapshots.data()!,
          snapshots.id,
        ),
        toFirestore: (establishments, _) => establishments.toJson(),
      );

  Future<void> verifyLocationPermission() async {
    var serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
    }

    var permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
    }

    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      final locationData = await _location.getLocation();
      emit(
        state.copyWith(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
        ),
      );
    }
  }

  Future<void> getEstablisments() async {
    emit(state.copyWith(requestStatus: RequestStatus.inProgress));
    try {
      final query = await _establishmentsRef.get();
      final establishmentsTemp = query.docs.map((e) => e.data()).toList();
      final establishments = <Establishment>[];

      for (final establishment in establishmentsTemp) {
        final products = await _getProductsByEstablishment(establishment.id);
        establishments.add(establishment.copyWith(products: products));
      }

      _establishmentsRef.snapshots().listen(
        (event) async {
          final index = state.establishments
              .indexWhere((element) => element.id == event.docs.first.id);
          final productsCount =
              await _getProductsByEstablishment(event.docs.first.id);
          final establishment = event.docs.map(
            (e) => e.data().copyWith(products: productsCount),
          );

          emit(
            state.copyWith(
              establishments: state.establishments
                ..replaceRange(
                  index,
                  index + 1,
                  establishment,
                ),
            ),
          );
        },
      );

      emit(
        state.copyWith(
          establishments: establishments,
          requestStatus: RequestStatus.completed,
        ),
      );
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed));
    }
  }

  Future<List<Product>> _getProductsByEstablishment(
    String establishmentId,
  ) async {
    final snapshot = await _establishmentsRef
        .doc(establishmentId)
        .collection('product')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) =>
              Product.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (product, _) => product.toJson(),
        )
        .get();

    return snapshot.docs.map((e) => e.data()).toList();
  }
}
