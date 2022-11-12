import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:models/models.dart';

part 'products_list_state.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  ProductsListCubit() : super(ProductsListState());

  final _establishmentsRef = FirebaseFirestore.instance
      .collection('establishment')
      .withConverter<Establishment>(
        fromFirestore: (snapshots, _) => Establishment.fromJson(
          snapshots.data()!,
          snapshots.id,
        ),
        toFirestore: (establishments, _) => establishments.toJson(),
      );

  Future<void> getProductsByEstablishmentAlphabet(
    String establishmentID,
  ) async {
    try {
      emit(state.copyWith(requestStatus: RequestStatus.inProgress));
      final snapshot = await _establishmentsRef
          .doc(establishmentID)
          .collection('product')
          .withConverter<Product>(
            fromFirestore: (snapshot, _) =>
                Product.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (product, _) => product.toJson(),
          )
          .get();
      snapshot.docs
          .map((e) => e.data())
          .toList()
          .sort((a, b) => a.name.compareTo(b.name));

      final productsListTemp = snapshot.docs.map((e) => e.data()).toList();
      emit(
        state.copyWith(
          products: productsListTemp,
          requestStatus: RequestStatus.completed,
        ),
      );
    } catch (e) {
      emit(state.copyWith(requestStatus: RequestStatus.failed));
    }
  }
}
