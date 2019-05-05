import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/Ui/GuillotineMenu.dart';
import 'package:firebase_example/Ui/book_descreptions.dart';
import 'package:firebase_example/Ui/userShoppingCart.dart';
import 'package:flutter/material.dart';

class AllBooks extends StatefulWidget {
  @override
  AllBooksState createState() => AllBooksState();
}

class AllBooksState extends State<AllBooks> {
  void pushGuillotine(BuildContext context, WidgetBuilder builder) {
    Navigator.push(context, new GuillotinePageRoute(builder: builder));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تمام کتاب ها"),
        centerTitle: true,
        leading: new RotatedBox(
          quarterTurns: -1,
          child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () =>
                  pushGuillotine(context, (context) => MenuPage())),
        ),
        actions: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: 40,
            child: StreamBuilder(
                stream:
                    Firestore.instance.collection('favoriteBooks').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return BadgeIconButton(
                      icon: Icon(Icons.shopping_cart),
                      itemCount: snapshot?.data?.documents?.length == 0
                          ? 0
                          : snapshot?.data?.documents?.length,
                      onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserShoppingCart(),
                            ),
                          ),
                    );
                  } else {
                    return Container(
                      height: 0,
                      width: 0,
                    );
                  }
                }),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
            stream: Firestore.instance.collection('books').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
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
                    int _quantity = snapshot
                        .data.documents[index].data["quantity"] as int;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => BookDescription(
                                    bookImageUrl,
                                    bookAuthor,
                                    bookName,
                                    bookPrice,
                                    bookPublisher,
                                    _quantity,
                                    index,
                                    snapshot.data.documents)));
                      },
                      child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      _quantity.toString(),
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.redAccent),
                                    ),
                                    SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: IconButton(
                                            icon: Image.asset(
                                                "assets/icons/categories.png"),
                                            onPressed: null)),
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child:
                                          Image.asset("assets/icons/shelf.png"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    );
                  });
            }),
      ),
    );
  }
}
