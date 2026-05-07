import 'package:flutter_test/flutter_test.dart';
import 'package:goodmall_flutter_app/main.dart';

void main() {
  testWidgets('GoodMall app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GoodMallApp());
    expect(find.text('GoodMall 原生内测版'), findsOneWidget);
  });
}
