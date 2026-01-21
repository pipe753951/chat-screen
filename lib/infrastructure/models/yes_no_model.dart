// https://app.quicktype.io/
// To parse this JSON data, do
//
//     final yesNoModel = yesNoModelFromJson(jsonString);

import 'package:yes_no_app/domain/domain.dart';

class YesNoModel {
  final String answer;
  final String imageUrl;
  final bool forced;

  YesNoModel({
    required this.answer,
    required this.imageUrl,
    required this.forced,
  });

  factory YesNoModel.fromJsonMap(Map<String, dynamic> json) => YesNoModel(
    answer: json["answer"],
    imageUrl: json["image"],
    forced: json["forced"],
  );

  Map<String, dynamic> toJson() => {
    "answer": answer,
    "image": imageUrl,
    "forced": forced,
  };

  List<Message> toMessageEntity() => [
    TextMessage(text: answer == 'yes' ? 'Si' : 'No', fromWho: FromWho.other),
    ImageMessage(fromWho: FromWho.other, imageUrl: imageUrl),
  ];
}
