import 'package:flutter/material.dart';
import 'package:hugsmobileapp/pages/helper/helperFunctions.dart';
import 'package:hugsmobileapp/pages/home/homeList.dart';
import 'package:hugsmobileapp/services/auth.dart';
//import '../bottomNavBar.dart';
import 'package:hugsmobileapp/services/database.dart';


class SignUp extends StatefulWidget {

  final Function toggleView;
  SignUp({ this.toggleView });

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final AuthService _auth = AuthService();

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController confirmedPasswordEditingController = new TextEditingController();

  //identify, validate form, keep track of state of form
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: <Widget> [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.5,
                      0.5
                    ],
                    colors: [Color(0XffFFE289), Color(0XFFE289)]
                ),
              ),
            ),
            Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 200.0),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset('assets/images/Hugs logo.png',
                          height: 80.0,
                          width: 80.0)
                  ),
                )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 150.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget> [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 10.0,
                          )
                        ]
                    ),
                    child: Column(
                      children: <Widget> [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                          child: Text('Welcome to Hugs!',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                          children: <Widget> [
                            Container(
                                padding: EdgeInsets.fromLTRB(25.0, 3.0, 0.0, 5.0),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                ),
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Username or Email",
                                        hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                    controller: emailEditingController,
                                    validator: (val) => val.isEmpty
                                        ? 'Please enter an email'
                                        : null,
                                )
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(25.0, 5.0, 0.0, 3.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                  obscureText: true,
                                  controller: passwordEditingController,
                                  validator: (val) => val.length  < 6
                                      ? 'Please enter minimum 6 characters'
                                      : null,
                                )
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(25.0, 5.0, 0.0, 3.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Confirm Password",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                  obscureText: true,
                                  controller: confirmedPasswordEditingController,
                                  validator: (val) => val != passwordEditingController.text
                                    ? 'Passwords do not match'
                                    : null,
                                )
                             ),
                            SizedBox(height: 10.0),
                            ButtonTheme(
                              minWidth: 200,
                              height: 40,
                              child: RaisedButton(
                                child: Text('Register',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        shadows: <Shadow> [
                                          Shadow(
                                            offset: Offset(2.5, 2.5),
                                            color: Colors.grey.withOpacity(0.6),
                                          )
                                        ]
                                    )),
                                color: Color(0XffFFE289),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () async {
                                  if(_formKey.currentState.validate()) {
                                    dynamic result = await _auth.registerWithEmailAndPassword(emailEditingController.text, passwordEditingController.text);
                                    if(result['user'] == null) {
                                      setState(() {
                                        error = result['error'];
                                      });
                                    } else {
                                      final AuthService _auth = AuthService();
                                      final userId = await _auth.getUserId();

                                      await DatabaseService(uid: userId).updateUserEmail(emailEditingController.text);
                                      HelperFunctions.saveUserLoggedIn(true);
                                      HelperFunctions.saveUserEmail(emailEditingController.text);
                                      print('successfully registered');
                                      Navigator.pushReplacement(context, MaterialPageRoute(
                                          builder: (context) => HomeList())
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 10.0)
                           ],
                         ),
                        ),
                     ]
                   )
                  ),
                  Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                  SizedBox(height: 30.0),
                  Row(
                      children: <Widget> [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.withOpacity(0.9),
                            height: 20.0,
                            thickness: 0.3,
                            endIndent: 15.0,
                          ),
                        ),
                        Text('Register with',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                              //fontSize: 20.0,
                            )
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.withOpacity(0.9),
                            height: 20.0,
                            thickness: 0.3,
                            indent: 15.0,
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget> [
                      Material(
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: Ink.image(
                            image: AssetImage('assets/images/Facebook.png'),
                            fit: BoxFit.cover,
                            width: 35.0,
                            height: 35.0,
                            child: InkWell(
                              onTap: () {},
                            )
                        ),
                      ),
                      SizedBox(width: 20.0),
                      Material(
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: Ink.image(
                            image: AssetImage('assets/images/Google.png'),
                            fit: BoxFit.cover,
                            width: 35.0,
                            height: 35.0,
                            child: InkWell(
                              onTap: () {},
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget> [
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text('Existing user? ',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  shadows: <Shadow> [
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      color: Colors.grey.withOpacity(0.8),
                                    )
                                  ]
                              )
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.toggleView();
                          },
                          child: Text('Login',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0XffFFE289),
                                  fontWeight: FontWeight.bold,
                                  shadows: <Shadow> [
                                    Shadow(
                                      offset: Offset(1.3, 1.3),
                                      color: Colors.grey.withOpacity(0.8),
                                    )
                                  ]
                              )
                          ),
                        )
                      ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
//      bottomNavigationBar: BottomNavBar(),
    );
  }
}
