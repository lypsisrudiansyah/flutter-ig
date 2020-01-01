import 'package:flutter/material.dart';
import 'package:ig/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  static final id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;
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
      print(_email);
      print(_password);
      print(_name);
      /* Logging in the user w/ Firebase */
      AuthService.signUpUser(context, _name, _email, _password);
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
      backgroundColor: Colors.white,
      appBar: null,
      body: GestureDetector(
        onTap: () {
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
                                labelText: 'Name', isDense: true),
                            validator: (input) => input.trim().isEmpty
                                ? 'Please Enter a Valid Name'
                                : null,
                            onSaved: (input) => _name = input,
                          ),
                        ),
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
                            textColor: Colors.white,
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(fontSize: 15),
                                  ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 250,
                          child: FlatButton(
                            padding: EdgeInsets.all(10),
                            onPressed: () => Navigator.pop(context),
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text(
                              "Back to Login",
                              style: TextStyle(fontSize: 15),
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
