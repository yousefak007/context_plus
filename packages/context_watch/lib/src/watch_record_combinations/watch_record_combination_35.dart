// ignore_for_file: use_of_void_result

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../watchers/future_context_watcher.dart';
import '../watchers/listenable_context_watcher.dart';

/// More convenient API for watching multiple values at once.
extension ContextWatchRecordExt35<T0, T2> on (
  ValueListenable<T0>,
  Listenable,
  Future<T2>
) {
  /// {@macro mass_watch_explanation}
  (T0, void, AsyncSnapshot<T2>) watch(BuildContext context) => (
        $1.watchValue(context),
        $2.watch(context) as Null,
        $3.watch(context),
      );
}
