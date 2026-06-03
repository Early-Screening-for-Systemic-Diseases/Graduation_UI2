import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AgeSelectorWidget extends StatefulWidget {
  final int initialValue;
  final Function(int) onChanged;
  final Color color;

  const AgeSelectorWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.color = Colors.teal,
  });

  @override
  State<AgeSelectorWidget> createState() => _AgeSelectorWidgetState();
}

class _AgeSelectorWidgetState extends State<AgeSelectorWidget> {
  late int _value;

  static const _ageRanges = [
    '18–24', '25–29', '30–34', '35–39', '40–44', '45–49',
    '50–54', '55–59', '60–64', '65–69', '70–74', '75–79', '80+',
  ];

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? const Color(0xFF2A2A3A) : Colors.white;
    final borderColor = isDark ? const Color(0xFF3A3A5A) : Colors.grey.shade200;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: isDark ? const Color(0xFF3A3A5A) : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Age Range', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
          SizedBox(height: 10.h),
          DropdownButtonFormField<int>(
            value: _value,
            dropdownColor: isDark ? const Color(0xFF1E1E2E) : null,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
                borderSide: BorderSide(color: widget.color),
              ),
            ),
            items: List.generate(
              _ageRanges.length,
              (i) => DropdownMenuItem(value: i + 1, child: Text(_ageRanges[i])),
            ),
            onChanged: (v) {
              if (v != null) {
                setState(() => _value = v);
                widget.onChanged(v);
              }
            },
          ),
        ],
      ),
    );
  }
}
