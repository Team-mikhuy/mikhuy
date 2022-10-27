part of 'google_maps_cubit.dart';

class GoogleMapsState extends Equatable {
  const GoogleMapsState({
    this.establishments = const [],
    this.requestStatus = RequestStatus.initial,
    this.latitude = -17.378236201337288,
    this.longitude = -66.16146446351347,
  });

  final List<Establishment> establishments;
  final RequestStatus requestStatus;
  final double latitude;
  final double longitude;

  @override
  List<Object> get props => [
        establishments,
        requestStatus,
        latitude,
        longitude,
      ];

  GoogleMapsState copyWith({
    List<Establishment>? establishments,
    RequestStatus? requestStatus,
    double? latitude,
    double? longitude,
  }) {
    return GoogleMapsState(
      establishments: establishments ?? this.establishments,
      requestStatus: requestStatus ?? this.requestStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
