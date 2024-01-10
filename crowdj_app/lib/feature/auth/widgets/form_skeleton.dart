import 'package:flutter/material.dart';

/// A custom conmponent that renders a [form] with a title above it.
class FormSkeleton extends StatelessWidget {
  const FormSkeleton({
    super.key,
    this.title,
    required this.form,
  });

  final String? title;
  final Widget form;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (title != null) const SizedBox(height: 20),
        form,
      ],
    );
  }
}
