import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:habib_app/core/common/widgets/hb_navigation_rail.dart';
import 'package:habib_app/core/common/widgets/hb_scaffold.dart';
import 'package:habib_app/core/res/hb_icons.dart';
import 'package:habib_app/core/services/routes.dart';

class MainPage extends StatelessWidget {

  final Widget navigator;

  const MainPage({ 
    super.key,
    required this.navigator
  });

  int _currentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    switch(location) {
      case HomeRoute.location: return 0;
      case CustomersRoute.location: return 1;
      case BooksRoute.location: return 2;
      case BorrowsRoute.location: return 3;
      case SettingsRoute.location: return 4;
      default: throw Exception('Index for location not found: $location');
    }
  }

  Future<void> _onItemPressed(BuildContext context, int index) async {
    switch (index) {
      case 0:
        const HomeRoute().go(context);
        break;
      case 1:
        const CustomersRoute().go(context);
        break;
      case 2:
        const BooksRoute().go(context);
        break;
      case 3:
        const BorrowsRoute().go(context);
        break;
      case 4:
        const SettingsRoute().go(context);
        break;
      default: throw Exception('Could not navigate to index: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return HBScaffold(
      body: Row(
        children: [
          HBNavigationRail(
            onItemPressed: (int index) => _onItemPressed(context, index),
            selectedIndex: _currentIndex(context),
            items: const <HBNavigationRailItem>[
              HBNavigationRailItem(
                icon: HBIcons.home,
                title: 'Startseite'
              ),
              HBNavigationRailItem(
                icon: HBIcons.users,
                title: 'Kunden'
              ),
              HBNavigationRailItem(
                icon: HBIcons.bookOpen,
                title: 'Bücher'
              ),
              HBNavigationRailItem(
                icon: HBIcons.clock,
                title: 'Ausleihen'
              ),
              HBNavigationRailItem(
                icon: HBIcons.cog6Tooth,
                title: 'Einstellungen'
              )
            ]
          ),
          Expanded(child: navigator)
        ]
      )
    );
  }
}