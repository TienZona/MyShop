import 'package:flutter/material.dart';
import 'package:myapp/ui/shared/app_drawer.dart';

import 'orders_manager.dart';
import 'order_item_cart.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override  
  Widget build(BuildContext context){
    print('building orders');
    final ordersManager = OrdersManager();

    return Scaffold( 
      appBar: AppBar(  
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: ordersManager.orderCount,
        itemBuilder: (ctx, i) => OrderItemCard(ordersManager.orders[i]),
      ),
    );
  }
}