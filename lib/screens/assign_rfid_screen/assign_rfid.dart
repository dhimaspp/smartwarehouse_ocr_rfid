import 'package:flutter/material.dart';
import 'package:smartwarehouse_ocr_rfid/bloc/bloc_po.dart';
import 'package:smartwarehouse_ocr_rfid/model/po_model.dart';
import 'package:smartwarehouse_ocr_rfid/theme/theme.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AssignRFID extends StatefulWidget {
  @override
  AssignRFIDState createState() => AssignRFIDState();
}

class AssignRFIDState extends State<AssignRFID> {
  @override
  void initState() {
    super.initState();
    blocPO..getPOrx();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            StreamBuilder<BluetoothState>(
              stream: FlutterBlue.instance.state,
              initialData: BluetoothState.unknown,
              builder: (c, snapshot) {
                final state = snapshot.data;
                if (state == BluetoothState.on) {
                  final ScanResult result;
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1),
                            color: kSecondaryColor,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  blurRadius: 3,
                                  color: Colors.black,
                                  offset: Offset(0, 1))
                            ],
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          width: MediaQuery.of(context).size.width * 0.63,
                          height: 45,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.bluetooth,
                                color: Colors.white,
                              ),
                              StreamBuilder<List<ScanResult>>(
                                  stream: FlutterBlue.instance.scanResults,
                                  initialData: [],
                                  builder: (c, snapshot) => Column(
                                        children: snapshot.data!
                                            .map((e) => Column(children: [
                                                  Text(e.advertisementData
                                                              .localName ==
                                                          ""
                                                      ? "Tidak Diketahui"
                                                      : e.advertisementData
                                                          .localName),
                                                  // Text(e.device.name),
                                                  // Text(e.device.id.toString())
                                                ]))
                                            .toList(),
                                      ))
                              // Text(
                              //   "No Device Available",
                              //   style: textInputDecoration.labelStyle!.copyWith(
                              //       color: Colors.white,
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 18),
                              // )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      blurRadius: 3,
                                      color: Colors.black,
                                      offset: Offset(0, 1))
                                ],
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 45,
                              child: Text(
                                "Connect",
                                style: textInputDecoration.labelStyle!.copyWith(
                                    color: kMaincolor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              )),
                        ),
                      ]);
                }
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            blurRadius: 3,
                            color: Colors.black12,
                            offset: Offset(0, 1))
                      ],
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 45,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth,
                          color: Colors.black,
                        ),
                        Text(
                          "Bluetooth is Off",
                          style: textInputDecoration.labelStyle!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 10,
              thickness: 4,
            ),
            ListTile(
              title: Text("POA12345"),
              subtitle: Text("Paku"),
              trailing: Column(
                children: [Text("Qty"), Text("60")],
              ),
            ),
            Divider(
              height: 10,
              thickness: 4,
            ),
            ListTile(
              title: Text("POA987654"),
              subtitle: Text("Palu"),
              trailing: Column(
                children: [Text("Qty"), Text("60")],
              ),
            ),
            Divider(
              height: 10,
              thickness: 4,
            ),
            ListTile(
              title: Text("POA456123"),
              subtitle: Text("Scanner"),
              trailing: Column(
                children: [Text("Qty"), Text("60")],
              ),
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
      ))),
    );
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
