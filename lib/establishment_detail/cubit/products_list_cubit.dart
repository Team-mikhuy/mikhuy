import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:models/models.dart';

part 'products_list_state.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  ProductsListCubit() : super(const ProductsListState());

  final _establishmentsRef = FirebaseFirestore.instance
      .collection('establishment')
      .withConverter<Establishment>(
        fromFirestore: (snapshots, _) => Establishment.fromJson(
          snapshots.data()!,
          snapshots.id,
        ),
        toFirestore: (establishments, _) => establishments.toJson(),
      );

  final _reservationRef = FirebaseFirestore.instance
      .collection('reservation')
      .withConverter<Reservation>(
        fromFirestore: (snapshots, _) => Reservation.fromJson(
          snapshots.data()!,
          snapshots.id,
        ),
        toFirestore: (reservation, _) => reservation.toJson(),
      );

  /// Emits a new state with products from the selected establishment.
  /// The list of products will be alphabetically sorted.
  Future<void> getProductsByEstablishment(
    String establishmentID,
  ) async {
    try {
      emit(state.copyWith(productsRequestStatus: RequestStatus.inProgress));
      final snapshot = await _establishmentsRef
          .doc(establishmentID)
          .collection('product')
          .withConverter<Product>(
            fromFirestore: (snapshot, _) =>
                Product.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (product, _) => product.toJson(),
          )
          .get();

      final productsListTemp = snapshot.docs
          .map((e) => e.data())
          .where((element) => element.stock > 0)
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      emit(
        state.copyWith(
          products: productsListTemp,
          productsRequestStatus: RequestStatus.completed,
        ),
      );
    } catch (e) {
      emit(state.copyWith(productsRequestStatus: RequestStatus.failed));
    }
  }

  Future<void> searchProductsByCriteria(
    String establishmentID,
    String criteria,
  ) async {
    if (criteria.isEmpty) return;

    try {
      emit(state.copyWith(productsRequestStatus: RequestStatus.inProgress));

      final snapshot = await _establishmentsRef
          .doc(establishmentID)
          .collection('product')
          .withConverter<Product>(
            fromFirestore: (snapshot, _) =>
                Product.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (product, _) => product.toJson(),
          )
          .get();

      final productsListTemp = snapshot.docs
          .map((e) => e.data())
          .where(
            (element) =>
                element.stock > 0 &&
                element.name.toLowerCase().contains(criteria.toLowerCase()),
          )
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

      emit(
        state.copyWith(
          productsRequestStatus: RequestStatus.completed,
          products: productsListTemp,
        ),
      );
    } catch (e) {
      emit(state.copyWith(productsRequestStatus: RequestStatus.failed));
    }
  }

  void addToCart(Product product, int quantity) {
    final index =
        state.cart.indexWhere((element) => element.productId == product.id);
    if (index == -1) {
      final cartTemp = [...state.cart];
      emit(
        state.copyWith(
          cart: cartTemp
            ..add(
              ReservationDetail(
                id: '',
                productId: product.id,
                productName: product.name,
                quantity: quantity,
                unitPrice: product.price,
                subtotal: product.price * quantity,
              ),
            ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          cart: state.cart
            ..replaceRange(index, index + 1, [
              ReservationDetail(
                id: '',
                productId: product.id,
                productName: product.name,
                quantity: quantity,
                unitPrice: product.price,
                subtotal: product.price * quantity,
              )
            ]),
        ),
      );
    }
  }

  void removeItemFromCart(ReservationDetail reservationDetail) {
    final cartTemp = [...state.cart]
      ..removeWhere((element) => element == reservationDetail);

    emit(state.copyWith(cart: cartTemp));
  }

  Future<void> confirmReservation(
    Establishment establishment,
    String userId,
  ) async {
    emit(state.copyWith(reservationRequestStatus: RequestStatus.inProgress));
    try {
      var total = 0.0;
      for (final element in state.cart) {
        total += element.subtotal;
      }

      final reservation = Reservation(
        id: '',
        userId: userId,
        establishmentId: establishment.id,
        establishmentName: establishment.name,
        establishmentAddress: establishment.address,
        total: total,
        productsCount: state.cart.length,
        dateIssued: DateTime.now(),
        expirationDate: DateTime.now().add(const Duration(hours: 6)),
        status: ReservationStatus.active,
      );

      final doc = await _reservationRef.add(reservation);

      for (final detail in state.cart) {
        await doc
            .collection('reservation_Detail')
            .withConverter<ReservationDetail>(
              fromFirestore: (snapshots, _) => ReservationDetail.fromJson(
                snapshots.data()!,
                snapshots.id,
              ),
              toFirestore: (reservationDetail, _) => reservationDetail.toJson(),
            )
            .add(detail);

        final productRef = _establishmentsRef
            .doc(establishment.id)
            .collection('product')
            .doc(detail.productId)
            .withConverter<Product>(
              fromFirestore: (snapshots, _) => Product.fromJson(
                snapshots.data()!,
                snapshots.id,
              ),
              toFirestore: (product, _) => product.toJson(),
            );

        final productSnap = await productRef.get();
        final product = productSnap.data()!;
        await productRef.update({'stock': product.stock - detail.quantity});
      }
      emit(state.copyWith(reservationRequestStatus: RequestStatus.completed));
    } catch (e) {
      emit(state.copyWith(reservationRequestStatus: RequestStatus.failed));
    }
  }
}
