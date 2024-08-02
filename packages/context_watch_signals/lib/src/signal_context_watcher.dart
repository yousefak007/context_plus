import 'package:context_watch_base/context_watch_base.dart';
import 'package:flutter/widgets.dart';
import 'package:signals_flutter/signals_flutter.dart';

class _SignalsSubscription implements ContextWatchSubscription {
  _SignalsSubscription({
    required this.observable,
    required this.dispose,
  });

  final VoidCallback dispose;

  @override
  final ReadonlySignal observable;

  @override
  get hasValue => true;

  @override
  get value => observable.value;

  @override
  get selectorParameterType => ContextWatchSelectorParameterType.value;

  @override
  void cancel() => dispose();
}

class SignalContextWatcher extends ContextWatcher<ReadonlySignal> {
  SignalContextWatcher._();

  static final instance = SignalContextWatcher._();

  @override
  ContextWatchSubscription createSubscription<T>(
      BuildContext context, ReadonlySignal observable) {
    return _SignalsSubscription(
      observable: observable,
      dispose: observable.subscribe(
        (_) => rebuildIfNeeded(context, observable),
      ),
    );
  }
}

extension SignalContextWatchExtension<T> on ReadonlySignal<T> {
  /// Watch this [Signal] for changes.
  ///
  /// Whenever this [Signal] emits new value, the [context] will be
  /// rebuilt.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  T watch(BuildContext context) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this)
        ?.watch();
    return value;
  }
}

extension SignalContextWatchValueExtension<T> on ReadonlySignal<T> {
  /// Watch this [Signal] for changes.
  ///
  /// Whenever this [Signal] emits new value, if [selector]
  /// returns a different value, the [context] will be rebuilt.
  ///
  /// Returns the selected value.
  ///
  /// It is safe to call this method multiple times within the same build
  /// method.
  R watchOnly<R>(BuildContext context, R Function(T value) selector) {
    final observable = InheritedContextWatch.of(context)
        .getOrCreateObservable<T>(context, this);
    if (observable == null) return selector(value);

    final selectedValue = selector(value);
    observable.watchOnly(selector, selectedValue);

    return selectedValue;
  }
}

extension ListenableContextWatchEffectExtension<T> on ReadonlySignal<T> {
  /// Watch this [Signal] for changes.
  ///
  /// Whenever this [Signal] notifies of a change, the [effect] will be
  /// called, *without* rebuilding the widget.
  ///
  /// Conditional effects are supported, but it's highly recommended to specify
  /// a unique [key] for all such effects followed by the [unwatchEffect] call
  /// when condition is no longer met:
  /// ```dart
  /// if (condition) {
  ///   signal.watchEffect(context, key: 'effect', (_) {...});
  /// } else {
  ///   signal.unwatchEffect(context, key: 'effect');
  /// }
  /// ```
  ///
  /// If [immediate] is `true`, the effect will be called upon effect
  /// registration immediately. If [once] is `true`, the effect will be called
  /// only once. These parameters can be combined.
  ///
  /// [immediate] and [once] parameters require a unique [key].
  void watchEffect(
    BuildContext context,
    void Function(T value) effect, {
    Object? key,
    bool immediate = false,
    bool once = false,
  }) {
    InheritedContextWatch.of(context)
        .getOrCreateObservable(context, this)
        ?.watchEffect(effect, key: key, immediate: immediate, once: once);
  }
}

extension ListenableContextUnwatchEffectExtension on ReadonlySignal {
  /// Remove the effect with the given [key] from the list of effects to be
  /// called when this [Signal] notifies of a change.
  void unwatchEffect(
    BuildContext context, {
    required Object key,
  }) {
    InheritedContextWatch.of(context).unwatchEffect(context, this, key);
  }
}
