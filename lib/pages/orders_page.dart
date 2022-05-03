import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/drawer.dart';
import '../widgets/oder_item.dart';
import '../providers/orders_provider.dart' show Orders;

class OrdersPage extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      body: ListView.builder(
        itemCount: ordersData.length,
        itemBuilder: (ctx, index) => OrderItem(ordersData[index]),
      ),
      drawer: AppDrawer(),
    );
  }
}
