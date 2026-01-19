import 'package:yes_no_app/domain/domain.dart';

class ChatRepositoryImplementation extends ChatRepository {
  final ChatDatasource chatDatasource;

  ChatRepositoryImplementation({required this.chatDatasource});

  @override
  Future<Message?> processMesage(Message message) async {
    return await chatDatasource.processMesage(message);
  }
}
