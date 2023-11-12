// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation_history_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$meditationHistoriesOnDateHash() =>
    r'8d30fc7439f4f95e61600136f765405f0dd37463';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [meditationHistoriesOnDate].
@ProviderFor(meditationHistoriesOnDate)
const meditationHistoriesOnDateProvider = MeditationHistoriesOnDateFamily();

/// See also [meditationHistoriesOnDate].
class MeditationHistoriesOnDateFamily extends Family<List<Meditation>> {
  /// See also [meditationHistoriesOnDate].
  const MeditationHistoriesOnDateFamily();

  /// See also [meditationHistoriesOnDate].
  MeditationHistoriesOnDateProvider call(
    DateTime date,
  ) {
    return MeditationHistoriesOnDateProvider(
      date,
    );
  }

  @override
  MeditationHistoriesOnDateProvider getProviderOverride(
    covariant MeditationHistoriesOnDateProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'meditationHistoriesOnDateProvider';
}

/// See also [meditationHistoriesOnDate].
class MeditationHistoriesOnDateProvider
    extends AutoDisposeProvider<List<Meditation>> {
  /// See also [meditationHistoriesOnDate].
  MeditationHistoriesOnDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => meditationHistoriesOnDate(
            ref as MeditationHistoriesOnDateRef,
            date,
          ),
          from: meditationHistoriesOnDateProvider,
          name: r'meditationHistoriesOnDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$meditationHistoriesOnDateHash,
          dependencies: MeditationHistoriesOnDateFamily._dependencies,
          allTransitiveDependencies:
              MeditationHistoriesOnDateFamily._allTransitiveDependencies,
          date: date,
        );

  MeditationHistoriesOnDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    List<Meditation> Function(MeditationHistoriesOnDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MeditationHistoriesOnDateProvider._internal(
        (ref) => create(ref as MeditationHistoriesOnDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<Meditation>> createElement() {
    return _MeditationHistoriesOnDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MeditationHistoriesOnDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MeditationHistoriesOnDateRef on AutoDisposeProviderRef<List<Meditation>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _MeditationHistoriesOnDateProviderElement
    extends AutoDisposeProviderElement<List<Meditation>>
    with MeditationHistoriesOnDateRef {
  _MeditationHistoriesOnDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as MeditationHistoriesOnDateProvider).date;
}

String _$meditationHistoryNotifierHash() =>
    r'583ce66539ca54ed6a0e53b470d9ed1bc352fe09';

/// See also [MeditationHistoryNotifier].
@ProviderFor(MeditationHistoryNotifier)
final meditationHistoryNotifierProvider = AutoDisposeAsyncNotifierProvider<
    MeditationHistoryNotifier, MeditationList>.internal(
  MeditationHistoryNotifier.new,
  name: r'meditationHistoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$meditationHistoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MeditationHistoryNotifier = AutoDisposeAsyncNotifier<MeditationList>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
