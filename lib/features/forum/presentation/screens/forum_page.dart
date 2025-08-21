import 'package:alhadara_mobile_project/features/forum/presentation/widgets/loc_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/navigation/routes_names.dart';
import '../../../../core/utils/const.dart';
import '../../../../shared/widgets/app_bar/custom_app_bar.dart';
import '../../cubit/forum_cubit.dart';
import '../../cubit/forum_state.dart';
import '../widgets/forum_page_widgets/forum_body.dart';
import '../widgets/forum_page_widgets/new_question_fab.dart';

/// ===== Root page =====
class ForumPage extends StatelessWidget {
  final int sectionId;

  const ForumPage({super.key, required this.sectionId});

  Future<int> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _loadCurrentUserId(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        final meId = snap.data ?? 0;

        return Directionality(
          textDirection: context.dir,
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: context.trf('forum_title', ar: 'المنتدى', en: 'Forum'),
              onBack: () => context.go(AppRoutesNames.home),
            ),
            floatingActionButton: NewQuestionFab(sectionId: sectionId),
            body: ForumBody(sectionId: sectionId, meId: meId),
          ),
        );
      },
    );
  }
}











