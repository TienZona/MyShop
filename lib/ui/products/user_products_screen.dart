import 'package:flutter/material.dart';
import 'package:myapp/ui/shared/app_drawer.dart';
import 'package:provider/provider.dart';
import 'user_product_list_tile.dart';
import '../screens.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});


  Future<void> _refreshProducts(BuildContext context) async {
    await context.read<ProductsManager>().fetchProducts(true);
  }

  @override

  Widget build(BuildContext context){
    final productsManager = ProductsManager();

    return Scaffold(
      appBar: AppBar(  
        title: const Text('Your Products'),
        actions: <Widget>[
          buildAddButton(context),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(  
        future: _refreshProducts(context),
        builder: (ctx, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(  
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(  
            onRefresh: () => _refreshProducts(context),
            child: buildUserProductListView(productsManager),
          );
        },
      )
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

  Widget buildAddButton(BuildContext context){
    return IconButton(  
      icon: const Icon(Icons.add),
      onPressed: () {
        Navigator.of(context).pushNamed(
          EditProductScreen.routeName,
        );
      },
    );
  }
}