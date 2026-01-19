import 'package:flutter/material.dart';

class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftWidget;
  final Widget? rightWidget;

  const PrimaryAppBar({super.key, this.leftWidget, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 20,
      ),
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leftWidget != null) leftWidget! else const SizedBox.shrink(),
              if (rightWidget != null)
                rightWidget!
              else
                const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
