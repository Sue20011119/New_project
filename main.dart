import "package:flutter/material.dart";
import "package:my_topic_project/login.dart";
import "package:my_topic_project/MysqlInterface.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//印出資料庫資料的入口
// void main() => runApp(PrintInterface());

//新增資料庫資料的入口
void main() => runApp(CreateInterface());

//APP啟動的入口
// void main() => runApp(MyApp());

//通知測試的入口
// void main() => runApp(NoticePage());



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
    );
  }
}

