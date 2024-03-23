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
      home: const AdaptiveWidgetExample(),
    );
  }
}

class AdaptiveWidgetExample extends StatelessWidget {
  const AdaptiveWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adaptive Container"),
      ),
      body: SingleChildScrollView(
        child: Center(
              child: AdaptiveContainer(
                configs: {
                  BreakPoint.xs: AdaptiveSlot(builder: (context) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.red,
                      child: const Center(
                          child: Text(
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              'XM')),
                    );
                  }),
                  BreakPoint.sm: AdaptiveSlot(builder: (context) {
                    return Container(
                      width: 200,
                      height: 200,
                      color: Colors.green,
                      child: const Center(
                          child: Text(
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              'SM')),
                    );
                  }),
                  BreakPoint.md: AdaptiveSlot(builder: (context) {
                    return Container(
                      width: 300,
                      height: 300,
                      color: Colors.black,
                      child: const Center(
                          child: Text(
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              'MD')),
                    );
                  }),
                  BreakPoint.lg: AdaptiveSlot(builder: (context) {
                    return Container(
                      width: 400,
                      height: 400,
                      color: Colors.purple,
                      child: const Center(
                          child: Text(
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              'LG')),
                    );
                  }),
                  BreakPoint.xl: AdaptiveSlot(builder: (context) {
                    return Container(
                      width: 500,
                      height: 500,
                      color: Colors.yellow,
                      child: const Center(
                          child: Text(
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              'XL')),
                    );
                  }),
                  BreakPoint.xxl: AdaptiveSlot(builder: (context) {
                    return Container(
                      width: 600,
                      height: 600,
                      color: Colors.blue,
                      child: const Center(
                          child: Text(
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              'XXL')),
                    );
                  }),
                },
              ),
            ),
          
      ),
    );
  }
}

class BreakPoints extends StatelessWidget {
  const BreakPoints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Media query breakpoints"),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: valueFor<Color>(
                    context,
                    xs: Colors.red,
                    sm: Colors.green,
                    md: Colors.black,
                    lg: Colors.purple,
                    xl: Colors.yellow,
                    xxl: Colors.blue,
                  ),
                  width: valueFor<double>(
                    context,
                    xs: 100,
                    sm: 200,
                    md: 300,
                    lg: 400,
                    xl: 500,
                    xxl: 600,
                  ),
                  height: valueFor<double>(
                    context,
                    xs: 100,
                    sm: 200,
                    md: 300,
                    lg: 400,
                    xl: 500,
                    xxl: 600,
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
