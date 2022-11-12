import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mikhuy/home/cubit/establishment_list_cubit.dart';
import 'package:mikhuy/theme/theme.dart';

class EstablishmentsSearchBar extends StatelessWidget {
  const EstablishmentsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.shade700.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(2, 4), // changes position of shadow
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
                hintText: 'Establecimiento, producto...',
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
                  context.read<EstablishmentListCubit>().getEstablisments();
                }
              },
              onSubmitted: (value) => context
                  .read<EstablishmentListCubit>()
                  .searchEstablishments(value),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              MdiIcons.shopping,
              color: AppColors.grey.shade800,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              MdiIcons.account,
              color: AppColors.grey.shade800,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
