import "package:flutter/material.dart";
import "package:my_topic_project/login.dart";
import "package:my_topic_project/MysqlInterface.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';


//印出資料庫資料的入口
// void main() => runApp(PrintInterface());

//新增資料庫資料的入口
// void main() => runApp(CreateInterface());

//APP啟動的入口
void main() async{
  runApp(MyApp());
  await AndroidAlarmManager.initialize();
}

//通知測試的入口
// void main() => runApp(NoticePage());

//定時測試的入口
// void main() async{
//   runApp(NotifyPage());
//   await AndroidAlarmManager.initialize();
// }

//測試入口
// void main() => runApp(Testface());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "失語症復健紀錄APP",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, //主题顏色樣本
      ),
      debugShowCheckedModeBanner: false,  //不顯示上方debug的物件
      home: const LoginPage(),  //第一頁，到登入畫面
      //調整全部字體大小
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
    );
  }
}

