import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/pages/login_screen.dart';
import 'package:mobile/features/auth/presentation/pages/register_screen.dart';
import 'package:mobile/features/cart/presentation/pages/cart_screen.dart';
import 'package:mobile/features/home/presentation/pages/home_screen.dart';
import 'package:mobile/features/orders/presentation/pages/checkout_screen.dart';
import 'package:mobile/features/orders/presentation/pages/order_confirmation_screen.dart';
import 'package:mobile/features/products/presentation/pages/product_details_screen.dart';
import 'package:mobile/features/products/presentation/pages/search_screen.dart';
import 'package:mobile/features/profile/presentation/pages/address_screen.dart';
import 'package:mobile/features/profile/presentation/pages/profile_screen.dart';

class NavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      debugPrint('Route ${route.settings.name} ${route.settings.arguments}');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute?.settings.name != null) {
      debugPrint('Route ${newRoute?.settings.name}');
    }
  }
}

final GoRouter router = GoRouter(
  observers: [NavigationObserver()],
  initialLocation: "/login",
  routes: [
    GoRoute(
      name: "login",
      path: "/login",
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      name: "register",
      path: "/register",
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      name: "home",
      path: "/home",
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      name: "search",
      path: "/search",
      builder: (context, state) {
        return const SearchScreen();
      },
    ),
    GoRoute(
      name: "productDetails",
      path: "/product/:id",
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(
      name: "cart",
      path: "/cart",
      builder: (context, state) {
        return const CartScreen();
      },
    ),
    GoRoute(
      name: "checkout",
      path: "/checkout",
      builder: (context, state) {
        return const CheckoutScreen();
      },
    ),
    GoRoute(
      name: "orderConfirmation",
      path: "/order-confirmation/:id",
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OrderConfirmationScreen(orderId: id);
      },
    ),
    GoRoute(
      name: "profile",
      path: "/profile",
      builder: (context, state) {
        return const ProfileScreen();
      },
    ),
    GoRoute(
      name: "addresses",
      path: "/addresses",
      builder: (context, state) {
        return const AddressScreen();
      },
    ),
  ],
);

void navigateToNewPage(BuildContext context, String page, Object extra) {
  GoRouter.of(context).go('/$page', extra: extra);
}
