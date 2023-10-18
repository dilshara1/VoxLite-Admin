import 'package:charts_common/src/data/series.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
//import 'package:fl_chart/fl_chart.dart' as charts;
import 'package:intl/intl.dart';
import '../colors.dart';
import '../widgets/UserListScreen.dart';
import '../widgets/char1.dart';
import '../widgets/chart2.dart';

import '../widgets/revinue.dart';

class analyzePage extends StatefulWidget {
  const analyzePage({super.key});

  @override
  State<analyzePage> createState() => _analyzePageState();
}

@override
State<analyzePage> createState() => _analyzePageState();

class _analyzePageState extends State<analyzePage> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: kc2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width),
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kc2,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff0000FF),
                                Color.fromARGB(255, 0, 102, 255),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Total Orders",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kc3),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.shopping_cart,
                                      color: Colors.white),
                                  SizedBox(width: 5),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('orders')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();

                                      int totalOrders =
                                          snapshot.data!.docs.length;

                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(totalOrders.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          SizedBox(width: 10),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kc2,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff0000FF),
                                Color.fromARGB(255, 0, 102, 255),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Waiting Orders",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kc3),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.hourglass_bottom,
                                      color: Colors.white),
                                  SizedBox(width: 5),
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('orders')
                                          .where('status', isEqualTo: 'waiting')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return CircularProgressIndicator();
                                        int waitingOrders =
                                            snapshot.data!.docs.length;

                                        return Text(waitingOrders.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20));
                                      }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kc2,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff0000FF),
                                Color.fromARGB(255, 0, 102, 255),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Watched Orders",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kc3)),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Icon(Icons.remove_red_eye_rounded,
                                      color: Colors.white),
                                  SizedBox(width: 5),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('orders')
                                        .where('status', isEqualTo: 'watched')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();
                                      int watchedOrders =
                                          snapshot.data!.docs.length;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(watchedOrders.toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)),
                                          SizedBox(width: 10),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RevenueContainer(),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),

            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kc2,
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0000FF),
                    Color.fromARGB(255, 0, 102, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'Sales chart',
                    style: TextStyle(fontSize: 20, color: kc3),
                  ),
                  SizedBox(height: 10),

                  // Define the chart
                  SizedBox(
                    height: 300,
                    child: OrdersChartWidget(),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kc2,
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0000FF),
                    Color.fromARGB(255, 0, 102, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'Movies',
                    style: TextStyle(fontSize: 20, color: kc3),
                  ),
                  SizedBox(height: 10),

                  // Define the chart
                  SizedBox(
                    height: 400,
                    child: TopEarningMoviesWidget(),
                  ), 
                ],
              ),
            ),

         
               
               
               

//Call chart here

            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: kc2,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff0000FF),
                          Color.fromARGB(255, 0, 102, 255),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [UserListScreen()],
                    ),
                  ),
                ],
              ),
            ), 
          ],
        ),
      ),
    );
  }
}
