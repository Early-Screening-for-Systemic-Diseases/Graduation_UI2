import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../auth/presentation/cubit/auth_hydrated_cubit.dart';
import '../auth/presentation/cubit/auth_state.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) return const SizedBox();
        final me = state.user;
        final isDoctor = me.role.name == 'doctor';

        return Scaffold(
          backgroundColor: const Color(0xFF0A0E1A),
          appBar: AppBar(
            backgroundColor: const Color(0xFF111827),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E5FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color: const Color(0xFF00E5FF).withOpacity(0.4)),
                  ),
                  child: Icon(Icons.chat_bubble_outline_rounded,
                      color: const Color(0xFF00E5FF), size: 18.sp),
                ),
                SizedBox(width: 10.w),
                Text('Messages',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700)),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                  height: 1,
                  color: const Color(0xFF00E5FF).withOpacity(0.3)),
            ),
          ),
          body: isDoctor
              ? _DoctorChatList(doctorId: me.id, doctorName: me.name)
              : _PatientChatList(
                  patientId: me.id, patientName: me.name),
        );
      },
    );
  }
}

// ── Patient view: list all doctors ───────────────────────────────────────────

class _PatientChatList extends StatelessWidget {
  final String patientId;
  final String patientName;

  const _PatientChatList(
      {required this.patientId, required this.patientName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFF00E5FF)));
        }
        final doctors = snapshot.data!.docs;
        if (doctors.isEmpty) {
          return _EmptyState(message: 'No doctors available yet.');
        }
        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: doctors.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (_, i) {
            final data = doctors[i].data() as Map<String, dynamic>;
            final doctorId = data['id'] as String? ?? doctors[i].id;
            final doctorName = data['name'] as String? ?? 'Doctor';
            return _ChatTile(
              name: doctorName,
              subtitle: data['email'] as String? ?? '',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    currentUserId: patientId,
                    currentUserName: patientName,
                    otherUserId: doctorId,
                    otherUserName: doctorName,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Doctor view: list all patients ──────────────────────────────────────────

class _DoctorChatList extends StatelessWidget {
  final String doctorId;
  final String doctorName;

  const _DoctorChatList(
      {required this.doctorId, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('patients')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFF00E5FF)));
        }
        final patients = snapshot.data!.docs;
        if (patients.isEmpty) {
          return _EmptyState(
              message: 'No patients available yet.');
        }
        return ListView.separated(
          padding: EdgeInsets.all(16.w),
          itemCount: patients.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (_, i) {
            final data = patients[i].data() as Map<String, dynamic>;
            final patientId = data['id'] as String? ?? patients[i].id;
            final patientName = data['name'] as String? ?? 'Patient';
            final email = data['email'] as String? ?? '';
            return _ChatTile(
              name: patientName,
              subtitle: email,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    currentUserId: doctorId,
                    currentUserName: doctorName,
                    otherUserId: patientId,
                    otherUserName: patientName,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _ChatTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const _ChatTile(
      {required this.name,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2235),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFF1E2D45)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor:
                  const Color(0xFF00E5FF).withOpacity(0.1),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                    color: const Color(0xFF00E5FF),
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp)),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 3.h),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white38, fontSize: 12.sp)),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white24, size: 14.sp),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              color: Colors.white24, size: 52.sp),
          SizedBox(height: 12.h),
          Text(message,
              style:
                  TextStyle(color: Colors.white38, fontSize: 14.sp)),
        ],
      ),
    );
  }
}
