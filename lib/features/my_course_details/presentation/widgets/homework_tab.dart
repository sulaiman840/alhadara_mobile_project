import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:alhadara_mobile_project/core/utils/const.dart';
import 'package:alhadara_mobile_project/core/localization/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../shared/widgets/pdf_viewer_page.dart';
import '../../cubit/section_files_cubit.dart';
import '../../cubit/section_files_state.dart';

class HomeworkTab extends StatelessWidget {
  final int sectionId;
  final AppLocalizations loc;

  const HomeworkTab({
    super.key,
    required this.sectionId,
    required this.loc,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SectionFilesCubit, SectionFilesState>(
      builder: (ctx, state) {
        if (state is SectionFilesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SectionFilesError) {
          return Center(child: Text(state.message));
        }
        final files = (state as SectionFilesLoaded).files;
        if (files.isEmpty) {
          return Center(child: Text(loc.tr('no_homework_yet')));
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
          itemCount: files.length,
          separatorBuilder: (_, __) => Divider(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          itemBuilder: (_, i) {
            final f = files[i];
            final url = '${ConstString.baseURl}${f.filePath}';
            return ListTile(
              leading: FaIcon(FontAwesomeIcons.solidFilePdf,
                  size: 28.r, color: Colors.redAccent),
              title: Text(
                f.fileName,
                style: theme.textTheme.bodyLarge!
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
              subtitle: Text(
                '${loc.tr('homework_created_label')}: '
                    '${f.createdAt.day}/${f.createdAt.month}/${f.createdAt.year}',
                style: theme.textTheme.bodySmall!
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.download_rounded),
                tooltip: loc.tr('download_pdf_tooltip'),
                onPressed: () async {
                  final status = await Permission.storage.request();
                  if (!status.isGranted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.tr('no_storage_permission'))));
                    return;
                  }
                  final baseDir = await getExternalStorageDirectory();
                  final dir = Directory('${baseDir!.path}/Download');
                  if (!dir.existsSync()) dir.createSync(recursive: true);
                  await FlutterDownloader.enqueue(
                    url: url,
                    savedDir: dir.path,
                    fileName: f.fileName,
                    showNotification: true,
                    openFileFromNotification: true,
                  );
                },
              ),
              onTap: () => _openPdf(context, url),
            );
          },
        );
      },
    );
  }

  void _openPdf(BuildContext context, String url) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViewerPage(url: url)));
  }
}
