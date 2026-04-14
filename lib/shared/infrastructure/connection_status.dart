import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_status.g.dart';

@Riverpod(keepAlive: true)
class ConnectionStatus extends _$ConnectionStatus {
  final List<void Function(bool)> _callbacks = [];

  @override
  Future<bool> build() {
    final connectivity = Connectivity();

    final subscription = connectivity //
        .onConnectivityChanged //
        .listen(_onConnectivityChanged);

    ref.onDispose(subscription.cancel);

    return connectivity.checkConnectivity().then(_isConnected);
  }

  void subscribe(void Function(bool connected) callback) {
    _callbacks.add(callback);
  }

  void unsubscribe(void Function(bool connected) callback) {
    _callbacks.remove(callback);
  }

  void _onConnectivityChanged(ConnectivityResult result) {
    state = AsyncData(_isConnected(result));

    for (final callback in _callbacks) {
      callback.call(state.requireValue);
    }

    log(
      'Connection ${state.requireValue ? '' : 'un'}available',
      name: 'ConnectionStatus',
    );
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
}
