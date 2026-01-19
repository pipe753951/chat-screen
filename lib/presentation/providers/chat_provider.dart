import 'package:flutter/material.dart';

import 'package:yes_no_app/domain/domain.dart';
import 'package:yes_no_app/infrastructure/infrastructure.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final ChatRepositoryImplementation chatRepository =
      ChatRepositoryImplementation(chatDatasource: YesNoMessageDatasource());

  List<Message> messageList = [
    Message(text: 'Hola Mundo', fromWho: FromWho.me),
    Message(text: 'Estás bien?', fromWho: FromWho.me),
  ];

  Message addNewMessage(String text) {
    // Add message to local list.
    final newMessage = Message(text: text, fromWho: FromWho.me);
    messageList.add(newMessage);

    // Update state.
    notifyListeners();
    moveScrollToBottom();

    // Return new local message.
    return newMessage;
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    // Add message to state before sending it to repository.
    final Message newMessage = addNewMessage(text);

    // Send message to repository and save response to a variable
    final Message? response = await chatRepository.processMesage(newMessage);
    if (response != null) {
      messageList.add(response);
      notifyListeners();
      moveScrollToBottom();
    }
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));

    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
