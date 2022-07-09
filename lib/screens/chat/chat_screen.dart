import 'package:appointment/resources/auth_methods.dart';
import 'package:appointment/screens/chat/chat_room_screen.dart';
import 'package:appointment/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthMethods _auth = AuthMethods();
  final TextEditingController _search = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>>? userMap;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  String getLastMessage(String mainString, String subString) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var query = _firestore.collection('chatroom');
    query.doc(mainString).collection('chats').get().then((value) {
      if (value.docs.isNotEmpty) {
        //print("has data" + value.docs.last.data()['message']);
        if (value.docs[0].data()['type'] == 'text') {
          //print(value.docs[2].data()['message'].length);
          if (value.docs[0].data()['message'].length > 25) {
            return value.docs[0].data()['message'].substring(0, 25) + '...';
          }
          return value.docs[0].data()['message'] + '...';
        }
        return 'Image';
      } else {
        print("no data");
      }
    });
    return "Not found";
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var query = _firestore.collection('users');
    if (_search.text.isEmpty) {
      await query
          .where('uid', isNotEqualTo: _auth.user.uid)
          .get()
          .then((value) {
        setState(() {
          userMap = value.docs;
        });
      });
      Fluttertoast.showToast(
          msg: "Input to search please!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: fillColor,
          textColor: Colors.black,
          fontSize: 14.0);
    } else {
      await query
          .where('username', isGreaterThanOrEqualTo: _search.text)
          .get()
          .then((value) {
        //print(value.docs[1].data()['username']);
        if (value.docs.isEmpty) {
          Fluttertoast.showToast(
              msg: "Not found!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: fillColor,
              textColor: Colors.black,
              fontSize: 14.0);
          return;
        }
        setState(() {
          userMap = value.docs;
        });
        //print(userMap![1].data()['username']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initState() {
      super.initState();
      onSearch();
    }

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black12,
              //     blurRadius: 10,
              //     offset: Offset(0, 10),
              //   ),
              // ],
            ),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.unfocus();
                onSearch();
              },
            ),
          ),
          const SizedBox(height: 20),
          Column(children: [
            userMap == null
                ? Container(
                    height: size.height / 1.1,
                    width: size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('users')
                          .where('uid', isNotEqualTo: _auth.user.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              //print(snapshot.data!.docs[index].data());
                              Map<String, dynamic> map =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              // print(getLastMessage(
                              //     chatRoomId(_auth.user.uid, map['uid']),
                              //     _auth.user.uid));
                              // print(map);
                              // getLastMessage(chatRoomId(_auth.user.uid, map['uid']),
                              //     _auth.user.uid);
                              //print(map);
                              String roomId = chatRoomId(
                                  _auth.user.uid.toString(),
                                  map['uid'].toString());
                              //print(roomId);
                              return userchat(
                                  map,
                                  "",
                                  () => {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (_) => ChatRoomScreen(
                                                      roomId: roomId,
                                                      userMap: map,
                                                    )))
                                      });
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                : Container(
                    height: size.height / 1.1,
                    width: size.width,
                    child: ListView.builder(
                      itemCount: userMap!.length,
                      itemBuilder: (context, index) {
                        String roomId = chatRoomId(_auth.user.uid.toString(),
                            userMap![index].data()['uid']);
                        //print(roomId);
                        return userchat(
                            userMap![index].data(),
                            "",
                            () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ChatRoomScreen(
                                            roomId: roomId,
                                            userMap: userMap![index].data(),
                                          )))
                                });
                      },
                    ),
                  )
          ]),
        ],
      ),
    ))));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

Widget userchat(
    Map<String, dynamic> map, String lastMessage, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2),
                  image: DecorationImage(
                      image: NetworkImage(map['profilePhoto']),
                      fit: BoxFit.cover)),
            ),
          ]),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              map['username'],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            Text(lastMessage),
          ],
        )
      ],
    ),
  );
}
