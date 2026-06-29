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
    String? waiterName, List<
        MenuItemModel>? listMenuItemModel, bool? isSubmiting
  }) {
    return PosOrderSuccess(waiterName: waiterName ?? this.waiterName,
        listMenuItemModel: listMenuItemModel ?? this.listMenuItemModel,
        isSubmiting: isSubmiting ?? this.isSubmiting);
  }
}
