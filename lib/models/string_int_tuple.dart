import 'package:equatable/equatable.dart';

class StringIntTuple extends Equatable {
  final String text;
  final int number;

  const StringIntTuple({required this.text, required this.number});

  factory StringIntTuple.fromMap(Map<String, dynamic> json) =>
      new StringIntTuple(text: json['text'], number: json['number']);

  Map<String, dynamic> toMap() => {'text': text, 'number': number};

  @override
  List<Object> get props => [text, number];

  @override
  String toString() {
    return "text: $text, number: $number";
  }
}
