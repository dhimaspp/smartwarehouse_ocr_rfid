import 'dart:collection';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_delete_PO.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_po.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_po_loadmore.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_search_po.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/assign_rfid_screen/item_tagging.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/bt_pairing/bt_wrapper.dart';
import 'package:smartwarehouse_ocr_rfid/screens/home_screen/home_screen.dart';
import 'package:smartwarehouse_ocr_rfid/screens/login_screen/login.dart';
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
  BluetoothConnection? connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection!.isConnected;

  bool isDisconnecting = false;
  bool isError = false;
  bool isSearching = false;
  bool isDone = false;
  String? searchPO;
  List pagination = [];
  List<DataPO> listPO = [];

  @override
  void initState() {
    super.initState();
    listPO.clear();
    pagination.clear();
    searchController.addListener(_onChangeInputText);
    // BluetoothConnection.toAddress(widget.server.address).then((_connection) {
    // try {
    //   if (_connection.isConnected) {
    if (isSearching == false) {
      // getAllPOBloc..getallPOrx();
      getPOLoadmoreBloc..getallPOrx('');
    } else {
      // var myInt = int.parse(searchController.text);
      // assert(myInt is int);
      getSearchBloc..search(searchController.text);
    }
  }

  void _onChangeInputText() {
    setState(() {
      searchPO = searchController.text;
    });

    print('value = ${searchController.text}');
  }

  @override
  void dispose() {
    listPO.clear();
    pagination.clear();
    getPOLoadmoreBloc.dispose();
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
          // if (state != fb.BluetoothState.on) {
          //   return BleOff();
          // }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AppBar(
                title: Text(
                  'PO List To Assign Tag',
                  style: textInputDecoration.labelStyle!.copyWith(
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
                      listPO.clear();
                      pagination.clear();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded)),
              ),
            ),
            body: Padding(
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
                                  color: Colors.grey[100]!.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(30.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.grey[100]!.withOpacity(0.3)),
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
                                      'print snapshot${snapshot.data!.data!.length}');
                                  return _buildSearchPO(snapshot.data!);
                                } else if (snapshot.hasError) {
                                  EasyLoading.showError(
                                      'Error occured\nPlease check your local connection',
                                      duration: Duration(seconds: 15));
                                  return Container();
                                } else {
                                  EasyLoading.show(
                                      status: 'Loading',
                                      dismissOnTap: true,
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
                            stream: getPOLoadmoreBloc.subject.stream,
                            builder: (context, AsyncSnapshot<POList> snapshot) {
                              if (snapshot.hasError) {
                                EasyLoading.showError(snapshot.data!.message!,
                                    duration: Duration(seconds: 15));
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => HomeScreen()));

                                // logout();
                                return Container();
                              } else if (snapshot.hasData) {
                                if (listPO.length == 0) {
                                  if (snapshot.data!.data == null) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => HomeScreen()));
                                  } else {
                                    listPO = snapshot.data!.data!;
                                  }
                                }
                                for (var i = 0; i < listPO.length; i++) {
                                  snapshot.data!.data!.map((e) {
                                    if (e.poNo != listPO[i].poNo) {
                                      listPO.add(e);
                                    }
                                  });
                                }
                                // listPO.addAll(snapshot.data!.data!);
                                snapshot.data!.pagination!.hasOlder == true
                                    ? pagination
                                        .add(snapshot.data!.pagination!.older)
                                    : isDone = true;
                                print('get all po list');
                                EasyLoading.dismiss();
                                print(
                                    'print snapshot${snapshot.data!.data!.length}');
                                return _buildPOList(listPO);
                              }
                              // else if (snapshot.data!.data!.isEmpty) {
                              //   EasyLoading.showError(snapshot.data!.message!,
                              //       duration: Duration(seconds: 15));
                              //   Navigator.of(context).pop();
                              //   return Container();
                              // }
                              else {
                                EasyLoading.show(
                                    status: 'Loading',
                                    dismissOnTap: true,
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

  void logout() async {
    // var res = await UserAuth().getData();
    // var body = json.decode(res.body);
    // if (body['success']) {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('ListImagePath');
    localStorage.remove('poNumber');
    localStorage.remove('username');
    localStorage.remove('access_token');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    // }
  }

  Widget _buildSearchPO(POList data) {
    List<DataPO> po = data.data!;

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
          itemBuilder: (contexti, index) {
            print('this po no : ${po[index].poNo}');
            return ListTile(
              onLongPress: () {
                presentLoader(context, text: 'Delete PO', onPressed: () async {
                  EasyLoading.show(status: 'Loading');

                  await contexti.read<DeletePOCubit>().deletePO(
                        po[index].poNo!,
                      );
                  DeletePOState state = contexti.read<DeletePOCubit>().state;
                  if (state is DeletePOLoaded) {
                    print('delete success');
                    EasyLoading.show(
                      status: 'delete success',
                    );
                    listPO.removeAt(index);
                    getPOLoadmoreBloc..getallPOrx('');
                    Navigator.of(context).pop();
                    // Navigator.of(contexti).push(MaterialPageRoute(
                    //     builder: (_) => AssignRFID(widget.server)));
                    EasyLoading.dismiss();
                  } else if (state is DeletePOLoadingFailed) {
                    EasyLoading.showError(state.message!);
                  }
                });
              },
              title: Text(po[index].poNo!),
              subtitle: Text(po[index].poTgl!.split('T').first),
              // trailing: Column(
              //   children: [
              //     Text('Status'),
              //     po[index].status == 'closed'
              //         ? Icon(
              //             Icons.circle_rounded,
              //             color: kMaincolor,
              //             size: 16,
              //           )
              //         : Icon(
              //             Icons.circle_rounded,
              //             color: Colors.greenAccent.shade700,
              //             size: 16,
              //           ),
              //     Text('${po[index].status}')
              //   ],
              // ),
            );
          });
  }

  Widget _buildPOList(List<DataPO> data) {
    final ids = Set<DataPO>().toList();
    // data.retainWhere((element) => ids.add(element));

    List<DataPO> po = ids;
    for (var i = 0; i < data.length; i++) {
      po = data;
      for (var j = i + 1; j < data.length; j++) {
        if (data[j].poNo == data[i].poNo) {
          po.removeAt(j);
        } else {
          // break inner loop dan masuk ke outer loop selanjutnya,
          break;
        }
      }
    }

    print(po);

    if (po.length == 0) {
      print('PO length: ${po.length}');
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "There is no data in List PO\nPlease do OCR for related PO",
              style: textInputDecoration.labelStyle,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    } else
      return LoadMore(
        isFinish: isDone,
        whenEmptyLoad: false,
        delegate: DefaultLoadMoreDelegate(),
        textBuilder: DefaultLoadMoreTextBuilder.english,
        onLoadMore: _loadMore,
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemCount: po.length,
            itemBuilder: (contexti, index) {
              print('this po no : ${po.length}');
              return ListTile(
                onLongPress: () {
                  presentLoader(context, text: 'Delete PO',
                      onPressed: () async {
                    EasyLoading.show(status: 'Loading');

                    await contexti.read<DeletePOCubit>().deletePO(
                          po[index].poNo!,
                        );
                    DeletePOState state = contexti.read<DeletePOCubit>().state;
                    if (state is DeletePOLoaded) {
                      print('delete success');
                      EasyLoading.show(
                        status: 'delete success',
                      );
                      listPO.removeAt(index);
                      getPOLoadmoreBloc..getallPOrx('');
                      Navigator.of(context).pop();
                      // Navigator.of(contexti).push(MaterialPageRoute(
                      //     builder: (_) => AssignRFID(widget.server)));
                      EasyLoading.dismiss();
                    } else if (state is DeletePOLoadingFailed) {
                      EasyLoading.showError(state.message!);
                    }
                  });
                },
                onTap: () {
                  Navigator.of(contexti).push(MaterialPageRoute(
                      builder: (_) => ItemTagging(
                            poNumber: po[index].poNo,
                            // connection: uid,
                            server: widget.server,
                          )));
                },
                title: Text(po[index].poNo!),
                subtitle: Text(po[index].poTgl!.split('T').first),
                // trailing: Column(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Text(
                //       'Status',
                //       // style: TextStyle(fontSize: 12),
                //     ),
                //     po[index].status == 'closed'
                //         ? Icon(
                //             Icons.circle_rounded,
                //             color: kMaincolor,
                //             size: 16,
                //           )
                //         : Icon(
                //             Icons.circle_rounded,
                //             color: Colors.greenAccent.shade700,
                //             size: 16,
                //           ),
                //     Text('${po[index].status}')
                //     // Row(
                //     //   children: [Icon(Icons.circle_rounded)],
                //     // )
                //   ],
                // ),
              );
            }),
      );
  }

  Future<bool> _loadMore() async {
    print("onLoadMore");
    await Future.delayed(Duration(seconds: 2, milliseconds: 2000));

    load();
    return true;
  }

  void load() async {
    List<DataPO> tempList = [];
    print('load page');
    if (pagination != null) {
      getPOLoadmoreBloc..getallPOrx(pagination.last);
    } else {
      setState(() {
        isDone = true;
      });
    }
  }

  void presentLoader(BuildContext context,
      {String text1 = 'Aguarde...',
      String text = 'Aguarde...',
      String uid = '',
      bool barrierDismissible = true,
      bool error = false,
      bool willPop = true,
      bool success = false,
      List<Widget>? action,
      Widget? elevatedButton,
      required VoidCallback onPressed,
      double? value}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        text,
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Text('Are you sure want to delete PO?'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: onPressed,
                            child:
                                Text('Yes', style: TextStyle(fontSize: 16.0))),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel',
                                style: TextStyle(fontSize: 16.0)))
                      ],
                    )
                  ],
                ),
              ),
              actions: action,
            ),
          );
        });
  }
}
