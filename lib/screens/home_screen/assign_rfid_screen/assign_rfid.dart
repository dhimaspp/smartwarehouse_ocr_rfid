import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_po.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_search_po.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/assign_rfid_screen/item_tagging.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/bt_pairing/bt_wrapper.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/home_screen.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';
import 'package:flutter_blue/flutter_blue.dart' as fb;

class AssignRFID extends StatefulWidget {
  final BluetoothDevice server;
  const AssignRFID(this.server);
  @override
  AssignRFIDState createState() => AssignRFIDState();
}

class _Message {
  String text;

  _Message(this.text);
}

class AssignRFIDState extends State<AssignRFID> {
  // String uid = "";
  final ScrollController listScrollController = new ScrollController();
  TextEditingController searchController = TextEditingController();

  List<_Message> messages = <_Message>[];
  static final clientID = 0;
  String _messageBuffer = '';
  BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  bool isError = false;
  bool isSearching = false;
  String searchPO;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onChangeInputText);
    // BluetoothConnection.toAddress(widget.server.address).then((_connection) {
    // try {
    //   if (_connection.isConnected) {
    if (isSearching == false) {
      getAllPOBloc..getallPOrx();
    } else {
      // var myInt = int.parse(searchController.text);
      // assert(myInt is int);
      getSearchBloc..search(searchController.text);
    }

    // print('Connected to the device');
    // connection = _connection;
    // setState(() {
    //   isConnecting = false;
    //   isDisconnecting = false;
    // });

    // connection.input.listen(_onDataReceived).onDone(() {
    //   // Example: Detect which side closed the connection
    //   // There should be `isDisconnecting` flag to show are we are (locally)
    //   // in middle of disconnecting process, should be set before calling
    //   // `dispose`, `finish` or `close`, which all causes to disconnect.
    //   // If we except the disconnection, `onDone` should be fired as result.
    //   // If we didn't except this (no flag set), it means closing by remote.
    //   if (isDisconnecting) {
    //     print('Disconnecting locally!');
    //     Navigator.of(context).pop();
    //   } else {
    //     print('Disconnected remotely!');
    //   }
    //   if (this.mounted) {
    //     setState(() {});
    //   }
    // });
    //     } else {
    //       setState(() {
    //         isConnecting = true;
    //       });
    //     }
    //   } on PlatformException catch (errP) {
    //     print('Cannot connect, Platform exception occured : $errP');
    //     setState(() {
    //       isError = true;
    //     });
    //   } catch (e) {
    //     print(e);
    //     Navigator.of(context).pop();
    //   }
    // }).onError<PlatformException>((error, s) {
    //   print('Cannot connect, exception occured');
    //   print(error);
    //   setState(() {
    //     isError = true;
    //   });
    // }
    // );
  }

  void _onChangeInputText() {
    setState(() {
      searchPO = searchController.text;
    });

    print('value = ${searchController.text}');
  }

  _getAllPOorGetSearchPO(String query) {
    // getSearchBloc..search(query);
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    // if (isConnected) {
    //   isDisconnecting = true;
    //   connection.dispose();
    //   connection = null;
    // }
    searchController.dispose();
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final List<String> list = messages.map((_message) {
    //   print(_message.text);
    //   return _message.text;
    // }).toList();
    return StreamBuilder<fb.BluetoothState>(
        stream: fb.FlutterBlue.instance.state,
        initialData: fb.BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state != fb.BluetoothState.on) {
            return BleOff();
          }
          return
              //  isConnecting == true
              //     ?
              //     Scaffold(
              //         backgroundColor: Colors.white,
              //         body: isError == true
              //             ? Container(
              //                 child: Center(
              //                     child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Icon(
              //                       Icons.error_outline_rounded,
              //                       color: Colors.red[800],
              //                       size: 40,
              //                     ),
              //                     SizedBox(height: 20),
              //                     Text(
              //                       'Oops Something Went Wrong',
              //                       style: textInputDecoration.labelStyle.copyWith(
              //                           fontWeight: FontWeight.w800,
              //                           fontSize: 22,
              //                           color: Colors.black),
              //                     ),
              //                     SizedBox(height: 20),
              //                     Text(
              //                       "Please make sure Bluetooth RFID Reader\ndevice is installed properly",
              //                       textAlign: TextAlign.center,
              //                       style: textInputDecoration.labelStyle.copyWith(
              //                           fontWeight: FontWeight.w800,
              //                           fontSize: 18,
              //                           color: Colors.black),
              //                     ),
              //                     SizedBox(height: 20),
              //                     GestureDetector(
              //                         onTap: () {
              //                           Navigator.of(context).pop();
              //                         },
              //                         child: Row(
              //                           mainAxisAlignment: MainAxisAlignment.center,
              //                           children: [
              //                             Icon(
              //                               Icons.arrow_back_ios_new_rounded,
              //                               color: kMaincolor,
              //                             ),
              //                             Text('Back',
              //                                 style: textInputDecoration.labelStyle
              //                                     .copyWith(
              //                                         fontWeight: FontWeight.w800,
              //                                         fontSize: 18,
              //                                         color: kMaincolor))
              //                           ],
              //                         ))
              //                   ],
              //                 )),
              //               )
              //             : Center(
              //                 // heightFactor: MediaQuery.of(context).size.height,s
              //                 child: SpinKitRipple(
              //                 color: kMaincolor,
              //                 size: 80,
              //               )),
              //       )
              // :
              Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                title: Text(
                  'PO List To Assign Tag',
                  style: textInputDecoration.labelStyle.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.white),
                ),
                centerTitle: false,
                backgroundColor: kMaincolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded)),
              ),
            ),
            body:
                // isConnecting
                //     ? Center(child: CircularProgressIndicator())
                //     :
                Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "PO List",
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.black54,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                    child: TextFormField(
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                        controller: searchController,
                        onChanged: (change) {
                          setState(() {
                            isSearching = true;
                          });
                          // var myInt = int.parse(searchController.text);
                          // assert(myInt is int);
                          getSearchBloc..search(searchController.text);
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          filled: true,
                          fillColor: Colors.grey[100],
                          suffixIcon: searchController.text.length > 0
                              ? IconButton(
                                  icon: Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.grey[500],
                                    size: 16.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isSearching = false;
                                      searchController.clear();
                                    });
                                  })
                              : IconButton(
                                  icon: Icon(
                                    Icons.search_outlined,
                                    color: Colors.grey[500],
                                    size: 16.0,
                                  ),
                                  onPressed: () {},
                                ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey[100].withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(30.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey[100].withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(30.0)),
                          contentPadding:
                              EdgeInsets.only(left: 15.0, right: 10.0),
                          labelText: "Search...",
                          hintStyle: TextStyle(
                              fontSize: 14.0,
                              color: kFillColor,
                              fontWeight: FontWeight.w500),
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500),
                        ),
                        autocorrect: false,
                        autovalidateMode: AutovalidateMode.disabled),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 10,
                    thickness: 1,
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: isSearching == true
                        ? AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: StreamBuilder<POList>(
                              stream: getSearchBloc.result,
                              builder:
                                  (context, AsyncSnapshot<POList> snapshot) {
                                print('searching query params');
                                if (snapshot.hasData) {
                                  EasyLoading.dismiss();
                                  Future.delayed(Duration(seconds: 1));

                                  print(
                                      'print snapshot${snapshot.data.data.length}');
                                  return _buildSearchPO(snapshot.data);
                                } else if (snapshot.hasError) {
                                  EasyLoading.showError(
                                      'Error occured\nPlease check your internet connection');
                                  return Container();
                                } else {
                                  EasyLoading.show(
                                      status: 'Loading',
                                      indicator: Center(
                                          child: SpinKitRipple(
                                        color: kMaincolor,
                                      )));
                                  return Container();
                                }
                              },
                            ),
                          )
                        : StreamBuilder<POList>(
                            stream: getAllPOBloc.subject.stream,
                            builder: (context, AsyncSnapshot<POList> snapshot) {
                              print('get all po list');
                              if (snapshot.hasData) {
                                EasyLoading.dismiss();
                                print(
                                    'print snapshot${snapshot.data.data.length}');
                                return _buildPOList(snapshot.data);
                              } else if (snapshot.hasError) {
                                EasyLoading.showError(
                                    'Error occured\nPlease check your internet connection');
                                return Container();
                              } else {
                                EasyLoading.show(
                                    status: 'Loading',
                                    indicator: Center(
                                        child: SpinKitRipple(
                                      color: kMaincolor,
                                    )));
                                return Container();
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        });
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
            // 1,
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

  Widget _buildSearchPO(POList data) {
    List<DataPO> po = data.data;

    if (po.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Your search did not match with any data PO",
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
            print('this po no : ${po[index].poNo}');
            return ListTile(
              title: Text(po[index].poNo),
              subtitle: Text(po[index].poTgl.split('T').first),
              trailing: Column(
                children: [
                  Text('Status'),
                  po[index].status == 'closed'
                      ? Icon(
                          Icons.circle_rounded,
                          color: kMaincolor,
                          size: 16,
                        )
                      : Icon(
                          Icons.circle_rounded,
                          color: Colors.red.shade900,
                          size: 16,
                        ),
                  Text('${po[index].status}')
                ],
              ),
            );
          });
  }

  Widget _buildPOList(POList data) {
    List<DataPO> po = data.data;

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
            print('this po no : ${po[index].poNo}');
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ItemTagging(
                          poNumber: po[index].poNo,
                          // connection: uid,
                          server: widget.server,
                        )));
              },
              title: Text(po[index].poNo),
              subtitle: Text(po[index].poTgl.split('T').first),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Status',
                    // style: TextStyle(fontSize: 12),
                  ),
                  po[index].status == 'closed'
                      ? Icon(
                          Icons.circle_rounded,
                          color: kMaincolor,
                          size: 16,
                        )
                      : Icon(
                          Icons.circle_rounded,
                          color: Colors.red.shade900,
                          size: 16,
                        ),
                  Text('${po[index].status}')
                  // Row(
                  //   children: [Icon(Icons.circle_rounded)],
                  // )
                ],
              ),
            );
          });
  }
}
