part of 'products_list_cubit.dart';

class ProductsListState extends Equatable {
  const ProductsListState({
    required this.establishment,
    this.products = const [],
    this.cart = const [],
    this.productsRequestStatus = RequestStatus.initial,
    this.reservationRequestStatus = RequestStatus.initial,
  });

  final Establishment establishment;
  final List<Product> products;
  final List<ReservationDetail> cart;
  final RequestStatus productsRequestStatus;
  final RequestStatus reservationRequestStatus;

  @override
  List<Object> get props => [
        establishment,
        products,
        cart,
        productsRequestStatus,
        reservationRequestStatus,
      ];

  ProductsListState copyWith({
    Establishment? establishment,
    List<Product>? products,
    List<ReservationDetail>? cart,
    RequestStatus? productsRequestStatus,
    RequestStatus? reservationRequestStatus,
  }) {
    return ProductsListState(
      establishment: establishment ?? this.establishment,
      products: products ?? this.products,
      cart: cart ?? this.cart,
      productsRequestStatus:
          productsRequestStatus ?? this.productsRequestStatus,
      reservationRequestStatus:
          reservationRequestStatus ?? this.reservationRequestStatus,
    );
  }
}
