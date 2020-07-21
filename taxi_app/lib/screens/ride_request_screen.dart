import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:taxi_app/models/app_drawer.dart';
import 'package:taxi_app/widgets/ui_Container.dart';
import'../models/profilemodel.dart';

class RideRequests extends StatefulWidget {

  static const routeName = '/ride-request';

  @override
  _RideRequestsState createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  final name = Profilee.mydefineduser['name'];
  List<Map<String,dynamic>> matchedReqs = [];
  //matchedReqs = Provider.of<Request>(context, listen: false).getList();

  getData()async{
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
    return matchedReq;
  }

  @override
  void initState() {
    getData().then((val){
      matchedReqs = val;
    });
    print(matchedReqs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String endaddress;
    String staddress;

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
      print(request);
      DateTime time = DateTime.parse(request['time']);
      print(time.toString());
      showModalBottomSheet(context: context, builder: (ctx){
        return Container(
          child: Column(children: <Widget>[
            UiContainer(
              Column(children: <Widget>[
                Text('Start Location :', style: TextStyle(color: Theme.of(context).primaryColor),),
                SizedBox(height: size.height*0.008,),
                Text(getStartAddress(request['startLocationLat'], request['startLocationLong']), style: TextStyle(color: Theme.of(context).primaryColor),),
              ],),
              Theme.of(context).accentColor,
              size.width*0.95
            ),
            UiContainer(
              Column(children: <Widget>[
                Text('End Location :',style: TextStyle(color: Theme.of(context).primaryColor),),
                SizedBox(height: size.height*0.008,),
                Text(getEndAddress(request['endLocationLat'], request['endLocationLong']), style: TextStyle(color: Theme.of(context).primaryColor),),
              ],),
              Theme.of(context).accentColor,
              size.width*0.95
            ),
            UiContainer(
              Column(children: <Widget>[
                Text('Mode of Transport :',style: TextStyle(color: Theme.of(context).primaryColor)),
                SizedBox(height: size.height*0.008,),
                Text(request['mode'],style: TextStyle(color: Theme.of(context).primaryColor))
              ],),
              Theme.of(context).accentColor,
              size.width*0.95
            ),
            UiContainer(
              Column(children: <Widget>[
                Text('Date :',style: TextStyle(color: Theme.of(context).primaryColor)),
                SizedBox(height: size.height*0.008,),
                Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(request['time'])),style: TextStyle(color: Theme.of(context).primaryColor))
              ],),
              Theme.of(context).accentColor,
              size.width*0.95
            ),
            UiContainer(
              Column(children: <Widget>[
                Text('Time :',style: TextStyle(color: Theme.of(context).primaryColor)),
                SizedBox(height: size.height*0.008,),
                Text(DateFormat.jm().format(DateTime.parse(request['time'])),style: TextStyle(color: Theme.of(context).primaryColor))
              ],),
              Theme.of(context).accentColor,
              size.width*0.95
            ),
          ],),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Your Ride Requests'),),
      body: ListView.builder(
        itemCount: matchedReqs.length,
        itemBuilder: (ctx,i){
          return Card(
            elevation: 5,
            child: ListTile(
              title: Text(
                DateFormat.yMMMMEEEEd().format(DateTime.parse(matchedReqs[i]['time'])),
                style: TextStyle(color: Theme.of(context).primaryColor)
              ),
              subtitle: Text(matchedReqs[i]['mode'],style: TextStyle(color: Theme.of(context).primaryColor)),
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
      drawer: AppDrawer(),
    );
  }
}

