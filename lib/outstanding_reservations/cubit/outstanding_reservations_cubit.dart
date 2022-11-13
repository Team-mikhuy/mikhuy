import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:models/models.dart';

part 'outstanding_reservations_state.dart';

class OutstandingReservationsCubit extends Cubit<OutstandingReservationsState> {
  OutstandingReservationsCubit() : super(const OutstandingReservationsState());

  StreamSubscription<QuerySnapshot<Reservation>>? _reservationsSub;
  final _reservationsRef = FirebaseFirestore.instance
      .collection('reservation')
      .withConverter<Reservation>(
        fromFirestore: (snapshots, _) => Reservation.fromJson(
          snapshots.data()!,
          snapshots.id,
        ),
        toFirestore: (reservation, _) => reservation.toJson(),
      );

  Future<void> getReservations(String userId) async {
    emit(state.copyWith(requestStatus: RequestStatus.inProgress));
    try {
      await _reservationsSub?.cancel();
      _reservationsSub = _reservationsRef
          .where('user_Id', isEqualTo: userId)
          .where('status', isEqualTo: 'ACT')
          .snapshots()
          .listen(
        (event) async {
          final reservations = event.docs.map((e) => e.data()).toList();

          emit(
            state.copyWith(
              reservations: reservations,
              requestStatus: RequestStatus.completed,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed));
    }
  }
}
