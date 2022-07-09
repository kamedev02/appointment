import 'package:appointment/resources/firestore_methods.dart';
import 'package:appointment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HistoryMeetingScreen extends StatelessWidget {
  const HistoryMeetingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Meeting'),
        backgroundColor: backgroundColor,
      ),
      body: StreamBuilder(
          stream: FirestoreMethods().meetingHistory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: (snapshot.data! as dynamic).docs.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: ListTile(
                    tileColor: Colors.black12,
                    title: Text(
                        'Room ID: ${(snapshot.data! as dynamic).docs[index]['meetingName']}'),
                    subtitle: Text(
                        'Joined on: ${(snapshot.data! as dynamic).docs[index]['createdAt'].toDate()}'),
                  ),
                ),
              );
            }
            return const Center(child: Text('No captured meeting'));
          }),
    );
  }
}
