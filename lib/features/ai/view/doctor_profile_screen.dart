import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/theme_cubit.dart';
import '../../auth/presentation/cubit/auth_hydrated_cubit.dart';
import '../../auth/presentation/cubit/auth_state.dart';
import '../../auth/presentation/view/login.dart';
import '../../chat/rating_widget.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        return Scaffold(
          backgroundColor: const Color(0xFF0A0E1A),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 32.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF111827), Color(0xFF1A2235)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(32)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00E5FF).withValues(alpha: 0.5),
                            width: 2.5,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 44.r,
                          backgroundColor:
                              const Color(0xFF00E5FF).withValues(alpha: 0.1),
                          child: Icon(
                            Icons.medical_services_rounded,
                            size: 44.sp,
                            color: const Color(0xFF00E5FF),
                          ),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        user?.name ?? '',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                              color: const Color(0xFF00E5FF).withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          'DOCTOR',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF00E5FF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      if (user != null)
                        RatingWidget(userId: user.id, color: Colors.amber),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(20.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 8.h),
                    _DarkInfoCard(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? '',
                      color: Colors.blueAccent,
                    ),
                    SizedBox(height: 12.h),
                    _DarkInfoCard(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: user?.phone ?? '—',
                      color: const Color(0xFF00E5FF),
                    ),
                    SizedBox(height: 12.h),
                    const _DarkThemeToggleCard(),
                    SizedBox(height: 32.h),
                    GestureDetector(
                      onTap: () => _confirmLogout(context),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.redAccent.withValues(alpha: 0.12),
                          border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded,
                                color: Colors.redAccent, size: 20.sp),
                            SizedBox(width: 10.w),
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1A2235),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.4)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded,
                    color: Colors.redAccent, size: 28.sp),
              ),
              SizedBox(height: 16.h),
              Text('Sign Out',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700)),
              SizedBox(height: 8.h),
              Text(
                'Are you sure you want to sign out?',
                style: TextStyle(color: Colors.white38, fontSize: 13.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: Colors.white24),
                        ),
                        alignment: Alignment.center,
                        child: Text('Cancel',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        await context.read<AuthCubit>().logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const Login()),
                            (r) => false,
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: Colors.redAccent.withValues(alpha: 0.5)),
                        ),
                        alignment: Alignment.center,
                        child: Text('Sign Out',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DarkInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DarkInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2235),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF1E2D45)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white38,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 2.h),
              Text(value,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DarkThemeToggleCard extends StatelessWidget {
  const _DarkThemeToggleCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;
        final iconColor =
            isDark ? const Color(0xFF7986CB) : const Color(0xFFFF9800);
        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1A2235),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF1E2D45)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: iconColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Appearance',
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.white38,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 2.h),
                    Text(
                      isDark ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                activeThumbColor: const Color(0xFF00E5FF),
                activeTrackColor: const Color(0xFF00E5FF).withValues(alpha: 0.3),
                inactiveThumbColor: Colors.white54,
                inactiveTrackColor: Colors.white12,
              ),
            ],
          ),
        );
      },
    );
  }
}
