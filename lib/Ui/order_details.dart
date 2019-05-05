import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  final int index;
  final String fullAddress;
  final String customerName;

  const OrderDetails({Key key, this.index, this.fullAddress, this.customerName})
      : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("جزییات سفارش"),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.customerName),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.fullAddress),
                )
              ],
            ),
          ),
        ));
  }
}
