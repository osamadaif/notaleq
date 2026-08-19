import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../style/app_colors.dart';
import '../style/app_dimens.dart';
import '../style/app_text_styles.dart';

/// A generic pill segmented control. Used for theme mode
/// (فاتح / داكن / تلقائي) but value-type agnostic.
class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  final List<SegmentOption<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: c.surfaceSunken,
        borderRadius: BorderRadius.circular(AppRadii.chip),
      ),
      child: Row(
        children: [
          for (final segment in segments)
            Expanded(
              child: _Segment(
                segment: segment,
                selected: segment.value == value,
                onTap: () => onChanged(segment.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  final SegmentOption<T> segment;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: AppMotion.keyDepress,
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? c.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.chip - 3),
          boxShadow: selected ? AppElevation.key : null,
        ),
        alignment: Alignment.center,
        child: Text(
          segment.label,
          style: AppTextStyles.button.copyWith(
            fontSize: 14.sp,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? c.accent : c.textSecondary,
          ),
        ),
      ),
    );
  }
}

class SegmentOption<T> {
  const SegmentOption({required this.label, required this.value});

  final String label;
  final T value;
}
