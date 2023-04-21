import 'dart:ffi';

// import 'dart:html';
import "package:my_topic_project/main.dart";
import 'package:flutter/material.dart';
import 'package:my_topic_project/login.dart';
import 'package:my_topic_project/JumpPage.dart';
import 'package:mysql1/mysql1.dart';
import 'package:my_topic_project/ConnectMysql.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';
import 'package:my_topic_project/MysqlList.dart';

//通知+計時
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

//SQLite
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class MainPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  MainPage(this.DataMenu);

  @override
  _MainPageState createState() => _MainPageState();
}

//建構全畫面
class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  bool back = false;
  List<MysqlDataOfPersonal> PersonalMenu = []; //個人資料
  List<AllPagesNeedData> DataMenu = []; //頁面所需資料
  late List<Widget> pages = [
    HomePage(DataMenu),
    RecordPage(DataMenu),
    NewMessagePage(DataMenu),
    AboutUsPage(DataMenu),
  ];

  var db = new Mysql();
  String personal_name = "";
  String personal_gender = "";

  //延遲取得資料庫資料，因為會有非同步的情況
  Future _delayText() async {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        personal_name = PersonalMenu[0].name.toString();
        personal_gender = PersonalMenu[0].gender.toString();
      });
    });
  }

  //取得Mysql裡patient_database資料表的資料
  _getMysqlData() {
    PersonalMenu.clear(); //初始化列表
    db.getConnection().then((conn) {
      String sql =
          "SELECT * FROM patient_database WHERE account='${DataMenu[0].account}'";
      conn.query(sql).then((results) {
        print("連線成功!");
        for (var row in results) {
          // print(row);
          setState(() {
            PersonalMenu.add(
                MysqlDataOfPersonal(row['id'], row['name'], row['gender']));
            personal_name = PersonalMenu[0].name.toString();
            personal_gender = PersonalMenu[0].gender.toString();
          });
        }
      });
      conn.close();
    });
    // .then((value) => _delayText());
  }

  //在主畫面按下返回鍵
  Future<bool> RequestPop() async {
    //登出提示框
    showAlertDialog(context, DataMenu);
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    DataMenu = widget.DataMenu;
    _getMysqlData();
    DataMenu[0].page = "MainPage";
    PrintList(DataMenu[0].page, "AllPagesNeedData", DataMenu);
  }

  @override
  Widget build(BuildContext context) {
    //返回鍵
    return WillPopScope(
      onWillPop: RequestPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 20,
          unselectedFontSize: 18,
          iconSize: 30,
          selectedItemColor: Colors.grey.shade900,
          unselectedItemColor: Colors.grey.shade700,
          selectedIconTheme: const IconThemeData(
            size: 42,
          ),
          unselectedIconTheme: const IconThemeData(
            size: 32,
          ),
          currentIndex: currentIndex,
          onTap: (int idx) {
            setState(() {
              currentIndex = idx;
              //防止其他頁跟著跳回來，觀感不佳
              // idx == 0
              idx == 0 &&
                      DataMenu[0].page != "MainPage" &&
                      DataMenu[0].page != "HomePage" &&
                      DataMenu[0].page != "RecordPage" &&
                      DataMenu[0].page != "NewMessagePage" &&
                      DataMenu[0].page != "AboutUsPage"
                  ? Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MainPage(DataMenu),
                        ),
                      )
                  : null;

              DataMenu[0].page = pages[currentIndex].toString();
              PrintList(DataMenu[0].page, "AllPagesNeedData", DataMenu);
            });
          },
          items: [
            buildBottomNavigationBarView("lib/images/bottom_return.png",
                Colors.redAccent.shade400, "返回", DataMenu),
            buildBottomNavigationBarView("lib/images/bottom_record.png",
                Colors.yellow.shade400, "使用紀錄", DataMenu),
            buildBottomNavigationBarView("lib/images/bottom_notify.png",
                Colors.lightGreen.shade400, "新訊息", DataMenu),
            buildBottomNavigationBarView("lib/images/bottom_info.png",
                Colors.blue.shade300, "關於", DataMenu),
          ],
        ),
        body: pages[currentIndex],
      ),
    );
  }
}

// 顯示確認登出對話框
void showAlertDialog(BuildContext context, List<AllPagesNeedData> DataMenu) {
  // Init
  AlertDialog dialog = AlertDialog(
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    title: RichText(
      text: const TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.warning,
              size: 30,
              color: Colors.yellow,
            ),
          ),
          TextSpan(
            text: "您確定要登出嗎?",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),
    actions: [
      Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: const Text(
                "取消",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(
              width: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text(
                "登出",
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    ],
  );

  // Show the dialog (showDialog() => showGeneralDialog())
  //登出確認框的動畫
  showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Wrap();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform(
        transform: Matrix4.translationValues(
          0.0,
          (1.0 - Curves.easeInOut.transform(anim1.value)) * 400,
          0.0,
        ),
        child: dialog,
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

// 首頁，主要頁面
class HomePage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  HomePage(this.DataMenu);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;
  List<MysqlDataOfPersonal> PersonalMenu = []; //個人資料
  String id = ""; //病患編號
  String name = ""; //姓名
  int coin = 100; //病患的虛擬幣
  final List<GridViewMenuData> menu = [
    GridViewMenuData(
        0, 'lib/images/hands.png', '需求表達', Colors.orangeAccent.shade100),
    GridViewMenuData(
        1, 'lib/images/rehabilitation.png', '復健訓練', Colors.indigo.shade200),
    GridViewMenuData(2, 'lib/images/phone.png', '諮詢社群', Colors.green.shade300),
    GridViewMenuData(3, 'lib/images/settings.png', '設定', Colors.grey),
  ];

  _getMysqlData() {
    // PersonalMenu.clear(); //初始化列表
    db.getConnection().then((conn) {
      String sql =
          "SELECT * FROM patient_database WHERE id='${DataMenu[0].id}'";
      conn.query(sql).then((results) {
        print("連線成功!");
        for (var row in results) {
          print(row);
          setState(() {
            PersonalMenu.add(
                MysqlDataOfPersonal(row['id'], row['name'], row['gender']));
            id = PersonalMenu[0].id.toString();
            name = PersonalMenu[0].name.toString();
            coin = row['coin'];
            // print("diagnosis_left:$diagnosis_left");
            // print("diagnosis_right:$diagnosis_right");
            // print("diagnosis_hemorrhagic:$diagnosis_hemorrhagic");
            // print("diagnosis_ischemic:$diagnosis_ischemic");
            // print("affected_side_left:$affected_side_left");
            // print("affected_side_right:$affected_side_right");
          });
        }
      });
      conn.close();
    });
  }
  
  @override
  void initState() {
    super.initState();
    DataMenu = widget.DataMenu;
    _getMysqlData();
  }


  @override
  Widget build(BuildContext context) {

    void PushPage(){
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => TrainPage(DataMenu)),
      );
    }


    return MaterialApp(
      debugShowCheckedModeBanner: false, //不顯示上方debug的物件
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
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  right: 20.0,
                  left: 20.0,
                  bottom: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hello",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ],
            ),
            const Text(
              "繼續努力加油!!!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: Image.asset(
                        'lib/images/coin.png',
                        width: 70,
                        height: 70,
                      )),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "金幣數量：$coin",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              //移除上面出現的白色部分
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.builder(
                  itemCount: menu.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    //寬高比
                    childAspectRatio: 4.5,
                    crossAxisCount: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {});
                        switch (index) {
                          //需求表達頁面
                          case 0:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PhysiologicalPage1(DataMenu)),
                            );
                            break;

                          //復健訓練頁面
                          case 1:
                            PushPage();
                            break;

                          //諮詢社群頁面
                          case 2:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommunityCommunicationPage(DataMenu)),
                            );
                            break;

                          //設定頁面
                          case 3:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BasicSettingsPage(DataMenu)),
                            );
                            break;
                        }
                      },
                      child: Material(
                        color: menu[index].self_color,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 30,
                            ),
                            Image.asset(
                              menu[index].image,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 120,
                              alignment: Alignment.center,
                              child: Text(
                                menu[index].title,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//復健紀錄頁面
class RecordPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  RecordPage(this.DataMenu);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;

  //取得Mysql裡patient_rehabilitation資料表的資料
  Future _getMysqlData() async {
    MysqlMenu.clear(); //初始化列表
    db.getConnection().then((conn) {
      String sql =
          "SELECT * FROM patient_rehabilitation WHERE id='${DataMenu[0].id}'";
      conn.query(sql).then((results) {
        print("連線成功!");
        for (var row in results) {
          setState(() {
            if ((row['time'].difference(DateTime.now()).inDays).abs() <= 7) {
              MysqlMenu.add(MysqlDataOfpatient_rehabilitation(
                  row['id'], row['time'], row['type'], row['score']));
            }
          });
        }
      });
      conn.close();
    });
  }

  @override
  void initState() {
    super.initState();
    _getMysqlData();
    DataMenu = widget.DataMenu;
  }

  @override
  Widget build(BuildContext context) {
    //分隔線顏色
    Widget divider0 = const Divider(
      color: Colors.red,
      thickness: 2,
    );
    Widget divider1 = const Divider(
      color: Colors.orange,
      thickness: 2,
    );
    Widget divider2 = Divider(
      color: Colors.yellow.shade600,
      thickness: 2,
    );
    Widget divider3 = const Divider(
      color: Colors.green,
      thickness: 2,
    );
    Widget divider4 = const Divider(
      color: Colors.blue,
      thickness: 2,
    );
    Widget divider5 = Divider(
      color: Colors.blue.shade900,
      thickness: 2,
    );
    Widget divider6 = const Divider(
      color: Colors.purple,
      thickness: 2,
    );

    Widget ChooseDivider(int index) {
      return index % 7 == 0
          ? divider0
          : index % 7 == 1
              ? divider1
              : index % 7 == 2
                  ? divider2
                  : index % 7 == 3
                      ? divider3
                      : index % 7 == 4
                          ? divider4
                          : index % 7 == 5
                              ? divider5
                              : divider6;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
      backgroundColor: Colors.orange.shade50,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                right: 20.0,
                left: 20.0,
                bottom: 20.0),
          ),
          const Center(
            child: Text(
              "復健訓練",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            //移除上面出現的白色部分
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.separated(
                itemCount: MysqlMenu.length,
                itemBuilder: (context, index) {
                  return Container(
                    // color: MysqlMenu[index].score > 90
                    //     ? Colors.green.shade200
                    //     : MysqlMenu[index].score >= 75
                    //         ? Colors.yellow.shade400
                    //         : MysqlMenu[index].score >= 60
                    //             ? Colors.orange.shade300
                    //             : Colors.red.shade200,
                    child: ListTile(
                      leading: const Icon(
                        Icons.access_time,
                        size: 50,
                        color: Colors.black,
                      ),
                      title: Text(
                        MysqlMenu[index].type,
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        //日期格式轉換
                        formatDate(
                            MysqlMenu[index].time, [yyyy, "-", mm, "-", dd]),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      // trailing: Text(
                      //   MysqlMenu[index].score.toString(),
                      //   style: const TextStyle(
                      //     fontSize: 23,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      onTap: () {
                        print(index);
                      },
                    ),
                  );
                },
                //選擇分隔線的
                separatorBuilder: (BuildContext context, int index) {
                  return ChooseDivider(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//新訊息頁面
class NewMessagePage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  NewMessagePage(this.DataMenu);

  @override
  _NewMessagePageState createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  var db = new Mysql();

  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;
  int alarmId = 1;
  bool RehabilitationNotice = false;

  // List<ExpansionPanelListData> expansionpanellist_menu = [];

  //ExpansionPanelListData(this.FormId, this.isread, this.detail, this.date, this.isopen);
  List<ExpansionPanelListData> expansionpanellist_menu = [
    ExpansionPanelListData(1, true, "內容", DateTime.now().toString(), true),
    //第一筆
    ExpansionPanelListData(1, true, "內容", DateTime.now().toString(), true),
    //第二筆
  ];

  Future<Null> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 500), () {
      print('refresh');
      setState(() {
        _initList();
      });
    });
    DatabaseHelper.instance.getForm().then((value) {
      print("refresh後的長度是:${value.length}");
    });
  }

  Future _initList() async {
    expansionpanellist_menu.clear();
    DatabaseHelper.instance.getForm().then((value) {
      for (int i = 0; i < value.length; i++) {
        setState(() {
          //ExpansionPanelListData(this.isread, this.detail, this.date, this.isopen);
          value[i].PersonalId == DataMenu[0].id
              ? {
                  expansionpanellist_menu.add(
                    ExpansionPanelListData(
                        value[i].id!,
                        value[i].isread == 1 ? true : false,
                        value[i].detail,
                        (DateTime.now()).toString(),
                        false),
                  )
                }
              : null;
        });
      }
    });
    PersonalListHelper.instance.getData().then((value) {
      setState(() {
        RehabilitationNotice = value[0].RehabilitationNotice == 1;
      });
    });
  }

  Future updateRehabilitationNotice(bool RehabilitationNotice) async {
    PersonalListHelper.instance.getData().then((value) async {
      await PersonalListHelper.instance.update(PersonalList(
          id: 1,
          PersonalId: value[0].PersonalId,
          account: value[0].account,
          password: value[0].password,
          RehabilitationNotice: RehabilitationNotice ? 1 : 0));
    });
  }

  @override
  void initState() {
    super.initState();
    DataMenu = widget.DataMenu;
    var androidInitialize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitialize = const IOSInitializationSettings();
    var initialzationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    //初始化復健訊息
    RehabilitationNotification = FlutterLocalNotificationsPlugin();
    RehabilitationNotification.initialize(initialzationSettings);

    //初始化問卷訊息
    // QuestionnaireNotification = FlutterLocalNotificationsPlugin();
    // QuestionnaireNotification.initialize(initialzationSettings);
    _initList();
  }

  @override
  Widget build(BuildContext context) {
    // 顯示刪除對話框
    void showDeleteAlertDialog(
        List<ExpansionPanelListData> expansionpanellist_menu, int reversedIndex,
        [bool all = false]) {
      // Init
      AlertDialog dialog = AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: all ? "刪除全部?" : "刪除該訊息?",
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
                  child: const Text(
                    "取消",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  child: Text(
                    all ? "刪除全部訊息" : "刪除",
                    style: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    //刪除全部:刪除單一項
                    all
                        ? {
                            await DatabaseHelper.instance
                                .getForm()
                                .then((value) {
                              for (int i = 0;
                                  i < expansionpanellist_menu.length;
                                  i++) {
                                DatabaseHelper.instance
                                    .delete(expansionpanellist_menu[i].FormId);
                              }
                            }),
                            setState(() {
                              expansionpanellist_menu.clear();
                            }),
                            print("刪除expansionpanellist_menu的index:全部"),
                          }
                        : {
                            await DatabaseHelper.instance
                                .getForm()
                                .then((value) {
                              setState(() {
                                DatabaseHelper.instance.delete(
                                    expansionpanellist_menu[reversedIndex]
                                        .FormId);
                              });
                              print(
                                  "刪除FormId=${expansionpanellist_menu[reversedIndex].FormId}");
                              print(
                                  "刪除expansionpanellist_menu的index:$reversedIndex");
                              setState(() {
                                expansionpanellist_menu.removeAt(reversedIndex);
                              });
                              print("長度:${value.length - 1}");
                            }),
                          };
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      );

      // Show the dialog (showDialog() => showGeneralDialog())
      //登出確認框的動畫
      showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Wrap();
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform(
            transform: Matrix4.translationValues(
              0.0,
              (1.0 - Curves.easeInOut.transform(anim1.value)) * 400,
              0.0,
            ),
            child: dialog,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                right: 20.0,
                left: 20.0,
                bottom: 0.0),
          ),
          Expanded(
            //移除上面出現的白色部分
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 0),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          "訊息通知",
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (expansionpanellist_menu.isEmpty)
                        Column(
                          children: [
                            SwitchListTile(
                                dense: true,
                                activeColor: Colors.green,
                                contentPadding: const EdgeInsets.all(10),
                                value: RehabilitationNotice,
                                title: const Text(
                                  "復健通知",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    RehabilitationNotice =
                                        !RehabilitationNotice;
                                    updateRehabilitationNotice(
                                        RehabilitationNotice);
                                  });
                                  if (RehabilitationNotice) {
                                    decideNotification(DataMenu, alarmId);
                                    // _initList();
                                  } else {
                                    print("已取消, alarmId=$alarmId");
                                    AndroidAlarmManager.cancel(alarmId);
                                  }
                                }),
                            Container(
                              width: double.infinity,
                              height: 2,
                              color: Colors.green.shade500,
                            ),
                            // SwitchListTile(
                            //     dense: true,
                            //     activeColor: Colors.green,
                            //     contentPadding: const EdgeInsets.all(10),
                            //     value: DataMenu[0].QuestionnaireNotice,
                            //     title: const Text(
                            //       "問卷填寫通知",
                            //       style: TextStyle(
                            //         fontSize: 30,
                            //         color: Colors.black,
                            //       ),
                            //     ),
                            //     onChanged: (val) {
                            //       setState(() {
                            //         DataMenu[0].QuestionnaireNotice =
                            //             !DataMenu[0].QuestionnaireNotice;
                            //       });
                            //       if (DataMenu[0].QuestionnaireNotice) {
                            //         decideNotification(
                            //             DataMenu, QuestionnaireId);
                            //             _initList();
                            //       } else {
                            //         print("已取消, id=$QuestionnaireId");
                            //         AndroidAlarmManager.cancel(QuestionnaireId);
                            //       }
                            //     }),
                            // Container(
                            //   width: double.infinity,
                            //   height: 2,
                            //   color: Colors.green.shade500,
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                            )
                          ],
                        ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: expansionpanellist_menu.length,
                          // reverse: true,
                          itemBuilder: (context, index) {
                            int reversedIndex =
                                expansionpanellist_menu.length - 1 - index;
                            return Column(
                              children: [
                                if (index == 0)
                                  Column(
                                    children: [
                                      SwitchListTile(
                                          dense: true,
                                          activeColor: Colors.green,
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          value: RehabilitationNotice,
                                          title: const Text(
                                            "復健通知",
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.black,
                                            ),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              RehabilitationNotice =
                                                  !RehabilitationNotice;
                                              updateRehabilitationNotice(
                                                  RehabilitationNotice);
                                            });
                                            //開啟Switch
                                            if (RehabilitationNotice) {
                                              decideNotification(
                                                  DataMenu, alarmId);
                                              // _initList();
                                            } else {
                                              print("已取消, alarmId=$alarmId");
                                              AndroidAlarmManager.cancel(
                                                  alarmId);
                                            }
                                          }),
                                      Container(
                                        width: double.infinity,
                                        height: 2,
                                        color: Colors.green.shade500,
                                      ),
                                      // SwitchListTile(
                                      //     dense: true,
                                      //     activeColor: Colors.green,
                                      //     contentPadding:
                                      //         const EdgeInsets.all(10),
                                      //     value:
                                      //         DataMenu[0].QuestionnaireNotice,
                                      //     title: const Text(
                                      //       "問卷填寫通知",
                                      //       style: TextStyle(
                                      //         fontSize: 30,
                                      //         color: Colors.black,
                                      //       ),
                                      //     ),
                                      //     onChanged: (val) {
                                      //       setState(() {
                                      //         DataMenu[0].QuestionnaireNotice =
                                      //             !DataMenu[0]
                                      //                 .QuestionnaireNotice;
                                      //       });
                                      //       if (DataMenu[0]
                                      //           .QuestionnaireNotice) {
                                      //         decideNotification(
                                      //             DataMenu, QuestionnaireId);
                                      //              _initList();
                                      //       } else {
                                      //         print("已取消, id=$QuestionnaireId");
                                      //         AndroidAlarmManager.cancel(
                                      //             QuestionnaireId);
                                      //       }
                                      //     }),
                                      // Container(
                                      //   width: double.infinity,
                                      //   height: 2,
                                      //   color: Colors.green.shade500,
                                      // ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                showDeleteAlertDialog(
                                                    expansionpanellist_menu,
                                                    reversedIndex,
                                                    true); //顯示刪除全部的提示對話框
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 30,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                        thickness: 2,
                                      )
                                    ],
                                  ),
                                ExpansionPanelList(
                                    animationDuration:
                                        const Duration(milliseconds: 500),
                                    elevation: 0,
                                    expandedHeaderPadding:
                                        const EdgeInsets.all(8),
                                    children: [
                                      ExpansionPanel(
                                        backgroundColor: Colors.white,
                                        isExpanded: expansionpanellist_menu[
                                                reversedIndex]
                                            .isopen,
                                        canTapOnHeader: true,
                                        //能按標題展開
                                        headerBuilder: (BuildContext context,
                                            bool isExpanded) {
                                          return ListTile(
                                            leading: !expansionpanellist_menu[
                                                        reversedIndex]
                                                    .isread
                                                ? Icon(Icons.circle,
                                                    size: 16,
                                                    color: Colors
                                                        .greenAccent.shade200)
                                                : const Icon(
                                                    Icons.circle_outlined,
                                                    size: 16,
                                                    color: Colors.grey),
                                            title: Text(
                                              "${expansionpanellist_menu[reversedIndex].date}復健通知",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight:
                                                      //未讀嗎?未讀的話粗體，已讀的話復原
                                                      !expansionpanellist_menu[
                                                                  reversedIndex]
                                                              .isread
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                            ),
                                          );
                                        },
                                        body: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Text(
                                                expansionpanellist_menu[
                                                        reversedIndex]
                                                    .detail,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    showDeleteAlertDialog(
                                                        expansionpanellist_menu,
                                                        reversedIndex); //顯示刪除單個的提示對話框
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                    expansionCallback: (i, isExpanded) async {
                                      setState(() {
                                        expansionpanellist_menu[reversedIndex]
                                            .isopen = !isExpanded;
                                        expansionpanellist_menu[reversedIndex]
                                            .isread = true;
                                      });
                                      await DatabaseHelper.instance
                                          .getForm()
                                          .then((value) {})
                                          .then((value) async {
                                        print(
                                            "按的FormId是:${expansionpanellist_menu[reversedIndex].FormId}");
                                        print(
                                            "按的expansionpanellist_menu的index是:$reversedIndex");
                                        await DatabaseHelper.instance.update(
                                          FormList(
                                            id: expansionpanellist_menu[
                                                    reversedIndex]
                                                .FormId,
                                            PersonalId: DataMenu[0].id,
                                            isread: expansionpanellist_menu[
                                                        reversedIndex]
                                                    .isread
                                                ? 1
                                                : 0,
                                            detail: expansionpanellist_menu[
                                                    reversedIndex]
                                                .detail,
                                          ),
                                        );
                                      });
                                    }),
                              ],
                            );
                          },
                          //選擇分隔線的
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              color: Colors.grey.shade200,
                              thickness: 2,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () async {
          await DatabaseHelper.instance.insert(
            FormList(
              PersonalId: DataMenu[0].id,
              isread: 0,
              detail: "細節：今天是${DateTime.now()}",
            ),
          );
          _initList();
        },
      ),
    );
  }
}

//設定expansionpanellist_menu的格式
// expansionpanellist_menu
class ExpansionPanelListData {
  ExpansionPanelListData(
      this.FormId, this.isread, this.detail, this.date, this.isopen);

  int FormId;
  bool isread;
  String detail;
  String date;
  bool isopen;
}

//復健訊息相關
late FlutterLocalNotificationsPlugin RehabilitationNotification;

Future<void> _showRehabilitationNotification() async {
  String PersonalId = "初始化";
  String detail = "${DateTime.now()}今天要記得復健喔!!";
  var androidInitialize =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  var iOSInitialize = const IOSInitializationSettings();
  var initialzationSettings =
      InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  RehabilitationNotification = FlutterLocalNotificationsPlugin();
  RehabilitationNotification.initialize(initialzationSettings);

  print("Rehabilitation：已在:${DateTime.now()} 寄出");
  var androidDetails = const AndroidNotificationDetails(
      "channelId", "channelName",
      importance: Importance.max, priority: Priority.max);
  var iosDetails = const IOSNotificationDetails();
  var generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
  await RehabilitationNotification.show(
      0, "復健提醒", detail, generalNotificationDetails);

  //讀取是誰的資料
  PersonalListHelper.instance.getData().then((value) async {
    PersonalId = value[0].PersonalId;
  }).then((value) async {
    print("PesonalId:$PersonalId");
    await DatabaseHelper.instance.insert(
      FormList(
        PersonalId: PersonalId,
        isread: 0,
        detail: detail,
      ),
    );
  });
}

void decideNotification(List<AllPagesNeedData> DataMenu, int alarmId) {
  print("有動作, alarmId=$alarmId");
  if (alarmId == 1) {
    //定期的
    AndroidAlarmManager.periodic(
      const Duration(seconds: 5),
      alarmId,
      _showRehabilitationNotification,
      // startAt: DateTime(
      //   DateTime.now().year,
      //   DateTime.now().month,
      //   DateTime.now().day,
      //   DateTime.now().hour,
      //   6,
      // ),
      exact: true,
    );

    //固定一個時間
    // AndroidAlarmManager.oneShotAt(
    // DateTime(2023, 3, 18, 21, 50), alarmId, firmAlarm);
  }
  // else if (alarmI == 2) {
  //   //定期的
  //   AndroidAlarmManager.periodic(
  //     const Duration(seconds: 5),
  //     id,
  //     _showQuestionnaireNotification,
  //     // startAt: DateTime(
  //     //   DateTime.now().year,
  //     //   DateTime.now().month,
  //     //   DateTime.now().day,
  //     //   DateTime.now().hour,
  //     //   6,
  //     // ),
  //   );
  //
  //   //固定一個時間
  //   // AndroidAlarmManager.oneShotAt(
  //   // DateTime(2023, 3, 18, 21, 50), alarmId, firmAlarm);
  // }
  else
    print("ERROR!，alarmId = $alarmId");
}

//問卷訊息相關
// late FlutterLocalNotificationsPlugin QuestionnaireNotification;
//
// Future<void> _showQuestionnaireNotification() async {
//   var androidInitialize =
//       const AndroidInitializationSettings("@mipmap/ic_launcher");
//   var iOSInitialize = const IOSInitializationSettings();
//   var initialzationSettings =
//       InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//   QuestionnaireNotification = FlutterLocalNotificationsPlugin();
//   QuestionnaireNotification.initialize(initialzationSettings);
//
//   print("Questionnaire：已在:${DateTime.now()} 寄出");
//   var androidDetails = const AndroidNotificationDetails(
//       "channelId", "channelName",
//       importance: Importance.max, priority: Priority.max);
//   var iosDetails = const IOSNotificationDetails();
//   var generalNotificationDetails =
//       NotificationDetails(android: androidDetails, iOS: iosDetails);
//   await QuestionnaireNotification.show(
//       0, "Questionnaire", "Questionnaire", generalNotificationDetails);
// }

class FormList {
  final int? id;
  final String PersonalId;
  final int isread;
  final String detail;

  FormList({
    this.id,
    required this.PersonalId,
    required this.isread,
    required this.detail,
  });

  factory FormList.fromMap(Map<String, dynamic> json) => FormList(
        id: json['id'],
        PersonalId: json['PersonalId'],
        isread: json['isread'],
        detail: json['detail'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'PersonalId': PersonalId,
      'isread': isread,
      'detail': detail,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = Path.join(documentsDirectory.path, "RehabilitationForm.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Form(
      id INTEGER PRIMARY KEY,
      PersonalId TEXT,
      RehabilitationNotice INTEGER,
      isread INTEGER,
      detail TEXT
      )
    ''');
  }

  //查詢
  Future<List<FormList>> getForm() async {
    Database db = await instance.database;
    var Form = await db.query("Form");
    List<FormList> formList =
        Form.isNotEmpty ? Form.map((c) => FormList.fromMap(c)).toList() : [];
    return formList;
  }

  //新增
  Future<int> insert(FormList formList) async {
    Database db = await instance.database;
    return await db.insert("Form", formList.toMap());
  }

  //刪除
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete("Form", where: "id=?", whereArgs: [id]);
  }

  //修改
  Future<int> update(FormList formList) async {
    Database db = await instance.database;
    return await db.update("Form", formList.toMap(),
        where: "id=?", whereArgs: [formList.id]);
  }
}

//關於我們頁面
class AboutUsPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  AboutUsPage(this.DataMenu);

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;

  @override
  void initState() {
    super.initState();
    DataMenu = widget.DataMenu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
      backgroundColor: Colors.blue.shade50,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                right: 20.0,
                left: 20.0,
                bottom: 20.0),
          ),
          const Center(
            child: Text(
              "關於我們",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            //移除上面出現的白色部分
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  Card(
                    color: Colors.blue.shade50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 2,
                          color: Colors.black,
                        ),
                        buildAboutAs("發展單位及合作公司", "高科大/高醫"),
                        buildAboutAs("APP使用", ""),
                        buildAboutAs(
                          "最後更新時間",
                          "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//關於我們頁面的list
Widget buildAboutAs(String title, String trailing) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        trailing,
        style: const TextStyle(
          fontSize: 24,
        ),
      ),
      Container(
        width: double.infinity,
        height: 2,
        color: Colors.black,
      ),
    ],
  );
}

//設定GridViewMenuData格式
class GridViewMenuData {
  GridViewMenuData(this.index, this.image, this.title, this.self_color);

  final int index;
  final String image;
  final String title;
  final Color self_color;
}

//BottomNavigationBarItem模板
BottomNavigationBarItem buildBottomNavigationBarView(
    String url, Color color, String label, List<AllPagesNeedData> DataMenu) {
  return BottomNavigationBarItem(
    icon: Image.asset(url),
    label: label,
  );
}

//ListTile模板
ListTile buildListTile(BuildContext context, int index, IconData icon,
    String title, List<AllPagesNeedData> DataMenu) {
  return ListTile(
    leading: Icon(
      icon,
      size: 30,
      color: Colors.grey.shade800,
    ),
    title: Text(title,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 20,
        )),
    onTap: () {
      switch (index) {
        //社區交流頁面
        case 0:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CommunityCommunicationPage(DataMenu)));
          break;

        //相關連結頁面
        case 1:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RelateLinkPage(DataMenu)));
          break;

        //問卷系統頁面
        case 2:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QuestionnairePage(DataMenu)));
          break;

        //居家照護小知識頁面
        case 3:
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => HomeCarePage(DataMenu)));
          break;

        //放鬆音樂頁面
        case 4:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RelaxMusicPage(DataMenu)));
          break;

        //回首頁
        case 5:
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MainPage(DataMenu)));
          break;

        //登出
        case 6:
          showAlertDialog(context, DataMenu); //顯示登出提示對話框
          break;
      }
    },
  );
}

//跳轉首頁方格頁面
void ChoosePage(
    BuildContext context, int index, List<AllPagesNeedData> DataMenu) {
  switch (index) {
    //訓練頁面
    case 0:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => TrainPage(DataMenu)),
      );
      break;

    //生理需求頁面
    case 1:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PhysiologicalPage1(DataMenu)),
      );
      break;

    //認識失語症頁面
    case 2:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RecognizePage(DataMenu)),
      );
      break;

    //基本設定頁面
    case 3:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BasicSettingsPage(DataMenu)),
      );
      break;
  }
}
