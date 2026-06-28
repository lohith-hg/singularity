import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SNavBar extends StatelessWidget {
  const SNavBar({super.key, required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final void Function(int) onTap;

  static const List<_NavItem> _items = [
    _NavItem(
      label: 'Today',
      icon: Icons.wb_sunny_outlined,
      activeIcon: Icons.wb_sunny,
    ),
    _NavItem(
      label: 'Mars',
      icon: Icons.public_outlined,
      activeIcon: Icons.public,
    ),
    _NavItem(
      label: 'Vault',
      icon: Icons.auto_stories_outlined,
      activeIcon: Icons.auto_stories,
    ),
    _NavItem(label: 'Me', icon: Icons.person_outline, activeIcon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 76 + MediaQuery.of(context).padding.bottom,
          decoration: const BoxDecoration(
            color: Color(0xCC0A0A0F),
            border: Border(top: BorderSide(color: AppColors.hairline)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                final active = i == selectedIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          active ? item.activeIcon : item.icon,
                          size: 22,
                          color: active ? AppColors.bone : AppColors.bone4,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'Geist',
                            fontSize: 10,
                            fontWeight: active
                                ? FontWeight.w500
                                : FontWeight.w400,
                            color: active ? AppColors.bone : AppColors.bone4,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
