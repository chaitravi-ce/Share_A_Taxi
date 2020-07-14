import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:liquid_swipe/Helpers/Helpers.dart';
import 'package:taxi_app/screens/welcome_screen.dart';

class InfoScreen extends StatefulWidget {
  static const routeName = '/info';
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: LiquidSwipe(     
        enableSlideIcon: true,
        positionSlideIcon: 0.5,
        enableLoop: false,
        waveType: WaveType.liquidReveal,
        pages: <Container>[
          Container(
            color: Color.fromRGBO(51, 0, 50, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height*0.15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  child: Text(
                    'Same Location...',
                    style: GoogleFonts.grenze(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      fontStyle: FontStyle.italic
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Same Taxi',
                    style: GoogleFonts.grenze(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      fontStyle: FontStyle.italic
                    )
                  ),
                ),
                SizedBox(height: size.height*0.08,),
                Container(
                  padding: EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0),
                  child: Image.asset(
                    'assets/images/sharing.jpg',
                  ),
                ),
                SizedBox(height: size.height*0.08,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Share Rides',
                        style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                        ),
                      ),
                      Text(
                        'Together...',
                        style: GoogleFonts.dancingScript(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 30
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Just Enter your Locations',
                        style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                        ),                      
                      ),
                      Text(
                        'and you are good to go...',
                        style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color.fromRGBO(247, 202, 201, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height*0.15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Meet New People...',
                    style: GoogleFonts.grenze(
                      fontSize: 40,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold
                    ),
                  ),      
                ),
                SizedBox(height: size.height*0.08,),
                Container(
                  padding: EdgeInsets.fromLTRB(60,0,60,0),
                  child: Image.asset('assets/images/meetPeople.jpg'),
                ),
                SizedBox(height: size.height*0.08,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Meet your colleagues',
                        style: GoogleFonts.dancingScript(
                          fontWeight: FontWeight.bold,
                          fontSize: 28
                        ),
                      ),
                      Text(
                        'from other backgrounds',
                        style: GoogleFonts.dancingScript(
                          fontWeight: FontWeight.bold,
                          fontSize: 28
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Text(
                        'Interact with people coming',
                        style: GoogleFonts.dancingScript(
                          fontWeight: FontWeight.bold,
                          fontSize: 28
                        ),
                      ),
                      Text(
                        'from all walks of life...',
                        style: GoogleFonts.dancingScript(
                          fontWeight: FontWeight.bold,
                          fontSize: 28
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color.fromRGBO(60, 40, 80, 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height*0.12,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Save Money...',
                    style: GoogleFonts.grenze(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 40
                    ),
                  ),
                ),
                SizedBox(height: size.height*0.06,),
                Container(               
                  padding: EdgeInsets.fromLTRB(90.0, 0.0, 80.0, 0.0),
                  height: size.height*0.4,
                  child: Image.asset(
                    'assets/images/saveMoney.png'
                  ),
                ),
                SizedBox(height: size.height*0.06,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Split up Bills',
                        style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        'Also lower the levels of',
                        style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                        ),
                      ),
                      Text(
                        'pollution by reducing the amount of vehicles...',
                        style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        onPageChangeCallback: swipeFinished,
      ),
    );
  }

  void swipeFinished(int pageNum) {
    if (pageNum == 2) {
      Navigator.of(context).pushNamed(WelcomeScreen.routeName);
    }
  }
}
