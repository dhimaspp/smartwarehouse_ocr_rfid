import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/assign_rfid_screen/assign_rfid.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

import 'bluetooth_device_list_entry.dart';

class SelectBondedDevicePage extends StatefulWidget {
  /// If true, on page start there is performed discovery upon the bonded devices.
  /// Then, if they are not avaliable, they would be disabled from the selection.
  final bool checkAvailability;

  const SelectBondedDevicePage({this.checkAvailability = true});

  @override
  _SelectBondedDevicePage createState() => new _SelectBondedDevicePage();
}

enum _DeviceAvailability {
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
  List<_DeviceWithAvailability> devices = <_DeviceWithAvailability>[];

  // Availability
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  bool _isDiscovering;

  _SelectBondedDevicePage();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                device,
                widget.checkAvailability
                    ? _DeviceAvailability.maybe
                    : _DeviceAvailability.yes,
              ),
            )
            .toList();
      });
    });
  }

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.no;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _discoveryStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map((_device) => BluetoothDeviceListEntry(
              device: _device.device,
              rssi: _device.rssi,
              enabled: _device.availability == _DeviceAvailability.yes,
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AssignRFID()));
                // Navigator.of(context).pop(_device.device);
              },
            ))
        .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(alignment: AlignmentDirectional.topCenter, children: <Widget>[
              Container(
                height: 110,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: kFillColor,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(18))),
              ),
              Positioned(
                top: 55,
                left: 5,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: kFillColor),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          )),
                      Text(
                        '  Select Device',
                        style: textInputDecoration.labelStyle.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: 140,
                      ),
                      _isDiscovering
                          ? FittedBox(
                              child: Container(
                                margin: new EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : IconButton(
                              icon: Icon(
                                Icons.replay,
                                color: Colors.white,
                              ),
                              onPressed: _restartDiscovery,
                            )
                    ]),
              ),
            ]),
            ListView(
              padding: EdgeInsets.all(5),
              shrinkWrap: true,
              children: list,
            )
          ],
        ),
      ),
    );

    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Select device'),
    //     actions: <Widget>[
    //       _isDiscovering
    //           ? FittedBox(
    //               child: Container(
    //                 margin: new EdgeInsets.all(16.0),
    //                 child: CircularProgressIndicator(
    //                   valueColor: AlwaysStoppedAnimation<Color>(
    //                     Colors.white,
    //                   ),
    //                 ),
    //               ),
    //             )
    //           : IconButton(
    //               icon: Icon(Icons.replay),
    //               onPressed: _restartDiscovery,
    //             )
    //     ],
    //   ),
    //   body: ListView(children: list),
    // );
  }
}
