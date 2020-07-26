import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/models/save_image.dart';
import 'package:taxi_app/providers/request.dart';
import 'package:taxi_app/screens/bill_splitter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/screens/chat_list_screen.dart';
import 'package:taxi_app/screens/ride_request_screen.dart';
import 'package:taxi_app/screens/settings.dart';
import 'package:taxi_app/screens/welcome_screen.dart';
import '../screens/rickshaw_rates_screen.dart';
import '../screens/taxi_rates_screens.dart';
import '../screens/main_screen.dart';
import '../screens/profile.dart';
import '../providers/auth.dart';
import './profilemodel.dart';

class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final name = Profilee.mydefineduser['name'];
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          AppBar(
            title: Container(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    backgroundImage: image != null ?image.image : null,                     
                    radius: 20,
                  ),
                  SizedBox(width: 8,),
                  Text(
                    'Hello $name', 
                    style: GoogleFonts.alice(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ],
              ),
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(51, 0, 50, 1),
          ),
          //Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Share A Ride', 
              style: GoogleFonts.alice(
                color: Color.fromRGBO(51, 0, 50, 1),
                fontSize: 20
              ),
            )
          ),
          ListTile(
            leading: Icon(Icons.people,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Connect to a Co-Passenger', style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.category,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Bill Splitter',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(BillSPlitterScreen.routeName);
            },
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Mumbai Rates', 
              style: GoogleFonts.alice(
                color: Color.fromRGBO(51, 0, 50, 1),
                fontSize: 20
              ),
            )
          ),
          ListTile(
            leading: Icon(Icons.local_taxi,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Taxi Rates',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TaxiRatesScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.tram,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Rickshaw Rates',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RickshawRatesScreen.routeName);
            },
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Account', 
              style: GoogleFonts.alice(
                color: Color.fromRGBO(51, 0, 50, 1),
                fontSize: 20
              ),
            )
          ),
          ListTile(
            leading: Icon(Icons.chat,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Chat Section', style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: (){ 
              Provider.of<Request>(context,listen:false).fetchRequests();
              Navigator.of(context).pushReplacementNamed(ChatListScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.directions_car,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Ride Requests', style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: (){ 
              Provider.of<Request>(context,listen:false).fetchRequests();
              Navigator.of(context).pushReplacementNamed(RideRequests.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Profile',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              'Access', 
              style: GoogleFonts.alice(
                color: Color.fromRGBO(51, 0, 50, 1),
                fontSize: 20
              ),
            )
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Color.fromRGBO(51, 0, 50, 1),),
            title: Text('Settings',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Settings.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.power_settings_new, color: Color.fromRGBO(51, 0, 50, 1),),
            title: Text('Logout',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
            },
          ),
        ],),
      ),
    );
  }
}