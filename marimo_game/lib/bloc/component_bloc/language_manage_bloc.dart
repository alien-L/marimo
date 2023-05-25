import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marimo_game/app_manage/language.dart';

class LanguageManageBloc extends Cubit<Language>{
  LanguageManageBloc(super.initialState);

    changeLanguage(Language language){
      emit(language);
    }

}