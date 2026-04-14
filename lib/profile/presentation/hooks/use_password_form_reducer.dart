import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/profile/data/dtos/password_change_dto.dart';

Store<PasswordChangeDTO, dynamic> usePasswordFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      <String, Password>{'old': Password()} =>
        state.copyWith(oldPassword: action['old']),
      <String, Password>{'new': Password()} =>
        state.copyWith(newPassword: action['new']),
      PasswordConfirm() => state.copyWith(passwordConfirm: action),
      _ => state,
    },
    initialState: const PasswordChangeDTO(),
    initialAction: null,
  );
}
