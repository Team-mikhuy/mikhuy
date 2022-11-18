import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:models/models.dart';

part 'reservation_detail_state.dart';

class ReservationDetailCubit extends Cubit<ReservationDetailState> {
  ReservationDetailCubit(Reservation reservation)
      : super(ReservationDetailState(reservation: reservation));

  DocumentReference<Reservation> get _reservationRef =>
      FirebaseFirestore.instance
          .collection('reservation')
          .withConverter<Reservation>(
            fromFirestore: (snapshots, _) => Reservation.fromJson(
              snapshots.data()!,
              snapshots.id,
            ),
            toFirestore: (reservation, _) => reservation.toJson(),
          )
          .doc(state.reservation.id);

  CollectionReference<ReservationDetail> get _reservationDetailsRef =>
      _reservationRef
          .collection('reservation_Detail')
          .withConverter<ReservationDetail>(
            fromFirestore: (snapshots, _) => ReservationDetail.fromJson(
              snapshots.data()!,
              snapshots.id,
            ),
            toFirestore: (reservationDetail, _) => reservationDetail.toJson(),
          );

  Future<void> listenReservation() async {
    _reservationRef.snapshots().listen((event) {
      final reservation = event.data();
      emit(
        state.copyWith(
          reservation: state.reservation.copyWith(
            status: reservation!.status,
          ),
        ),
      );
    });
  }

  Future<void> getReservationDetails() async {
    emit(state.copyWith(requestStatus: RequestStatus.inProgress));

    try {
      final snapshot = await _reservationDetailsRef.get();
      final details = snapshot.docs.map((e) => e.data()).toList();
      emit(
        state.copyWith(
          reservation: state.reservation.copyWith(details: details),
          requestStatus: RequestStatus.completed,
        ),
      );
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed));
    }
  }

  Future<void> cancelReservation() async {
    emit(state.copyWith(requestStatus: RequestStatus.inProgress));
    try {
      await _reservationRef.update({'status': 'CAN'});
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed));
    }
  }
}
