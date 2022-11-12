import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikhuy/home/cubit/google_maps_cubit.dart';
import 'package:mikhuy/home/view/establishments_list_panel.dart';
import 'package:mikhuy/home/view/establishments_search_bar.dart';
import 'package:mikhuy/home/view/google_maps_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider<GoogleMapsCubit>(
          create: (context) => GoogleMapsCubit()
            ..verifyLocationPermission()
            ..getEstablisments(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const GoogleMapsBuilder(),
              Positioned.fill(
                child: Column(
                  children: const [
                    EstablishmentsSearchBar(),
                    Expanded(
                      child: EstablishmentsListPanel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
