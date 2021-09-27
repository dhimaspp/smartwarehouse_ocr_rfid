// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

// class ListenerBottomSheet extends StatefulWidget {
//   const ListenerBottomSheet({@required this.server, Key key}) : super(key: key);
//   final BluetoothDevice server;

//   @override
//   _ListenerBottomSheetState createState() => _ListenerBottomSheetState();
// }

// class _ListenerBottomSheetState extends State<ListenerBottomSheet> {
//   String _messageBuffer = '';
//   BluetoothConnection connection;
//   bool isConnecting = true;
//   bool get isConnected => connection != null && connection.isConnected;

//   bool isDisconnecting = false;
//   bool isError = false;


//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   _initBlutooth(){
//     BluetoothConnection.toAddress(widget.server.address).then((_connection) {
//       try {
//         if (_connection.isConnected) {
//           print('Connected to the device');
//           connection = _connection;
//           setState(() {
//             isConnecting = false;
//             isDisconnecting = false;
//           });

//           connection.input.listen(_onDataReceived).onDone(() {
//             // Example: Detect which side closed the connection
//             // There should be `isDisconnecting` flag to show are we are (locally)
//             // in middle of disconnecting process, should be set before calling
//             // `dispose`, `finish` or `close`, which all causes to disconnect.
//             // If we except the disconnection, `onDone` should be fired as result.
//             // If we didn't except this (no flag set), it means closing by remote.
//             if (isDisconnecting) {
//               print('Disconnecting locally!');
//               Navigator.of(context).pop();
//             } else {
//               print('Disconnected remotely!');
//             }
//             if (this.mounted) {
//               setState(() {});
//             }
//           });
//         } else {
//           setState(() {
//             isConnecting = true;
//           });
//         }
//       } on PlatformException catch (errP) {
//         print('Cannot connect, Platform exception occured : $errP');
//         setState(() {
//           isError = true;
//         });
//       } catch (e) {
//         print(e);
//         Navigator.of(context).pop();
//       }
//     }).onError<PlatformException>((error, s) {
//       print('Cannot connect, exception occured');
//       print(error);
//       setState(() {
//         isError = true;
//       });
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }

//   void _onDataReceived(Uint8List data) {
//     // Allocate buffer for parsed data
//     int backspacesCounter = 0;
//     data.forEach((byte) {
//       if (byte == 8 || byte == 127) {
//         backspacesCounter++;
//       }
//     });
//     Uint8List buffer = Uint8List(data.length - backspacesCounter);
//     int bufferIndex = buffer.length;

//     // Apply backspace control character
//     backspacesCounter = 0;
//     for (int i = data.length - 1; i >= 0; i--) {
//       if (data[i] == 8 || data[i] == 127) {
//         backspacesCounter++;
//       } else {
//         if (backspacesCounter > 0) {
//           backspacesCounter--;
//         } else {
//           buffer[--bufferIndex] = data[i];
//         }
//       }
//     }

//     // Create message if there is new line character
//     String dataString = String.fromCharCodes(buffer);
//     int index = buffer.indexOf(13);
//     if (~index != 0) {
//       setState(() {
//         messages.add(
//           _Message(
//             // 1,
//             backspacesCounter > 0
//                 ? _messageBuffer.substring(
//                     0, _messageBuffer.length - backspacesCounter)
//                 : _messageBuffer + dataString.substring(0, index),
//           ),
//         );
//         _messageBuffer = dataString.substring(index);
//       });
//     } else {
//       _messageBuffer = (backspacesCounter > 0
//           ? _messageBuffer.substring(
//               0, _messageBuffer.length - backspacesCounter)
//           : _messageBuffer + dataString);
//     }
//   }

// }
