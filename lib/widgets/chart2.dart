import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TopEarningMoviesWidget extends StatelessWidget {
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
          // Calculate total revenue for each movie ID
          Map<String, int> movieTotals = {};
          snapshot.data!.docs.forEach((doc) {
            double? total = doc.get('total') as double?;
            String? movieID = doc.get('movieID') as String?;

            if (total != null && movieID != null) {
              if (movieTotals.containsKey(movieID)) {
                movieTotals[movieID] = movieTotals[movieID]! + total.toInt();
              } else {
                movieTotals[movieID] = total.toInt();
              }
            }
          });

          // Query movie names for each movie ID
          Future<QuerySnapshot> moviesFuture =
              firestore.collection('movies').get();
          return FutureBuilder<QuerySnapshot>(
            future: moviesFuture,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              // Build data for bar chart
              List<MovieTotal> data = [];
              movieTotals.forEach((movieID, total) {
                String movieName = '';
                snapshot.data!.docs.forEach((doc) {
                  if (doc.id == movieID && doc.get('title') != null) {
                    movieName = doc.get('title');
                  }
                });

                data.add(MovieTotal(movieName, total));
              });
              // Sort movies by total revenue
              data.sort((a, b) => b.total.compareTo(a.total));
              data = data.take(4).toList(); // Limit to top 4 earners
              return Expanded(child: SimpleBarChart(data));
            },
          );
        },
      ),
    );
  }
}class SimpleBarChart extends StatelessWidget {
  final List<MovieTotal> data;

  SimpleBarChart(this.data);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<dynamic, String>> seriesList = [
      charts.Series<dynamic, String>(
        id: 'movies',
        colorFn: (_, __) =>
            charts.MaterialPalette.white, // Change color to blue
        domainFn: (dynamic total, _) => total.movieName,
        measureFn: (dynamic total, _) => total.total,
        data: data,
        labelAccessorFn: (dynamic total, _) =>
            '\$${total.total}', // Show total on top of bar
        insideLabelStyleAccessorFn: (dynamic total, _) =>
            charts.TextStyleSpec(fontSize: 12, color: charts.Color.white),
        outsideLabelStyleAccessorFn: (dynamic total, _) =>
            charts.TextStyleSpec(fontSize: 12, color: charts.Color.white),
      )
    ];
    return charts.BarChart(
      seriesList,
      animate: true,
      barRendererDecorator: charts.BarLabelDecorator<String>(
        labelPosition: charts.BarLabelPosition.outside,
      ),
            domainAxis: charts.OrdinalAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
          labelRotation: 45, // Rotate x-axis labels for better readability
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.Color.white, // Change label color to white
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.Color.white, // Change tick line color to white
          ),
        ),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: charts.GridlineRendererSpec(
          labelStyle: charts.TextStyleSpec(
            fontSize: 12,
            color: charts.Color.white, // Change label color to white
          ),
          lineStyle: charts.LineStyleSpec(
            color: charts.Color.white, // Change gridline color to white
          ),
        ),
      ),
    );
  }
}

class MovieTotal {
  final String movieName;
  final int total;

  MovieTotal(this.movieName, this.total);
}
