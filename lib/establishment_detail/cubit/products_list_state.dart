part of 'products_list_cubit.dart';

class ProductsListState extends Equatable {
  ProductsListState({
    this.products = const [],
    this.requestStatus = RequestStatus.initial,
  });

  final List<Product> products;
  final RequestStatus requestStatus;

  @override
  // TODO: implement props
  List<Object> get props => [products, requestStatus];

  ProductsListState copyWith({
    List<Product>? products,
    RequestStatus? requestStatus,
  }) {
    return ProductsListState(
      products: products ?? this.products,
      requestStatus: requestStatus ?? this.requestStatus,
    );
  }
}
