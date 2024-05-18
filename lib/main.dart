import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'TranslateScreen.dart';
import 'TranslateScreen1.dart';
import 'TranslateScreen2.dart';
import 'TranslateScreen3.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  //   await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //         apiKey: "AIzaSyB8l_5gclg2EqpxEns3WgVzcw7fqscr7Is",
  //         authDomain: "video-app-9a046.firebaseapp.com",
  //         projectId: "video-app-9a046",
  //         storageBucket: "video-app-9a046.appspot.com",
  //         messagingSenderId: "114285128020",
  //         appId: "1:114285128020:web:567186974e1d995fbf00c1",
  //         measurementId: "G-XZ652D26J4"),
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Translate',
      theme: ThemeData(
        brightness: Brightness.dark, // Set brightness to dark
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TranslateScreen(),
    TranslateScreen1(),
    TranslateScreen2(),
    TranslateScreen3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Add functionality to navigate to profile screen
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu'),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Tamil'),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.segment_outlined),
              title: const Text('Japan'),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark_add),
              title: const Text('German'),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Hindi'),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            
          ],
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}
