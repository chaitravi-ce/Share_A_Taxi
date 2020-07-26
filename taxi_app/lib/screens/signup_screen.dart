import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'loginScreen.dart';
import 'package:progress_indicators/progress_indicators.dart';
import '../widgets/ui_Container.dart';
import '../providers/user.dart';
import 'package:http/http.dart' as http;
import '../providers/auth.dart';
import '../providers/users.dart';

class SignUpScreen extends StatefulWidget {

  static const routeName = '/signup';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool _obscureText = true;
  bool _obscureText1 = true;
  var _isLoading = false;
  final _phonefocus = FocusNode();
  final _usernamefocus = FocusNode();
  final _pass1focus = FocusNode();
  final _pass2focus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noController = TextEditingController();
  final _usernameController = TextEditingController();
  final _pass1Controller = TextEditingController();
  final _pass2Controller = TextEditingController();

  void _toggleSeen(){
    setState(() {
      _obscureText = !_obscureText;
    });   
  }

  void _toggleSeen1(){
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  void dispose() {
    _phonefocus.dispose();
    _usernamefocus.dispose();
    _pass1focus.dispose();
    _pass2focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var _newUser = User(
      id: null,
      name: '',
      contactNo: '',
      username: '',
      password: '',
    );

    void _showErrorDialog(String message) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'An Error Occurred!',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(
            message,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Okay',
                style: TextStyle(color: Theme.of(context).primaryColor),  
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
    }

    void _showSuccessDialog(){
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            'Signed Up Successfully!',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(
            'Please Login using your newly created acount.',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Go to Login Screen',
                style: TextStyle(color: Theme.of(context).primaryColor),  
              ),
              onPressed: () {
                Navigator.of(ctx).pushReplacementNamed(LoginScreen.routeName);
              },
            )
          ],
        ),
      );
    }

    Future<void> submit() async{
      setState(() {
        _isLoading = true;
      });
      final isValid = _formKey.currentState.validate();
      if (!isValid) {
        print('Line 66');
        return;
      }
      _formKey.currentState.save();

      _newUser=User(
        name:_nameController.text,
        contactNo: _noController.text,
        username: _usernameController.text,
        password: _pass1Controller.text,
        id: DateTime.now().toString(),
      );
      print(_newUser.username+" hiiiiiiii"+_newUser.password);
      final url ='https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCE4eIGuIXww0YRBda6xsaN2fxzSiKY_cA';
      final response = await http.post(
      url,
      body: json.encode(
        {
          'email': _usernameController.text,
          'password': _pass1Controller.text,
          'returnSecureToken': true,
        },
      ),
      );
      final responseData = json.decode(response.body);
      if(responseData['error']!=null){
      var error = responseData['error']['message'];
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      }
      print("hhhh============================================"); 
      setState(() {
        _isLoading = false;
      });   
      return _showErrorDialog(errorMessage);
    }else{
      print('signup verification done');
      setState(() {
        _isLoading = false;
      });
      Provider.of<Auth>(context, listen:false).registerUser(_noController.text);
      _showSuccessDialog();
      await Provider.of<Users>(context, listen: false).addUser(_newUser);
      print('User added');
      print(_newUser.name);
      print(_newUser.contactNo);
      print(_newUser.username);
      print(_newUser.password);
      //print(Provider.of<Auth>(context, listen: false).userId);
    }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: _isLoading == true ? Center(child: JumpingText(
          'Please Wait...Signing Up',
          style: TextStyle(color: Theme.of(context).primaryColor),
        )) : Stack(
          alignment: Alignment.center,
          children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/signup_top.png", width: size.width*0.3,),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset("assets/images/main_bottom.png", width: size.width*0.23),
          ),
          SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: size.height*0.1,),
              Text('SIGN UP', style: GoogleFonts.grenze(
                fontSize: 40, 
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic
              ),),
              SizedBox(height: size.height*0.015,),
              SvgPicture.asset("assets/icons/signup.svg"),
              SizedBox(height: size.height*0.015,),
              Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  UiContainer(
                    TextFormField(
                     
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                        hintText: 'Name'
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phonefocus);
                      },
                      controller: _nameController,
                      validator: (value){
                        if(value.isEmpty){
                          return 'Name should not be empty';
                        }
                        return null;
                      },
                    ),
                    Theme.of(context).accentColor,
                    size.width*0.8,
                  ),
                  UiContainer(
                    TextFormField(
                      
                      decoration: InputDecoration(
                        icon: Icon(Icons.contact_phone, color: Theme.of(context).primaryColor,),
                        hintText: 'Contact No.'
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: _phonefocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_usernamefocus);
                      },
                      validator: (value){
                        if(value.isEmpty){
                          return 'Contact Number should not be empty';
                        }
                        if(value.length != 10){
                          return 'Enter a valid Contact Number';
                        }
                        return null;
                      },
                      controller: _noController,
                    ),
                    Theme.of(context).accentColor,
                    size.width*0.8,
                  ),
                  UiContainer(
                    TextFormField(
                      
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle, color: Theme.of(context).primaryColor,),
                        hintText: 'Username (Email ID)'
                      ),
                      focusNode: _usernamefocus,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pass1focus);
                      },
                      controller: _usernameController,
                      validator: (value){
                        if(value.isEmpty){
                          return 'Username should not be empty';
                        }
                        return null;
                      },
                    ),
                    Theme.of(context).accentColor,
                    size.width*0.8,
                  ),
                  UiContainer(
                    TextFormField(
                  
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Theme.of(context).primaryColor,),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility), 
                          color: Theme.of(context).primaryColor,
                          onPressed: _toggleSeen,
                        ),
                        hintText: 'Password',
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Password should not be empty';
                        }
                        return null;
                      },
                      focusNode: _pass1focus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pass2focus);
                      },
                      controller: _pass1Controller,
                    ),
                    Theme.of(context).accentColor,
                    size.width*0.8,
                  ),
                  UiContainer(
                    TextFormField(
                      autovalidate: true,
                      obscureText: _obscureText1,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Theme.of(context).primaryColor,),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility), 
                          color: Theme.of(context).primaryColor,
                          onPressed: _toggleSeen1,  
                        ),
                        hintText: 'Confirm Password',
                      ),
                      focusNode: _pass2focus,
                      controller: _pass2Controller,
                      validator: (value) {
                        if(value != _pass2Controller.text){
                          return 'Password doesnt match';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_){
                        submit();
                      },
                    ),
                    Theme.of(context).accentColor,
                    size.width*0.8
                  ),
                ])
              ),
              UiContainer(
                FlatButton(
                  onPressed: submit, 
                  child: Text('Sign Up', style: TextStyle(color: Colors.white),)
                ),
                Theme.of(context).primaryColor,
                size.width*0.4,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text(
                  "Already have an accout ?", 
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, 
                  ),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                  },
                  child: Text(
                    'Login', 
                    style: TextStyle(
                      color: Theme.of(context).primaryColor, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],),
              SizedBox(height: size.height*0.1,),
            ],),
          ),
        ],),
      ),
    );
  }
}
