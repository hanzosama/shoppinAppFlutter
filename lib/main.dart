import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pages/product_detail_page.dart';
import 'package:provider/provider.dart';

import './pages/products_overview_page.dart';
import './providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductsOverviewPage(),
        routes: {
          ProducDetailPage.routeName: (context) => ProducDetailPage(),
        },
      ),
    );
  }
}
