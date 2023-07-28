import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_status.g.dart';

@riverpod
bool isConnected(IsConnectedRef ref) {
  return ref.watch(connectionStatusProvider).value ?? false;
}

@Riverpod(keepAlive: true)
class ConnectionStatus extends _$ConnectionStatus {
  @override
  Future<bool> build() {
    final connectivity = Connectivity();

    final stream = connectivity.onConnectivityChanged;
    final subscription = stream.listen(_onConnectivityChanged);

    ref.onDispose(subscription.cancel);

    return stream.first.then(_isConnected);
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    state = AsyncData(_isConnected(result));
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
}
