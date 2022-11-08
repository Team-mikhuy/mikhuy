import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikhuy/app/app.dart';
import 'package:mikhuy/home/cubit/google_maps_cubit.dart';
import 'package:mikhuy/home/view/google_maps_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocProvider<GoogleMapsCubit>(
            create: (context) => GoogleMapsCubit()
              ..verifyLocationPermission()
              ..getEstablisments(),
            child: const GoogleMapsBuilder(),
          ),
          Positioned(
            bottom: 0,
            child: TextButton(
              onPressed: () =>
                  context.read<AppBloc>().add(AppLogoutRequested()),
              child: const Text('Cerrar sesion'),
            ),
          ),
        ],
      ),
    );
  }
}
