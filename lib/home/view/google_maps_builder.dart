import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mikhuy/models/stablishment.dart';

class GoogleMapsBuilder extends StatelessWidget {
  GoogleMapsBuilder({Key? key}) : super(key: key);

  final stablishmentsRef =
      FirebaseFirestore.instance.collection('establishment').withConverter<Stablishment>(
            fromFirestore: (snapshots, _) => Stablishment.fromJson(
              snapshots.data()!,
              snapshots.id,
            ),
            toFirestore: (stablishment, _) => stablishment.toJson(),
          );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: stablishmentsRef.get(),
      builder: (_, AsyncSnapshot<QuerySnapshot<Stablishment>> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Ocurrio un error inesperado :('),
          );
        }

        if (snapshot.hasData) {
          final stablishments = snapshot.data!.docs.map((e) => e.data()).toList();
          return _GoogleMapsView(stablishments);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _GoogleMapsView extends StatelessWidget {
  _GoogleMapsView(this.stablishments, {Key? key}) : super(key: key);

  final List<Stablishment> stablishments;

  final Completer<GoogleMapController> _controller = Completer();
  final _initialPosition = const CameraPosition(
    target: LatLng(-17.378236201337288, -66.16146446351347),
    zoom: 13,
  );

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      markers: _getmarkers(context),
      onMapCreated: _onMapCreated,
      initialCameraPosition: _initialPosition,
      myLocationEnabled: true,
    );
  }

  Set<Marker> _getmarkers(BuildContext context) {
    return stablishments
        .map((e) => Marker(
            markerId: MarkerId(e.id),
            position: LatLng(e.latitude, e.longitude),
            infoWindow: InfoWindow(title: e.name),
            onTap: () {/*
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => stablishmentPage(e)),
              );*/
            }))
        .toSet();
  }
}
