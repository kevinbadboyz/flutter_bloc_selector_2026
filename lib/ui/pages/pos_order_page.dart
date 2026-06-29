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
          // Implementasi BlocSelector untuk Subtotal
          BlocSelector<PosOrderBloc, PosOrderState, int>(
            selector: (state) {
              if (state is PosOrderSuccess) {
                return state.subTotal;
              }
              return 0;
            },
            builder: (context, subTotalValue) {
              // Log ini di jalankan jika total kalkulasi belanjaan berubah nominalnya
              // Jika pengguna menekan tombol "Ganti Shift" atau WaiterName berubah,
              // Log ini tidak di jalankan sama sekali
              debugPrint('Widget SUBTOTAL HARGA REBUILD : Rp ${subTotalValue}');

              return Container(
                width: double.infinity,
                color: Colors.orange.shade100,
                child: ListTile(
                  title: Text('Subtotal',
                    style: Theme.of(context).textTheme.titleMedium,),
                  trailing: Text(
                    'Rp ${subTotalValue}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            },
          ),
          // Implementasi BlocSelector untuk Discount
          BlocSelector<PosOrderBloc, PosOrderState, int>(
            selector: (state) {
              if (state is PosOrderSuccess) {
                return state.discount;
              }
              return 0;
            },
            builder: (context, discountValue) {
              if (discountValue == 0) return SizedBox.shrink();

              // Log ini di jalankan jika discount kalkulasi belanjaan berubah nominalnya
              // Jika pengguna menekan tombol "Ganti Shift" atau WaiterName berubah,
              // Log ini tidak di jalankan sama sekali
              debugPrint('Widget DISCOUNT REBUILD : Rp ${discountValue}');

              return Container(
                width: double.infinity,
                color: Colors.orange.shade100,
                child: ListTile(
                  title: Text('Discount',
                    style: Theme.of(context).textTheme.titleMedium,),
                  trailing: Text(
                    'Rp ${discountValue}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            },
          ),

          // Implementasi BlocSelector untuk Tax
          BlocSelector<PosOrderBloc, PosOrderState, int>(
            selector: (state) {
              if (state is PosOrderSuccess) {
                return state.tax;
              }
              return 0;
            },
            builder: (context, taxValue) {
              if (taxValue == 0) return SizedBox.shrink();

              // Log ini di jalankan jika tax kalkulasi belanjaan berubah nominalnya
              // Jika pengguna menekan tombol "Ganti Shift" atau WaiterName berubah,
              // Log ini tidak di jalankan sama sekali
              debugPrint('Widget TAX REBUILD : Rp ${taxValue}');

              return Container(
                width: double.infinity,
                color: Colors.orange.shade100,
                child: ListTile(
                  title: Text('Pajak (12%)',
                    style: Theme.of(context).textTheme.titleMedium,),
                  trailing: Text(
                    'Rp ${taxValue}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              );
            },
          ),

          // Implementasi BlocSelector untuk Total Bayar
          BlocSelector<PosOrderBloc, PosOrderState, int>(
            selector: (state) {
              if (state is PosOrderSuccess) {
                return state.totalPayment;
              }
              return 0;
            },
            builder: (context, totalPaymentValue) {
              if (totalPaymentValue == 0) return SizedBox.shrink();
              // Log ini di jalankan jika total bayar kalkulasi belanjaan berubah nominalnya
              // Jika pengguna menekan tombol "Ganti Shift" atau WaiterName berubah,
              // Log ini tidak di jalankan sama sekali
              debugPrint(
                'Widget TOTAL BAYAR REBUILD : Rp ${totalPaymentValue}',
              );

              return Container(
                width: double.infinity,
                color: Colors.orange.shade100,
                child: ListTile(
                  title: Text('Total Bayar',
                    style: Theme.of(context).textTheme.titleMedium,),
                  trailing: Text(
                    'Rp ${totalPaymentValue}',
                    style: Theme.of(context).textTheme.titleMedium,
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
