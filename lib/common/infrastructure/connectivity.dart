import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity.g.dart';

@Riverpod(keepAlive: true)
Stream<bool> isConnected(IsConnectedRef ref) async* {
  await for (final status in Connectivity().onConnectivityChanged) {
    yield switch (status) {
      ConnectivityResult.wifi || ConnectivityResult.mobile => true,
      _ => false,
    };
  }
}
