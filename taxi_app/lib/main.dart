import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/screens/chat_list_screen.dart';
import 'package:taxi_app/screens/edit_profile_screen.dart';
import 'package:taxi_app/screens/info_screen.dart';
import 'package:taxi_app/screens/settings.dart';
import './screens/loginScreen.dart';
import './screens/welcome_screen.dart';
import './screens/signup_screen.dart';
import './screens/main_screen.dart';
import './providers/users.dart';
import './screens/profile.dart';
import './screens/bill_splitter.dart';
import './providers/request.dart';
import './providers/auth.dart';
import './screens/taxi_rates_screens.dart';
import './screens/rickshaw_rates_screen.dart';
import './screens/splash_screen.dart';
import './screens/ride_request_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider.value(value: Users()),
        ChangeNotifierProvider.value(value: Request()),
        ChangeNotifierProvider.value(value: Auth())
      ],
      child: MaterialApp(
        title: 'Share A Taxi',
        theme: ThemeData(
          primaryColor: Color(0xFF6F35A5),
          accentColor: Color(0xFFF1E6FF),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: SplashScreen(),
        routes: {
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SplashScreen.routeName: (ctx) => SplashScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          MainScreen.routeName: (ctx) => MainScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          BillSPlitterScreen.routeName: (ctx) => BillSPlitterScreen(),
          TaxiRatesScreen.routeName: (ctx) => TaxiRatesScreen(),
          RickshawRatesScreen.routeName: (ctx) => RickshawRatesScreen(),
          RideRequests.routeName: (ctx) => RideRequests(),
          InfoScreen.routeName : (ctx) => InfoScreen(),
          ChatListScreen.routeName : (ctx) => ChatListScreen(),
          EditProfileScreen.routeName : (ctx) => EditProfileScreen(),
          Settings.routeName : (ctx) => Settings(),
        },
      )
    );
  }
}
