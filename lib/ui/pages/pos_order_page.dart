import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_selector_2026/data/models/menu_item_model.dart';

import '../bloc/pos_order_bloc.dart';

class PosOrderPage extends StatelessWidget {
  const PosOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pos Order Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<PosOrderBloc, PosOrderState>(
            builder: (context, state) {
              if (state is PosOrderSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pelayan : ${state.waiterName}'),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PosOrderBloc>().add(
                            ChangeWaiterName(newName: 'Lina (Kasir 2)'),
                          );
                        },
                        child: Text('Ganti Shift'),
                      ),
                    ],
                  ),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pelayan : '),
                  TextButton(onPressed: () {}, child: Text('Ganti Shift')),
                ],
              );
            },
          ),
          Divider(),
          Text('Pilihan Menu'),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 10,
              children: [
                OutlinedButton(
                  onPressed: () {
                    context.read<PosOrderBloc>().add(
                      AddMenuToOrder(
                        menuItemModel: MenuItemModel(
                          id: 1,
                          name: 'Nasi Goreng',
                          price: 25000,
                          quantity: 1,
                        ),
                      ),
                    );
                  },
                  child: Text('Nasi Goreng'),
                ),
                OutlinedButton(
                  onPressed: () {
                    context.read<PosOrderBloc>().add(
                      AddMenuToOrder(
                        menuItemModel: MenuItemModel(
                          id: 2,
                          name: 'Es Teh',
                          price: 10000,
                          quantity: 1,
                        ),
                      ),
                    );
                  },
                  child: Text('Es Teh'),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Daftar Pesanan Saat ini : ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Expanded(
            child: BlocBuilder<PosOrderBloc, PosOrderState>(
              builder: (context, state) {
                if (state is PosOrderSuccess &&
                    state.listMenuItemModel.isEmpty) {
                  return Center(child: Text('Belum ada menu yang dipilih'));
                } else if (state is PosOrderSuccess &&
                    state.listMenuItemModel.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.listMenuItemModel.length,
                    itemBuilder: (_, index) {
                      final menuItemModel = state.listMenuItemModel[index];
                      return ListTile(
                        title: Text('${menuItemModel.name}'),
                        subtitle: Text(
                          'Rp ${menuItemModel.price} x ${menuItemModel.quantity}',
                        ),
                        trailing: Text(
                          '${menuItemModel.price! * menuItemModel.quantity!}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
          // Implementasi BlocSelector untuk Total Harga
          BlocSelector<PosOrderBloc, PosOrderState, int>(
            selector: (state) {
              if (state is PosOrderSuccess) {
                return state.listMenuItemModel.fold(
                  0,
                  (total, item) => total + (item.price! * item.quantity!),
                );
              }
              return 0;
            },
            builder: (context, totalPrice) {
              // Log ini di jalankan jika total kalkulasi belanjaan berubah nominalnya
              // Jika pengguna menekan tombol "Ganti Shift" atau WaiterName berubah,
              // Log ini tidak di jalankan sama sekali
              debugPrint('Widget TOTAL HARGA REBUILD : Rp ${totalPrice}');

              return Container(
                width: double.infinity,
                height: 80,
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    spacing: 10,
                    children: [
                      Text('Total Pembayaran : ', style: Theme.of(context).textTheme.titleMedium,),
                      Text('Rp ${totalPrice}', style: Theme.of(context).textTheme.titleMedium,)
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
