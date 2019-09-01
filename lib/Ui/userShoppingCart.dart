import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/Ui/checkout_page.dart';
import 'package:flutter/material.dart';

class UserShoppingCart extends StatefulWidget {

  @override
  _UserShoppingCartState createState() => _UserShoppingCartState();
}

class _UserShoppingCartState extends State<UserShoppingCart> {
  int _favoriteBooksListLength;
  int _sumPrice = 0;
  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("سبد خرید"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('favoriteBooks')?.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data != null) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    String _bookName = snapshot
                        .data.documents[index].data['book name'] as String;
                    String _bookAuthor = snapshot
                        .data.documents[index].data['book author'] as String;
                        String bookImageUrl = snapshot
                        .data.documents[index].data['book image'] as String;

                    String _bookPublisher = snapshot
                        .data.documents[index].data["book publisher"] as String;
                    int _bookPrice = snapshot
                        .data.documents[index].data["book price"] as int;
                    for (int i = 0;
                        i < snapshot?.data?.documents?.length;
                        i++) {
                      _sumPrice += snapshot
                          ?.data?.documents[i]?.data["book price"] as int;
                    }

                    _favoriteBooksListLength =
                        snapshot?.data?.documents?.length;

                    final _item = snapshot.data.documents[index].data;
                    return Dismissible(
                      key: Key(_item.toString()),
                      onDismissed: (direction) {
                        setState(() {
                          List<DocumentSnapshot> documents =
                              snapshot.data.documents;

                          Firestore.instance
                              .runTransaction((Transaction transaction) async {
                            await transaction
                                .delete(documents[index].reference);
                          });
                        });
                      },
                      background: Container(color: Colors.red),
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
                                  "$_bookName",
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
                                  "نویسنده: $_bookAuthor",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("ناشر: $_bookPublisher"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("قیمت:$_bookPrice تومان"),
                              ),
                                  ],
                                ),
                              ],
                              ),
                              
                            ],
                          )),
                    );
                  });
            } else
              return Center(
                child: Text("سبد خرید خالی است"),
              );
          }),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        icon: Icon(Icons.add),
        label: Text("سفارش"),
        onPressed: () {
          if (_favoriteBooksListLength > 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => CheckoutPage(
                          sumPrice: _sumPrice,
                        )));
          } else {
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("سبد خرید خالی است"),
              backgroundColor: Colors.red,
            ));
          }
        },
      ),
    );
  }
}
