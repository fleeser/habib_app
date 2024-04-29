import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:habib_app/core/error/error_page.dart';
import 'package:habib_app/src/features/books/presentation/pages/book_details_page.dart';
import 'package:habib_app/src/features/books/presentation/pages/books_page.dart';
import 'package:habib_app/src/features/customers/presentation/pages/customer_details_page.dart';
import 'package:habib_app/src/features/customers/presentation/pages/customers_page.dart';
import 'package:habib_app/src/features/home/presentation/pages/home_page.dart';
import 'package:habib_app/src/features/reminders/presentation/pages/reminders_page.dart';
import 'package:habib_app/src/features/settings/presentation/pages/settings_page.dart';
import 'package:habib_app/src/main_page.dart';

part 'routes.g.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

class ErrorRoute extends GoRouteData {

  final Exception error;

  const ErrorRoute({ required this.error });

  @override
  Widget build(BuildContext context, GoRouterState state) => const ErrorPage();
}

@TypedGoRoute<SplashRoute>(path: SplashRoute.location)
class SplashRoute extends GoRouteData {

  const SplashRoute();

  static const String location = '/';

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    return HomeRoute.location;
  }
}

@TypedShellRoute<MainRoute>(
  routes: [
    TypedGoRoute<HomeRoute>(path: HomeRoute.location),
    TypedGoRoute<CustomersRoute>(path: CustomersRoute.location),
    TypedGoRoute<BooksRoute>(path: BooksRoute.location),
    TypedGoRoute<RemindersRoute>(path: RemindersRoute.location),
    TypedGoRoute<SettingsRoute>(path: SettingsRoute.location),
  ]
)
class MainRoute extends ShellRouteData {

  const MainRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return MainPage(navigator: navigator);
  }
}

class HomeRoute extends GoRouteData {

  const HomeRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/home';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const HomePage()
    );
  }
}

class CustomersRoute extends GoRouteData {

  const CustomersRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/customers';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const CustomersPage()
    );
  }
}

@TypedGoRoute<CustomerDetailsRoute>(path: CustomerDetailsRoute.location)
class CustomerDetailsRoute extends GoRouteData {

  final int customerId;

  const CustomerDetailsRoute({
    required this.customerId
  });

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/customers/:customerId';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final CustomerDetailsPageParams params = CustomerDetailsPageParams(customerId: customerId);
    return CustomerDetailsPage(params: params);
  }
}

class BooksRoute extends GoRouteData {

  const BooksRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/books';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const BooksPage()
    );
  }
}

@TypedGoRoute<BookDetailsRoute>(path: BookDetailsRoute.location)
class BookDetailsRoute extends GoRouteData {

  final int bookId;

  const BookDetailsRoute({
    required this.bookId
  });

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/books/:bookId';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final BookDetailsPageParams params = BookDetailsPageParams(bookId: bookId);
    return BookDetailsPage(params: params);
  }
}

class RemindersRoute extends GoRouteData {

  const RemindersRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/reminders';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const RemindersPage()
    );
  }
}

class SettingsRoute extends GoRouteData {

  const SettingsRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/settings';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const SettingsPage()
    );
  }
}