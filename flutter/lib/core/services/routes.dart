import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:habib_app/src/features/home/presentation/pages/home_page.dart';
import 'package:habib_app/src/features/categories/presentation/pages/categories_page.dart';
import 'package:habib_app/src/features/categories/presentation/pages/category_details_page.dart';
import 'package:habib_app/src/features/categories/presentation/pages/create_category_page.dart';
import 'package:habib_app/core/common/widgets/hb_dialog.dart';
import 'package:habib_app/core/error/error_page.dart';
import 'package:habib_app/src/features/publishers/presentation/pages/create_publisher_page.dart';
import 'package:habib_app/src/features/publishers/presentation/pages/publisher_details_page.dart';
import 'package:habib_app/src/features/publishers/presentation/pages/publishers_page.dart';
import 'package:habib_app/src/features/authors/presentation/pages/authors_page.dart';
import 'package:habib_app/src/features/authors/presentation/pages/author_details_page.dart';
import 'package:habib_app/src/features/authors/presentation/pages/create_author_page.dart';
import 'package:habib_app/src/features/books/presentation/pages/book_details_page.dart';
import 'package:habib_app/src/features/books/presentation/pages/books_page.dart';
import 'package:habib_app/src/features/books/presentation/pages/create_book_page.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/borrow_details_page.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/borrows_page.dart';
import 'package:habib_app/src/features/borrows/presentation/pages/create_borrow_page.dart';
import 'package:habib_app/src/features/customers/presentation/pages/create_customer_page.dart';
import 'package:habib_app/src/features/customers/presentation/pages/customer_details_page.dart';
import 'package:habib_app/src/features/customers/presentation/pages/customers_page.dart';
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
    TypedGoRoute<AuthorsRoute>(path: AuthorsRoute.location),
    TypedGoRoute<PublishersRoute>(path: PublishersRoute.location),
    TypedGoRoute<CategoriesRoute>(path: CategoriesRoute.location),
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

class AuthorsRoute extends GoRouteData {

  const AuthorsRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/authors';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const AuthorsPage()
    );
  }
}

@TypedGoRoute<CreateAuthorRoute>(path: CreateAuthorRoute.location)
class CreateAuthorRoute extends GoRouteData {

  const CreateAuthorRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/authors/new';

  @override
  Page<int> buildPage(BuildContext context, GoRouterState state) {
    return HBDialogPage<int>(
      builder: (BuildContext context) => const CreateAuthorPage()
    );
  }
}

@TypedGoRoute<AuthorDetailsRoute>(path: AuthorDetailsRoute.location)
class AuthorDetailsRoute extends GoRouteData {

  final int authorId;

  const AuthorDetailsRoute({
    required this.authorId
  });

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/authors/:authorId';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final AuthorDetailsPageParams params = AuthorDetailsPageParams(authorId: authorId);
    return AuthorDetailsPage(params: params);
  }
}

class PublishersRoute extends GoRouteData {

  const PublishersRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/publishers';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const PublishersPage()
    );
  }
}

@TypedGoRoute<CreatePublisherRoute>(path: CreatePublisherRoute.location)
class CreatePublisherRoute extends GoRouteData {

  const CreatePublisherRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/publishers/new';

  @override
  Page<int> buildPage(BuildContext context, GoRouterState state) {
    return HBDialogPage<int>(
      builder: (BuildContext context) => const CreatePublisherPage()
    );
  }
}

@TypedGoRoute<PublisherDetailsRoute>(path: PublisherDetailsRoute.location)
class PublisherDetailsRoute extends GoRouteData {

  final int publisherId;

  const PublisherDetailsRoute({
    required this.publisherId
  });

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/publishers/:publisherId';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final PublisherDetailsPageParams params = PublisherDetailsPageParams(publisherId: publisherId);
    return PublisherDetailsPage(params: params);
  }
}

class CategoriesRoute extends GoRouteData {

  const CategoriesRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = shellNavigatorKey;

  static const String location = '/categories';

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      key: state.pageKey,
      child: const CategoriesPage()
    );
  }
}

@TypedGoRoute<CreateCategoryRoute>(path: CreateCategoryRoute.location)
class CreateCategoryRoute extends GoRouteData {

  const CreateCategoryRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/categories/new';

  @override
  Page<int> buildPage(BuildContext context, GoRouterState state) {
    return HBDialogPage<int>(
      builder: (BuildContext context) => const CreateCategoryPage()
    );
  }
}

@TypedGoRoute<CategoryDetailsRoute>(path: CategoryDetailsRoute.location)
class CategoryDetailsRoute extends GoRouteData {

  final int categoryId;

  const CategoryDetailsRoute({
    required this.categoryId
  });

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/categories/:categoryId';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final CategoryDetailsPageParams params = CategoryDetailsPageParams(categoryId: categoryId);
    return CategoryDetailsPage(params: params);
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

  final CreateBorrowPageParams? $extra;

  const CreateBorrowRoute({ this.$extra });

  static final GlobalKey<NavigatorState> $navigatorKey = rootNavigatorKey;

  static const String location = '/borrows/new';

  @override
  Page<int> buildPage(BuildContext context, GoRouterState state) {
    return HBDialogPage<int>(
      builder: (BuildContext context) => CreateBorrowPage(params: $extra)
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