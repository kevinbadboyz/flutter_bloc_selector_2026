import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_selector_2026/data/models/menu_item_model.dart';
import 'package:meta/meta.dart';

part 'pos_order_event.dart';

part 'pos_order_state.dart';

class PosOrderBloc extends Bloc<PosOrderEvent, PosOrderState> {
  PosOrderBloc()
    : super(
        PosOrderSuccess(waiterName: 'Andi (Kasir 1)', listMenuItemModel: []),
      ) {
    // Skenario 1 : Menambahkan makanan atau menambahkan jumlah porsi
    on<AddMenuToOrder>((event, emit) {
      var currentState = state as PosOrderSuccess;
      final existingIndex = currentState.listMenuItemModel.indexWhere(
        (element) => element.id == event.menuItemModel.id,
      );
      List<MenuItemModel> updatedListMenuItemModel = List.from(
        currentState.listMenuItemModel,
      );

      if (existingIndex >= 0) {
        // Jika menu sudah ada di bill, tambahkan quantitynya (+1 porsi)
        final currentItem = currentState.listMenuItemModel[existingIndex];
        updatedListMenuItemModel[existingIndex] = currentItem.copyWith(
          quantity: currentItem.quantity! + 1,
        );
      } else {
        // Jika menu baru dipilih, masukkan ke dalam list
        updatedListMenuItemModel.add(event.menuItemModel);
      }
      // Emit List Baru, mengirimkan salinan list baru ke widget tree
      emit(currentState.copyWith(listMenuItemModel: updatedListMenuItemModel));
    });

    on<ChangeWaiterName>((event, emit) {
      if (state is PosOrderSuccess) {
        var currentState = state as PosOrderSuccess;
        emit(currentState.copyWith(waiterName: event.newName));
      }
    });
  }
}
