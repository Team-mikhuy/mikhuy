import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/outstanding_reservations/outstanding_reservations.dart';
import 'package:mikhuy/reservation_detail/reservation_detail.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:mikhuy/theme/theme.dart';
import 'package:models/models.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservationDetailPage extends StatelessWidget {
  const ReservationDetailPage(this._reservation, {super.key});
  final Reservation _reservation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de reserva'),
      ),
      body: BlocProvider<ReservationDetailCubit>(
        create: (context) => ReservationDetailCubit(_reservation)
          ..listenReservation()
          ..getReservationDetails(),
        child: const _ReservationDetailView(),
      ),
    );
  }
}

class _ReservationDetailView extends StatelessWidget {
  const _ReservationDetailView();

  @override
  Widget build(BuildContext context) {
    final reservation = context.select<ReservationDetailCubit, Reservation>(
      (value) => value.state.reservation,
    );

    return BlocListener<ReservationDetailCubit, ReservationDetailState>(
      listenWhen: (previous, current) =>
          previous.reservation.status != current.reservation.status,
      listener: (context, state) {
        if (state.reservation.status == ReservationStatus.canceled) {
          showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Text('Tu reserva expiro o fue cancelada 👀'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const OutstandingReservationsPage(),
                        ),
                        ModalRoute.withName('/'),
                      ),
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Recoger en'),
              Text(
                reservation.establishmentName,
                style: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    MdiIcons.mapMarkerOutline,
                    size: 24,
                  ),
                  Text(reservation.establishmentAddress),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueMalibu.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Reservado el'),
                        Text(
                          DateFormat('dd/MM/yyyy H:m')
                              .format(reservation.dateIssued!),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blueMalibu.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Recoger hasta'),
                        Text(
                          DateFormat('dd/MM/yyyy H:m')
                              .format(reservation.expirationDate!),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Recoge tu pedido con el QR de este ticket :)'),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: QrImage(
                  data: reservation.id,
                ),
              ),
              BlocBuilder<ReservationDetailCubit, ReservationDetailState>(
                builder: (context, state) {
                  if (state.requestStatus == RequestStatus.completed) {
                    return DetailTable(reservation: reservation);
                  }

                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DetailTable extends StatelessWidget {
  const DetailTable({required this.reservation, super.key});

  final Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: 32,
      columns: const [
        DataColumn(label: Text('')),
        DataColumn(label: Text('Producto')),
        DataColumn(label: Text('c/u')),
        DataColumn(label: Text('Subtotal')),
      ],
      rows: reservation.details.map((detail) {
        return DataRow(
          cells: [
            DataCell(Text(detail.quantity.toString())),
            DataCell(Text(detail.productName)),
            DataCell(Text('Bs.${detail.unitPrice}')),
            DataCell(Text('Bs.${detail.subtotal}')),
          ],
        );
      }).toList()
        ..add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(
                Text(
                  'Bs.${reservation.total}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
