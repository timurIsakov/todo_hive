import 'package:flutter/cupertino.dart';

import '../core/local_api/task_local_api.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;

  changeTheme() async {
    print("Call function 'saveTheme'");
    isDark = !isDark;
    await TaskLocalApi.saveTheme(isDark);
    notifyListeners();
  }

  getTheme() async {
    print("Call function 'getTheme'");
    isDark = await TaskLocalApi.getTheme();
    notifyListeners();
  }
}
