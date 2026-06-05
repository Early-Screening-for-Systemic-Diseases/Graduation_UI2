import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/providers/ui_providers.dart';
import '../../chat/chat_list_screen.dart';
import 'analysis_screen.dart';
import 'consent_dialog.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MedicalNavBar extends ConsumerStatefulWidget {
  const MedicalNavBar({super.key});

  @override
  ConsumerState<MedicalNavBar> createState() => _MedicalNavBarState();
}

class _MedicalNavBarState extends ConsumerState<MedicalNavBar> {
  static const List<Widget> _screens = [
    HomeScreen(),
    AnalysisScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  static const _items = [
    (icon: Icons.home_rounded, label: 'Home'),
    (icon: Icons.bar_chart_rounded, label: 'Analysis'),
    (icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
    (icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkConsent());
  }

  Future<void> _checkConsent() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || !mounted) return;
    final consent = await ConsentService.getConsent(uid);
    if (consent.modelTraining == null && mounted) {
      await ConsentDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(navIndexProvider);

    return Scaffold(
      body: _screens[selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final selected = i == selectedIndex;
            final item = _items[i];
            return GestureDetector(
              onTap: () => ref.read(navIndexProvider.notifier).state = i,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(
                    horizontal: selected ? 18.w : 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: selected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(item.icon,
                        color: selected ? Colors.white : Colors.grey,
                        size: 22.sp),
                    if (selected) ...[
                      SizedBox(width: 6.w),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
