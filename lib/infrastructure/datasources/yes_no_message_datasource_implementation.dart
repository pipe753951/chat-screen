import 'package:dio/dio.dart';

import 'package:yes_no_app/domain/domain.dart';
import 'package:yes_no_app/infrastructure/infrastructure.dart';

class YesNoMessageDatasource extends ChatDatasource {
  final _dio = Dio();

  @override
  Future<Message?> processMesage(Message message) async {
    if (!message.text.endsWith('?')) {
      return null;
    }
    return await getAnswer();
  }

  Future<Message> getAnswer() async {
    final response = await _dio.get('https://yes-no-wtf.vercel.app/api');

    final yesNoModel = YesNoModel.fromJsonMap(response.data);

    return yesNoModel.toMessageEntity();
  }
}
