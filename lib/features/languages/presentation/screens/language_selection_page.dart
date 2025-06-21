// lib/features/settings/presentation/screens/language_selection_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  String _selectedCode = 'en';

  final List<_Language> _langs = const [
    _Language(code: 'en', label: 'الإنجليزية', flag: '🇺🇸'),
    _Language(code: 'ar', label: 'العربية',    flag: '🇸🇦'),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'اختيار اللغة',
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 44.h, horizontal: 16.w),
          itemCount: _langs.length,
          itemBuilder: (ctx, idx) {
            final lang = _langs[idx];
            final selected = lang.code == _selectedCode;

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Material(
                elevation: selected ? 4 : 1,
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {
                    setState(() => _selectedCode = lang.code);
                    // TODO: apply locale change
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: selected ? Colors.white : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: selected ? AppColor.purple : Colors.transparent,
                        width: 2.r,
                      ),
                    ),
                    child: Row(
                      children: [

                        Text(lang.flag, style: TextStyle(fontSize: 28.sp)),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            lang.label,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textDarkBlue,
                            ),
                          ),
                        ),
                        // Checkmark
                        Icon(
                          selected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: selected ? AppColor.purple : AppColor.gray3,
                          size: 24.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Language {
  final String code, label, flag;
  const _Language({required this.code, required this.label, required this.flag});
}
