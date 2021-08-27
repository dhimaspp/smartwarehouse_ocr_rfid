import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_blue/flutter_blue.dart' as fb;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:input_with_keyboard_control/input_with_keyboard_control.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/api_repository/data_repository/po_repository.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_assign_tag.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_items_po.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_search_po.dart';
import 'package:smartwarehouse_ocr_rfid/model/items_model.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/bt_pairing/bt_wrapper.dart';
import 'package:smartwarehouse_ocr_rfid/theme/my_flutter_app_icons.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';

class ItemTagging extends StatefulWidget {
  const ItemTagging({@required this.poNumber, @required this.server, Key key})
      : super(key: key);
  final String poNumber;
  final BluetoothDevice server;

  @override
  _ItemTaggingState createState() => _ItemTaggingState();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _ItemTaggingState extends State<ItemTagging> {
  // String uid = "";
  final ScrollController listScrollController = new ScrollController();
  TextEditingController searchController = TextEditingController();
  TextEditingController _textController = TextEditingController();

  List<_Message> messages = <_Message>[];
  bool _isLoading;
  static final clientID = 0;
  String _messageBuffer = '';
  BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;
  bool isError = false;
  bool isSearching = false;
  String searchPO;
  int itemIndex;
  // Stream<ItemsPOModel> _result;
  // Stream<ItemsPOModel> get result => _result;
  final PoRepository apiWrapper = PoRepository();
  final _subject = BehaviorSubject<String>();
  final Dio _dio = Dio();
  static String mainUrl = 'http://100.68.1.2:7030'; //vpn

  var getPOItemsurl = '$mainUrl/v1/purchase-orders/';

  @override
  void initState() {
    super.initState();
    _addPONumber(widget.poNumber);
    // searchController.addListener(_onChangeInputText);
    // BluetoothConnection.toAddress(widget.server.address).then((_connection) {
    // try {
    // if (_connection.isConnected) {
    if (isSearching == false) {
      print('po no : ${widget.poNumber}');
      getPOItems..getItemsPOList(widget.poNumber);
    } else {
      // var myInt = int.parse(searchController.text);
      // assert(myInt is int);
      print('getsearchItemBloc');
      getSearchItemBloc..searchItems(searchController.text);

      // _subject.add(searchController.text);

    }

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
    //           Navigator.of(context).pop();
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
    // });
  }

  _addPONumber(String po) async {
    SharedPreferences sharedLocal = await SharedPreferences.getInstance();
    print('removing local po');
    sharedLocal.remove('poNumber');
    print('just get po number $po');
    sharedLocal.setString('poNumber', po);
  }

  void _searchItems(String query) {
    _subject.add(query);
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
    return StreamBuilder<fb.BluetoothState>(
        stream: fb.FlutterBlue.instance.state,
        initialData: fb.BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state != fb.BluetoothState.on) {
            return BleOff();
          }
          // return isConnecting == true
          //     ? Scaffold(
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
          //     :
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                title: Text(
                  'Items List To Assign Tag',
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
                      Navigator.of(context).pop();
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (_) => HomeScreen()));
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
                    "Items PO List",
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
                          getSearchItemBloc..searchItems(searchController.text);
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
                            child: StreamBuilder<ItemsPOModel>(
                              stream: getSearchItemBloc.result,
                              builder: (context,
                                  AsyncSnapshot<ItemsPOModel> snapshot) {
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
                        : StreamBuilder<ItemsPOModel>(
                            stream: getPOItems.subject.stream,
                            builder: (context,
                                AsyncSnapshot<ItemsPOModel> snapshot) {
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

  Widget _buildSearchPO(ItemsPOModel data) {
    List<DataItem> items = data.data;

    if (items.length == 0) {
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
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final itemIndex = index;
            print('this po items : ${items[index].deskripsi}');
            return ExpansionTile(
              leading: Column(
                children: [Text('Qty'), Text('${items[index].qty}')],
              ),
              title: Text(items[index].deskripsi),
              subtitle: Text("Material code: " + items[index].kodeMaterial),
              trailing: Column(
                children: [Text('0 of ${items[index].qty}')],
              ),
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: items[itemIndex].qty,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[itemIndex].deskripsi),
                      subtitle: Text(
                          "Material code: " + items[itemIndex].kodeMaterial),
                      trailing: GestureDetector(
                        onTap: () {
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          fixedSize:
                                                              Size(120, 40),
                                                          elevation: 0,
                                                          primary: kFillColor),
                                                  onPressed: () async {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    await context
                                                        .read<AssignTagCubit>()
                                                        .assignTag(
                                                            items[index]
                                                                .recId
                                                                .toString(),
                                                            _textController
                                                                .text);

                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  },
                                                  child: Text("Process",
                                                      style: TextStyle(
                                                          fontSize: 16))),
                                            ]),
                                        InputWithKeyboardControl(
                                          startShowKeyboard: false,
                                          controller: _textController,
                                          focusNode:
                                              InputWithKeyboardControlFocusNode(),
                                          width: 200,
                                          autofocus: true,
                                          showButton: false,
                                          showUnderline: false,
                                          cursorColor: Colors.black,
                                        )
                                      ],
                                    ),
                                  ));
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            color: kMaincolor,
                            child: Column(
                              children: [
                                Icon(CustomIcon.tag_1, color: Colors.white),
                                Text(
                                  'AssignTag',
                                  style: textInputDecoration.labelStyle
                                      .copyWith(
                                          color: Colors.white, fontSize: 12),
                                )
                              ],
                            )),
                      ),
                    );
                  },
                )
              ],
            );
          });
  }

  Widget _buildPOList(ItemsPOModel data) {
    List<DataItem> items = data.data;

    if (items.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "There is no items in data list PO",
              style: textInputDecoration.labelStyle,
            )
          ],
        ),
      );
    } else
      return ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final itemIndex = index;
            print('this po items : ${items[index].deskripsi}');
            // final List<String> uid = List<String>.generate(items[itemIndex].qty,
            //     (indexRFID) => items[itemIndex].rfids[indexRFID].uid);
            return ExpansionTile(
              leading: Column(
                children: [Text('Qty'), Text('${items[index].qty}')],
              ),
              title: Text(items[index].deskripsi),
              subtitle: Text("Material code: " + items[index].kodeMaterial),
              trailing: Column(
                children: [Text('0 of ${items[index].qty}')],
              ),
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: items[itemIndex].qty,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(items[itemIndex].deskripsi),
                      subtitle: Text((items[itemIndex].rfids != null &&
                              items[itemIndex].rfids.length > index
                          ? "UID No: " + items[itemIndex].rfids[index].uid
                          : "UID No: -not assign tag yet-")),
                      // items[itemIndex].rfids[index].uid.
                      //     ? Text("UID no: " + items[itemIndex].rfids[index].uid)
                      //     :
                      //  Text("UID no: not yet assign tag"),
                      trailing: items[itemIndex].rfids != null &&
                              items[itemIndex].rfids.length > index
                          ? Text('Already assign')
                          : GestureDetector(
                              onTap: () {
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
                                              Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // list.isEmpty
                                                    //     ? Text('')
                                                    //     : list[0],
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                fixedSize: Size(
                                                                    120, 40),
                                                                elevation: 0,
                                                                primary:
                                                                    kFillColor),
                                                        onPressed: () async {
                                                          EasyLoading.show(
                                                              status:
                                                                  'Loading');
                                                          await context
                                                              .read<
                                                                  AssignTagCubit>()
                                                              .assignTag(
                                                                  items[index]
                                                                      .recId
                                                                      .toString(),
                                                                  _textController
                                                                      .text)
                                                              .onError((error,
                                                                      stackTrace) =>
                                                                  EasyLoading
                                                                      .showError(
                                                                          error));
                                                          EasyLoading.showSuccess(
                                                              'Assign Tag Success');
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                              builder: (_) => ItemTagging(
                                                                  poNumber: widget
                                                                      .poNumber,
                                                                  server: widget
                                                                      .server)));
                                                        },
                                                        child: Text("Process",
                                                            style: TextStyle(
                                                                fontSize: 16))),
                                                  ]),
                                              InputWithKeyboardControl(
                                                startShowKeyboard: false,
                                                controller: _textController,
                                                focusNode:
                                                    InputWithKeyboardControlFocusNode(),
                                                width: 200,
                                                autofocus: true,
                                                showButton: false,
                                                showUnderline: false,
                                                cursorColor: Colors.black,
                                              )
                                            ],
                                          ),
                                        ));
                              },
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: kMaincolor,
                                  child: Column(
                                    children: [
                                      Icon(CustomIcon.tag_1,
                                          color: Colors.white),
                                      Text(
                                        'Assign Tag',
                                        style: textInputDecoration.labelStyle
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 12),
                                      )
                                    ],
                                  )),
                            ),
                    );
                  },
                )
              ],
            );
          });
  }
}
