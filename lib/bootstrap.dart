import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/utils/logger.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Temporarily disable Firebase for local testing without config
  try {
    // await Firebase.initializeApp();
    // await FirebaseMessagingService().initialize();
  } catch (e) {
    LoggerService().error('Firebase init failed', e, null);
  }

  FlutterError.onError = (errorDetails) {
    LoggerService().error(
      'Unhandled Flutter error',
      errorDetails.exception,
      errorDetails.stack,
    );
    if (!kDebugMode) {
      // FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    LoggerService().error('Unhandled asynchronous error', error, stack);
    if (!kDebugMode) {
      // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };

  runApp(ProviderScope(child: await builder()));
}
