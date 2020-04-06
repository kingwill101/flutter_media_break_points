import 'package:flutter/material.dart';
import 'package:media_break_points/media_break_points.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: "OpenSans"),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Example breakpoints"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                  color: Colors.red,
                  margin: valueFor<EdgeInsets>(
                    context,
                    xs: EdgeInsets.only(left: 25),
                    md: EdgeInsets.only(left: 50),
                    lg: EdgeInsets.only(left: 75),
                  )),
              Container(
                color: Colors.blue,
                padding: valueFor<EdgeInsets>(
                  context,
                  xs: EdgeInsets.only(right: 20),
                  md: EdgeInsets.only(right: 40),
                  lg: EdgeInsets.only(right: 60),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
