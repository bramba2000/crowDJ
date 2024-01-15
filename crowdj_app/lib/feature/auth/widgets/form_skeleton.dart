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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (title != null) const SizedBox(height: 15),
          form,
        ],
      ),
    );
  }
}
