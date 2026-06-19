import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/app_colors.dart';
import '../style/app_dimens.dart';
import '../style/app_text_styles.dart';

/// Modal bottom sheet shell: grab handle + title + caller-provided content,
/// rounded at the top, safe-area + keyboard aware. Used for "Save sheet".
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required String title,
  required WidgetBuilder builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AppBottomSheet(title: title, child: builder(context)),
  );
}

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.md,
        bottom: AppSpacing.xxl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: c.hairline,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontSize: 17.sp,
              color: c.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
