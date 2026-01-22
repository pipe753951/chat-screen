import 'package:yes_no_app/domain/entities/message/message.dart';

class TextMessage extends Message {
  final String text;

  TextMessage({required super.fromWho, required this.text});
}
