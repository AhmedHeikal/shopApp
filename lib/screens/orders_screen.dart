import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreeen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreeenState createState() => _OrderScreeenState();
}

class _OrderScreeenState extends State<OrderScreeen> {
  Future _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).festchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your orders'),
        ),
        drawer: AppDrwaer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnashopt) {
            if (dataSnashopt.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnashopt.error != null) {
              return Center(
                child: Text('An Error Occured'),
              );
            } else {
              return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) => OrderItem(
                          orderData.orders[i],
                        ),
                      ));
            }
          },
        ));
  }
}
