import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RiverpodLogger extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint('''
{
  "PROVIDER": "${provider.name ?? provider.runtimeType}"
  "ADD": "$value"
}''');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint('''
{
  "PROVIDER": "${provider.name ?? provider.runtimeType}",
  "UPDATE": "$newValue"
}''');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    debugPrint('''
{
  "PROVIDER": "${provider.name ?? provider.runtimeType}",
  "DISPOSE!!"
}''');
  }
}
