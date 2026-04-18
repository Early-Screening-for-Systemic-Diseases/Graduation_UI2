import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/service/service_locator.dart';
import '../data/model/anemia_survey_model.dart';
import '../viewmodel/prediction_cubit.dart';
import '../viewmodel/prediction_state.dart';
import 'text_prediction_screen.dart';

class AnemiaSurveyScreen extends StatefulWidget {
  const AnemiaSurveyScreen({super.key});

  @override
  State<AnemiaSurveyScreen> createState() => _AnemiaSurveyScreenState();
}

class _AnemiaSurveyScreenState extends State<AnemiaSurveyScreen> {
  int _age = 25;
  int _gender = 2;
  int _ethnicity = 3;
  int _diabetes = 2;
  int _hypertension = 2;
  int _heartCondition = 2;
  int _asthma = 2;

  late final PredictionCubit _predictionCubit;
  static const _color = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    _predictionCubit = getIt<PredictionCubit>();
  }

  void _submitForm() {
    _predictionCubit.predictAnemiaSurvey(AnemiaSurveyModel(
      age: _age,
      gender: _gender,
      ethnicity: _ethnicity,
      diabetes: _diabetes,
      hypertension: _hypertension,
      heartCondition: _heartCondition,
      asthma: _asthma,
    ).toJson());
  }

  void _showResultSheet(PredictionSuccess state) {
    final isAnemic = state.prediction == '1';
    final resultColor = isAnemic ? Colors.red : Colors.green;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.all(28.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w, height: 4.h,
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2.r)),
            ),
            SizedBox(height: 24.h),
            Container(
              width: 72.w, height: 72.w,
              decoration: BoxDecoration(color: resultColor.withOpacity(0.12), shape: BoxShape.circle),
              child: Icon(
                isAnemic ? Icons.warning_rounded : Icons.check_circle_rounded,
                color: resultColor, size: 38.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text('Analysis Complete', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
            SizedBox(height: 6.h),
            Text(
              isAnemic ? 'Anemia Detected' : 'No Anemia',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: resultColor),
            ),
            SizedBox(height: 6.h),
            Text(
              'Probability: ${(state.probability * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade600),
            ),
            if (state.message.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade500),
              ),
            ],
            SizedBox(height: 28.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const TextPredictionScreen(filterDisease: 'anemia')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _color,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                ),
                child: Text('Continue', style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  Widget _binaryRow(String label, int value, void Function(int) onChanged) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, height: 1.4)),
          SizedBox(height: 12.h),
          Row(
            children: [
              _toggleBtn('No', 2, value, onChanged),
              SizedBox(width: 8.w),
              _toggleBtn('Yes', 1, value, onChanged),
            ],
          ),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, int val, int current, void Function(int) onChanged) {
    final selected = current == val;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => onChanged(val)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? _color : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: selected ? _color : Colors.grey.shade300),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _predictionCubit,
      child: BlocListener<PredictionCubit, PredictionState>(
        listener: (context, state) {
          if (state is PredictionSuccess && ModalRoute.of(context)?.isCurrent == true) {
            _showResultSheet(state);
          } else if (state is PredictionError && ModalRoute.of(context)?.isCurrent == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              // ── Gradient App Bar ──────────────────────────────
              SliverAppBar(
                expandedHeight: 150.h,
                pinned: true,
                backgroundColor: _color,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB71C1C), Colors.redAccent],
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
                            Text('🩸', style: TextStyle(fontSize: 30.sp)),
                            SizedBox(height: 4.h),
                            Text('Anemia Survey', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('Answer honestly for best results', style: TextStyle(fontSize: 13.sp, color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.all(20.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Demographics ────────────────────────────
                    _SurveySection(title: 'Demographics', icon: Icons.person_rounded, color: _color),
                    SizedBox(height: 12.h),

                    // Age input
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Age (years)', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                          SizedBox(height: 10.h),
                          TextFormField(
                            initialValue: _age.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Enter age (1–120)',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                borderSide: const BorderSide(color: _color),
                              ),
                            ),
                            onChanged: (v) {
                              final age = int.tryParse(v);
                              if (age != null && age >= 1 && age <= 120) setState(() => _age = age);
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Gender
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Biological Sex', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              _toggleBtn('Male', 1, _gender, (v) => _gender = v),
                              SizedBox(width: 8.w),
                              _toggleBtn('Female', 2, _gender, (v) => _gender = v),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Ethnicity
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ethnicity', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                          SizedBox(height: 10.h),
                          DropdownButtonFormField<int>(
                            value: _ethnicity,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade200)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.grey.shade200)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: _color)),
                            ),
                            items: const [
                              DropdownMenuItem(value: 1, child: Text('Mexican American')),
                              DropdownMenuItem(value: 2, child: Text('Other Hispanic')),
                              DropdownMenuItem(value: 3, child: Text('Non-Hispanic White')),
                              DropdownMenuItem(value: 4, child: Text('Non-Hispanic Black')),
                              DropdownMenuItem(value: 5, child: Text('Other or Mixed')),
                            ],
                            onChanged: (v) => setState(() => _ethnicity = v!),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Medical History ──────────────────────────
                    _SurveySection(title: 'Medical History', icon: Icons.medical_services_rounded, color: _color),
                    SizedBox(height: 12.h),

                    _binaryRow('Have you ever been told by a doctor that you have diabetes?', _diabetes, (v) => _diabetes = v),
                    SizedBox(height: 10.h),
                    _binaryRow('Have you ever been diagnosed with high blood pressure (hypertension)?', _hypertension, (v) => _hypertension = v),
                    SizedBox(height: 10.h),
                    _binaryRow('Have you ever been diagnosed with a heart condition?', _heartCondition, (v) => _heartCondition = v),
                    SizedBox(height: 10.h),
                    _binaryRow('Have you ever been diagnosed with asthma?', _asthma, (v) => _asthma = v),

                    SizedBox(height: 32.h),

                    BlocBuilder<PredictionCubit, PredictionState>(
                      builder: (context, state) {
                        final loading = state is PredictionLoading;
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFB71C1C), Colors.redAccent]),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [BoxShadow(color: _color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
                          ),
                          child: ElevatedButton(
                            onPressed: loading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              minimumSize: Size(double.infinity, 54.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                                      SizedBox(width: 8.w),
                                      Text('Analyze Survey', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)),
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

class _SurveySection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  const _SurveySection({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8.r)),
          child: Icon(icon, color: color, size: 16.sp),
        ),
        SizedBox(width: 8.w),
        Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
