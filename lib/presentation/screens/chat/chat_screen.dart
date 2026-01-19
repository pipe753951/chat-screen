import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/domain/entities/message.dart';

import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/screens/shared/message_field.dart';
import 'package:yes_no_app/presentation/widgets/chat/first_person_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/second_person_message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(6.0),
          child: CircleAvatar(
            // Photo by Khanh Do - Unsplash
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1764072565527-a079ac59853d?ixlib=rb-4.1.0&q=85&fm=jpg&crop=entropy&cs=srgb&w=640',
            ),
          ),
        ),
        title: const Text('Usuario'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorScheme.surface,
          systemNavigationBarColor: colorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark
        ),
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      // left: false,
      // right: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: chatProvider.chatScrollController,
                itemCount: chatProvider.messageList.length,
                itemBuilder: (context, index) {
                  final message = chatProvider.messageList[index];

                  return message.fromWho == FromWho.other
                      ? SecondPersonMessageBubble(message: message)
                      : FirstPersonMessageBubble(message: message);
                },
              ),
            ),

            // Caja de texto de mensajes
            MessageField(
              // onValue: (value) => chatProvider.sendMessage(value),
              onValue: chatProvider.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
