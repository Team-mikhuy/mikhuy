import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'google_maps_state.dart';

class GoogleMapsCubit extends Cubit<GoogleMapsState> {
  GoogleMapsCubit() : super(GoogleMapsInitial());

  
}
