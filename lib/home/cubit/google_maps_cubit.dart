import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:models/models.dart';

part 'google_maps_state.dart';

class GoogleMapsCubit extends Cubit<GoogleMapsState> {
  GoogleMapsCubit() : super(const GoogleMapsState());

  final Location location = Location();

  Future<void> verifyLocationPermission() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    if (serviceEnabled && permissionGranted == PermissionStatus.granted) {
      final locationData = await location.getLocation();
      emit(
        state.copyWith(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
        ),
      );
    }
  }
}
