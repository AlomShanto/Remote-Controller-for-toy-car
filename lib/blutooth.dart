import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remote_controller/size_config.dart';

import 'all_calculation.dart';

class BluetoothPageMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth Motor Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothPage(),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  BluetoothConnection? _connection;
  bool _isLoading = false;
  String _status = '';
  Color color = Colors.red;
  int speedValue = 0;

  _incrementCounter() async{

    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      speedValue = Calculate.increase_speed();
    });


  }

  _decrementCounter() async{

    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      speedValue = Calculate.decrease_speed();
    });
  }

  _forceStopCounter() async{


    var x = speedValue/3;

    await Future.delayed(Duration(milliseconds: 250));
    setState((){
      speedValue = Calculate.decrease_speed();
      print(speedValue);
    });
    if(speedValue>0)
      _forceStopCounter();
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    setState(() {
      _isLoading = true;
    });

    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        _isLoading = false;
        _status = 'Connected';
        color=Colors.green;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Connection failed';
        speedValue = 0;
        color=Colors.red;
      });
      print(e);
    }
  }

  void _sendCommand(String command) {
    if (_connection != null) {
      Uint8List data = Uint8List.fromList(utf8.encode(command));
      _connection?.output.add(data);
      _connection?.output.allSent.then((value) {
        print('Command sent: $command');
      });
    }
  }

  void _increaseSpeed() {
    _sendCommand('F');
    if(_status=='Connected')
    _incrementCounter();
  }

  void _decreaseSpeed() {
    _sendCommand('B');
    if(_status=='Connected')
    _decrementCounter();
  }

  void _forceStop() {
    _sendCommand('S');
    if(_status=='Connected')
    _forceStopCounter();
  }

  Future<List<BluetoothDevice>> _getDeviceList() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    } catch (e) {
      print(e);
    }

    return devices;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Motor Control'),
        leading: MaterialButton(
          onPressed: () async {
            List<BluetoothDevice> devices = await _getDeviceList();
            showModalBottomSheet(
              context: context,
              builder: (context) => ListView(
                children: devices
                    .map(
                      (device) => ListTile(
                    title: Text('${device.name}'),
                    subtitle: Text(device.address),
                    onTap: () {
                      Navigator.pop(context);
                      _connectToDevice(device);
                    },
                  ),
                )
                    .toList(),
              ),
            );
          },
          color: color,
          child: Center(
            child: Icon(
              Icons.bluetooth_outlined,
              //color: color,
              size: 40,
            ),
          )
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(

                  height: SizeConfig.screenHeight*.15,

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
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight*.1,),
                child: SizedBox(),
              ),
              Container(
                height: SizeConfig.screenHeight*.60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    MaterialButton(
                      height: SizeConfig.screenHeight*.1,
                      onPressed: _increaseSpeed,
                      child: Icon(Icons.arrow_upward,size: 80),
                      color: Colors.blue,
                      shape: CircleBorder(),
                    ),
                    MaterialButton (
                      height: SizeConfig.screenHeight*.1,
                      onPressed: _forceStop,
                      child: Icon( Icons.stop_outlined, size: 80, ),
                      color: Colors.blue,
                      shape: CircleBorder(),
                    ),
                    MaterialButton(
                      height: SizeConfig.screenHeight*.1,
                      onPressed: _decreaseSpeed,
                      child: Icon(Icons.arrow_downward,size: 80,),
                      color: Colors.blue,
                      shape: CircleBorder(),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}