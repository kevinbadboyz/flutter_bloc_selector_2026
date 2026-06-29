part of 'pos_order_bloc.dart';

@immutable
sealed class PosOrderEvent {}

final class AddMenuToOrder extends PosOrderEvent {
  final MenuItemModel menuItemModel;

  AddMenuToOrder({required this.menuItemModel});
}

final class ChangeWaiterName extends PosOrderEvent {
  final String newName;

  ChangeWaiterName({required this.newName});
}
