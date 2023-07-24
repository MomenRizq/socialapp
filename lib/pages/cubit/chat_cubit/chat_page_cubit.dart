import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:socialapp/models/message.dart';

import '../../../constants.dart';

part 'chat_page_state.dart';

class ChatPageCubit extends Cubit<ChatPageState> {
  ChatPageCubit() : super(ChatPageInitial());
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollections);
  List<Message> messagesList = [];

  void sendMessage({required String mesaage, required String email}) {
    messages
        .add({kMessage: mesaage, kCreatedAt: DateTime.now(), "email": email})
        .then((value) => print("message Added"))
        .catchError((error) => print("Failed to add message: $error"));
  }

  void getMessage() {

    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      print("Success");
      for(var doc in event.docs)
      {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatPageSuccess(messages: messagesList));
     });
  }
}
