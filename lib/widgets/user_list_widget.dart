import 'package:flutter/material.dart';

import '../models/User.dart';

class UserListWidget extends StatelessWidget {
  final List<User> users;
  final bool sortAscending;

  UserListWidget({required this.users, required this.sortAscending});

  @override
  Widget build(BuildContext context) {
    // Sort the users list based on the _sortAscending flag
    users.sort((a, b) =>
        sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(users[index].photoUrl),
          ),
      title: Text(
            users[index].name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            users[index].email,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
