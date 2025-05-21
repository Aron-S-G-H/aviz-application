import 'package:aviz_project/settings/settings.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback onActionTap;
  final double borderRadius;
  final Widget? icon;
  final Size? size;
  final IconAlignment? iconAlignment;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const CustomElevatedButton({
    required this.title,
    required this.onActionTap,
    this.borderRadius = 4.0,
    this.icon,
    this.size,
    this.iconAlignment,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onActionTap,
      label: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: foregroundColor ?? Colors.white),
      ),
      icon: icon,
      style: ElevatedButton.styleFrom(
        iconAlignment: iconAlignment,
        backgroundColor: backgroundColor ?? ColorSetting.customRed,
        fixedSize: size,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
