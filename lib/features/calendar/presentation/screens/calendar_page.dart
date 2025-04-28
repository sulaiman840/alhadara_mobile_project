
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:alhadara_mobile_project/core/utils/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/routes_names.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

class _Event {
  String title;
  String type;
  _Event({required this.title, required this.type});
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final Map<DateTime, List<_Event>> _events = {
    DateTime.utc(2025, 4, 1): [ _Event(title: 'عيد الفطر', type: 'عطلة') ],
    DateTime.utc(2025, 4, 10): [ _Event(title: 'عيد الاضحى', type: 'عطلة') ],
    DateTime.utc(2025, 4, 20): [ _Event(title: 'اجتماع المعهد', type: 'حدث') ],
    DateTime.utc(2025, 4, 17): [ _Event(title: 'عيد الجلاء', type: 'مناسبة') ],
  };

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
    final firstWeekday = DateTime(_focusedDay.year, _focusedDay.month, 1).weekday % 7;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CustomAppBar(
          title: 'التقويم',
          onBack: () => context.go(AppRoutesNames.activity),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Text(
                '${_monthName(_focusedDay.month)} ${_focusedDay.year}',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,color: AppColor.textDarkBlue),
              ),
            ),

            AspectRatio(
              aspectRatio: 1.3,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4.w,
                  mainAxisSpacing: 4.h,
                ),
                itemCount: daysInMonth + firstWeekday,
                itemBuilder: (ctx, idx) {
                  if (idx < firstWeekday) return const SizedBox();
                  final day = idx - firstWeekday + 1;
                  final date = DateTime.utc(_focusedDay.year, _focusedDay.month, day);
                  final isSelected = date == _selectedDay;
                  final hasEvent = (_events[date]?.isNotEmpty ?? false);

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedDay = date);
                    },
                    child: Container(
                      margin: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColor.purple : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              '$day',
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColor.textDarkBlue,
                              ),
                            ),
                          ),
                          if (hasEvent)
                            Positioned(
                              bottom: 4.h,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 6.r,
                                  height: 6.r,
                                  decoration: BoxDecoration(
                                    color: AppColor.purple,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'أحداث ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,color: AppColor.textDarkBlue),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: (_events[_selectedDay]?.isNotEmpty ?? false)
                          ? ListView.builder(
                        itemCount: _events[_selectedDay]!.length,
                        itemBuilder: (ctx, i) {
                          final ev = _events[_selectedDay]![i];
                          Color bg;
                          switch (ev.type) {
                            case 'عطلة':
                              bg = AppColor.purple2;
                              break;
                            case 'فعالية':
                              bg = AppColor.purple2;
                              break;
                            case 'حدث':
                              bg =AppColor.purple2;
                              break;
                            default:
                              bg = AppColor.purple2;
                          }
                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ev.title,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColor.white),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      size: 20.r, color: AppColor.textDarkBlue),
                                  onPressed: () => _showEventDialog(
                                    editDate: _selectedDay,
                                    index: i,
                                    existing: ev,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      size: 20.r, color: Colors.redAccent),
                                  onPressed: () {
                                    setState(() {
                                      _events[_selectedDay]!.removeAt(i);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                          : Center(
                        child: Text(
                          'لا توجد أحداث لهذا اليوم.',
                          style: TextStyle(color: AppColor.gray3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.purple,
          child: const Icon(Icons.add),
          onPressed: () => _showEventDialog(editDate: _selectedDay),
        ),
      ),
    );
  }

  void _showEventDialog({
    required DateTime editDate,
    int? index,
    _Event? existing,
  }) {
    final titleCtl = TextEditingController(text: existing?.title ?? '');
    final typeCtl = TextEditingController(text: existing?.type ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(backgroundColor: AppColor.purple,
        title: Text(style: TextStyle(color: AppColor.white),
          existing == null ? 'إضافة حدث' : 'تعديل حدث',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(style: TextStyle(color:AppColor.white ),
              controller: titleCtl,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
            TextField(style: TextStyle(color:AppColor.white ),
              controller: typeCtl,
              decoration:
              const InputDecoration(labelText: 'النوع (عطلة، فعالية، ...)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColor.white),
              foregroundColor: WidgetStateProperty.all(AppColor.textDarkBlue),
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              elevation: WidgetStateProperty.all(0),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
              ),
            ),
            onPressed: () {
              final t = titleCtl.text.trim();
              final ty = typeCtl.text.trim();
              if (t.isEmpty || ty.isEmpty) return;
              setState(() {
                final list = _events.putIfAbsent(editDate, () => []);
                if (existing != null && index != null) {
                  list[index] = _Event(title: t, type: ty);
                } else {
                  list.add(_Event(title: t, type: ty));
                }
              });
              Navigator.of(ctx).pop();
            },

            child: Text('حفظ'),
          ),

        ],
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return names[m - 1];
  }
}
