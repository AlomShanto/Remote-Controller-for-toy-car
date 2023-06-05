import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remote_controller/all_calculation.dart';

class ControllingPage extends StatefulWidget {
  const ControllingPage({Key? key}) : super(key: key);

  @override
  _ControllingPageState createState() => _ControllingPageState();
}

class _ControllingPageState extends State<ControllingPage> {
  int speedValue = 0;
  bool on_tap_increase=false;
  bool on_tap_decrease=false;

  _incrementCounter() async{

    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      speedValue = Calculate.increase_speed();
    });

    if (on_tap_increase) {
      _incrementCounter();
    }
  }

  _decrementCounter() async{

    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
     speedValue = Calculate.decrease_speed();
    });

    if (on_tap_decrease) {
      _decrementCounter();
    }
  }

  _forceStop() async{

    await Future.delayed(Duration(milliseconds: 100));
    setState(() {
      speedValue = Calculate.decrease_speed();
      speedValue = Calculate.decrease_speed();
    });

    if (speedValue>0) {
      _forceStop();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[

            Container(

              height: 100,

              color: Colors.black26,

              child: Center(
                child: Text(
                  'Speed: ${speedValue}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 35
                  ),
                ),
              )

            ),

            GestureDetector(

              onTap: () {
                //  ontap = true;
                _incrementCounter();
              },

              onLongPress: () {
                on_tap_increase = true;
                _incrementCounter();
              },

              onLongPressEnd: (_) {
                setState(() {
                  on_tap_increase = false;
                });
              },

              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(Icons.add),
              ),
            ),
            GestureDetector(

              onTap: () {
                //  ontap = true;
                _forceStop();
              },

              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(Icons.stop),
              ),
            ),
            GestureDetector(

              onTap: () {
                //  ontap = true;
                _decrementCounter();
              },

              onLongPress: () {
                on_tap_decrease = true;
                _decrementCounter();
              },

              onLongPressEnd: (_) {
                setState(() {
                  on_tap_decrease = false;
                });
              },

              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(Icons.remove),
              ),
            ),

          ],
        ),
      ),
    );;
  }
}
