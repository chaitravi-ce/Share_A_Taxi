import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/models/app_drawer.dart';
import 'package:taxi_app/models/profilemodel.dart';
import 'package:taxi_app/models/save_image.dart';

class Settings extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  //getImage()async{
  //  String uid;
  //  final url = 'https://samelocationsametaxi.firebaseio.com/users.json';
  //  final response =  await http.get(url);
  //  final extractedData = json.decode(response.body) as Map<String,dynamic>;
  //  if(extractedData == null){
  //    print('in null');
  //    return ;
  //  }
  //  String contactNo = Profilee.mydefineduser['contactNo'];
  //  print(contactNo);
  //  extractedData.forEach((userID, userData){
  //    if(Profilee.mydefineduser['username'] == userData['username']){
  //      uid = userID;
  //    }
  //  });
  //  final url2 = 'https://samelocationsametaxi.firebaseio.com/users/$uid.json';
  //  final resp = await http.get(url2);
  //  final extractedData2 = json.decode(resp.body) as Map<String,dynamic>;
  //  String image = extractedData2['image'];
  //  print(image);
  //  setState(() {
  //    image = ImageSharedPrefs.imageFrom64BaseString(image);
  //  });   
  //}
  Image image;

  loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageKeyValue = prefs.getString(IMAGE_KEY);
    if (imageKeyValue != null) {
      final imageString = await ImageSharedPrefs.loadImageFromPrefs();
      setState(() {
        image = ImageSharedPrefs.imageFrom64BaseString(imageString);
      });
    }
  } 
  
  @override
  void initState() {
    loadImageFromPrefs();
    super.initState();
  }

  bool isSwitched = false;
  bool isSwitched2  = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: GoogleFonts.grenze(fontSize: 26,),),),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 50,),
          Container(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              backgroundImage: image != null ? image.image : null,                     
              radius: 85,
            ),
          ),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Show Image to everyone',
                style: GoogleFonts.aBeeZee(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
              SizedBox(width: 40,),
              Container(
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    Profilee.mydefineduser['showImage'] = value;
                    isSwitched = value;
                    print(isSwitched);
                  });
                },
                activeTrackColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).accentColor,
              ),),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Show Contact No. to everyone',
                style: GoogleFonts.aBeeZee(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
              ),
              SizedBox(width: 18,),
              Container(
              child: Switch(
                value: isSwitched2,
                onChanged: (value) {
                  setState(() {
                    Profilee.mydefineduser['showContact'] = value;
                    isSwitched2 = value;
                    print(Profilee.mydefineduser['showContact']);
                  });
                },
                activeTrackColor: Theme.of(context).primaryColor,
                activeColor: Theme.of(context).accentColor,
              ),),
            ],
          ),
        ],
      )
    );
  }
}