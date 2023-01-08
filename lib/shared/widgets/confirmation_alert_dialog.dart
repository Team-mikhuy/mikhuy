import 'package:flutter/material.dart';
import 'package:mikhuy/theme/theme.dart';

class ConfirmationAlertDialog extends StatelessWidget {
  const ConfirmationAlertDialog({
    this.title,
    this.content,
    this.onConfirmPressed,
    this.onCancelPressed,
    this.confirmButtonContent,
    this.cancelButtonContent,
    super.key,
  });

  final Widget? title;
  final Widget? content;
  final void Function()? onConfirmPressed;
  final void Function()? onCancelPressed;
  final Widget? confirmButtonContent;
  final Widget? cancelButtonContent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      title: title,
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (content != null)
              Container(
                child: content,
              ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancelPressed,
                    style: AppTheme.secondaryButton,
                    child: cancelButtonContent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirmPressed,
                    child: confirmButtonContent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
