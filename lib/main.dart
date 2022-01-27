import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';

import 'notification.dart';

Beacon? _beacon;
StreamSubscription<RangingResult>? _streamSubcriptionMonitoring;
Stream<RangingResult>? _streamMonitoring;
final regions = <Region>[];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppNotification.init();
  try {
    // if you want to manage manual checking about the required permissions
    await flutterBeacon.initializeScanning;

    // or if you want to include automatic checking permission
    await flutterBeacon.initializeAndCheckScanning;
  } on PlatformException catch(e) {
    // library failed to initialize, check code and message
  }
  await    _beaconSetting();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String text = "Stop Service";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TLS TEST BEACON'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("The info beacon foceground".toUpperCase()),
              Text("UDID                   : ${_beacon?.proximityUUID??"No"}".toUpperCase()),
              Text("MAC ADDRESS : ${_beacon?.macAddress??"No"}".toUpperCase()),
              Text("DISTANCE          : ${_beacon?.accuracy??"No"}".toUpperCase()),
              Text("POWER               : ${_beacon?.txPower??"No"}".toUpperCase()),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async{
                // to start ranging beacons
                _streamMonitoring = flutterBeacon.ranging(regions);
                try{
                  _streamSubcriptionMonitoring = await _streamMonitoring?.listen((event) {
                    if(event.beacons.isEmpty){
                      _beacon =null;
                    }
                    event.beacons.sort((a,b){
                      return a.accuracy.compareTo(b.accuracy);
                    });
                    if(event.beacons.isNotEmpty&&event.beacons.first.proximityUUID!=_beacon?.proximityUUID){
                      _beacon = event.beacons.first;
                      AppNotification.showDialog(data: "Beacon: ${_beacon?.macAddress??""}");
                    }
                    setState(() {

                    });
                  },onError: (object,track){},onDone: (){},cancelOnError: true);
                }
                catch(e){
                  print(e.toString());
                }

              },
              child: Icon(Icons.play_arrow),
            ),
            SizedBox(
              height: 20,
            ),
            // FloatingActionButton(
            //   onPressed: () {
            //
            //   },
            //   child: Icon(Icons.play_for_work_outlined),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            FloatingActionButton(
              onPressed: () {
                try {
                  _streamSubcriptionMonitoring?.cancel();
                } catch (e) {}
              },
              child: Icon(Icons.pause),
            ),
          ],
        ),
      ),
    );
  }
}

_beaconSetting() async {
  if (Platform.isIOS) {
    // iOS platform, at least set identifier and proximityUUID for region scanning
    regions.add(Region(
        identifier: 'Apple Airlocate',
        proximityUUID: '48534442-4C45-4144-80C0-170000000000'));
  } else {
    // android platform, it can ranging out of beacon that filter all of Proximity UUID
    regions.add(Region(identifier: 'com.beacon',proximityUUID: "48534442-4C45-4144-80C0-170000000000"));
  }
}
