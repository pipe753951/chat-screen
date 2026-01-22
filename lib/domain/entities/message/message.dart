enum FromWho { me, other }

abstract class Message {
  final FromWho fromWho;

  Message({required this.fromWho});
}
