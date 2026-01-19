import 'package:yes_no_app/domain/entities/message.dart';

abstract class ChatDatasource {
  Future<Message?> processMesage(Message message);
}
