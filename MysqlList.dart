import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";

// 設定所有頁面傳值的數據的格式
//DataMenu
class AllPagesNeedData {
  AllPagesNeedData(this.id, this.account, this.page);

  String id;
  String account;
  String page;
}

//調整字體大小
//textScaleFactor: choosetextscale(DataMenu),
// double choosetextscale(List<AllPagesNeedData> DataMenu) {
//   return DataMenu[0].textscale == 0
//       ? 0.8
//       : DataMenu[0].textscale == 5
//           ? 1
//           : 1.1;
// }

//設定登入的MysqlData的格式
//MysqlMenu
class MysqlDataOflogin_patient_database {
  MysqlDataOflogin_patient_database(this.id, this.account, this.password);

  String id;
  String account;
  String password;
}

//設定病患復健紀錄的MysqlData的格式
//MysqlMenu
class MysqlDataOfpatient_rehabilitation {
  MysqlDataOfpatient_rehabilitation(
      this.id, this.time, this.type, this.score);

  final String id;
  final DateTime time;
  final String type;
  final int score;
}

//設定使用者個人的MysqlData的格式
//PersonalMenu
class MysqlDataOfPersonal {
  MysqlDataOfPersonal(this.id, this.name, this.gender);

  String id;
  String name;
  String gender;
}

//設定復健題目的格式
//TopicMenu
class TopicData {
  TopicData(this.title, this.topic, this.path, this.type);

  String title;
  String topic;
  String path;
  String type;
}



//設定轉跳網址的listview_menu的格式
// listview_menu
class ListViewMenuData {
  ListViewMenuData(this.name, this.url);

  final String name;
  final String url;
}

//設定暗黑模式與非暗黑模式的物件顏色
// DarkMode(DataMenu[0].isdark, "background", Colors.black, Colors.white),
// DarkMode(DataMenu[0].isdark, "Text", Colors.black, Colors.white),
// DarkMode(bool isdark, String object,
//     [Color deep_color = Colors.black, Color pale_color = Colors.white]) {
//   Color? self_color;
//   switch (object) {
//     case "background":
//       //是深色模式嗎?是的話背景黑色，不是的話背景白色(自訂色)
//       isdark ? self_color = deep_color : self_color = pale_color;
//       break;
//
//     //是深色模式嗎?不是的話字黑色(自訂色)，是的話字白色
//     case "Text":
//       !isdark ? self_color = deep_color : self_color = pale_color;
//       break;
//
//     default:
//       print("ERROR，for ");
//   }
//   // print("DarkMode(bool isdark=$isdark,"
//   //     " String object=$object,"
//   //     " [Color deep_color = $deep_color,"
//   //     " Color pale_color = $pale_color])");
//   return self_color;
// }

//印出list的function
PrintList(String page, String class_object, List list) {
  switch (class_object) {
    //個人資料
    case "MysqlDataOfPersonal":
      print("$page is id:${list[0].id}, "
          "name:${list[0].name}, "
          "gender:${list[0].gender}, ");
      break;

    //頁面所需資料
    case "AllPagesNeedData":
      print("$page is id:${list[0].id}, "
          "account:${list[0].account}, "
          "page:${list[0].page}"
      );
      break;

    //病患復健資料
    case "MysqlDataOfpatient_rehabilitation":
      print("$page is id:${list[0].id}, "
          "name:${list[0].name}, "
          "time:${list[0].time}, "
          "type:${list[0].type}, "
          "score:${list[0].score}, ");
      break;

    case "ExpansionPanelListData":
      print("$page is isread:${list[0].isread}, "
          "detail:${list[0].detail}, "
          "date:${list[0].date}, "
          "isread:${list[0].isread}");
      break;

    default:
      print("ERROR，for List list=$list, String object=$class_object");
      return;
  }
}
