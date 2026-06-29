part of 'pos_order_bloc.dart';

@immutable
sealed class PosOrderState {}

final class PosOrderInitial extends PosOrderState {}

final class PosOrderSuccess extends PosOrderState {
  final String waiterName;
  final List<MenuItemModel> listMenuItemModel;
  final bool isSubmiting;

  PosOrderSuccess({
    required this.waiterName,
    required this.listMenuItemModel,
    this.isSubmiting = false,
  });

  PosOrderSuccess copyWith({
    String? waiterName,
    List<MenuItemModel>? listMenuItemModel,
    bool? isSubmiting,
  }) {
    return PosOrderSuccess(
      waiterName: waiterName ?? this.waiterName,
      listMenuItemModel: listMenuItemModel ?? this.listMenuItemModel,
      isSubmiting: isSubmiting ?? this.isSubmiting,
    );
  }

  // SubTotal sebelum diskon dan pajak
  int get subTotal {
    return listMenuItemModel.fold(
      0,
      (total, item) => total + (item.quantity! * item.price!),
    );
  }

  // Diskon 10% jika belanja di atas dari Rp 100.000
  int get discount{
    if(subTotal > 100000){
      return (subTotal * 0.10).round();
    }
    return 0;
  }

  // Nilai setelah discount
  int get totalAfterDiscount{
    return subTotal + discount;
  }

  // Pajak restaurant 12%
  int get tax{
    return (totalAfterDiscount * 0.12).round();
  }

  // Total Pembayaran
  int get totalPayment{
    return totalAfterDiscount + tax;
  }
}
