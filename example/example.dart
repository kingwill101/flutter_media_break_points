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
        body: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: valueFor<Color>(context,
                      xs: Colors.red,
                      sm: Colors.green,
                      md: Colors.black,
                      lg: Colors.purple,
                      xl: Colors.yellow),
                  width: valueFor<double>(
                    context,
                    xs: 100,
                    sm: 200,
                    md: 300,
                    lg: 400,
                    xl: 500,
                  ),
                  height: valueFor<double>(
                    context,
                    xs: 400,
                    sm: 300,
                    md: 200,
                    lg: 100,
                    xl: 50,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
