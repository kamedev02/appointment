import 'package:appointment/resources/auth_methods.dart';
import 'package:appointment/screens/chat/chat_screen.dart';
import 'package:appointment/screens/option.dart';
import 'package:appointment/screens/profile_screen.dart';
import 'package:appointment/utils/colors.dart';
import 'package:appointment/utils/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;
  String _appbarTitle = 'Meet';
  final List<Widget> _pageOptions = <Widget>[
    OptionScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  final List<String> _listTitle = <String>[
    'Meet',
    'Chat',
    'Profile',
  ];

  final AuthMethods _auth = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(builder: (_, model, __) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text(_appbarTitle, style: const TextStyle(color: Colors.white)),
            backgroundColor: backgroundColor,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundImage: NetworkImage(_auth.user.photoURL!)),
            ),
            actions: [
              IconButton(
                onPressed: logOut,
                icon: const Icon(Icons.logout_outlined),
                color: Colors.white,
              ),
            ],
          ),
          body: Center(
            child: _pageOptions.elementAt(_selectedPage),
          ),
          bottomNavigationBar: Container(
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: GNav(
                  color: Colors.white,
                  activeColor: Colors.white,
                  backgroundColor: backgroundColor,
                  tabBackgroundColor: tabColor,
                  gap: 20,
                  padding: const EdgeInsets.all(16.0),
                  selectedIndex: _selectedPage,
                  onTabChange: (index) {
                    setState(() {
                      _appbarTitle = _listTitle.elementAt(index);
                      _selectedPage = index;
                    });
                  },
                  tabs: const [
                    GButton(
                      icon: CupertinoIcons.video_camera_solid,
                      text: 'Meet',
                    ),
                    GButton(
                      icon: CupertinoIcons.chat_bubble_2_fill,
                      text: 'Chat',
                    ),
                    GButton(
                      icon: Icons.person,
                      text: 'Profile',
                    ),
                  ]),
            ),
          ),
        );
      }),
    );
  }

  void logOut() {
    _auth.signOut();
  }
}
