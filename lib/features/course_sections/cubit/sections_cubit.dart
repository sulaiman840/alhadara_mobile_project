
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/sections_repository.dart';
import '../data/models/section_model.dart';

part 'sections_state.dart';

class SectionsCubit extends Cubit<SectionsState> {
  final SectionsRepository _repository;

  SectionsCubit(this._repository) : super(SectionsInitial());

  void fetchSections(int courseId) async {
    emit(SectionsLoading());
    try {
      final sections = await _repository.fetchPendingSections(courseId);
      emit(SectionsSuccess(sections));
    } catch (e) {
      emit(SectionsFailure(e.toString()));
    }
  }

  /// Attempts to register into the given section. Returns an Arabic message.
  Future<String> registerIntoSection(int sectionId) async {
    try {
      final rawMessage = await _repository.registerSection(sectionId);

      // rawMessage is English, e.g.:
      //   "Your reservation has been successfully completed. Please pay within 48 hours."
      //   or "You have already booked here. You cannot book twice."

      if (rawMessage.toLowerCase().contains("successfully")) {
        return "تم إتمام الحجز بنجاح. الرجاء الدفع في غضون ٤٨ ساعة.";
      } else if (rawMessage.toLowerCase().contains("already")) {
        return "لقد قمت بالحجز مسبقًا. لا يمكنك الحجز مرتين.";
      } else {
        // Fallback if server returned something else:
        return "تمت العملية بنجاح.";
      }
    } on Exception catch (e) {
      // If anything goes wrong (e.g. network error, 400/500 without "message" field, etc.)
      // return "حدث خطأ أثناء محاولة الحجز. يرجى المحاولة مرة أخرى لاحقًا.";
      return "لقد قمت بالحجز مسبقًا. لا يمكنك الحجز مرتين.";

    }
  }
}
