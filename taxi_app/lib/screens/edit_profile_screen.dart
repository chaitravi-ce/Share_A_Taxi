import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/models/profilemodel.dart';
import 'package:taxi_app/widgets/ui_Container.dart';

class EditProfileScreen extends StatefulWidget {

  static const routeName = '/edit-profile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {


  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
   
  @override
  void initState() {
    name.text = Profilee.mydefineduser['name'];
    email.text = Profilee.mydefineduser['username'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    updateProfile()async{
      final isValid = _formKey.currentState.validate();
      if (!isValid) {
        return;
      }
      final url = 'https://samelocationsametaxi.firebaseio.com/users.json';
      final response =  await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      if(extractedData == null){
        print('in null');
        return ;
      }
      String contactNo = Profilee.mydefineduser['contactNo'];
      print(contactNo);
      extractedData.forEach((userID, userData){
        if(Profilee.mydefineduser['username'] == userData['username']){
          final url3 = 'https://samelocationsametaxi.firebaseio.com/users/$userID.json';
          http.patch(url3,
            body: json.encode({
              'name' : name.text,
              'username' : email.text,
            })
          );
        }
      });
      Profilee.mydefineduser['name'] = name.text;
      Profilee.mydefineduser['username'] = email.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("email", email.text);
    }
    
    final emailFocus = FocusNode();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile', style: GoogleFonts.grenze(fontSize: 25,),),),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              SizedBox(height: size.height*0.07,),
              Image.asset('assets/images/edit.png'),
              SizedBox(height: size.height*0.07,),
              Container(
                alignment: Alignment.center,
                child: UiContainer(
                  TextFormField(
                    controller: name,
                    cursorColor: Theme.of(context).primaryColor,       
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                      hintText: 'Enter Name',               
                    ),
                    onFieldSubmitted: (_){
                      FocusScope.of(context).requestFocus(emailFocus);
                    },
                    style: GoogleFonts.galada(),
                  ),
                  Theme.of(context).accentColor,
                  size.width*0.8
                ),
              ),
              UiContainer(
                TextFormField(
                  controller: email,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email, color: Theme.of(context).primaryColor,),
                    hintText: 'Enter Email'
                  ),
                  onFieldSubmitted: (_){
                    updateProfile();
                  },
                  style: GoogleFonts.galada(),
                ),
                Theme.of(context).accentColor,
                size.width*0.8
              ),
            ],),
          ),
          UiContainer(
            FlatButton(
              onPressed: (){
                print('inininininin');
                updateProfile();
              }, 
              child: Text('Edit Profile', style: GoogleFonts.galada(color: Colors.white))
            ),
            Theme.of(context).primaryColor,
            size.width*0.8
          )
        ],),
      ),
    );
  }
}