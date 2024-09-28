import 'package:shared_preferences/shared_preferences.dart';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  TodoRepository() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

}
