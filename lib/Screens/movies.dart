import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';



class Movies extends StatefulWidget {
  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  static _MoviesState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MoviesState>();
  late List<Movie> _movies;
late File? _pickedImage;

  Future<void> _updateMovie(Movie movie, String id) async {
    try { print('This is movie id ${movie.title}');
      await FirebaseFirestore.instance.collection('movies').doc(id).update({

       
        'title': movie.title,
        'description': movie.description,
        'rate': movie.rate,
        'price': movie.price,
        'startDateTime': movie.startDate,
        'endDateTime': movie.endDate,
        'coverUrl': movie.coverUrl,
      });
      final index = _movies.indexWhere((element) => element.id == id);
      if (index >= 0) {
        _movies[index] = _movies[index].copyWith(
          title: movie.title,
          description: movie.description,
          rate: movie.rate,
          price: movie.price,
          startDate: movie.startDate,
          endDate: movie.endDate,
          coverUrl: movie.coverUrl,
        );

        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  void _showEditDialog(BuildContext context, Movie movie) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final picker = ImagePicker();
    String movieid = movie.id;

    String title = movie.title;
    String coverUrl = movie.coverUrl;
    String description = movie.description;
    double rate = movie.rate;
    double price = movie.price;
    DateTime startDate = movie.startDate;
    DateTime endDate = movie.endDate;

    TextEditingController? titleController;
    TextEditingController? descriptionController;
    TextEditingController? rateController;
    TextEditingController? priceController;
    TextEditingController? startDateTimeController;
    TextEditingController? endDateTimeController;

    FocusNode? titleFocusNode;
    FocusNode? descriptionFocusNode;
    FocusNode? rateFocusNode;
    FocusNode? priceFocusNode;
    FocusNode? startDateTimeFocusNode;
    FocusNode? endDateTimeFocusNode;

    bool isLoading = false;

    titleController = TextEditingController(text: title);
    descriptionController = TextEditingController(text: description);
    rateController = TextEditingController(text: rate.toString());
    priceController = TextEditingController(text: price.toString());
    startDateTimeController = TextEditingController(
        text: DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate));
    endDateTimeController = TextEditingController(
        text: DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate));

    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    rateFocusNode = FocusNode();
    priceFocusNode = FocusNode();
    startDateTimeFocusNode = FocusNode();
    endDateTimeFocusNode = FocusNode();

   Widget _buildCoverImage() {
  if (coverUrl != null) {
    return Image.network(coverUrl);
  } else if (_pickedImage != null) {
    return Image.file(_pickedImage!);
  } else {
    return const Placeholder();
  }
}
Future<void> _uploadCoverImage() async {
  final pickedFile = await picker.getImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      isLoading = true;
    });
    final file = File(pickedFile.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}';
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('movie_covers')
        .child(fileName);
    final uploadTask = firebaseStorageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      coverUrl = downloadUrl;
      isLoading = false;
      _pickedImage = file; // set _pickedImage to the selected file
    });
  }
}

    Widget _buildCoverImageWidget(BuildContext context) {
      return Stack(
        children: [
          ElevatedButton(
                        onPressed: _uploadCoverImage,
                        style: ElevatedButton.styleFrom(
                          primary: kc2,
                        ),
                        child: Text(
                          'Pick Image',
                        ),
                      ),
        ],
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit movie'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                _buildCoverImageWidget(context),
                TextFormField(
                  controller: titleController,
                  focusNode: titleFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  onFieldSubmitted: (_) {
                    titleFocusNode!.unfocus();
                    FocusScope.of(context).requestFocus(titleFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  focusNode: descriptionFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  onFieldSubmitted: (_) {
                    descriptionFocusNode!.unfocus();
                    FocusScope.of(context).requestFocus(rateFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: rateController,
                  focusNode: rateFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Rate',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')),
                  ],
                  onFieldSubmitted: (_) {
                    rateFocusNode!.unfocus();
                    FocusScope.of(context).requestFocus(priceFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Rate is required';
                    }
                    final rate = double.tryParse(value);
                    if (rate == null || rate < 0 || rate > 10) {
                      return 'Rate should be between 0 and 10';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  focusNode: priceFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final int? parsed = int.tryParse(newValue.text);
                      if (parsed != null && parsed > 1000000) {
                        return oldValue;
                      } else {
                        return newValue;
                      }
                    }),
                  ],
                  onFieldSubmitted: (_) {
                    priceFocusNode!.unfocus();
                    FocusScope.of(context).requestFocus(startDateTimeFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Price is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: startDateTimeController,
                  focusNode: startDateTimeFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Start Date Time',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: startDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(startDate),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          startDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          startDateTimeController!.text = startDate.toString();
                        });
                      }
                    }
                  },
                  validator: (value) {
                    if (startDate == null) {
                      return 'Start Date Time is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: endDateTimeController,
                  focusNode: endDateTimeFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'End Date Time',
                  ),
                  readOnly: true,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: endDate,
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (selectedDate != null) {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(endDate),
                      );
                      if (selectedTime != null) {
                        setState(() {
                          endDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                          endDateTimeController!.text = endDate.toString();
                        });
                      }
                    }
                  },
                  validator: (value) {
                    if (endDate == null) {
                      return 'End Date Time is required';
                    }
                    if (startDate != null && endDate.isBefore(startDate)) {
                      return 'End Date Time must be after Start Date Time';
                    }
                    return null;
                  },
                ),
              ]),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final editedMovie = movie.copyWith(
                    title: titleController!.text,
                    coverUrl: coverUrl,
                    description: descriptionController!.text,
                    rate: double.parse(rateController!.text),
                    price: double.parse(priceController!.text),
                    startDate: DateTime.parse(startDateTimeController!.text),
                    endDate: DateTime.parse(endDateTimeController!.text),
                  );
                  await _updateMovie(editedMovie, movieid);

                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: kc2,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('movies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final movies = snapshot.data!.docs
              .map((doc) => Movie.fromDocument(doc))
              .toList();
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Container(
                // Set the height of the container to a larger value
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Container(
                    child: ListTile(
                      leading: Image.network(
                        movie.coverUrl,
                        fit: BoxFit.fitHeight,
                      ),
                      title: Text(movie.title),
                      subtitle: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.description),
                            SizedBox(height: 8),
                            Text('Rate: ${movie.rate}'),
                            SizedBox(height: 8),
                            Text('Price: ${movie.price}'),
                            SizedBox(height: 8),
                            Text(
                                'Showtime: ${DateFormat.jm().format(movie.showtime)}'),
                            SizedBox(height: 8),
                            Text(
                                'Start Date: ${DateFormat.yMd().format(movie.startDate)}'),
                            SizedBox(height: 8),
                            Text(
                                'End Date: ${DateFormat.yMd().format(movie.endDate)}'),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditDialog(context, movie);
                              // TODO: Implement edit functionality
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('movies')
                                  .doc(movie.id)
                                  .delete();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Movie deleted successfully'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Movie {
  final String id;
  final String title;
  final String description;
  final double rate;
  final double price;
  final DateTime showtime;
  final DateTime startDate;
  final DateTime endDate;
  final String coverUrl;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.rate,
    required this.price,
    required this.showtime,
    required this.startDate,
    required this.endDate,
    required this.coverUrl,
  });

  factory Movie.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Movie(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      rate: data['rate'] != null ? data['rate'] : 1,
      price: data['price'] != null ? data['price'] : 1,
      showtime: data['startDateTime'] != null
          ? data['startDateTime'].toDate()
          : DateTime.now(),
      startDate: data['startDateTime'] != null
          ? data['startDateTime'].toDate()
          : DateTime.now(),
      endDate: data['endDateTime'] != null
          ? data['endDateTime'].toDate()
          : DateTime.now(),
      coverUrl: data['coverUrl'] ?? ' ',
    );
  }

  copyWith({
    String? id,
    String? title,
    String? description,
    double? rate,
    double? price,
    DateTime? showtime,
    DateTime? startDate,
    DateTime? endDate,
    String? coverUrl,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      rate: rate ?? this.rate,
      price: price ?? this.price,
      showtime: showtime ?? this.showtime,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }
}

