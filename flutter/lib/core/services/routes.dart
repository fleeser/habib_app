import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:habib_app/core/common/widgets/hb_dialog.dart';
import 'package:habib_app/core/error/error_page.dart';
import 'package:habib_app/src/features/books/presentation/pages/book_details_page.dart';
import 'package:habib_app/src/features/books/presentation/pages/books_page.dart';
import 'package:habib_app/src/features/books/presentation/pages/create_book_page.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/borrow_details_page.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/borrows_page.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/create_borrow_page.dart';
import 'package:habib_app/src/features/customers/presentation/pages/create_customer_page.dart';
import 'package:habib_app/src/features/customers/presentation/pages/customer_details_page.dart';
import 'package:habib_app/src/features/customers/presentation/pages/customers_page.dart';
import 'package:habib_app/src/features/home/presentation/pages/home_page.dart';
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
    TypedGoRoute<BorrowsRoute>(path: BorrowsRoute.location),
    TypedGoRoute<SettingsRoute>(path: SettingsRoute.location)
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

@TypedGoRoute<CreateCustomerRoute>(path: CreateCustomerRoute.location)
class CreateCustomerRoute extends GoRouteData {

  const CreateCustomerRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/customers/new';

  @override
  Page<int> buildPage(BuildContext context, GoRouterState state) {
    return HBDialogPage<int>(
      builder: (BuildContext context) => const CreateCustomerPage()
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

@TypedGoRoute<CreateBookRoute>(path: CreateBookRoute.location)
class CreateBookRoute extends GoRouteData {

  const CreateBookRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/books/new';

  @override
  Page<int> buildPage(BuildContext context, GoRouterState state) {
    return HBDialogPage<int>(
      builder: (BuildContext context) => const CreateBookPage()
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

class BorrowsRoute extends GoRouteData {

  const BorrowsRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/borrows';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const BorrowsPage()
    );
  }
}

@TypedGoRoute<CreateBorrowRoute>(path: CreateBorrowRoute.location)
class CreateBorrowRoute extends GoRouteData {

  const CreateBorrowRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/borrows/new';

  @override
  Page<int> buildPage(BuildContext context, GoRouterState state) {
    return HBDialogPage<int>(
      builder: (BuildContext context) => const CreateBorrowPage()
    );
  }
}

@TypedGoRoute<BorrowDetailsRoute>(path: BorrowDetailsRoute.location)
class BorrowDetailsRoute extends GoRouteData {

  final int borrowId;

  const BorrowDetailsRoute({
    required this.borrowId
  });

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/borrows/:borrowId';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final BorrowDetailsPageParams params = BorrowDetailsPageParams(borrowId: borrowId);
    return BorrowDetailsPage(params: params);
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