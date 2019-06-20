import 'package:flutter/material.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'item_controller.dart';

class ScanPage extends StatefulWidget {
  ScanPage({Key key}) : super(key: key);

  @override
  _ScanPageState createState() => new _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  ItemController _controller;
  Map<String, int> _scanned = Map();

  @override
  void initState() {
    super.initState();
    ItemController.getInstance().then((controller) {
      _controller = controller;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Scanning"),
          leading: BackButton(),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            return Container(
              width: width,
              height: height,
              child: QrCamera(
                qrCodeCallback: (code) {
                  _scanned[code] =
                      _scanned.containsKey(code) ? _scanned[code] + 1 : 1;
                  if (_scanned[code] == 10) {
                    _controller?.increase(barcode: code);
                    final scaffold = Scaffold.of(context);
                    final snackbar = SnackBar(
                      content: Text("Scanned $code"),
                      duration: Duration(seconds: 2),
                    );
                    scaffold.showSnackBar(snackbar);
                  }
                },
                fit: BoxFit.cover,
              ),
            );
          },
        ));
  }
}
