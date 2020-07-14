import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taxi_app/providers/request.dart';
import 'package:taxi_app/screens/bill_splitter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/screens/ride_request_screen.dart';
import 'package:taxi_app/screens/welcome_screen.dart';
import '../screens/rickshaw_rates_screen.dart';
import '../screens/taxi_rates_screens.dart';
import '../screens/main_screen.dart';
import '../screens/profile.dart';
import '../providers/auth.dart';
import './profilemodel.dart';

class AppDrawer extends StatelessWidget {

  final name = Profilee.mydefineduser['name'];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          AppBar(
            title: Text('Hello $name', style: GoogleFonts.alice(color: Colors.white, fontWeight: FontWeight.bold)),
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromRGBO(51, 0, 50, 1),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Connect to a Co-Passenger', style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.directions_car,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Your Requests', style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: (){ 
              Provider.of<Request>(context,listen:false).fetchRequests();
              Navigator.of(context).pushReplacementNamed(RideRequests.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.category,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Bill Splitter',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(BillSPlitterScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_taxi,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Taxi Rates',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TaxiRatesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.tram,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Rickshaw Rates',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RickshawRatesScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle,color: Color.fromRGBO(51, 0, 50, 1)),
            title: Text('Your Profile',style: GoogleFonts.alice(color: Color.fromRGBO(51, 0, 50, 1),),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          Divider(),
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