import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/details_screen.dart';
import 'screens/search_screen.dart';
import 'screens/profile_screen.dart';
import 'models/media_item.dart';

RouterConfig<Object> createRouter() {
  return RouterConfig(
    routerDelegate: _FamFlixRouterDelegate(),
    routeInformationProvider: PlatformRouteInformationProvider(initialRouteInformation: RouteInformation(uri: Uri.parse('/'))),
    routeInformationParser: _FamFlixRouteParser(),
  );
}

// Simple route model
class _RoutePath {
  final String name;
  final Map<String, dynamic>? params;
  _RoutePath(this.name, {this.params});
}

class _FamFlixRouterDelegate extends RouterDelegate<_RoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<_RoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  _RoutePath _current = _RoutePath('home');

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        const MaterialPage(child: HomeScreen()),
        if (_current.name == 'search') const MaterialPage(child: SearchScreen()),
        if (_current.name == 'profile') const MaterialPage(child: ProfileScreen()),
        if (_current.name == 'details' && _current.params?['item'] != null) MaterialPage(child: DetailsScreen(item: _current.params!['item'] as MediaItem)),
      ],
      onDidRemovePage: (page) {
        _current = _RoutePath('home');
        notifyListeners();
      },
    );
  }

  @override
  Future<void> setNewRoutePath(_RoutePath configuration) async {
    _current = configuration;
  }

  // Helpers for navigation
  void goHome() {
    _current = _RoutePath('home');
    notifyListeners();
  }

  void goSearch() {
    _current = _RoutePath('search');
    notifyListeners();
  }

  void goProfile() {
    _current = _RoutePath('profile');
    notifyListeners();
  }

  void goDetails(MediaItem item) {
    _current = _RoutePath('details', params: {'item': item});
    notifyListeners();
  }
}

class _FamFlixRouteParser extends RouteInformationParser<_RoutePath> {
  @override
  Future<_RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    if (uri.pathSegments.isEmpty) return _RoutePath('home');
    switch (uri.pathSegments[0]) {
      case 'search':
        return _RoutePath('search');
      case 'profile':
        return _RoutePath('profile');
      case 'details':
        // For web deeplinks we could parse query params, but keeping simple here.
        return _RoutePath('home');
      default:
        return _RoutePath('home');
    }
  }

  @override
  RouteInformation? restoreRouteInformation(_RoutePath configuration) {
    return switch (configuration.name) {
      'home' => RouteInformation(uri: Uri.parse('/')),
      'search' => RouteInformation(uri: Uri.parse('/search')),
      'profile' => RouteInformation(uri: Uri.parse('/profile')),
      'details' => RouteInformation(uri: Uri.parse('/details')),
      _ => RouteInformation(uri: Uri.parse('/')),
    };
  }
}
