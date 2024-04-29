import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:habib_app/core/services/routes.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: SplashRoute.location,
    routes: $appRoutes,
    extraCodec: const ExtraCodec()
  );

  ref.onDispose(router.dispose);

  return router;
}

class ExtraCodec extends Codec<Object?, Object?> {

  const ExtraCodec();
  
  @override
  Converter<Object?, Object?> get decoder => const ExtraDecoder();
  
  @override
  Converter<Object?, Object?> get encoder => const ExtraEncoder();
}

class ExtraDecoder extends Converter<Object?, Object?> {

  const ExtraDecoder();
  
  @override
  Object? convert(Object? input) {
    return null;
  }
}

class ExtraEncoder extends Converter<Object?, Object?> {

  const ExtraEncoder();
  
  @override
  Object? convert(Object? input) {
    return null;
  }
}