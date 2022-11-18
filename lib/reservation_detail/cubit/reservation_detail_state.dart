part of 'reservation_detail_cubit.dart';

class ReservationDetailState extends Equatable {
  const ReservationDetailState({
    this.requestStatus = RequestStatus.initial,
    this.reservation = Reservation.empty,
  });

  final RequestStatus requestStatus;
  final Reservation reservation;

  @override
  List<Object> get props => [requestStatus, reservation];

  ReservationDetailState copyWith({
    RequestStatus? requestStatus,
    Reservation? reservation,
  }) {
    return ReservationDetailState(
      requestStatus: requestStatus ?? this.requestStatus,
      reservation: reservation ?? this.reservation,
    );
  }
}
