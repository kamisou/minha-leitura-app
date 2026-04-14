import 'package:reading/shared/infrastructure/connection_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_status.g.dart';

@riverpod
bool isConnected(IsConnectedRef ref) {
  return ref.watch(connectionStatusProvider).value ?? false;
}
