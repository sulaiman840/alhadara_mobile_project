import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/TextFormField/custom_text_form_field.dart';
import '../../../../shared/widgets/buttons/custom_button.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class InitialSurveyPage extends StatefulWidget {
  const InitialSurveyPage({Key? key}) : super(key: key);

  @override
  _InitialSurveyPageState createState() => _InitialSurveyPageState();
}

class _InitialSurveyPageState extends State<InitialSurveyPage> {
  final _specialtyController = TextEditingController();
  final _hobbyController     = TextEditingController();

  final Map<String, bool> _interests = {
    'البرمجة': false,
    'التصميم': false,
    'الطبخ': false,
    'السياحة': false,
    'اللغة الألمانية': false,
    'اللغة الإنجليزية': false,
  };

  @override
  void dispose() {
    _specialtyController.dispose();
    _hobbyController.dispose();
    super.dispose();
  }

  void _submit() {
    // Example validation:
    if (_specialtyController.text.isEmpty || _hobbyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
      );
      return;
    }
    if (!_interests.values.any((v) => v)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار اهتمام واحد على الأقل')),
      );
      return;
    }

    // TODO: send data to your backend…

    // Then navigate on:
    // GoRouter.of(context).go(AppRoutesNames.home);
  }

  Widget _buildInterestCheckbox(String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(activeColor: AppColor.purple2,
          value: _interests[label],
          onChanged: (b) => setState(() => _interests[label] = b!),
        ),
        Text(label, style: TextStyle(fontSize: 16.sp,color: AppColor.textDarkBlue,)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'رجاء قم بتعبئة هذه الاستبيان الأولي',
          onBack: () => context.go(AppRoutesNames.login),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 16.h),

                // two text fields
                CustomTextFormField(
                  controller: _specialtyController,
                  hintText: 'الاختصاص',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 12.h),
                CustomTextFormField(
                  controller: _hobbyController,
                  hintText: 'الهواية',
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 24.h),

                // Interests section
                Text(
                  'الاهتمامات',
                  style: TextStyle(
                    fontSize: 18.sp,color: AppColor.textDarkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),

                // layout them in rows
                Wrap(
                  spacing: 20.w,
                  runSpacing: 8.h,
                  children: _interests.keys
                      .map((label) => _buildInterestCheckbox(label))
                      .toList(),
                ),

                SizedBox(height: 75.h),
                CustomButton(
                  text: 'تأكيد',
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
