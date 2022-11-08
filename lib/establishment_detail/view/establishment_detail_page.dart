import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mikhuy/theme/app_colors.dart';
import 'package:models/establishment.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EstablishmentDetailPage extends StatelessWidget {
  final Establishment _establishment;
  const EstablishmentDetailPage(this._establishment, {super.key});

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

    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text(_establishment.name),
        leading: new IconButton(
            onPressed: () => {
                  Navigator.of(context).pop(),
                },
            icon: new Icon(MdiIcons.arrowLeft)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {},
                  child: Row(
                    children: [
                      Icon(MdiIcons.mapMarkerOutline),
                      Text(
                        _establishment.address,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.blue),
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
              'Todos los días de ' +
                  _establishment.openingTime.hour.toString() +
                  ':' +
                  _establishment.openingTime.minute.toString() +
                  ' a ' +
                  _establishment.closingTime.hour.toString() +
                  ':' +
                  _establishment.closingTime.minute.toString(),
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
          ],
        ),
      ),
    );
  }

  /*_launchURL() async {
    final url = 'https://www.google.com/maps/search/?api=1&query=' +
                            _establishment.latitude.toString() +
                            '%2C' +
                            _establishment.longitude.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/
}
