import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mikhuy/home/cubit/google_maps_cubit.dart';
import 'package:models/establishment.dart';

class GoogleMapsBuilder extends StatelessWidget {
  GoogleMapsBuilder({super.key});

  final establishmentsRef = FirebaseFirestore.instance
      .collection('establishment')
      .withConverter<Establishment>(
        fromFirestore: (snapshots, _) => Establishment.fromJson(
          snapshots.data()!,
          snapshots.id,
        ),
        toFirestore: (establishments, _) => establishments.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: establishmentsRef.get(),
      builder: (_, AsyncSnapshot<QuerySnapshot<Establishment>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Ocurrio un error inesperado :('),
          );
        }

        if (snapshot.hasData) {
          final establishmentss =
              snapshot.data!.docs.map((e) => e.data()).toList();
          return BlocProvider(
            create: (context) => GoogleMapsCubit()..verifyLocationPermission(),
            child: _GoogleMapsView(establishmentss),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _GoogleMapsView extends StatelessWidget {
  _GoogleMapsView(this.establishmentss);

  final List<Establishment> establishmentss;

  final Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = CameraPosition(
      target: LatLng(
        context.select<GoogleMapsState, double>((value) => value.latitude),
        context.select<GoogleMapsState, double>((value) => value.longitude),
      ),
      zoom: 13,
    );

    return GoogleMap(
      markers: _getmarkers(context),
      onMapCreated: _onMapCreated,
      initialCameraPosition: initialPosition,
      myLocationEnabled: true,
    );
  }

  Set<Marker> _getmarkers(BuildContext context) {
    return establishmentss
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
