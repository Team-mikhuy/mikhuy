import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/establishment_detail/cubit/products_list_cubit.dart';
import 'package:mikhuy/establishment_detail/view/cart_page.dart';
import 'package:mikhuy/establishment_detail/view/products_list.dart';
import 'package:mikhuy/establishment_detail/view/products_search_bar.dart';
import 'package:mikhuy/theme/app_colors.dart';
import 'package:models/establishment.dart';
import 'package:url_launcher/url_launcher.dart';

class EstablishmentDetailPage extends StatelessWidget {
  const EstablishmentDetailPage(this._establishment, {super.key});
  final Establishment _establishment;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final openingTime = DateTime(
      now.year,
      now.month,
      now.day,
      _establishment.openingTime.hour,
      _establishment.openingTime.minute,
    );

    final closingTime = DateTime(
      now.year,
      now.month,
      now.day,
      _establishment.closingTime.hour,
      _establishment.closingTime.minute,
    );

    final isOpen = now.isAfter(openingTime) && now.isBefore(closingTime);

    final productsListCubit = ProductsListCubit()
      ..getProductsByEstablishment(_establishment.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(_establishment.name),
        leading: IconButton(
          onPressed: () => {
            Navigator.of(context).pop(),
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
              builder: (context) {
                return BlocProvider.value(
                  value: productsListCubit,
                  child: CartPage(_establishment),
                );
              },
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
                    onTap: _launchURL,
                    child: Row(
                      children: [
                        const Icon(MdiIcons.mapMarkerOutline),
                        Text(
                          _establishment.address,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _establishment.referenceNumber,
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
                'Todos los días de ${_establishment.openingTime.hour}:${_establishment.openingTime.minute} a ${_establishment.closingTime.hour}:${_establishment.closingTime.minute}',
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
              BlocProvider<ProductsListCubit>.value(
                value: productsListCubit,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProductsSearchBar(_establishment.id),
                    ProductsList(_establishment),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: inference_failure_on_function_return_type
  _launchURL() async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${_establishment.latitude}%2C${_establishment.longitude}');
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
}
