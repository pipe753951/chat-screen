import 'package:yes_no_app/domain/domain.dart';

abstract class ChatRepository {
  Future<Message?> processMesage(Message message);
}
