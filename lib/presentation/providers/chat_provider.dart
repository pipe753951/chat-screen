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
    // Test voice messages
    // TODO: Impleent voice messages location
    VoiceMessage(fromWho: FromWho.me, location: 'location'),
    VoiceMessage(fromWho: FromWho.other, location: 'location'),
  ];

  /// add a new [TextMessage]
  void addNewTextMessage(TextMessage message) {
    // Add message to local list.
    messageList.add(message);

    // Update state.
    notifyListeners();
    moveScrollToBottom();
  }

  /// add a new [VoiceMessage]
  VoiceMessage addNewVoiceMessage(String path) {
    // Add message to local list.
    final newVoiceMessage = VoiceMessage(location: path, fromWho: FromWho.me);
    messageList.add(newVoiceMessage);

    // Update state.
    notifyListeners();
    moveScrollToBottom();

    // Return new local message.
    return newVoiceMessage;
  }

  /// Create send a new [TextMessage] from [String].
  Future<void> sendTextMessage(TextMessage message) async {
    if (message.text.isEmpty) return;

    // Add message to state before sending it to repository.
    addNewTextMessage(message);

    // Send message to repository and save response to a variable
    final List<Message>? response = await chatRepository.processTextMessage(
      message,
    );

    if (response != null) {
      messageList.addAll(response);
      notifyListeners();
      moveScrollToBottom();
    }
  }

  Future<void> sendVoiceMessage(VoiceMessage voiceMessage) async {
    // Send message to repository to process it.
    final List<Message>? response = await chatRepository.processVoiceMessage(
      voiceMessage,
    );
    
    if (response != null) {
      // Add response messages to list
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
