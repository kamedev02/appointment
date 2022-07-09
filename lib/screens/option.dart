import 'dart:math';

import 'package:appointment/resources/jitsi_meet_methods.dart';
import 'package:appointment/widgets/home_meeting_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class OptionScreen extends StatelessWidget {
  OptionScreen({Key? key}) : super(key: key);

  final JitsiMeetMethods _jitsiMeetMethods = JitsiMeetMethods();

  newMeeting() async {
    var random = Random();
    String roomName = (random.nextInt(10000000) + 1000000).toString();
    _jitsiMeetMethods.createMeeting(
        roomName: roomName, isVideoMuted: false, isAudioMuted: false);
  }

  joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/video-call');
  }

  navHistory(BuildContext context) {
    Navigator.pushNamed(context, '/history');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              HomeMeetingButton(
                  onPressed: newMeeting,
                  icon: Icons.videocam,
                  text: 'New meeting'),
              HomeMeetingButton(
                  onPressed: () => joinMeeting(context),
                  icon: Icons.add_box_rounded,
                  text: 'Join meeting'),
              HomeMeetingButton(
                  onPressed: () => navHistory(context),
                  icon: Icons.history,
                  text: 'History'),
            ],
          ),
          const Expanded(
              child: Center(
                  child: Text(
            "Create/Join meeting with just a tap!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ))),
        ],
      ),
    );
  }
}
