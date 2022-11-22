import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

import 'package:movies/models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(
                'An error ocurred',
                textAlign: TextAlign.center,
              ),
              content: Text(
                message,
                style: const TextStyle(color: Colors.grey, fontSize: 17),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text("Okay"))
              ],
            ));
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'] as String, _authData['password'] as String);
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
            _authData['email'] as String, _authData['password'] as String);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication failed";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "Email already exists";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "Invalid Email";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage = "Couldn't find a user with that email";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Invalid password";
      }
      print(errorMessage);
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = "Couldn't authenticate. Try again later";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 201, 0, 0).withOpacity(0.5),
                  Color.fromARGB(255, 100, 1, 1).withOpacity(0.9),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),

                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red[800],
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        'My Movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontFamily: 'Quicksand',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      flex: deviceSize.width > 600 ? 2 : 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 8.0,
                        child: Container(
                          height: _authMode == AuthMode.Signup ? 380 : 300,
                          constraints: BoxConstraints(
                              minHeight:
                                  _authMode == AuthMode.Signup ? 380 : 300),
                          width: deviceSize.width * 0.75,
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                        labelText: 'E-Mail'),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Invalid email!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _authData['email'] = value!;
                                    },
                                  ),
                                  TextFormField(
                                    style: const TextStyle(color: Colors.black),
                                    decoration: const InputDecoration(
                                        labelText: 'Password'),
                                    obscureText: true,
                                    controller: _passwordController,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 5) {
                                        return 'Password is too short!';
                                      }
                                    },
                                    onSaved: (value) {
                                      _authData['password'] = value!;
                                    },
                                  ),
                                  if (_authMode == AuthMode.Signup)
                                    TextFormField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      enabled: _authMode == AuthMode.Signup,
                                      decoration: const InputDecoration(
                                          labelText: 'Confirm Password'),
                                      obscureText: true,
                                      validator: _authMode == AuthMode.Signup
                                          ? (value) {
                                              if (value !=
                                                  _passwordController.text) {
                                                return 'Passwords do not match!';
                                              }
                                            }
                                          : null,
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (_isLoading)
                                    const CircularProgressIndicator()
                                  else
                                    ElevatedButton(
                                      onPressed: _submit,
                                      style: ElevatedButton.styleFrom(
                                          primary:
                                              Theme.of(context).accentColor),
                                      child: Text(_authMode == AuthMode.Login
                                          ? 'LOGIN'
                                          : 'SIGN UP'),
                                    ),
                                  TextButton(
                                    onPressed: _switchAuthMode,
                                    child: Text(
                                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
