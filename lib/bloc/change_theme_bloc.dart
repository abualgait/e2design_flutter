import 'package:bloc/bloc.dart';
import 'change_theme_event.dart';
import 'change_theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  double fontSize = 12.0;

  void onLightThemeChange(double fontSize) =>
      {add(LightTheme()), this.fontSize = fontSize};

  void onDarkThemeChange(double fontSize) =>
      {add(DarkTheme()), this.fontSize = fontSize};

  void onDecideThemeChange() => add(DecideTheme());

  @override
  ChangeThemeState get initialState => ChangeThemeState.lightTheme(fontSize);

  @override
  Stream<ChangeThemeState> mapEventToState(ChangeThemeEvent event) async* {
    if (event is DecideTheme) {
      final int optionValue = await getOption();
      if (optionValue == 0) {
        yield ChangeThemeState.lightTheme(fontSize);
      } else if (optionValue == 1) {
        yield ChangeThemeState.darkTheme(fontSize);
      }
    }
    if (event is LightTheme) {
      yield ChangeThemeState.lightTheme(fontSize);
      try {
        _saveOptionValue(0);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }

    if (event is DarkTheme) {
      yield ChangeThemeState.darkTheme(fontSize);
      try {
        _saveOptionValue(1);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }
  }

  Future<Null> _saveOptionValue(int optionValue) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('theme_option', optionValue);
  }

  Future<int> getOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int option = preferences.get('theme_option') ?? 0;
    return option;
  }
}

final ChangeThemeBloc changeThemeBloc = ChangeThemeBloc()
  ..onDecideThemeChange();
