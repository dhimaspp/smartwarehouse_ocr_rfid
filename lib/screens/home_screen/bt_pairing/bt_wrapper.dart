import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/assign_rfid_screen/assign_rfid.dart';

import 'package:smartwarehouse_ocr_rfid/screens/home_screen/bt_pairing/select_bounded_device.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

class BleOff extends StatefulWidget {
  @override
  _BleOffState createState() => _BleOffState();
}

class _BleOffState extends State<BleOff> {
  turnOn() async {
    await FlutterBluetoothSerial.instance.requestEnable();
    final BluetoothDevice selectedDevice =
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return SelectBondedDevicePage(
        checkAvailability: false,
      );
    }));
    if (selectedDevice != null) {
      print('Connect to Device :' + selectedDevice.address);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return AssignRFID(selectedDevice);
      }));
    } else {
      print('no device selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bluetooth_disabled_rounded,
            color: Colors.black38,
            size: 120,
          ),
          Text('Bluetooth is Disable'),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              turnOn();
            },
            child: Text('Tap here to enable Bluetooh',
                style: textInputDecoration.labelStyle.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: Colors.black)),
          )
        ],
      ),
    );
  }
}
