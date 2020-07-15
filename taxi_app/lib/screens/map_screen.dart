import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../models/place_location.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation = const PlaceLocation(latitude: 19.015723586531074, longitude: 72.84425150603056),
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
    print(position.latitude);
    print(position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map', style: GoogleFonts.grenze(fontSize: 25),),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null ? null : () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.initialLocation.latitude,
                widget.initialLocation.longitude,
              ),
              zoom: 13,
            ),
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: (_pickedLocation == null && widget.isSelecting) ? null : {
              Marker(
                markerId: MarkerId('L'),
                position: _pickedLocation ?? LatLng(
                  widget.initialLocation.latitude,
                  widget.initialLocation.longitude,
                ),
              ),
            },
          ),
          Positioned(
            top: 15,
            left: 5,
            child: Container(
              color: Theme.of(context).accentColor,
              height: 50,
              width: 400,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Location',
                ),
                onTap: ()async{
                  const GOOGLE_API_KEY = 'AIzaSyBKMhWmeHSRe7zKin5xt-IdHoerfQleKT8';
                  try{
                    print('===================================================pp');
                    Prediction p = await PlacesAutocomplete.show(
                      context: context, 
                      apiKey: GOOGLE_API_KEY,
                      language: "en",
                      components: [Component(Component.country,"in")]
                    );
                    print('====================================');
                  }catch(error){
                    print('===============================================');
                    print(error);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}