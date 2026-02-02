import 'package:internet_connection_checker/internet_connection_checker.dart';

// This defines the contract that the repository will trust.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  /// Returns true if there is an internet connection, false otherwise
  Future<bool> get isConnected async {
    return await connectionChecker.hasConnection;
  }
}
