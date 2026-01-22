import 'package:yes_no_app/domain/entities/message/message.dart';

class VoiceMessage extends Message {
  final String location;

  VoiceMessage({required super.fromWho, required this.location});
}
