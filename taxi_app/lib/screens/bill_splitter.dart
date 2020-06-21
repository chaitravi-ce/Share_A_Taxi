import 'package:flutter/material.dart';
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

    dynamic calculate(){
      final totalAmount = _amountController.text as double;
      final people = _noController.text as double;

      amount = totalAmount/people;
      return amount;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Bill Splitter'),),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
            SizedBox(height: size.height*0.04,),
            UiContainer(
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  icon: Icon(Icons.monetization_on, color: Theme.of(context).primaryColor,),
                  hintText: 'Enter Amount'
                ),
              ),
              Theme.of(context).accentColor,
              size.width*0.9,
            ),
            UiContainer(
              TextField(
                controller: _noController,
                decoration: InputDecoration(
                  icon: Icon(Icons.people, color: Theme.of(context).primaryColor,),
                  hintText: 'No of People'
                ),
              ),
              Theme.of(context).accentColor,
              size.width*0.9,
            ),
            UiContainer(
              FlatButton(
                child: Text('Calculate', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  String total = calculate().toString();
                  print(total);
                },
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