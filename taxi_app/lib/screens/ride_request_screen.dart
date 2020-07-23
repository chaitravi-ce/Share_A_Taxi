import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:taxi_app/models/app_drawer.dart';
import 'package:taxi_app/widgets/ui_Container.dart';
import '../models/profilemodel.dart';

class RideRequests extends StatefulWidget {

  static const routeName = '/ride-request';

  @override
  _RideRequestsState createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  final name = Profilee.mydefineduser['name'];
  List<Map<String,dynamic>> matchedReqs = [];
  String sAdd;
  String eAdd;
  var isLoading = false;

  Future getData()async{
    setState(() {
      isLoading = true;
    });
    List<Map<String,dynamic>> matchedReq = [];
    final url = 'https://samelocationsametaxi.firebaseio.com/requests.json';
    final response =  await http.get(url);
    final extractedData = json.decode(response.body) as Map<String,dynamic>;
    if(extractedData == null){
      print('in null');
      return ;
    }
    String contactNo = Profilee.mydefineduser['contactNo'];
    print(contactNo);
    extractedData.forEach((userID, userData){
      if(contactNo == userData['contactNo']){
        matchedReq.add(userData);
      }
    });  
    setState(() {
      isLoading = false;
    });
    return matchedReq;
  }

  @override
  void initState(){
    getData().then((value) {
      setState(() {
        matchedReqs = value;
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String endaddress;
    String staddress;

    Future<void> deleteRequest(Map request)async{
      final url = 'https://samelocationsametaxi.firebaseio.com/requests.json';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
        if(extractedData == null){
          print('in null');
          return ;
        }
      print(extractedData);
      extractedData.forEach((userID, userData){       
        if(userData['startLocationLat'] == request['startLocationLat']){
          print('ididififififif');
          print(userID);
          final url3 = 'https://samelocationsametaxi.firebaseio.com/requests/$userID.json';
          http.delete(url3);
        }
      });
      setState(() {
        getData().then((value) {
          matchedReqs = value;
          setState(() {
            isLoading = false;
          });
        });
      });
    }

    Future<void> updateStatus(Map request)async{
      final url = 'https://samelocationsametaxi.firebaseio.com/requests.json';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
        if(extractedData == null){
          print('in null');
          return ;
        }
      print(extractedData);
      extractedData.forEach((userID, userData){       
        if(userData['startLocationLat'] == request['startLocationLat']){
          print('ididififififif');
          print(userID);
          final url3 = 'https://samelocationsametaxi.firebaseio.com/requests/$userID.json';
          http.patch(url3,
            body: json.encode({
              'isComplete' : true,
            })
          );
        }
      });
      setState(() {
        getData().then((value) {
          matchedReqs = value;
          setState(() {
            isLoading = false;
          });
        });
      });
    }

    Future<void>convertToEndAddress(double latitude, double longitude)async{
      final coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(first);
      endaddress=first.addressLine.toString();
      return first.addressLine;
    }

    Future<void>convertToStartAddress(double latitude, double longitude)async{
      final coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(first);
      staddress=first.addressLine.toString();
      return first.addressLine;
    }

    String getStartAddress(double latitude, double longitude){
      convertToStartAddress(latitude, longitude).then((value) {
        return staddress;
      });
      return staddress;
    }

    String getEndAddress(double latitude, double longitude){
      convertToEndAddress(latitude, longitude).then((value) {
        return endaddress;
      });
      return endaddress;
    }

    dynamic showModalSheet(Map<String,dynamic> request){
      Size size = MediaQuery.of(context).size;
      sAdd = getEndAddress(request['endLocationLat'], request['endLocationLong']);
      print('============================================================');
      print(sAdd);
      print(request);
      DateTime time = DateTime.parse(request['time']);
      print(time.toString());
      showModalBottomSheet(context: context, builder: (ctx){
        return Container(
          child: SingleChildScrollView(
            child: Column(children: <Widget>[
              UiContainer(
                Column(children: <Widget>[
                  Text(
                    'Start Location :', 
                    style: GoogleFonts.playfairDisplay(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: size.height*0.008,),
                  Text(
                    getStartAddress(request['startLocationLat'], request['startLocationLong']), 
                    style: GoogleFonts.alice(color: Theme.of(context).primaryColor),
                  ),
                ],),
                Theme.of(context).accentColor,
                size.width*0.95
              ),
              UiContainer(
                Column(children: <Widget>[
                  Text(
                    'End Location :',
                    style: GoogleFonts.playfairDisplay(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: size.height*0.008,),
                  Text(
                    getEndAddress(request['endLocationLat'], request['endLocationLong']), 
                    style: GoogleFonts.alice(color: Theme.of(context).primaryColor),
                  ),
                ],),
                Theme.of(context).accentColor,
                size.width*0.95
              ),
              UiContainer(
                Column(children: <Widget>[
                  Text(
                    'Mode of Transport :',
                    style: GoogleFonts.playfairDisplay(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: size.height*0.008,),
                  Text(
                    request['mode'],
                    style: GoogleFonts.alice(color: Theme.of(context).primaryColor)
                  )
                ],),
                Theme.of(context).accentColor,
                size.width*0.95
              ),
              UiContainer(
                Column(children: <Widget>[
                  Text(
                    'Date :',
                    style: GoogleFonts.playfairDisplay(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: size.height*0.008,),
                  Text(
                    DateFormat.yMMMMEEEEd().format(DateTime.parse(request['time'])),
                    style: GoogleFonts.alice(color: Theme.of(context).primaryColor)
                  )
                ],),
                Theme.of(context).accentColor,
                size.width*0.95
              ),
              UiContainer(
                Column(children: <Widget>[
                  Text(
                    'Time :',
                    style: GoogleFonts.playfairDisplay(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: size.height*0.008,),
                  Text(
                    DateFormat.jm().format(DateTime.parse(request['time'])),
                    style: GoogleFonts.alice(color: Theme.of(context).primaryColor)
                  )
                ],),
                Theme.of(context).accentColor,
                size.width*0.95
              ),
              request['isComplete'] == 'false' ? UiContainer(
                FlatButton(
                  child: Text(
                    'Co-Passenger found',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  onPressed: (){
                    //request.update(request['isComplete'], (value){
                    //  return 'true';
                    //});
                    updateStatus(request);
                  },
                ),
                Theme.of(context).primaryColor,
                size.width *0.6
              ) : SizedBox(height: 0,),   
              UiContainer(
                FlatButton(
                  child: Text(
                    'Delete Request',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  onPressed: (){
                    deleteRequest(request);
                  },
                ),
                Theme.of(context).primaryColor,
                size.width *0.6
              ),             
            ],),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Your Ride Requests', style: GoogleFonts.grenze(fontSize: 27)),),
      body: isLoading == true ? Center(child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),) : RefreshIndicator(
        onRefresh: () => getData().then((value) {
          matchedReqs = value;
          isLoading = false;
        }),
        child: ListView.builder(
          itemCount: matchedReqs.length,
          itemBuilder: (ctx,i){
            return Card(
              elevation: 5,
              child: ListTile(
                title: Text(
                  DateFormat.yMMMMEEEEd().format(DateTime.parse(matchedReqs[i]['time'])),
                  style: GoogleFonts.aBeeZee(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(matchedReqs[i]['mode'],style: GoogleFonts.aBeeZee(color: Theme.of(context).primaryColor, fontSize: 16)),
                trailing: IconButton(
                  icon : Icon(Icons.arrow_drop_down),
                  onPressed: (){
                    print(DateFormat.yMMMMEEEEd().format(DateTime.parse(matchedReqs[i]['time'])));
                    showModalSheet(matchedReqs[i]);
                    String ad = getStartAddress(matchedReqs[i]['startLocationLat'], matchedReqs[i]['startLocationLong']);
                    print(ad);
                  },
                )
              ),
            );
          },
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}

