import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voxliteadmin/colors.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<Orders> {
  late Stream<QuerySnapshot> _ordersStream;
  String _selectedStatus = 'waiting';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kc2,
        title: Text('Orders'),
        actions: [
          DropdownButton<String>(
            dropdownColor: kc2,
            value: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
            items: [
              DropdownMenuItem(
                value: 'waiting',
                child: Text(
                  'Waiting',
                  style: TextStyle(color: kc3),
                ),
              ),
              DropdownMenuItem(
                value: 'watched',
                child: Text('Watched', style: TextStyle(color: kc3)),
              ),
            ],
          ),
      
      
        /*   if (_selectedStatus == 'waiting')
            
            
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('orders')
                    .where('status', isEqualTo: 'waiting')
                    .get();
                final batch = FirebaseFirestore.instance.batch();
                for (final doc in querySnapshot.docs) {
                  batch.update(doc.reference, {'status': 'watched'});
                }
                await batch.commit();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected orders marked as watched'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ), */






        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Order ID',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _ordersStream,
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
                final orders = snapshot.data!.docs
                    .map((doc) => Order.fromDocument(doc))
                    .where((order) =>
                        _selectedStatus.isEmpty ||
                        order.status == _selectedStatus)
                    .where((order) => order.id.contains(_searchQuery.trim()))
                    .toList();
                return ListView.separated(
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return ListTile(
                      title: Text('Order ID: ${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User ID: ${order.userId}'),
                          SizedBox(height: 8),
                          Text('Movie ID: ${order.movieId}'),
                          SizedBox(height: 8),
                          Text('Status: ${order.status}'),
                        ],
                      ),trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedStatus != 'watched')
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(order.id)
                              .update({'status': 'watched'});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Order marked as watched'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(order.id)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order deleted successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}




class Order {
  final String id;
  final String userId;
  final String movieId;
  final DateTime selectedDate;
  final List<String> selectedSeats;
  // final DateTime selectedShowtime;
  final DateTime selectedShowtime;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.selectedDate,
    required this.selectedSeats,
    required this.selectedShowtime,
    required this.total,
    required this.status,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      userId: data['userID'] ?? '',
      movieId: data['movieID'] ?? '',
      selectedDate: data['selectedDate']?.toDate() ?? DateTime.now(),
      selectedSeats: List<String>.from(data['selectedSeats'] ?? []),
      //  selectedShowtime: data['selectedShowtime']?.toDate() ?? DateTime.now(),

      selectedShowtime: data['selectedDate']?.toDate() ?? DateTime.now(),
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? '',
    );
  }
}
















/* 
class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<Orders> {
  late Stream<QuerySnapshot> _ordersStream;
  String _selectedStatus = 'waiting';

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kc2,
        title: Text('Orders'),
        actions: [
          DropdownButton<String>(

            dropdownColor: kc2,
            value: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
            items: [
              DropdownMenuItem(
                
                value: 'waiting',
                child: Text(
                  'Waiting',style: TextStyle(color: kc3),
                ),
              ),
              DropdownMenuItem(
                value: 'watched' ,
                child: Text(
                  'Watched',style: TextStyle(color: kc3)
                ),
              ),
            ],
          ),
          if (_selectedStatus == 'waiting')
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                final querySnapshot = await FirebaseFirestore.instance
                    .collection('orders')
                    .where('status', isEqualTo: 'waiting')
                    .get();
                final batch = FirebaseFirestore.instance.batch();
                for (final doc in querySnapshot.docs) {
                  batch.update(doc.reference, {'status': 'watched'});
                }
                await batch.commit();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Selected orders marked as watched'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        
        stream: _ordersStream,
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
          final orders = snapshot.data!.docs
              .map((doc) => Order.fromDocument(doc))
              .where((order) =>
                  _selectedStatus.isEmpty || order.status == _selectedStatus)
              .toList();
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (context, index) => Divider(), 
            itemBuilder: (context, index) {
              final order = orders[index];
   
              return ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User ID: ${order.userId}'),
                    SizedBox(height: 8),
                    Text('Movie ID: ${order.movieId}'),
                    SizedBox(height: 8),
                    Text(
                        'Date: ${DateFormat('EEE, MMM d, yyyy').format(order.selectedDate)}'),
                    SizedBox(height: 8),
                    Text(
                        //  'Showtime: ${DateFormat.jm().format(order.selectedShowtime)}'),

                    'Showtime: ${DateFormat('h:mm a').format(order.selectedShowtime)}'),
                    SizedBox(height: 8),
                    Text('Seats: ${order.selectedSeats.join(', ')}'),
                    SizedBox(height: 8),
                    Text('Total: \$${order.total.toStringAsFixed(2)}'),
                    SizedBox(height: 8),
                    Text('Status: ${order.status}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedStatus != 'watched')
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('orders')
                              .doc(order.id)
                              .update({'status': 'watched'});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Order marked as watched'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(order.id)
                            .delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Order deleted successfully'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String movieId;
  final DateTime selectedDate;
  final List<String> selectedSeats;
  // final DateTime selectedShowtime;
  final DateTime selectedShowtime;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.selectedDate,
    required this.selectedSeats,
    required this.selectedShowtime,
    required this.total,
    required this.status,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      userId: data['userID'] ?? '',
      movieId: data['movieID'] ?? '',
      selectedDate: data['selectedDate']?.toDate() ?? DateTime.now(),
      selectedSeats: List<String>.from(data['selectedSeats'] ?? []),
      //  selectedShowtime: data['selectedShowtime']?.toDate() ?? DateTime.now(),

      selectedShowtime: data['selectedDate']?.toDate() ?? DateTime.now(),
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? '',
    );
  }
}



 */



















///////////////////////////////////////////
///
///
///
///
///
///
























































/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<Orders> {
  late Stream<QuerySnapshot> _ordersStream;
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          DropdownButton<String>(
            value: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
            items: [
              DropdownMenuItem(
                value: '',
                child: Text('All'),
              ),
              DropdownMenuItem(
                value: 'waiting',
                child: Text('Waiting'),
              ),
              DropdownMenuItem(
                value: 'Watched',
                child: Text('Watched'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
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
          final orders = snapshot.data!.docs
              .map((doc) => Order.fromDocument(doc))
              .where((order) =>
                  _selectedStatus.isEmpty || order.status == _selectedStatus)
              .toList();
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              return Container(
                color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                child: OrderContainer(order: order),
              );
            },
          );
        },
      ),
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String movieId;
  final DateTime selectedDate;
  final List<String> selectedSeats;
  final String selectedShowtime;
  final double total;
  final String status;
  final String userName;
  final String userEmail;
  final String movieTitle;
  final String movieCoverUrl;

  Order({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.selectedDate,
    required this.selectedSeats,
    required this.selectedShowtime,
    required this.total,
    required this.status,
    required this.userName,
    required this.userEmail,
    required this.movieTitle,
    required this.movieCoverUrl,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(data['userID'])
        .get();
    final movieDoc = FirebaseFirestore.instance
        .collection('movies')
        .doc(data['movieID'])
        .get();
    return Order(
      id: doc.id,
      userId: data['userID'] ?? '',
      movieId: data['movieID'] ?? '',
      selectedDate: data['selectedDate']?.toDate() ?? DateTime.now(),
      selectedSeats: List<String>.from(data['selectedSeats'] ?? []),
      selectedShowtime: data['selectedShowtime'] ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? '',
      userName: userDoc.then((doc) => doc['name']).toString(),
      userEmail: userDoc.then((doc) => doc['email']).toString(),
      movieTitle: movieDoc.then((doc) => doc['title']).toString(),
      movieCoverUrl: movieDoc.then((doc) => doc['coverUrl']).toString(),
    );
  }
}

class OrderContainer extends StatelessWidget {
  final Order order;

  const OrderContainer({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User: ${order.userName} (${order.userEmail})'),
              SizedBox(height: 8),
              Text('Email: (${order.userEmail})'),
              SizedBox(height: 8),
              Text('Movie: ${order.movieTitle}'),
              SizedBox(height: 8),
              Text(
                  'Date: ${DateFormat('EEE, MMM d, yyyy').format(order.selectedDate)}'),
              SizedBox(height: 8),
              Text('Showtime: ${order.selectedShowtime}'),
              SizedBox(height: 8),
              Text('Seats: ${order.selectedSeats.join(', ')}'),
              SizedBox(height: 8),
              Text('Total: ${order.total.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Status: ${order.status}'),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(order.id)
                .delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order deleted successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        if (order.status == 'Waiting')
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('orders')
                  .doc(order.id)
                  .update({'status': 'Watched'});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order status updated to Watched'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Mark as Watched'),
          ),
      ],
    );
  }
} 
 */
/* 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<Orders> {
  late Stream<QuerySnapshot> _ordersStream;
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          DropdownButton<String>(
            value: _selectedStatus,
            onChanged: (value) {
              setState(() {
                _selectedStatus = value!;
              });
            },
            items: [
              DropdownMenuItem(
                value: '',
                child: Text('All'),
              ),
              DropdownMenuItem(
                value: 'waiting',
                child: Text('Waiting'),
              ),
              DropdownMenuItem(
                value: 'Watched',
                child: Text('Watched'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
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
          final orders = snapshot.data!.docs
              .map((doc) => Order.fromDocument(doc))
              .where((order) =>
                  _selectedStatus.isEmpty || order.status == _selectedStatus)
              .toList();
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderContainer(order: order);
            },
          );
        },
      ),
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String movieId;
  final DateTime selectedDate;
  final List<String> selectedSeats;
  final String selectedShowtime;
  final double total;
  final String status;
  final String userName;
  final String userEmail;
  final String movieTitle;
  final String movieCoverUrl;

  Order({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.selectedDate,
    required this.selectedSeats,
    required this.selectedShowtime,
    required this.total,
    required this.status,
    required this.userName,
    required this.userEmail,
    required this.movieTitle,
    required this.movieCoverUrl,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(data['userID'])
        .get();
    final movieDoc = FirebaseFirestore.instance
        .collection('movies')
        .doc(data['movieID'])
        .get();
    return Order(
      id: doc.id,
      userId: data['userID'] ?? '',
      movieId: data['movieID'] ?? '',
      selectedDate: data['selectedDate']?.toDate() ?? DateTime.now(),
      selectedSeats: List<String>.from(data['selectedSeats'] ?? []),
      selectedShowtime: data['selectedShowtime'] ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? '',
      userName: userDoc.then((doc) => doc['name']).toString(),
      userEmail: userDoc.then((doc) => doc['email']).toString(),
      movieTitle: movieDoc.then((doc) => doc['title']).toString(),
      movieCoverUrl: movieDoc.then((doc) => doc['coverUrl']).toString(),
    );
  }
}

class OrderContainer extends StatelessWidget {
  final Order order;

  const OrderContainer({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User: ${order.userName} (${order.userEmail})'),
              SizedBox(height: 8),
              Text('Movie: ${order.movieTitle}'),
              SizedBox(height: 8),
              Text(
                  'Date: ${DateFormat('EEE, MMM d, yyyy').format(order.selectedDate)}'),
              SizedBox(height: 8),
              Text('Showtime: ${order.selectedShowtime}'),
              SizedBox(height: 8),
              Text('Seats: ${order.selectedSeats.join(', ')}'),
              SizedBox(height: 8),
              Text('Total: ${order.total.toStringAsFixed(2)}'),
              SizedBox(height: 8),
              Text('Status: ${order.status}'),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('orders')
                .doc(order.id)
                .delete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order deleted successfully'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        if (order.status == 'Waiting')
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('orders')
                  .doc(order.id)
                  .update({'status': 'Watched'});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order status updated to Watched'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Mark as Watched'),
          ),
      ],
    );
  }
}  */ /* 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<Orders> {
  late Stream<QuerySnapshot> _ordersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
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
          final orders = snapshot.data!.docs
              .map((doc) => Order.fromDocument(doc))
              .toList();
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User ID: ${order.userId}'),
                    SizedBox(height: 8),
                    Text('Movie ID: ${order.movieId}'),
                    SizedBox(height: 8),
                    Text(
                        'Date: ${DateFormat('EEE, MMM d, yyyy').format(order.selectedDate)}'),
                    SizedBox(height: 8),
                    Text('Showtime: ${order.selectedShowtime}'),
                    SizedBox(height: 8),
                    Text('Seats: ${order.selectedSeats.join(', ')}'),
                    SizedBox(height: 8),
                    Text('Total: \$${order.total.toStringAsFixed(2)}'),
                    SizedBox(height: 8),
                    Text('Status: ${order.status}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(order.id)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order deleted successfully'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Order {
  final String id;
  final String userId;
  final String movieId;
  final DateTime selectedDate;
  final List<String> selectedSeats;
  final String selectedShowtime;
  final double total;
  final String status;

  Order({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.selectedDate,
    required this.selectedSeats,
    required this.selectedShowtime,
    required this.total,
    required this.status,
  });

  factory Order.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Order(
      id: doc.id,
      userId: data['userID'] ?? '',
      movieId: data['movieID'] ?? '',
      selectedDate: data['selectedDate']?.toDate() ?? DateTime.now(),
      selectedSeats: List<String>.from(data['selectedSeats'] ?? []),
      selectedShowtime: data['selectedShowtime'] ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? '',
    );
  }
}
 */