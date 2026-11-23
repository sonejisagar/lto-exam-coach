import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final BorderSide? borderSide;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.base),
    this.backgroundColor,
    this.gradient,
    this.borderSide,
    this.borderRadius = AppRadius.card,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = backgroundColor ??
        (gradient == null
            ? (isDark ? AppColors.darkSurface : AppColors.lightSurface)
            : null);

    final defaultBorder = borderSide ??
        BorderSide(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        );

    final effectiveShadow = boxShadow ??
        (isDark ? AppShadows.cardDark : AppShadows.cardLight);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.fromBorderSide(defaultBorder),
        boxShadow: effectiveShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.10),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
