import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages/user_products_page.dart';
import 'package:provider/provider.dart';

import 'pages/edit_product_page.dart';
import 'pages/orders_page.dart';
import 'pages/cart_page.dart';
import 'providers/cart_provider.dart';
import 'pages/product_detail_page.dart';
import './pages/products_overview_page.dart';
import './providers/products_provider.dart';
import 'providers/orders_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductsOverviewPage(),
        routes: {
          ProducDetailPage.routeName: (context) => ProducDetailPage(),
          CartPage.routeName: (context) => CartPage(),
          OrdersPage.routeName: (context) => OrdersPage(),
          UserProductsPage.routeName: (context) => UserProductsPage(),
          EditProductPage.routeName: (context) => EditProductPage(),
        },
      ),
    );
  }
}
