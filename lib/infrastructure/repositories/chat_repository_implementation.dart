import 'package:yes_no_app/domain/domain.dart';

class ChatRepositoryImplementation extends ChatRepository {
  final ChatDatasource chatDatasource;

  ChatRepositoryImplementation({required this.chatDatasource});
  
  @override
  Future<List<Message>> processTextMessage(TextMessage message) {
    return chatDatasource.processTextMessage(message);
  }
  
  @override
  Future<List<Message>> processVoiceMessage(VoiceMessage message) {
    return chatDatasource.processVoiceMessage(message);
  }
}
