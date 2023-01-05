import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/app/app.dart';
import 'package:mikhuy/establishment_detail/cubit/products_list_cubit.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:mikhuy/theme/app_colors.dart';
import 'package:mikhuy/theme/app_theme.dart';
import 'package:models/models.dart';

class CartPage extends StatelessWidget {
  CartPage(this._establishment, {super.key});
  final Establishment _establishment;

  @override
  Widget build(BuildContext context) {
    final cart = context.select<ProductsListCubit, List<ReservationDetail>>(
        (value) => value.state.cart);

    var total = 0.0;
    cart.forEach((element) => total += element.subtotal);

    final userId =
        context.select<AppBloc, String>((value) => value.state.user.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito ${_establishment.name}'),
        leading: IconButton(
          onPressed: () => {
            Navigator.of(context).pop(),
          },
          icon: const Icon(MdiIcons.arrowLeft),
        ),
      ),
      body: BlocListener<ProductsListCubit, ProductsListState>(
        listener: (context, state) {
          if (state.reservationRequestStatus == RequestStatus.completed) {
            showDialog<bool>(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Tu reserva se\nregistro con exito :)',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context)
                              .popUntil((route) => route.isFirst),
                          child: const Text('Bien!'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          if (state.reservationRequestStatus == RequestStatus.inProgress) {
            showDialog<bool>(
              context: context,
              builder: (context) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.white,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const CircularProgressIndicator(),
                  ),
                );
              },
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DataTable(
                  columnSpacing: 32,
                  columns: const [
                    DataColumn(label: Text('')),
                    DataColumn(label: Text('Producto')),
                    DataColumn(label: Text('c/u')),
                    DataColumn(label: Text('Subtotal')),
                    DataColumn(label: Text(''))
                  ],
                  rows: cart.map((detail) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(
                            detail.quantity.toString(),
                            style: Theme.of(context).textTheme.headline2,
                          ),
                        ),
                        DataCell(
                          Text(
                            detail.productName,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ),
                        DataCell(Text(
                          'Bs. ${detail.unitPrice}',
                          style: Theme.of(context).textTheme.subtitle2,
                        )),
                        DataCell(Text(
                          'Bs. ${detail.subtotal}',
                          style: Theme.of(context).textTheme.subtitle2,
                        )),
                        DataCell(
                          IconButton(
                            icon: const Icon(MdiIcons.deleteOutline),
                            onPressed: () {
                              context
                                  .read<ProductsListCubit>()
                                  .removeItemFromCart(detail);
                            },
                          ),
                        )
                      ],
                    );
                  }).toList()),
              Column(
                children: [
                  const Divider(
                    height: 4,
                    thickness: 2,
                    color: AppColors.acadia,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Text(
                          'Bs. $total',
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key('Create_Reservation_flatButton'),
                      onPressed: () {
                        context
                            .read<ProductsListCubit>()
                            .confirmReservation(_establishment, userId);
                      },
                      style: AppTheme.secondaryButton,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(MdiIcons.check),
                          Text('CREAR RESERVA'),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
