import 'package:yes_no_app/domain/domain.dart';

class LocalTestingChatDatasource extends ChatDatasource {
  @override
  Future<List<Message>> processTextMessage(TextMessage message) async {
    return [
      TextMessage(fromWho: FromWho.other, text: 'Texto Recibido')
    ];
  }

  @override
  Future<List<Message>?> processVoiceMessage(VoiceMessage message) async {
    return [
      VoiceMessage(fromWho: FromWho.other, location: message.location)
    ];
  }
}
