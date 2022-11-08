import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikhuy/home/cubit/google_maps_cubit.dart';
import 'package:mikhuy/home/view/establishments_list.dart';
import 'package:mikhuy/theme/theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EstablishmentsListPanel extends StatelessWidget {
  const EstablishmentsListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      color: Colors.transparent,
      minHeight: MediaQuery.of(context).size.height * 0.25,
      maxHeight: MediaQuery.of(context).size.height,
      parallaxEnabled: true,
      panel: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: AppColors.white,
        ),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Container(
              width: 52,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.grey.shade500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Establecimientos cercanos',
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: AppColors.grey.shade700),
            ),
            const SizedBox(height: 12),
            BlocProvider<GoogleMapsCubit>(
              create: (context) => GoogleMapsCubit()..getEstablisments(),
              child: const EstablishmentsList(),
            ),
          ],
        ),
      ),
    );
  }
}
