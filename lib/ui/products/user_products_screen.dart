import 'package:flutter/material.dart';
import 'package:myapp/ui/shared/app_drawer.dart';
import 'package:provider/provider.dart';
import 'user_product_list_tile.dart';
import 'products_manager.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  @override

  Widget build(BuildContext context){
    final productsManager = ProductsManager();

    return Scaffold(
      appBar: AppBar(  
        title: const Text('Your Products'),
        actions: <Widget>[
          buildAddButton(),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(  
        onRefresh: () async => print('refresh products'),
        child: buildUserProductListView(productsManager)
      ),
    );
  }

  Widget buildUserProductListView(ProductsManager productsManager){
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child){
        return ListView.builder(  
          itemCount: productsManager.itemCount,
          itemBuilder: (context, index) => Column(  
            children: [
              UserProductListTile(productsManager.items[index]),
              const Divider(),
            ],
          ),
        );
      }
    );
  }

  Widget buildAddButton() {
    return IconButton(  
      icon: const Icon(Icons.add),
      onPressed: () {
        print('Go to edit product screen');
      },
    );
  }
}