import 'package:flutter/foundation.dart';

class MovieOrder {
  final String userName;
  final String userEmail;
  final String movieTitle;
  final DateTime selectedDate;
  final List<String> selectedSeats;
  final DateTime selectedShowtime;
  final double total;
  final String orderDocID;
  final String status;

  MovieOrder({
    required this.userName,
    required this.userEmail,
    required this.movieTitle,
    required this.selectedDate,
    required this.selectedSeats,
    required this.selectedShowtime,
    required this.total,
    required this.orderDocID,
    required this.status,
  });
}
