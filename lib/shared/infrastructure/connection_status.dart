import 'dart:developer';

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

    final subscription = connectivity //
        .onConnectivityChanged //
        .listen(_onConnectivityChanged);

    ref.onDispose(subscription.cancel);

    return connectivity.checkConnectivity().then(_isConnected);
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    state = AsyncData(_isConnected(result));
    log(
      'Connection ${state.value! ? '' : 'un'}available',
      name: 'ConnectionStatus',
    );
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
}
