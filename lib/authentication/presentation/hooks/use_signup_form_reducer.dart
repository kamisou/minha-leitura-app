import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:reading/authentication/data/dtos/signup_dto.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';

Store<SignupDTO, dynamic> useSignupFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Name() => state.copyWith(name: action),
      Email() => state.copyWith(email: action),
      Password() => state.copyWith(password: action),
      PasswordConfirm() => state.copyWith(passwordConfirm: action),
      _ => state,
    },
    initialState: const SignupDTO(),
    initialAction: null,
  );
}
