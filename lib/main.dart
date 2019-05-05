import 'package:firebase_example/Ui/choose_account.dart';
import 'package:firebase_example/Ui/home.dart';
import 'package:firebase_example/Ui/user_login_page.dart';
import 'package:flutter/material.dart';
void main() => runApp(
  MaterialApp(
      debugShowCheckedModeBanner: false,
        routes: {
          "home-page": (context) => Home(),
          "login-page": (context) => UserLoginPage(),
        },
      title: "کتاب فروشی آقای ایکس",
      home: ChooseAccount()
    ),
);



