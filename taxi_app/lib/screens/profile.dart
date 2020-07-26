import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/screens/edit_profile_screen.dart';
import '../models/app_drawer.dart';
import '../models/profilemodel.dart';
import '../models/save_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';

class ProfileScreen extends StatefulWidget {

  static const routeName = '/profile';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FSBStatus drawerStatus;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FoldableSidebarBuilder(
          drawerBackgroundColor: Theme.of(context).primaryColor,
          drawer: AppDrawer(),
          screenContents: Profile(),
          status: drawerStatus,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.menu,color: Colors.white,),
          onPressed: () {
            setState(() {
              drawerStatus = drawerStatus == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
            });
          }
        ),
      ),
    );
  }
  
}

// ignore: camel_case_types
class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //File _imageFile;
  //final picker = ImagePicker();
  Image image;

  getUserFromandStoreImage(String image)async{
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
        print(userData);
        final url3 = 'https://samelocationsametaxi.firebaseio.com/users/$userID.json';
        http.patch(url3,
          body: json.encode({
            'image' : image,
          })
        );
      }
    });
  }

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

  pickImage(ImageSource source) async {
    final _image = await ImagePicker.pickImage(source: source);
    if (_image != null) {
      setState(() {
        image = Image.file(_image);
      });
      ImageSharedPrefs.saveImageToPrefs(ImageSharedPrefs.base64String(_image.readAsBytesSync()));
      getUserFromandStoreImage(ImageSharedPrefs.base64String(_image.readAsBytesSync()));
      print('ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
    } else {
      print('Error picking image!');
    }
  }

  Future<void> _showDialog(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[
              Text(
                'Select an option',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.04,),
              Container(
                height: MediaQuery.of(context).size.height*0.06,
                child: GestureDetector(
                  child: Text(
                    'Gallery',
                    style: TextStyle(color: Theme.of(context).primaryColor)
                  ),
                  onTap: (){
                   // _openGallery();
                    print('Gallery');
                    pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              GestureDetector(
                child: Text(
                  'Camera',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onTap: (){
                  //_openCamera();
                  print('Camera');
                  pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],),
          ),
        );
      }
    );
  }
  String name;
  String email;
  String contactNo;

  @override
  void initState() {
    loadImageFromPrefs();
    name = Profilee.mydefineduser['name'];
    email = Profilee.mydefineduser['username'];
    contactNo = Profilee.mydefineduser['contactNo'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String email = Profilee.mydefineduser["username"];

    // ignore: missing_return
    Future<void> refresh(){
      email = Profilee.mydefineduser["username"];
      name = Profilee.mydefineduser['name'];
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: GoogleFonts.grenze(fontSize: 25,),),
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            icon: Icon(Icons.edit, color: Colors.white,),
            onPressed: (){
              Navigator.of(context).pushNamed(EditProfileScreen.routeName);
            },
          ),  
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()async{
          await Future.delayed(Duration(seconds: 2));
          refresh();
        },
        child: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Theme.of(context).accentColor),
            clipper: getClipper(),
          ),
          Positioned(
            width: 350.0,
            top: size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: image!=null ? 
                  CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    backgroundImage: image.image,                     
                    radius: 75,
                  ) : 
                  Text(''),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 7.0, color: Colors.black)
                    ]
                  )
                ),
                SizedBox(height: 90.0),
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).primaryColor
                    ),
                ),
                SizedBox(height: 15.0),
                Container(
                  height: size.height*0.04,
                  width: size.width*0.6,
                  child: Material(
                    shadowColor: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    elevation: 7.0,
                    color: Theme.of(context).primaryColor,
                    child: GestureDetector(
                      onTap: () {},
                      child: Center(
                        child: Text(
                          email,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                          ),
                        ),
                      ),
                    ),
                  ) ),
                  SizedBox(height: 25.0),
                  Container(
                    height: size.height*0.04,
                    width: size.width*0.6,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).primaryColor,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Text(
                            contactNo,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                            ),
                          ),
                        ),
                      ),
                    )
                  )
                ],
              )
            ),
            Positioned(
              top: size.height / 3.3,
              right: size.width*0.4,
              child: IconButton(
                icon: Icon(Icons.camera, color: Theme.of(context).primaryColor, size: 60,),
                onPressed: (){
                  print('Clicked');
                  _showDialog(context);
                },
              )
            ),
        ],
    ),
      ),
    );
  }
}