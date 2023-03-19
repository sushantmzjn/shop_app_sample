import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_app/view/home_page.dart';
import 'package:shop_app/view/login_page.dart';
import 'package:shop_app/view/status_page.dart';

import 'model/user.dart';

final box = Provider<List<User>>((ref) => []);

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  final userBox = await Hive.openBox<User>('user');

  runApp(ProviderScope(
      overrides: [box.overrideWithValue(userBox.values.toList())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Nunito',
            ),
            home: StatusPage());
      },
    );
  }
}
