import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/routes/app_router.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToastificationWrapper(
      config: const ToastificationConfig(alignment: Alignment.bottomCenter),
      child: ScreenUtilInit(
        designSize: const Size(375, 670),
        useInheritedMediaQuery: true,
        minTextAdapt: true,
        child: MaterialApp.router(
          routerConfig: router,
          // locale: DevicePreview.locale(context),
          debugShowCheckedModeBanner: false,
          // darkTheme: ThemeData.dark(),
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.white,
            scaffoldBackgroundColor: AppColors.white,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.dark,
            scaffoldBackgroundColor: AppColors.background,
          ),
          themeMode: ThemeMode.light,
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(textScaler: TextScaler.noScaling),
              child: SafeArea(
                top: false,
                bottom: Platform.isAndroid,
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }
}
