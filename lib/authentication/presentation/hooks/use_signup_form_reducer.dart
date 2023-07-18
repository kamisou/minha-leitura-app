import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:reading/authentication/data/dto/signup_dto.dart';
import 'package:reading/authentication/domain/value_objects/email.dart';
import 'package:reading/authentication/domain/value_objects/name.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';

Store<SignupDTO, dynamic> useSignupFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Name() =>
        // ignore: unused_result
        state.copyWith(name: action),
      Email() =>
        // ignore: unused_result
        state.copyWith(email: action),
      Password() =>
        // ignore: unused_result
        state.copyWith(password: action),
      PasswordConfirm() =>
        // ignore: unused_result
        state.copyWith(passwordConfirm: action),
      _ => state,
    },
    initialState: const SignupDTO(),
    initialAction: null,
  );
}
