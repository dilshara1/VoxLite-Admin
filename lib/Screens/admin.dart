import 'package:flutter/material.dart';
import '../colors.dart';
import 'add.dart';
import 'orders.dart';
import 'package:voxliteadmin/Screens/orders.dart';
import 'movies.dart';
import 'analyze.dart';




class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [     Orders(),     Movies(),     AddMoviePage(),     analyzePage(),  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kc2,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kc2,
        fixedColor: kc3,
        currentIndex: _currentIndex,
        onTap: (int index) {
          if (_currentIndex == index) return; // return early if the same button is clicked more than once
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: kc2,
            icon: Icon(Icons.shopping_cart, color: kc3),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie, color: kc3),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add , color: kc3),
            label: 'Add',
          ), 
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded, color: kc3),
            label: 'analyze',
          ),
        ],
      ),
    );
  }
}









/* 
class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
     Orders(),
     Movies(),
    AddMoviePage(),
     analyzePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: kc2,

      body: _pages[_currentIndex],

      
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor: kc2,
        fixedColor:kc3,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
   
          BottomNavigationBarItem(
            backgroundColor: kc2,
            icon: Icon(Icons.shopping_cart, color: kc3),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie, color: kc3),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add , color: kc3),
            label: 'Add',
          ), BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded, color: kc3),
            label: 'analyze',
          ),
        ],
      ),
    );
  }
} */
/* 
class MoviesPage extends StatelessWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies Page',),
      ),
      body: Center(
        child: Text('Movies Page'),
      ),
    );
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Page'),
      ),
      body: Center(
        child: Text('Order Page'),
      ),
    );
  }
}

class AddPage extends StatelessWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Page'),
      ),
      body: Center(
        child: Text('Add Page'),
      ),
    );
  }
}


class analyze  extends StatelessWidget {
  const analyze ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('analyze Page'),
      ),
      body: Center(
        child: Text('analyze Page'),
      ),
    );
  }
}
  */