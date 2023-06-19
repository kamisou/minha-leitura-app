import 'package:flutter_hooks/flutter_hooks.dart';

import '../../domain/models/user.dart';

String useUserInitials(User user, {int initialsCount = 2}) {
  return useMemoized(
    () => user.name.split(' ').take(initialsCount).map((e) => e[0]).join(),
    [user.name, initialsCount],
  );
}
