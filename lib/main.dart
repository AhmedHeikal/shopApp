import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/custom_route.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/auth.dart';

import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
            create: null,
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
            create: null,
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  })),
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResltSnapshot) =>
                          authResltSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrderScreeen.routeName: (ctx) => OrderScreeen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              }),
        ));
  }
}
