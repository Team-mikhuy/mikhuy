import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikhuy/app/app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mikhuy/home/view/google_maps_builder.dart';
import 'dart:async';
import 'package:mikhuy/models/establishment.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GoogleMapsBuilder()
    );
  }
}