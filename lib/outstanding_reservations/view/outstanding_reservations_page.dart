import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikhuy/app/bloc/app_bloc.dart';
import 'package:mikhuy/outstanding_reservations/cubit/outstanding_reservations_cubit.dart';
import 'package:mikhuy/outstanding_reservations/view/reservations_list.dart';
import 'package:mikhuy/shared/enums/request_status.dart';

class OutstandingReservationsPage extends StatelessWidget {
  const OutstandingReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = context.select<AppBloc, String>(
      (value) => value.state.user.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas pendientes'),
      ),
      body: BlocProvider<OutstandingReservationsCubit>(
        create: (_) => OutstandingReservationsCubit()..getReservations(userId),
        child: const _OutstandingReservationsView(),
      ),
    );
  }
}

class _OutstandingReservationsView extends StatelessWidget {
  const _OutstandingReservationsView();

  @override
  Widget build(BuildContext context) {
    final userId = context.select<AppBloc, String>(
      (value) => value.state.user.id,
    );

    return BlocBuilder<OutstandingReservationsCubit,
        OutstandingReservationsState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.failed) {
          return Center(
            child: Column(
              children: [
                const Text('Ups! Ha ocurrido un error inesperado :('),
                TextButton(
                  onPressed: () => context
                      .read<OutstandingReservationsCubit>()
                      .getReservations(userId),
                  child: const Text('Reintentar'),
                )
              ],
            ),
          );
        }

        if (state.requestStatus == RequestStatus.completed) {
          if (state.reservations.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text(
                  // ignore: lines_longer_than_80_chars
                  'No tienes reservas pendientes, crea una para encontrarla aqui :)',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return const ReservationsList();
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
