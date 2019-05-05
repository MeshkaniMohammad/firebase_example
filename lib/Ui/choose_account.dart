import 'package:firebase_example/Ui/AdminLoginPage.dart';
import 'package:firebase_example/Ui/user_login_page.dart';
import 'package:firebase_example/Utils/auth.dart';
import 'package:flutter/material.dart';

class ChooseAccount extends StatelessWidget {
  final BaseAuth auth = new Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("انتخاب حساب کاربری"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin: EdgeInsets.only(top: 50, left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 44),
                  child: RaisedButton(
                    child: new Text("خریدار",
                        style:
                            new TextStyle(color: Colors.white, fontSize: 20.0)),
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(44 / 2))),
                    color: Colors.blue,
                    textColor: Colors.black87,
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          });
                      loginaAsCustomer(context);
                    },
                  ),
                ),
                ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 44),
                    child: RaisedButton(
                      child: new Text("کتاب فروش",
                          style: new TextStyle(
                              color: Colors.white, fontSize: 20.0)),
                      shape: new RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(44 / 2))),
                      color: Colors.blue,
                      textColor: Colors.black87,
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });

                        loginAsBookStoreOwner(context);
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> loginAsBookStoreOwner(BuildContext context)async {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => AdminLoginPage(
              title: 'کتاب فروشی آقای ایکس',
              auth: new Auth(),
            ),
      ),
    );

    return true;
  }

  Future<bool> loginaAsCustomer(BuildContext context) async{
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => UserLoginPage(
              title: 'کتاب فروشی آقای ایکس',
              auth: new Auth(),
            ),
      ),
    );
    return true;
  }
}
