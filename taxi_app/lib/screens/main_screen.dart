import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../providers/request.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/ui_Container.dart';
import '../models/app_drawer.dart';
import '../widgets/location_input.dart';
import '../models/place_location.dart';

class MainScreen extends StatefulWidget{

  static const routeName = '/mainScreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final _locationStartController = TextEditingController();
  final _locationEndController = TextEditingController();
  PlaceLocation _pickedStartLocation;
  PlaceLocation _pickedEndLocation;
  String staddress;
  String endaddress;
  List<String> getType = ['Taxi', 'Rickshaw'];
  String selectedtype;
  String selectedResponse;
  List<String> getResponse = ['Yes', 'No'];

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List types){
    List<DropdownMenuItem<String>> items = List();
    for(String type in types){
      items.add(
        DropdownMenuItem(
          value: type, 
          child: Text(type, style: TextStyle(color: Theme.of(context).primaryColor),)
        )
      );
    } 
    return items;
  }
  int _groupValue = -1;
  Widget _myRadioButton({String title, int value, Function onChanged}) {
  return RadioListTile(
    activeColor: Theme.of(context).primaryColor,
    value: value,
    groupValue: _groupValue,
    onChanged: onChanged,
    title: Text(title),
  );
  }


  String getStartAddress(double latitude, double longitude){
   convertToStartAddress(latitude, longitude).then((value) {
     print("hi======================================");
     print(staddress);
     return staddress;
   });
   return staddress;
  }

  String getEndAddress(double latitude, double longitude){
    convertToEndAddress(latitude, longitude).then((value) {
      print("hi======================================");
      print(endaddress);
      return endaddress;
   });
   return endaddress;
  }

  Future<void>convertToEndAddress(double latitude, double longitude)async{
    print("coming here");

    final coordinates = new Coordinates(latitude, longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(first);
    endaddress=first.addressLine.toString();
    print(first.addressLine.runtimeType);
    print("=======================");
    //print(first.toString());
    return first.addressLine;
  }

  Future<void>convertToStartAddress(double latitude, double longitude)async{
    print("coming here");

    final coordinates = new Coordinates(latitude, longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(first);
    staddress=first.addressLine.toString();
    print(first.addressLine.runtimeType);
    print("=======================");
    //print(first.toString());
    return first.addressLine;
  }

  Future<void> _launchNav(double startLat, double startLong, double endLat, double endLong) async {
    String api = 'https://www.google.com/maps/dir/?api=1&origin=($startLat,$startLong)&destination=($endLat,$endLong)&travelmode=drive';
    if (await canLaunch(api)) {
      await launch(api);
    } else {
      throw 'Could not launch $api';
    }
  }
  String email;

  String getmail(){
    getEmail().then((value) {
      return email;
    });
    return email;
  }

  Future getEmail()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.get("email");
    print(email);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    void _selectStartPlace(double lat, double lng) {
      _pickedStartLocation = PlaceLocation(latitude: lat, longitude: lng, address: " ");
      print("here====================================");
      print(_pickedStartLocation);
    }

    void _selectEndPlace(double lat, double lng) {
      _pickedEndLocation = PlaceLocation(latitude: lat, longitude: lng, address: " ");
      print(_pickedEndLocation);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Same Location, Same Taxi'),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(height: size.height*0.01,),
          Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment(0.0,0.0),
            width: size.width*0.9,
            child: UiContainer(
              TextField(
                controller: _locationStartController,
                decoration: InputDecoration(
                  hintText: 'Select a Start Location',
                  icon: Icon(Icons.search),
                  focusColor: Theme.of(context).primaryColor,
                  labelText: _pickedStartLocation!=null ? getStartAddress(_pickedStartLocation.latitude, _pickedStartLocation.longitude).toString() : "Select a Start Location",
                ),
              ),
              Theme.of(context).accentColor,
              size.width*0.9
            ),
          ),
          LocationInput(_selectStartPlace),
          Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment(0.0,0.0),
            width: size.width*0.9,
            child: UiContainer(
              TextField(
                controller: _locationEndController,
                decoration: InputDecoration(
                  hintText: 'Select An End Location',
                  icon: Icon(Icons.search),
                  focusColor: Theme.of(context).primaryColor,
                  labelText: _pickedEndLocation!=null ? getEndAddress(_pickedEndLocation.latitude, _pickedEndLocation.longitude).toString() : "Select an End Location",
                  ///labelText: convertToAddress(_pickedEndLocation.latitude, _pickedEndLocation.longitude).toString(),
                ),
              ),
              Theme.of(context).accentColor,
              size.width*0.9
            ),
          ),
          LocationInputEnd(_selectEndPlace),
          SizedBox(height: size.height*0.01,),
          Container(
            alignment: Alignment.center,
            child: UiContainer(
              FlatButton(
                child: Text('Show Locations on map', style: TextStyle(color: Colors.white),),
                onPressed: ()async{
                  _launchNav(
                    _pickedStartLocation.latitude, 
                    _pickedStartLocation.longitude, 
                    _pickedEndLocation.latitude, 
                    _pickedEndLocation.longitude,
                  );
                },
              ),
              Theme.of(context).primaryColor,
              size.width*0.6
            )
          ),
          Container(
          alignment: Alignment.center,
          child: UiContainer(
            Column(
              children: <Widget>[
                Text(
                  'Select A Mode',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontStyle: FontStyle.italic
                  ),
                ),
                DropdownButton(
                  value: selectedtype,
                  items: buildDropDownMenuItems(getType),
                  onChanged: (String val){
                    setState(() {
                      selectedtype = val;
                    });
                  },
                ),
              ],
            ),
            Theme.of(context).accentColor,
            size.width*0.8
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: UiContainer(
            Column(children: <Widget>[
              Text(
                'Do you want to Ride Now',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontStyle: FontStyle.italic
                ),
              ),
              _myRadioButton(
                title: "Yes",
                value: 0,
                onChanged: (newValue) => setState(() => _groupValue = newValue),
              ),
              _myRadioButton(
                title: "No",
                value: 1,
                onChanged: (newValue) => setState(() => _groupValue = newValue),
              ),
            ],),
            Theme.of(context).accentColor,
            size.width*0.8
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: UiContainer(
            Column(
              children: <Widget>[
                Text(
                  'Are you already in the vehicle?',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontStyle: FontStyle.italic
                  ),
                ),
                DropdownButton(
                  value: selectedResponse,
                  items: buildDropDownMenuItems(getResponse),
                  onChanged: (String value){
                    setState(() {
                      selectedResponse = value;
                    });
                  },
                ),
              ],
            ),
            Theme.of(context).accentColor,
            size.width*0.8
          ),
        ),
        FlatButton(
          child: Text('Search for a Co-Passenger'),
          onPressed: (){
            double stlat = _pickedStartLocation.latitude;
            double stlon = _pickedStartLocation.longitude;
            double endlat = _pickedEndLocation.latitude;
            double endlong = _pickedEndLocation.longitude;
            //String id = Provider.of<Auth>(context, listen: false).userId;
            print(stlat);
            print(stlon);
            print(endlat);
            print(endlat);
            print(endlong);
            print(selectedtype);
            print(selectedResponse);
            var email = getmail();
            print(email);
            Provider.of<Request>(context, listen:false).searchPassenger(context, stlat, stlon, endlat, endlong, selectedtype, selectedResponse, DateTime.now());
            Provider.of<Request>(context, listen: false).postRequest(stlat,stlon,endlat,endlong,selectedtype,selectedResponse,DateTime.now(),email);
          },
        ),
        ],),
      ),
      drawer: AppDrawer(),
    );
  }
}