import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/colors/app_colors.dart';
import 'package:mobile/core/constants/text_styles.dart';

class ServerText extends ConsumerWidget {
  const ServerText(
    this.text, {
    super.key,
    this.textStyleName,
    this.maxLines,
    this.overflow,
    this.fontFamily = 'Golos Text',
    this.additionalStyle,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final String? fontFamily;
  final String? textStyleName;
  final TextStyle? additionalStyle;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final theme = get from ThemeProvider....
    final style = TextStyle(
      height: 0.h,
      // color: theme?.type == 'light' ? Colors.black : AppColors.textTitle,
      color: AppColors.purple,
    ).merge(customTextStyles[textStyleName]).merge(additionalStyle);

    return Text(
      text,
      maxLines: maxLines,
      style: GoogleFonts.getFont(fontFamily!, textStyle: style),
      textAlign: textAlign,
    );
  }
}
