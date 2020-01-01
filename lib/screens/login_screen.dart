import 'package:flutter/material.dart';
import 'package:ig/screens/signup_screen.dart';
import 'package:ig/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool _isHidePassword = true;

  bool _isLoading = false;

  bool _isButtonTapped = false;

  _onTapped() {
    setState(() => _isButtonTapped = !_isButtonTapped);
    if (_isButtonTapped == true) {
      _submit();
    }
    print(_isButtonTapped);
  }

  _submit() {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Logging in User w/ firebase
      AuthService.login(_email, _password);
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: ()  {
          setState(() {
            FocusScope.of(context).unfocus();
            _isLoading = !_isLoading;
            _isButtonTapped = !_isButtonTapped;
          });
        },
        child: ListView(
          children: <Widget>[
            Container(
              height: mq.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Instagram",
                    style: TextStyle(fontFamily: "Billabong", fontSize: 50),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Email', isDense: true),
                            validator: (input) => !input.contains('@')
                                ? 'Please Enter a Valid Email'
                                : null,
                            onSaved: (input) => _email = input,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    _togglePasswordVisibility();
                                  },
                                  child: Icon(
                                    _isHidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: _isHidePassword
                                        ? Colors.grey
                                        : Colors.blue,
                                  ),
                                ),
                                isDense: true),
                            validator: (input) => input.length < 6
                                ? 'Must be At Least 6 Character'
                                : null,
                            onSaved: (input) => _password = input,
                            obscureText: _isHidePassword,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 250,
                          child: FlatButton(
                            padding: EdgeInsets.all(10),
                            onPressed: _isButtonTapped ? null : _onTapped,
                            color: Colors.blue,
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 250,
                          child: FlatButton(
                            padding: EdgeInsets.all(10),
                            onPressed: () =>
                                Navigator.pushNamed(context, SignupScreen.id),
                            color: Colors.blue,
                            child: Text(
                              "Go to Signup",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
