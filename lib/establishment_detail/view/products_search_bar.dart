import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/establishment_detail/cubit/products_list_cubit.dart';
import 'package:mikhuy/theme/theme.dart';

class ProductsSearchBar extends StatelessWidget {
  const ProductsSearchBar(this.establishmentID, {super.key});
  final String establishmentID;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.blueMalibu.shade600,
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar Producto...',
                contentPadding: EdgeInsets.all(4),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<ProductsListCubit>().getProducts();
                }
              },
              onSubmitted: (value) => context
                  .read<ProductsListCubit>()
                  .searchProductsByCriteria(establishmentID, value),
            ),
          ),
          Icon(
            MdiIcons.magnify,
            color: AppColors.grey.shade800,
            size: 24,
          ),
        ],
      ),
    );
  }
}
