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
  StreamSubscription<QuerySnapshot<Establishment>>? _subscription;
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
      final establishments = query.docs.map((e) => e.data()).toList();

      _subscription = _establishmentsRef.snapshots().listen(
        (event) {
          final index = state.establishments
              .indexWhere((element) => element.id == event.docs.first.id);

          emit(
            state.copyWith(
              establishments: state.establishments
                ..replaceRange(
                  index,
                  index + 1,
                  event.docs.map((e) => e.data()),
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
}
