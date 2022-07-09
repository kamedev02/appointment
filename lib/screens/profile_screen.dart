import 'package:appointment/resources/auth_methods.dart';
import 'package:appointment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthMethods _auth = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            children: [
              ClipOval(
                child: Material(
                  child: Image.network(
                    _auth.user.photoURL.toString(),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(_auth.user.displayName.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
              Text(_auth.user.email.toString(),
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
  }
}
