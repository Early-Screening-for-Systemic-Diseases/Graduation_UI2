import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/service/service_locator.dart';
import '../viewmodel/prediction_cubit.dart';
import '../viewmodel/prediction_state.dart';
import 'disease_detail_screen.dart';
import 'diabetes_detail_screen.dart';
import 'skin_cancer_detail_screen.dart';

class TextPredictionScreen extends StatefulWidget {
  final String? filterDisease;
  const TextPredictionScreen({Key? key, this.filterDisease}) : super(key: key);

  @override
  State<TextPredictionScreen> createState() => _TextPredictionScreenState();
}

class _TextPredictionScreenState extends State<TextPredictionScreen> {
  final _textController = TextEditingController();
  late final PredictionCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PredictionCubit>();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E2E) : Colors.white;
    final fieldFill = isDark ? const Color(0xFF2A2A3A) : Colors.grey.shade50;
    final borderColor = isDark ? const Color(0xFF3A3A5A) : Colors.grey.shade200;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<PredictionCubit, PredictionState>(
        listener: (context, state) {
          if (state is TextPredictionSuccess) {
            if (widget.filterDisease != null) {
              final normalizedFilter =
                  widget.filterDisease!.toLowerCase().replaceAll(' ', '');
              final normalizedPrediction =
                  state.response.prediction.toLowerCase().replaceAll(' ', '');

              if (normalizedPrediction == normalizedFilter) {
                final detail = state.response.toDiseaseDetail();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      if (normalizedFilter == 'skincancer') {
                        return SkinCancerDetailScreen(detail: detail);
                      }
                      return DiabetesDetailScreen(detail: detail);
                    },
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('No Match Found'),
                    content: Text(
                      'Your symptoms don\'t match ${widget.filterDisease} indicators. '
                      'Please try describing your symptoms in more detail or consult a healthcare professional.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                );
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiseaseDetailScreen(response: state.response),
                ),
              );
            }
          } else if (state is PredictionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // ── Gradient App Bar ──────────────────────────────
            SliverAppBar(
              expandedHeight: 130.h,
              pinned: true,
              backgroundColor: Colors.teal,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00695C), Colors.teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('💬', style: TextStyle(fontSize: 28.sp)),
                          SizedBox(height: 4.h),
                          Text(
                            'Symptom Analysis',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Describe how you feel in your own words',
                            style: TextStyle(fontSize: 12.sp, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Content ───────────────────────────────────────
            SliverPadding(
              padding: EdgeInsets.all(20.w),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Section header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.teal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.edit_note_rounded, color: Colors.teal, size: 16.sp),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Your Symptoms',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Text field card
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Describe your symptoms',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 10.h),
                        TextField(
                          controller: _textController,
                          maxLines: 6,
                          style: TextStyle(fontSize: 14.sp),
                          decoration: InputDecoration(
                            hintText: 'e.g., I am really tired and feel weak, my skin looks pale...',
                            hintStyle: TextStyle(
                              color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                              fontSize: 13.sp,
                            ),
                            filled: true,
                            fillColor: fieldFill,
                            contentPadding: EdgeInsets.all(14.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Submit button
                  BlocBuilder<PredictionCubit, PredictionState>(
                    builder: (context, state) {
                      final loading = state is PredictionLoading;
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00695C), Colors.teal],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () {
                                  if (_textController.text.trim().isNotEmpty) {
                                    _cubit.predictFromText(_textController.text.trim());
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            minimumSize: Size(double.infinity, 54.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Analyze Symptoms',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 32.h),
                ]),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}
