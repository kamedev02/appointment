import 'dart:io';
import 'package:appointment/resources/auth_methods.dart';
import 'package:appointment/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatRoomScreen extends StatelessWidget {
  ChatRoomScreen({Key? key, required this.roomId, required this.userMap})
      : super(key: key);

  final String roomId;
  final Map<String, dynamic> userMap;

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthMethods _auth = AuthMethods();

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    int status = 1;
    String fileName = Uuid().v1();

    await _firestore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .doc(fileName)
        .set({
      'sendBy': _auth.user.displayName,
      'message': "",
      'type': 'img',
      'time': FieldValue.serverTimestamp()
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await _firestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .doc(fileName)
          .update({'message': imageUrl});
      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isEmpty) {
      print("Message is empty");
      return;
    }
    Map<String, dynamic> messages = {
      'sendBy': _auth.user.displayName,
      'message': _message.text,
      'type': 'text',
      'time': FieldValue.serverTimestamp()
    };
    await _firestore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .add(messages);
    _message.clear();
    print('Message sent');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(userMap['username']),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: size.height / 1.25,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(roomId)
                      .collection('chats')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return messages(size, map, context);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                )),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 16,
                width: size.width / 1.1,
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _message,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.image),
                          color: backgroundColor,
                          onPressed: () => getImage(),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: backgroundColor,
                    onPressed: onSendMessage,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      //
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == 'text'
        ? Container(
            width: size.width,
            alignment: map['sendBy'] == _auth.user.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: map['sendBy'] == _auth.user.displayName
                    ? backgroundColor
                    : Colors.grey,
              ),
              child: Text(
                map['message'],
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ))
        : Container(
            height: size.height * 0.3,
            width: size.width,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            alignment: map['sendBy'] == _auth.user.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowImage(imageUrl: map['message']))),
              child: Container(
                alignment: map["message"] != "" ? null : Alignment.center,
                decoration: BoxDecoration(border: Border.all()),
                height: size.height * 0.3,
                width: size.width * 0.4,
                child: map["message"] != ""
                    ? Image.network(
                        map["message"],
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
              ),
            ));
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;
  const ShowImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
