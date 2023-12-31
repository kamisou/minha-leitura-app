import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/authentication/data/dtos/login_dto.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/profile/domain/value_objects/email.dart';

Store<LoginDTO, dynamic> useLoginFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Email() => state.copyWith(email: action),
      Password() => state.copyWith(password: action),
      _ => state,
    },
    initialState: const LoginDTO(),
    initialAction: null,
  );
}
