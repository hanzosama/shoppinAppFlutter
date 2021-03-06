import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/edit_product_page.dart';
import '../providers/products_provider.dart';
import '../widgets/drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsPage extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print('Rebuilding....');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductPage.routeName);
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: (() => _refreshProducts(context)),
                    child: Consumer<Products>(
                      builder: (context, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItem(
                                productsData.items[index].id,
                                productsData.items[index].title,
                                productsData.items[index].imageUrl,
                              ),
                              Divider()
                            ],
                          ),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
