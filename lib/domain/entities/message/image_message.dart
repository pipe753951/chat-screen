import 'package:yes_no_app/domain/entities/message/message.dart';

class ImageMessage extends Message {
  final String imageUrl;

  ImageMessage({required super.fromWho, required this.imageUrl});
}
