import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity.g.dart';

@Riverpod(keepAlive: true)
Stream<bool> connectivity(ConnectivityRef ref) async* {
  final connectivity = Connectivity();

  await for (final status in connectivity.onConnectivityChanged) {
    yield switch (status) {
      ConnectivityResult.wifi || ConnectivityResult.mobile => true,
      _ => false,
    };
  }
}

@riverpod
bool isConnected(IsConnectedRef ref) {
  return ref.watch(connectivityProvider).value ?? false;
}
