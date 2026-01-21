import 'package:flutter/material.dart';

import 'package:yes_no_app/domain/domain.dart';
import 'package:yes_no_app/infrastructure/infrastructure.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final ChatRepositoryImplementation chatRepository =
      ChatRepositoryImplementation(chatDatasource: YesNoMessageDatasource());

  List<Message> messageList = [
    TextMessage(text: 'Hola Mundo', fromWho: FromWho.me),
    TextMessage(text: 'Estás bien?', fromWho: FromWho.me),
  ];

  TextMessage addNewTextMessage(String text) {
    // Add message to local list.
    final newMessage = TextMessage(text: text, fromWho: FromWho.me);
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
    final TextMessage newMessage = addNewTextMessage(text);

    // Send message to repository and save response to a variable
    final List<Message>? response = await chatRepository.processTextMessage(newMessage);
    
    if (response != null) {
      messageList.addAll(response);
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
