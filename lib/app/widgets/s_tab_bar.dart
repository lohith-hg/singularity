import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class STabBar extends StatelessWidget {
  const STabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> tabs;
  final int selectedIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.hairline)),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? AppColors.bone : Colors.transparent,
                    width: 1.5,
                  ),
                ),
              ),
              child: Text(
                tabs[i],
                style: TextStyle(
                  fontFamily: 'Geist',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected ? AppColors.bone : AppColors.bone4,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
