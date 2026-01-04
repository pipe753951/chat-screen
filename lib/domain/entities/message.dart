enum FromWho { me, other }

class Message {
  final FromWho fromWho;
  final String text;
  final String? imageUrl;

  Message({required this.text, required this.fromWho, this.imageUrl});
}
