import 'package:dio/dio.dart';

import 'package:yes_no_app/domain/domain.dart';
import 'package:yes_no_app/infrastructure/infrastructure.dart';

class YesNoMessageDatasource extends ChatDatasource {
  final _dio = Dio();

  @override
  Future<List<Message>> processTextMessage(TextMessage message) async {
    if (!message.text.endsWith('?')) {
      return [];
    }
    return await getAnswer();
  }

  Future<List<Message>> getAnswer() async {
    final response = await _dio.get('https://yes-no-wtf.vercel.app/api');

    final yesNoModel = YesNoModel.fromJsonMap(response.data);

    return yesNoModel.toMessageEntity();
  }
  
  @override
  Future<List<Message>> processVoiceMessage(VoiceMessage message) {
    // TODO: implement processVoiceMesage
    throw UnimplementedError();
  }
}
