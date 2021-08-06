import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:smartwarehouse_ocr_rfid/theme/my_flutter_app_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AssignRFID extends StatefulWidget {
  // final BluetoothDevice server;
  // // final BuildContext context;
  // const AssignRFID(this.server);
  @override
  AssignRFIDState createState() => AssignRFIDState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class AssignRFIDState extends State<AssignRFID> {
  // @override
  // void initState() {
  //   super.initState();
  //   blocPO..getPOrx();
  // }
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  // final bluetoothState = BluetoothDeviceState.connected;
  // BluetoothCharacteristic bluetoothCharacteristic;
  // final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  // String uid = "";
  final ScrollController listScrollController = new ScrollController();
  List<_Message> messages = <_Message>[];
  static final clientID = 0;
  String _messageBuffer = '';
  BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    // bluetoothState = BluetoothDeviceState.connected;
    // BluetoothConnection.toAddress(widget.server.address).then((_connection) {
    //   try {
    //     if (_connection.isConnected) {
    //       print('Connected to the device');
    //       connection = _connection;
    //       setState(() {
    //         isConnecting = false;
    //         isDisconnecting = false;
    //       });

    //       connection.input.listen(_onDataReceived).onDone(() {
    //         // Example: Detect which side closed the connection
    //         // There should be `isDisconnecting` flag to show are we are (locally)
    //         // in middle of disconnecting process, should be set before calling
    //         // `dispose`, `finish` or `close`, which all causes to disconnect.
    //         // If we except the disconnection, `onDone` should be fired as result.
    //         // If we didn't except this (no flag set), it means closing by remote.
    //         if (isDisconnecting) {
    //           print('Disconnecting locally!');
    //         } else {
    //           print('Disconnected remotely!');
    //         }
    //         if (this.mounted) {
    //           setState(() {});
    //         }
    //       });
    //     } else {
    //       setState(() {
    //         isConnecting = true;
    //       });
    //     }
    //   } catch (e) {
    //     print(e);
    //     Navigator.of(context).pop();
    //   }
    // }).onError<PlatformException>((error, s) {
    //   print('Cannot connect, exception occured');
    //   print(error);
    //   Navigator.of(context).pop();
    // });
  }

  // @override
  // void dispose() {
  //   // Avoid memory leak (`setState` after dispose) and disconnect
  //   if (isConnected) {
  //     isDisconnecting = true;
  //     connection.dispose();
  //     connection = null;
  //   }

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // final List<Row> list = messages.map((_message) {
    //   return Row(
    //     children: <Widget>[
    //       Container(
    //         alignment: Alignment.center,
    //         child: Text(
    //             (text) {
    //               return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
    //             }(_message.text.trim()),
    //             style: TextStyle(color: Colors.white, fontSize: 16)),
    //         padding: EdgeInsets.all(9.0),
    //         margin: EdgeInsets.only(right: 8.0),
    //         width: 222.0,
    //         decoration: BoxDecoration(
    //             color:
    //                 _message.whom == clientID ? Colors.blueAccent : Colors.grey,
    //             borderRadius: BorderRadius.circular(7.0)),
    //       ),
    //     ],
    //     mainAxisAlignment: MainAxisAlignment.center,
    //   );
    // }).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          // isConnecting
          //     ? Center(child: CircularProgressIndicator())
          //     :
          Center(
              child: Column(children: [
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
                    '  PO Registration (RFID Tag)',
                    style: textInputDecoration.labelStyle.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ]),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "   LIST PRODUCT",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                    fontSize: 20),
              ),
              Text(
                "    Please slide an item to assign tag",
                style: TextStyle(
                  color: kFillColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 10,
                thickness: 1,
              ),
              Slidable(
                // key: const ValueKey(3),
                endActionPane: ActionPane(
                    motion: BehindMotion(),
                    extentRatio: 0.55,
                    children: [
                      SlidableAction(
                          label: 'Assign Tag',
                          backgroundColor: kFillColor,
                          icon: CustomIcon.tag_1,
                          flex: 99,
                          onPressed: (context) {
                            // widget.characteristic.value.listen((value) {
                            //   readValues[bluetoothCharacteristic.uuid] = value;
                            //   print(
                            //       '${readValues[bluetoothCharacteristic.uuid]}');
                            return showBarModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                      height: 390,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),

                                          Text(
                                            "Ready To Assign",
                                            style: TextStyle(
                                                color: kFillColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            child: Image.asset(
                                              "assets/images/Pairing-Illustration.png",
                                              height: 200,
                                              width: 200,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'Stick RFID Tag to RFID Reader',
                                            style: TextStyle(
                                                color: kFillColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          // Container(
                                          //   width: MediaQuery.of(context)
                                          //           .size
                                          //           .width /
                                          //       1.2,
                                          //   height: 40,
                                          //   child: ElevatedButton(
                                          //       style: ElevatedButton.styleFrom(
                                          //           elevation: 0,
                                          //           primary: Colors.black38),
                                          //       onPressed: () {
                                          //         Navigator.of(context).pop();
                                          //       },
                                          //       child: Text("CANCEL",
                                          //           style: TextStyle(
                                          //               fontSize: 16))),
                                          // ),
                                          Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // list.isEmpty
                                                //     ? Text('')
                                                //     : list[0],
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            fixedSize:
                                                                Size(120, 40),
                                                            elevation: 0,
                                                            primary:
                                                                kFillColor),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Process",
                                                        style: TextStyle(
                                                            fontSize: 16))),
                                              ]),
                                          // InputWithKeyboardControl(
                                          //   startShowKeyboard: false,
                                          //   controller: _textController,
                                          //   focusNode:
                                          //       InputWithKeyboardControlFocusNode(),
                                          //   width: 200,
                                          //   autofocus: true,
                                          //   showButton: false,
                                          //   showUnderline: true,
                                          //   cursorColor: Colors.black,
                                          // )
                                          // Form(
                                          //   child: Container(
                                          //     height: 40,
                                          //     child: TextFormField(
                                          //       controller: _textController,
                                          //       showCursor: true,
                                          //       enabled: true,
                                          //       enableInteractiveSelection:
                                          //           true,
                                          //       enableSuggestions: true,
                                          //       focusNode:
                                          //           FirstDisabledFocusNode(),
                                          //       decoration: textInputDecoration.copyWith(
                                          //           focusedBorder:
                                          //               OutlineInputBorder(
                                          //                   borderSide: BorderSide(
                                          //                       color: Colors
                                          //                           .black
                                          //                           .withOpacity(
                                          //                               1))),
                                          //           enabledBorder:
                                          //               OutlineInputBorder(
                                          //                   borderSide: BorderSide(
                                          //                       color: Colors
                                          //                           .black
                                          //                           .withOpacity(
                                          //                               1)))),
                                          //       onTap: () {
                                          //         // Navigator.of(context).pop();
                                          //       },
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ));
                            // });
                          }),
                      SlidableAction(
                          label: 'Cancel',
                          backgroundColor: Colors.white,
                          icon: Icons.arrow_forward_ios_outlined,
                          flex: 99,
                          onPressed: (context) {})
                    ]),
                child: ListTile(
                  title: Text("POA12345"),
                  subtitle: Text("Paku"),
                  trailing: Column(
                    children: [Text("Qty"), Text("60")],
                  ),
                ),
              ),
              Divider(
                height: 10,
                thickness: 1,
              ),
              Slidable(
                // key: const ValueKey(2),
                endActionPane: ActionPane(
                    motion: BehindMotion(),
                    extentRatio: 0.55,
                    children: [
                      SlidableAction(
                          label: 'Assign Tag',
                          backgroundColor: kTextColor,
                          icon: CustomIcon.tag_1,
                          flex: 99,
                          onPressed: (context) {}),
                      SlidableAction(
                          label: 'Cancel',
                          backgroundColor: Colors.white,
                          icon: Icons.arrow_forward_ios_outlined,
                          flex: 99,
                          onPressed: (context) {})
                    ]),
                child: ListTile(
                  title: Text("POA987654"),
                  subtitle: Text("Palu"),
                  trailing: Column(
                    children: [Text("Qty"), Text("60")],
                  ),
                ),
              ),
              Divider(
                height: 10,
                thickness: 1,
              ),
              Slidable(
                // key: const ValueKey(2),
                endActionPane: ActionPane(
                    motion: BehindMotion(),
                    extentRatio: 0.55,
                    children: [
                      SlidableAction(
                          label: 'Assign Tag',
                          backgroundColor: kTextColor,
                          icon: CustomIcon.tag_1,
                          flex: 99,
                          onPressed: (context) {}),
                      SlidableAction(
                          label: 'Cancel',
                          backgroundColor: Colors.white,
                          icon: Icons.arrow_forward_ios_outlined,
                          flex: 99,
                          onPressed: (context) {})
                    ]),
                child: ListTile(
                  title: Text("POA456123"),
                  subtitle: Text("Scanner"),
                  trailing: Column(
                    children: [Text("Qty"), Text("60")],
                  ),
                ),
              ),
              Divider(
                height: 10,
                thickness: 1,
              ),
              // RefreshIndicator(
              //     onRefresh: () async {},
              //     child: SingleChildScrollView(
              //       child: StreamBuilder<POResponse>(
              //         stream: blocPO.subject.stream,
              //         builder: (context, AsyncSnapshot<POResponse> snapshot) {
              //           if (snapshot.hasData) {
              //             if (snapshot.error != null) {
              //               return Text("error happen");
              //             }
              //             return _buildPOList(snapshot.data!);
              //           } else if (snapshot.hasError) {
              //             return Text("Error");
              //           } else {
              //             return CircularProgressIndicator();
              //           }
              //         },
              //       ),
              //     )),
            ],
          ),
        ),
      ])),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  Widget _buildPOList(POResponse data) {
    List<PO> po = data.po;

    if (po.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "No More List PO",
              style: textInputDecoration.labelStyle,
            )
          ],
        ),
      );
    } else
      return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: po.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("POA12345"),
              subtitle: Text("Palu"),
              trailing: Text('30'),
            );
          });
  }
}

class FirstDisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}
