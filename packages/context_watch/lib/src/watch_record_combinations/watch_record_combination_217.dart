// ignore_for_file: use_of_void_result

import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt217<T0, T2> on (Future<T0>, Listenable, Future<T2>, Listenable) {
  /// {@macro mass_watch_explanation}
  (AsyncSnapshot<T0>, void, AsyncSnapshot<T2>, void) watch(BuildContext context) =>
      ($1.watch(context), $2.watch(context) as Null, $3.watch(context), $4.watch(context) as Null,);
}
