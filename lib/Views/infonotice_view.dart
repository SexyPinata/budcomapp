import 'dart:math';

import 'package:barcode/barcode.dart';
import 'package:budcomapp/Services/random_extended.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class infoNotice extends StatefulWidget {
  infoNotice({Key? key}) : super(key: key);

  @override
  _infoNoticeState createState() => _infoNoticeState();
}

String _generateNewInfoNotice() {
  final bc = Barcode.code128();

  final random = Random();
  final infoNoticeStart = "9850" + random.nextIntOfDigits(8).toString();
  final svg = bc.toSvg(infoNoticeStart, width: 400, height: 200);
  return svg;
}

class _infoNoticeState extends State<infoNotice> {
  @override
  Widget build(BuildContext context) {
    Widget svg2 = SvgPicture.string(_generateNewInfoNotice());
    return Scaffold(
        appBar: AppBar(
          title: const Text('Info Notice'),

          // If `TabController controller` is not provided, then a
          // DefaultTabController ancestor must be provided instead.
          // Another way is to use a self-defined controller, c.f. "Bottom tab
          // bar" example.
        ),
        extendBodyBehindAppBar: false,
        extendBody: true,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(padding: EdgeInsets.all(50)),
            Center(child: svg2),
            FlatButton(
                onPressed: () {
                  setState(() {
                    svg2 = SvgPicture.string(_generateNewInfoNotice());
                  });
                },
                child: Text('Generate')),
          ],
        )));
  }
}
