// TOKEN -  c_Ot9giORsqU5H5baumfcf:APA91bHe9eCHrjjq3ESMXSc6CM7MH1d6oB01mnrL35ShutTSim5d-_66NiC68cpUwu0MJs5vrr-EhlvGxAW5XcLdUsZ_p6Par3-UfFdd44mUrs1ybeWPMYqOn0PC_UKPtIwAp50Gm1uQ

import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../colors.dart';

class AddMoviePage extends StatefulWidget {
  @override
  _AddMoviePageState createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? title;
  String? description;
  double? rate;
  double? price;
  DateTime? startDateTime; // initialize to null
  DateTime? endDateTime; // initialize to null
  File? imageFile;

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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    rateController = TextEditingController();
    priceController = TextEditingController();
    startDateTimeController = TextEditingController();

    endDateTimeController = TextEditingController();


    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    rateFocusNode = FocusNode();
    priceFocusNode = FocusNode();
    startDateTimeFocusNode = FocusNode();
    endDateTimeFocusNode = FocusNode();
  }

  @override
  void dispose() {
    titleController!.dispose();
    descriptionController?.dispose();
    rateController!.dispose();
    priceController!.dispose();
    startDateTimeController!.dispose();
    endDateTimeController!.dispose();

    titleFocusNode!.dispose();
    descriptionFocusNode!.dispose();
    rateFocusNode!.dispose();
    priceFocusNode!.dispose();
    startDateTimeFocusNode!.dispose();
    endDateTimeFocusNode!.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> uploadImage() async {
    final storage = FirebaseStorage.instance;
    final ref = storage
        .ref()
        .child('movie_covers/${DateTime.now().millisecondsSinceEpoch}');

    // Convert the image to PNG format
    final imageBytes = await imageFile!.readAsBytes();
    final image = img.decodeImage(imageBytes);
    final pngBytes = img.encodePng(image!);
    final pngFile = File('${imageFile!.path}.png');
    await pngFile.writeAsBytes(pngBytes);

    final uploadTask = ref.putFile(pngFile);
    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addMovie() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select an image'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });
    _formKey.currentState!.save();
    final downloadUrl = await uploadImage();
    final movieData = {
      'title': title,
      'description': description,
      'rate': rate,
      'price': price,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'coverUrl': downloadUrl,
    };
    await FirebaseFirestore.instance.collection('movies').add(movieData);
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Movie added successfully'),
        duration: Duration(seconds: 2),
      ),
    );
    
    
// TOKEN IS BELOW
    final message = {
      'notification': {
        'title': 'New Movie Published',
        'body': '$title - $description. Book your seat now!',
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'coverUrl': downloadUrl,
      },
      'registration_ids': [
        'eNFBHwViSWK6jCrVEd0f9n:APA91bEWewSjW2RVAR6ggNymK9uwju0x1FIvAjx553FP2ABVz_ZVM2rmO-ocRtuW_VfxyeFq5V8sHMezflv-hpVZlGq3De31f7zpamVGvW4bqbkR5NnHrmnr1OWvxm9dj4v5C9j1d7Ey'
      ],
    };

//server key below

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAA8FExc5M:APA91bFvNyZ4zyTRe8yfw4roX60igAZ-A2bGwmNYEbB87RJA9spPt98QXNeO1hDtISB6POr09wTTnc6Ho5ZQhhFpuMbFitoYdu48on6JwiMBmqI6vk56OHXLoNXwBjlYvDzKHg-puq0b',
      },
      body: jsonEncode(message),
    );
    print('here is output  ${response.body}');
  print('here is url  ${downloadUrl}'); 
  }

















  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kc2,
        title: Text('Add Movie'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (imageFile != null)
                        Image.file(
                          imageFile!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: pickImage,
                        style: ElevatedButton.styleFrom(
                          primary: kc2,
                        ),
                        child: Text(
                          'Pick Image',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: titleController,
                        focusNode: titleFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          titleFocusNode!.unfocus();
                          descriptionFocusNode!.requestFocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'New Movie Showing Now';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          title = value;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        focusNode: descriptionFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          descriptionFocusNode!.unfocus();
                          rateFocusNode!.requestFocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          description = value;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: rateController,
                        focusNode: rateFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Rate',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          rateFocusNode!.unfocus();
                          priceFocusNode!.requestFocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a rate';
                          }
                          final rate = double.tryParse(value);
                          if (rate == null || rate < 0) {
                            return 'Please enter a valid rate';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          rate = double.parse(value!);
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: priceController,
                        focusNode: priceFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          priceFocusNode!.unfocus();
                          startDateTimeFocusNode!.requestFocus();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          final price = double.tryParse(value);
                          if (price == null || price < 0) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          price = double.parse(value!);
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: startDateTimeController,
                        focusNode: startDateTimeFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Start Date and Time',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date == null) {
                            return;
                          }
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time == null) {
                            return;
                          }
                          final dateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          setState(() {
                            startDateTime = dateTime;
                            startDateTimeController!.text = dateTime.toString();
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select a start date and time';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                     
                     
                      TextFormField(
                        controller: endDateTimeController,
                        focusNode: endDateTimeFocusNode,
                        decoration: InputDecoration(
                          labelText: 'End Date and Time',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date == null) {
                            return;
                          }
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time == null) {
                            return;
                          }
                          final dateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                          setState(() {
                            endDateTime = dateTime;
                            endDateTimeController!.text = dateTime.toString();
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please select an end date and time';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: addMovie,
                        child: Text('Add Movie'),  style: ElevatedButton.styleFrom(
                          primary: kc2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
