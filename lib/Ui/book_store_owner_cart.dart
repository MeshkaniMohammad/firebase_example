import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/Ui/order_details.dart';
import 'package:flutter/material.dart';

class BookStroreOwnerCart extends StatefulWidget {
  @override
  _BookStroreOwnerCartState createState() => _BookStroreOwnerCartState();
}

class _BookStroreOwnerCartState extends State<BookStroreOwnerCart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("سبد خرید"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('shoppingCart').snapshots(),
          builder:
              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            else if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    String _fullAddress = snapshot
                        .data.documents[index].data['fullAddress'] as String;
                    String _customerName = snapshot
                        .data.documents[index].data['customerName'] as String;
                    String bookName = snapshot
                        .data.documents[index].data['book name'] as String;
                    String bookAuthor = snapshot
                        .data.documents[index].data['book author'] as String;
String bookImageUrl = snapshot
                        .data.documents[index].data['book image'] as String;
                    String bookPublisher = snapshot
                        .data.documents[index].data["book publisher"] as String;
                    int bookPrice = snapshot
                        .data.documents[index].data["book price"] as int;

                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => OrderDetails(
                                    index: index,
                                    fullAddress: _fullAddress,
                                    customerName: _customerName,
                                  ))),
                      child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  "$bookName",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22),
                                )),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Image.network("$bookImageUrl",width: 100,height: 150,scale: 0.5,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "نویسنده: $bookAuthor",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("ناشر: $bookPublisher"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("قیمت:$bookPrice تومان"),
                              ),
                                  ],
                                ),
                              ],
                              ),
                              
                            ],
                          )),
                    );
                  });
            }
          }),
    );
  }
}
