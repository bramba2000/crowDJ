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
        const double breackPointWidth = 750;
        const double breackPointHeight = 700;

        const double maxSmallScreenFormWidth = 500;
        const double minSmallScreenFormHeigth = 400;

        const double bigScreenMaxWidth = 1200;

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
              maxWidth: bigScreenMaxWidth,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(constraints.maxWidth * 0.025),
                      child: child,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      'lib/assets/crowd_mobile_background.jpeg',
                      alignment: Alignment.centerRight,
                      height: breackPointHeight,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                ],
              ),
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
            constraints: const BoxConstraints(
                minHeight: minSmallScreenFormHeigth,
                maxWidth: maxSmallScreenFormWidth),
            margin:
                const EdgeInsets.symmetric(horizontal: breackPointWidth * 0.05),
            padding: const EdgeInsets.all(16.0),
            child: child,
          );
        }
      },
    );
  }
}
