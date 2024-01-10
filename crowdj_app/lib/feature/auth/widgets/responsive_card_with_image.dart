import 'package:flutter/material.dart';

class ResponsiveCardWithImage extends StatelessWidget {
  const ResponsiveCardWithImage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double breackPointWidth = 700;
        const double breackPointHeight = 700;

        if (constraints.maxWidth > breackPointWidth) {
          return Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                ),
              ],
              color: Colors.white,
            ),
            constraints: const BoxConstraints(
              maxHeight: breackPointHeight,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: child,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Image.asset(
                    'lib/assets/crowd_mobile_background.jpeg',
                    alignment: Alignment.centerRight,
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
            ),
            margin:
                const EdgeInsets.symmetric(horizontal: breackPointWidth * 0.1),
            padding: const EdgeInsets.all(16.0),
            child: child,
          );
        }
      },
    );
  }
}
