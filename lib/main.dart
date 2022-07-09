import 'package:appointment/resources/auth_methods.dart';
import 'package:appointment/screens/home_screen.dart';
import 'package:appointment/screens/login_screen.dart';
import 'package:appointment/screens/meet/history_meeting_screen.dart';
import 'package:appointment/screens/meet/videocall_screen.dart';
import 'package:appointment/utils/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(builder: (context, model, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Appointment',
            themeMode: ThemeMode.system,
            routes: {
              '/login': (context) => const LoginScreen(),
              '/home': (context) => const HomeScreen(),
              '/video-call': (context) => const VideoCallScreen(),
              '/history': (context) => const HistoryMeetingScreen(),
            },
            home: StreamBuilder(
              stream: AuthMethods().authChanges,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return const HomeScreen();
                }
                return const LoginScreen();
              },
            ),
          );
        }));
  }
}
