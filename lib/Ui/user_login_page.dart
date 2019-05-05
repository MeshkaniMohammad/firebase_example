import 'package:firebase_example/Ui/all_books.dart';
import 'package:firebase_example/Utils/auth.dart';
import 'package:firebase_example/Utils/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserLoginPage extends StatefulWidget {
  UserLoginPage({Key key, this.title, this.auth}) : super(key: key);

  final String title;
  final BaseAuth auth;

  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final formKey = new GlobalKey<FormState>();

  @override
  _UserLoginPageState createState() => new _UserLoginPageState(auth: auth);
}

enum LoginFormType { login, register }

class _UserLoginPageState extends State<UserLoginPage> {
  _UserLoginPageState({this.auth});
  final BaseAuth auth;
  String _authHint = '';

  static final scaffoldKey = UserLoginPage.scaffoldKey;
  static final formKey = UserLoginPage.formKey;
  String changeAccountText = 'حساب کاربری نداری؟ایجاد حساب';
  static String _email;
  static String _password;
  LoginFormType _formType = LoginFormType.login;
  var forgotLabel;
  var loginButton;
  bool _isLoading = false;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
       _isLoading = true; 
      });
      return true;
    }
    return false;
  }

  void validateAndLogin() async {
    if (validateAndSave()) {
      try {
        FirebaseUser user = await auth.signIn(_email, _password);
        _showSnackBar('Logged in: ${user.uid}');
        Navigator.push(context, MaterialPageRoute(builder: (c) => AllBooks()));
      } catch (e) {
        _showSnackBar(e.toString());
      }
    }
  }

  void validateAndRegister() async {
    if (validateAndSave()) {
      try {
        FirebaseUser user = await auth.createUser(_email, _password);
        _showSnackBar('Account created: ${user.uid}');

      } catch (e) {
        _showSnackBar(e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = LoginFormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = LoginFormType.login;
    });
  }

  void _showSnackBar(String message) {

    final snackBar = new SnackBar(
      content: new Text(message),
    );

  scaffoldKey.currentState.showSnackBar(snackBar);
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
        child: new TextFormField(
          key: new Key('email'),
          decoration: new InputDecoration(
            labelText: 'ایمیل'),
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          validator: (val) => val.isEmpty || val.contains("admin@admin.com")
              ? 'ایمیل ورودی صحیح نیست'
              : null,
          onSaved: (val) => _email = val,
        ),
      ),
      padded(
          child: new TextFormField(
        key: new Key('password'),
        decoration: new InputDecoration(
          hintText: 'حداقل 9 کاراکتر',
          labelText: 'رمز عبور'),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    if (_isLoading) {
      return [
        Center(
              child: Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator()),
            )
      ];
    }else{
      switch (_formType) {
      case LoginFormType.login:
        return [
          new PrimaryButton(
              key: new Key('login'),
              text: 'ورود',
              height: 44.0,
              onPressed: validateAndLogin),
          FlatButton(
              key: new Key('need-account'),
              child: new Text("حساب کاربری نداری؟ایجاد حساب"),
              onPressed: moveToRegister),
        ];
      case LoginFormType.register:
        return [
          new PrimaryButton(
              key: new Key('register'),
              text: 'ساخت حساب کاربری',
              height: 44.0,
              onPressed: validateAndRegister),
          new FlatButton(
              key: new Key('need-login'),
              child: new Text("حساب کاربری داری؟ورود به حساب"),
              onPressed: moveToLogin),
        ];
    }
    }
    return null;
  }

  Widget hintText() {
    return new Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: new Text(_authHint,
            key: new Key('hint'),
            style: new TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
        appBar: new AppBar(
          centerTitle: true,
          title: new Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
            child: new Container(
                padding: const EdgeInsets.all(16.0),
                child: new Column(children: [
                  new Card(
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        new Container(
                            padding: const EdgeInsets.all(16.0),
                            child: new Form(
                                key: formKey,
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children:
                                      usernameAndPassword() + submitWidgets(),
                                ))),
                      ])),
                  hintText()
                ]))));
  }

  Widget padded({Widget child}) {
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
