import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/common/providers/themes.dart';
import 'package:mobile/common/widgets/server_text.dart';
import 'package:mobile/routes/app_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
// import 'package:go_router/go_router.dart';

class SimpleAppbar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final Color? color;
  final double? fontSize;
  final String? textStyleName;

  const SimpleAppbar({
    super.key,
    this.textStyleName,
    this.fontSize,
    this.color,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeControllerProvider).value;
    return AppBar(
      surfaceTintColor: Colors.transparent, // 🔥 IMPORTANT
      scrolledUnderElevation: 0, // 🔥 IMPORTANT

      backgroundColor: Colors.transparent,
      title: ServerText(
        title ?? '',
        textStyleName: textStyleName ?? 'b12',
        additionalStyle: TextStyle(fontSize: fontSize ?? 18.sp, color: color),
      ),
      leading: Skeletonizer(
        enabled: ref.watch(themeControllerProvider).isLoading,
        child: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: theme == 'dark' ? Colors.black : Colors.white,
          ),
          onPressed: () {
            // Check if we can pop the current route
            if (router.canPop()) {
              router.pop();
            } else {
              router.go('/home');
            }
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
