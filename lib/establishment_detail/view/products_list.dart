import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductsList extends StatelessWidget {
  const ProductsList(this.establishment, {super.key});
  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    loadData(establishment.id);

    return _ProductsListView(establishment.products);
  }

  void loadData(String establishmentID) async {
    final _establishmentsRef = FirebaseFirestore.instance
        .collection('establishment')
        .withConverter<Establishment>(
          fromFirestore: (snapshots, _) => Establishment.fromJson(
            snapshots.data()!,
            snapshots.id,
          ),
          toFirestore: (establishments, _) => establishments.toJson(),
        );

    final snapshot = await _establishmentsRef
        .doc(establishmentID)
        .collection('product')
        .withConverter<Product>(
          fromFirestore: (snapshot, _) =>
              Product.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (product, _) => product.toJson(),
        )
        .get();

    final productsListTemp = snapshot.docs.map((e) => e.data()).toList();
    establishment.copyWith(products: productsListTemp);
    
  }
}

class _ProductsListView extends StatelessWidget {
  const _ProductsListView(this.products);
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(height: 16),
        itemCount: products.length,
        itemBuilder: (context, index) => _ProductsListItem(
          products[index],
        ),
      ),
    );
  }
}

class _ProductsListItem extends StatelessWidget {
  const _ProductsListItem(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text(product.name),
    );
  }
}
