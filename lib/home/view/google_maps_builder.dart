import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mikhuy/home/cubit/google_maps_cubit.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:models/establishment.dart';

class GoogleMapsBuilder extends StatelessWidget {
  const GoogleMapsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleMapsCubit, GoogleMapsState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.failed) {
          return const Center(
            child: Text('Ups! ha ocurrido un error inesperado'),
          );
        }

        if (state.requestStatus == RequestStatus.completed) {
          return _GoogleMapsView();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _GoogleMapsView extends StatelessWidget {
  _GoogleMapsView();

  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    final cameraPosition = CameraPosition(
      target: LatLng(
        context.select<GoogleMapsCubit, double>(
          (value) => value.state.latitude,
        ),
        context.select<GoogleMapsCubit, double>(
          (value) => value.state.longitude,
        ),
      ),
      zoom: 13,
    );

    return BlocListener<GoogleMapsCubit, GoogleMapsState>(
      listener: (context, state) async {
        final controller = await _controller.future;
        await controller.moveCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );
      },
      child: GoogleMap(
        markers: _getmarkers(context),
        onMapCreated: _onMapCreated,
        initialCameraPosition: cameraPosition,
        myLocationEnabled: true,
        padding: const EdgeInsets.only(top: 150),
      ),
    );
  }

  Set<Marker> _getmarkers(BuildContext context) {
    return context
        .select<GoogleMapsCubit, List<Establishment>>(
          (value) => value.state.establishments,
        )
        .map(
          (e) => Marker(
            markerId: MarkerId(e.id),
            position: LatLng(e.latitude, e.longitude),
            infoWindow: InfoWindow(title: e.name),
            onTap: () {
              /*
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => establishmentsPage(e)),
              );*/
            },
          ),
        )
        .toSet();
  }
}
