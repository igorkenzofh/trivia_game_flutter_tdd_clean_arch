import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:trivia_tdd_app/core/network/network_info.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  NetWorkInfoImpl netWorkInfoImpl;
  MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    netWorkInfoImpl = NetWorkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () {
    // o teste seria assim:
    // test('should forward the call to InternetConnectionChecker().hasConnection',
    //     () async {
    //
    //   when(mockInternetConnectionChecker.hasConnection)
    //       .thenAnswer((_) async => true);
    //
    //   final result = await netWorkInfoImpl.isConnected;
    //
    //   verify(mockInternetConnectionChecker.hasConnection);
    //   expect(result, true);
    // });
    // Porém,o teste poderia ser burlado se isConnected retornasse sempre true, portanto faremos assim:

    test('should forward the call to InternetConnectionChecker().hasConnection',
        () async {
      final tHasConnectionFuture = Future.value(true);
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);

      final result = netWorkInfoImpl.isConnected;

      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
