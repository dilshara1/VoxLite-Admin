import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersChartWidget extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('orders').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Order> orders = [];
          snapshot.data!.docs.forEach((doc) {
            orders.add(Order.fromSnapshot(doc));
          });
          Map<DateTime, int> ordersPerDay = {};
          orders.forEach((order) {
            DateTime date = order.orderPlaceDate.toDate();
            DateTime dateOnly = DateTime(date.year, date.month, date.day);
            if (ordersPerDay.containsKey(dateOnly)) {
              ordersPerDay[dateOnly] = ordersPerDay[dateOnly]! + 1;
            } else {
              ordersPerDay[dateOnly] = 1;
            }
          });
          List<OrderCount> data = [];
          int limit = 7; // Limit the chart to 7 bars
          int i = 0;
          ordersPerDay.forEach((date, count) {
            if (i < limit) {
              String formattedDate =
                  '${date.year.toString().substring(2)}-${date.month}-${date.day}';
              data.add(OrderCount(formattedDate, count));
              i++;
            }
          });
          return Expanded(child: SimpleBarChart(data));
        },
      ),
    );
  }
}

class SimpleBarChart extends StatelessWidget {
  final List<OrderCount> data;

  SimpleBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<dynamic, String>> seriesList = [
      charts.Series<dynamic, String>(
        id: 'orders',
        colorFn: (_, __) =>
            charts.MaterialPalette.white, // Change color to blue
        domainFn: (dynamic count, _) => count.date,
        measureFn: (dynamic count, _) => count.count,
        data: data,
        labelAccessorFn: (dynamic count, _) =>
            '${count.count}', // Show count on top of bar
        insideLabelStyleAccessorFn: (dynamic count, _) => charts.TextStyleSpec(
            fontSize: 12, color: charts.Color.fromHex(code: '#1100f8')),
        outsideLabelStyleAccessorFn: (dynamic count, _) =>
            charts.TextStyleSpec(fontSize: 12, color: charts.Color.white),
      ),
    ];
    return charts.BarChart(
      seriesList,
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelStyle:
              charts.TextStyleSpec(fontSize: 12, color: charts.Color.white),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle:
              charts.TextStyleSpec(fontSize: 12, color: charts.Color.white),
        ),
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
        ),
      ),
    );
  }
}

class Order {
  final DocumentSnapshot snapshot;

  Order.fromSnapshot(this.snapshot);

  Timestamp get orderPlaceDate => snapshot.get('OrderPlaceDate');
}

class OrderCount {
  final String date;
  final int count;

  OrderCount(this.date, this.count);
}
