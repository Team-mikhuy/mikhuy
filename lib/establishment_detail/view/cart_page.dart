import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:models/models.dart';

class CartPage extends StatelessWidget {
  CartPage(this._establishment, {super.key});
  final Establishment _establishment;
  List<Product> listProducts = const [
    Product(id: '', name: 'Leche', imageUrl: '', stock: 2, price: 10),
    Product(id: '', name: 'Palmitos', imageUrl: '', stock: 4, price: 30),
    Product(id: '', name: 'Agua', imageUrl: '', stock: 1, price: 40),
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }
}
