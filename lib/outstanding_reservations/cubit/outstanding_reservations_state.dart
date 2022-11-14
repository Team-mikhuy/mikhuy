part of 'outstanding_reservations_cubit.dart';

class OutstandingReservationsState extends Equatable {
  const OutstandingReservationsState({
    this.requestStatus = RequestStatus.initial,
    this.reservations = const [],
  });

  final RequestStatus requestStatus;
  final List<Reservation> reservations;

  @override
  List<Object> get props => [requestStatus, reservations];

  OutstandingReservationsState copyWith({
    RequestStatus? requestStatus,
    List<Reservation>? reservations,
  }) {
    return OutstandingReservationsState(
      requestStatus: requestStatus ?? this.requestStatus,
      reservations: reservations ?? this.reservations,
    );
  }
}
