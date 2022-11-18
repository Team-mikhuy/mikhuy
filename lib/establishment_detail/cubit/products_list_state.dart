part of 'products_list_cubit.dart';

class ProductsListState extends Equatable {
  const ProductsListState({
    this.products = const [],
    this.cart = const [],
    this.productsRequestStatus = RequestStatus.initial,
    this.reservationRequestStatus = RequestStatus.initial,
  });

  final List<Product> products;
  final List<ReservationDetail> cart;
  final RequestStatus productsRequestStatus;
  final RequestStatus reservationRequestStatus;

  @override
  List<Object> get props =>
      [products, cart, productsRequestStatus, reservationRequestStatus];

  ProductsListState copyWith({
    List<Product>? products,
    List<ReservationDetail>? cart,
    RequestStatus? productsRequestStatus,
    RequestStatus? reservationRequestStatus,
  }) {
    return ProductsListState(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      productsRequestStatus:
          productsRequestStatus ?? this.productsRequestStatus,
      reservationRequestStatus:
          reservationRequestStatus ?? this.reservationRequestStatus,
    );
  }
}
