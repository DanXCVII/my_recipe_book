import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_book/constants/global_constants.dart' as constants;

void main() {
  test('switches to the navigation rail only above 900 dp', () {
    expect(constants.usesHomeNavigationRail(899), isFalse);
    expect(constants.usesHomeNavigationRail(900), isFalse);
    expect(constants.usesHomeNavigationRail(900.01), isTrue);
    expect(constants.usesHomeNavigationRail(1200), isTrue);
  });
}
