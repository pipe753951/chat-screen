import 'package:yes_no_app/domain/domain.dart';

abstract class ChatRepository {
  Future<List<Message>> processTextMessage(TextMessage message);
  Future<List<Message>> processVoiceMessage(VoiceMessage message);
}
