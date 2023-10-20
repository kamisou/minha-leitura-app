import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/authentication/domain/value_objects/password.dart';
import 'package:reading/profile/data/dtos/profile_change_dto.dart';
import 'package:reading/profile/domain/value_objects/email.dart';
import 'package:reading/profile/domain/value_objects/name.dart';

Store<ProfileChangeDTO, dynamic> useProfileFormReducer({
  ProfileChangeDTO? initialState,
}) {
  return useReducer(
    (state, action) => switch (action) {
      Name() => state.copyWith(name: action),
      Email() => state.copyWith(email: action),
      Password() => state.copyWith(password: action),
      _ => state,
    },
    initialState: initialState ?? const ProfileChangeDTO(),
    initialAction: null,
  );
}
