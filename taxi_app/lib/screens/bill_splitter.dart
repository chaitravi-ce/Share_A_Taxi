import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/app_drawer.dart';
import '../widgets/ui_Container.dart';

class BillSPlitterScreen extends StatelessWidget {

  static const routeName = '/billSpltter';
  @override
  Widget build(BuildContext context) {

    final _amountController = TextEditingController();
    final _noController = TextEditingController();
    var amount;
    Size size = MediaQuery.of(context).size;
    final peopleFocus = FocusNode();

    dynamic calculate(){
      final totalAmount = _amountController.text;
      final people = _noController.text;

      amount = double.parse(totalAmount)/double.parse(people);
      print(totalAmount);
      print(people);
      return amount;
    }

    calculateAmount(){
      String total = calculate().toString();
      print(total);
      showDialog(context: context, builder: (ctx){
      return AlertDialog(
        content: 
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: Column(children: <Widget>[
              Container(
                child: Text(
                  'Amount to be paid by each person :',
                  style: GoogleFonts.aBeeZee(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: Text(
                  total,
                  style: GoogleFonts.aBeeZee(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25 
                  ),
                ),
              )],
            ),
          ),
        
      );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Bill Splitter', style: GoogleFonts.grenze(fontSize: 25),),),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
            SizedBox(height: size.height*0.04,),
            UiContainer(
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(Icons.monetization_on, color: Theme.of(context).primaryColor,),
                  hintText: 'Enter Amount'
                ),
                onFieldSubmitted: (_){
                  FocusScope.of(context).requestFocus(peopleFocus);
                },
                style: GoogleFonts.galada(),
              ),
              Theme.of(context).accentColor,
              size.width*0.9,
            ),
            UiContainer(
              TextField(
                controller: _noController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: Icon(Icons.people, color: Theme.of(context).primaryColor,),
                  hintText: 'No of People'
                ),
                style: GoogleFonts.galada(),
                focusNode: peopleFocus,
                onSubmitted: (_){
                  calculateAmount();
                },
              ),
              Theme.of(context).accentColor,
              size.width*0.9,
            ),
            UiContainer(
              FlatButton(
                child: Text(
                  'Calculate', 
                  style: GoogleFonts.grenze(
                    color: Colors.white,
                    fontSize: 20
                  )
                ),
                onPressed: () {
                  calculateAmount();
                }
              ), 
              Theme.of(context).primaryColor,
              size.width*0.4
              )
          ],),
        ),
      drawer: AppDrawer(),
    );
  }
}