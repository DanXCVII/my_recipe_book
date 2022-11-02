import 'package:equatable/equatable.dart';

class Tuple2<T1, T2> extends Equatable {
  /// Returns the first item of the tuple
  final T1 item1;

  /// Returns the second item of the tuple
  final T2 item2;

  /// Creates a new tuple value with the specified items.
  const Tuple2(this.item1, this.item2);

  @override
  String toString() => '[$item1, $item2]';

  @override
  List<Object?> get props => [
        item1,
        item2,
      ];
}
