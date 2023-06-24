import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:socialapp/widgets/customChatBuble.dart';

import '../constants.dart';
import '../models/message.dart';

class chatPage extends StatelessWidget {
  static String id = "chatPage";

  CollectionReference messages =
  FirebaseFirestore.instance.collection(kMessagesCollections);
  TextEditingController controller = TextEditingController();
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var email  = ModalRoute.of(context)!.settings.arguments ;
   return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar:AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).primaryColor,
              title: Text('chat app'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return messagesList[index].email == email ?  customChatBuble(
                          message: messagesList[index],
                        ) : ChatBubleForFriend(message: messagesList[index]);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Send Message',
                      suffixIcon: IconButton(
                        icon :Icon(Icons.send),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          messages.add({
                            kMessage: controller.text,
                            kCreatedAt: DateTime.now(),
                            "email" : email
                          }).then((value) => print("message Added")).catchError((error) => print("Failed to add message: $error"));
                          print(controller.text);
                          controller.clear();
                          _controller.animateTo(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(body: ModalProgressHUD(inAsyncCall : false,
            child: Center(child: Text("isloading")),));
        }
      },
    );
  }
}
