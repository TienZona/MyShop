import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'ui/screens.dart';
Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsmanager){
            productsmanager!.authToken = authManager.authToken;
            return productsmanager;
          }
        ),
        ChangeNotifierProvider(create: (ctx) => CartManager()),
        ChangeNotifierProvider(create: (ctx) => OrdersManager())
      ],
      child: Consumer<AuthManager>(
        builder: (ctx, authmanager, child) {
          return MaterialApp( 
            title: 'My Shop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple
              ).copyWith(
                secondary: Colors.deepOrange
              ),
            ),
            home: authmanager.isAuth
                ? const ProductsOverviewScreen()
                : FutureBuilder(
                  future: authmanager.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? const SplashScreen()
                        : const AuthScreen();
                  },
                ),
            routes: {
              CartScreen.routeName:
                (ctx) => const CartScreen(),
              OrdersScreen.routeName:
                (ctx) => const OrdersScreen(),
              UserProductsScreen.routeName: 
                (ctx) => const UserProductsScreen(),
            },
            onGenerateRoute: (settings) {
              if(settings.name == ProductDetailScreen.routeName){
                final productId = settings.arguments as String;
                return MaterialPageRoute(  
                  builder: (ctx) {
                    return ProductDetailScreen(
                      ctx.read<ProductsManager>().findById(productId),
                    );
                  }
                );
              }
              if(settings.name == EditProductScreen.routeName){
                final productId = settings.arguments as String?;
                return MaterialPageRoute(  
                  builder: (ctx) {
                    return EditProductScreen(
                      productId != null
                      ? ctx.read<ProductsManager>().findById(productId)
                      : null,
                    );
                  }
                );
              }
              return null;
            },
          );
        },
      )
    );
  }
}

