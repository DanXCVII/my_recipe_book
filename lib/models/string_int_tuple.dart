import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'string_int_tuple.g.dart';

@HiveType()
class StringIntTuple extends Equatable {
  @HiveField(0)
  final String text;
  @HiveField(1)
  final int number;

  StringIntTuple({
    this.text,
    this.number,
  });

  factory StringIntTuple.fromMap(Map<String, dynamic> json) =>
      new StringIntTuple(
        text: json['text'],
        number: json['number'],
      );

  Map<String, dynamic> toMap() => {
        'text': text,
        'number': number,
      };

  @override
  List<Object> get props => [
        text,
        number,
      ];
}
