import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../colors.dart';


bool isToday(DateTime date) {
  return date.day == DateTime.now().day &&
      date.month == DateTime.now().month &&
      date.year == DateTime.now().year;
}

bool isLast7Days(DateTime date) {
  final now = DateTime.now();
  final lastWeek = now.subtract(Duration(days: 7));
  return date.isAfter(lastWeek) && date.isBefore(now);
}

bool isCurrentMonth(DateTime date) {
  final now = DateTime.now();
  return date.month == now.month && date.year == now.year;
}








class RevenueContainer extends StatefulWidget {
  @override
  _RevenueContainerState createState() => _RevenueContainerState();
}

class _RevenueContainerState extends State<RevenueContainer> {
  String _dateFilter = 'Today'; // default filter value
  DateTime td = DateTime.now();
  void _updateFilter(String? value) {
    setState(() {
      _dateFilter = value ?? 'Today';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 20),
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
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Revenue",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kc3,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.attach_money, color: Colors.white),
                        SizedBox(width: 5),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
                            double revenue = 0;
                            snapshot.data!.docs.forEach((doc) {
                              if (_dateFilter == 'Today') {
                                if (_dateFilter == 'Today' &&
                                    isToday(doc['OrderPlaceDate'].toDate())) {
                                  revenue += doc['total'] as double;
                                }
                              } else if (_dateFilter == '7 Days') {
                                if (isLast7Days(doc['OrderPlaceDate'].toDate())) {
                                  revenue += doc['total'] as double;
                                }
                              } else if (_dateFilter == 'Month') {
                                if (isCurrentMonth(
                                    doc['OrderPlaceDate'].toDate())) {
                                  revenue += doc['total'] as double;
                                }
                              } else {
                                revenue += doc['total'] as double;
                              }
                            });

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('$revenue',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
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
              SizedBox(height: 20),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter by:',
                      style: TextStyle(fontSize: 16,color: kc3),
                      
                    ),
                    DropdownButton<String>(
                      value: _dateFilter,
                      dropdownColor: kc2,
                      items: [
                        DropdownMenuItem<String>(
                          child: Text('Today' ,style: TextStyle(color: kc3) ),
                          value: 'Today',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('7 Days' ,style: TextStyle(color: kc3)),
                          value: '7 Days',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('Month' ,style: TextStyle(color: kc3)),
                          value: 'Month',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('All Time' ,style: TextStyle(color: kc3)),
                          value: 'All Time',
                        ),
                      ],
                      onChanged: _updateFilter,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

