import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
import '../models/User.dart';
import '../widgets/user_list_widget.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> _users = []; // Contains all the users fetched from Firebase
  bool _sortAscending = true; // Sort order flag

  @override
  void initState() {
    super.initState();
    // Fetch the users from Firebase and store them in _users list
    FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        User user = User(
          name: doc['name'],
          email: doc['email'],
          photoUrl: doc['photoUrl'],
          id: '',
        );
        setState(() {
          _users.add(user);
        });
      });
    });
  }

  void _sortUsers(bool value) {
    setState(() {
      _sortAscending = value;
      _users.sort((a, b) {
        if (_sortAscending) {
          return a.name.compareTo(b.name);
        } else {
          return b.name.compareTo(a.name);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Users',
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: kc3),
                  ),
                  PopupMenuButton(
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: Text(
                          'Sort A to Z',
                          style: TextStyle(
                            color: kc2,
                          ),
                        ),
                        value: true,
                      ),
                      PopupMenuItem(
                        child: Text(
                          'Sort Z to A',
                          style: TextStyle(
                            color: kc2,
                          ),
                        ),
                        value: false,
                      ),
                    ],
                    icon: Icon(
                      Icons.more_vert,
                      color: kc3,
                    ),
                    onSelected: _sortUsers,
                  )
                ],
              ),
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
              child:
                  UserListWidget(users: _users, sortAscending: _sortAscending),
            ),
          ],
        ),
      ),
    );
  }
}
