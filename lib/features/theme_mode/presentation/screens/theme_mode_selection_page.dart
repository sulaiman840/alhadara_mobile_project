
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class ThemeModeSelectionPage extends StatefulWidget {
  const ThemeModeSelectionPage({Key? key}) : super(key: key);

  @override
  _ThemeModeSelectionPageState createState() => _ThemeModeSelectionPageState();
}

class _ThemeModeSelectionPageState extends State<ThemeModeSelectionPage> {
  String _selectedMode = 'system';

  final List<_ModeOption> _options = const [
    _ModeOption(key: 'light',  label: 'الوضع الفاتح', icon: Icons.wb_sunny_rounded),
    _ModeOption(key: 'dark',   label: 'الوضع الداكن', icon: Icons.nights_stay_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'تغيير وضع العرض',
          onBack: () => context.go(AppRoutesNames.settings),
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(vertical:44.h, horizontal: 16.w),
          itemCount: _options.length,
          itemBuilder: (ctx, idx) {
            final opt = _options[idx];
            final selected = opt.key == _selectedMode;

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Material(
                elevation: selected ? 4 : 1,
                borderRadius: BorderRadius.circular(12.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.r),
                  onTap: () {
                    setState(() => _selectedMode = opt.key);
                    // TODO: apply theme mode change
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: selected ? AppColor.purple : Colors.transparent,
                        width: 2.r,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Mode icon
                        Icon(opt.icon, color: AppColor.purple, size: 28.r),
                        SizedBox(width: 16.w),
                        // Label
                        Expanded(
                          child: Text(
                            opt.label,
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

class _ModeOption {
  final String key, label;
  final IconData icon;
  const _ModeOption({required this.key, required this.label, required this.icon});
}
