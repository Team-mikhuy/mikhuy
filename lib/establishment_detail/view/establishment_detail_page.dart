import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/establishment_detail/cubit/products_list_cubit.dart';
import 'package:mikhuy/establishment_detail/view/cart_page.dart';
import 'package:mikhuy/establishment_detail/view/products_list.dart';
import 'package:mikhuy/establishment_detail/view/products_search_bar.dart';
import 'package:mikhuy/theme/theme.dart';
import 'package:models/establishment.dart';
import 'package:url_launcher/url_launcher.dart';

class EstablishmentDetailPage extends StatelessWidget {
  const EstablishmentDetailPage(this._establishment, {super.key});
  final Establishment _establishment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsListCubit(_establishment)..getProducts(),
      child: _EstablishmentDetailView(),
    );
  }
}

class _EstablishmentDetailView extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _EstablishmentDetailView();

  @override
  Widget build(BuildContext context) {
    final establishment = context.select<ProductsListCubit, Establishment>(
      (value) => value.state.establishment,
    );

    final now = DateTime.now();

    final openingTime = DateTime(
      now.year,
      now.month,
      now.day,
      establishment.openingTime.hour,
      establishment.openingTime.minute,
    );

    final closingTime = DateTime(
      now.year,
      now.month,
      now.day,
      establishment.closingTime.hour,
      establishment.closingTime.minute,
    );

    final isOpen = now.isAfter(openingTime) && now.isBefore(closingTime);

    return WillPopScope(
      onWillPop: () async {
        if (context.read<ProductsListCubit>().state.cart.isNotEmpty) {
          final goBack = await showDialog<bool>(
            context: context,
            builder: _getGoBackAlert,
          );

          return goBack!;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(establishment.name),
          leading: IconButton(
            onPressed: () async {
              final goBack = await showDialog<bool>(
                context: context,
                builder: _getGoBackAlert,
              );

              // ignore: use_build_context_synchronously
              if (goBack!) Navigator.of(context).pop();
            },
            icon: const Icon(MdiIcons.arrowLeft),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(MdiIcons.cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<bool>(
                builder: (_) => BlocProvider.value(
                  value: context.read<ProductsListCubit>(),
                  child: CartPage(establishment),
                ),
              ),
            );
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _launchURL(establishment),
                      child: Row(
                        children: [
                          const Icon(MdiIcons.mapMarkerOutline),
                          Text(
                            establishment.address,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      establishment.referenceNumber,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Horarios de Atención',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Todos los días de ${establishment.openingTime.hour}:${establishment.openingTime.minute} a ${establishment.closingTime.hour}:${establishment.closingTime.minute}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  isOpen ? 'Abierto ahora' : 'Cerrado',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: isOpen ? AppColors.success : AppColors.danger,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Productos disponibles',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProductsSearchBar(establishment.id),
                    ProductsList(establishment),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: inference_failure_on_function_return_type
  Future<void> _launchURL(Establishment establishment) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${establishment.latitude}%2C${establishment.longitude}');
    final nativeAppLaunchSucceeded = await launchUrl(
      url,
      mode: LaunchMode.externalNonBrowserApplication,
    );
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      );
    } else {
      //Need message
      print('Not found');
    }
  }

  AlertDialog _getGoBackAlert(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      title: const Icon(MdiIcons.exclamation),
      content: const Text(
          'Tienes una reserva en proceso, se cancelará si sales del establecimiento.\n¿Deseas continuar?'),
      actionsPadding: const EdgeInsets.only(
        bottom: 16,
        left: 16,
        right: 16,
      ),
      contentPadding: const EdgeInsets.all(16),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          style: AppTheme.secondaryButton,
          child: const Text('Salir'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Permanecer'),
        ),
      ],
    );
  }
}
