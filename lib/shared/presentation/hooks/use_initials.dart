import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reading/shared/domain/has_name.dart';

String useInitials(HasName named, [int initialsCount = 2]) {
  return useMemoized(
    () => named.name.split(' ').take(initialsCount).map((e) => e[0]).join(),
    [named.name, initialsCount],
  );
}
