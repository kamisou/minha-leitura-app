import 'package:flutter_hooks/flutter_hooks.dart';

import '../../data/dto/login_dto.dart';
import '../../domain/value_objects/email.dart';
import '../../domain/value_objects/password.dart';

Store<LoginDTO, dynamic> useLoginFormReducer() {
  return useReducer(
    (state, action) => switch (action) {
      Email() =>
        // ignore: unused_result
        state.copyWith(email: action),
      Password() =>
        // ignore: unused_result
        state.copyWith(password: action),
      _ => state,
    },
    initialState: const LoginDTO(),
    initialAction: null,
  );
}
