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

class MainPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  MainPage(this.DataMenu);

  @override
  _MainPageState createState() => _MainPageState();
}

//建構全畫面
class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
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

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    _getMysqlData();
    PrintList("MainPage", "AllPagesNeedData", DataMenu);
    super.initState();
  }

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
          "SELECT * FROM patient_database WHERE id='${DataMenu[0].id}'";
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
              PrintList(
                  pages[currentIndex].toString(), "AllPagesNeedData", DataMenu);
            });
          },
          items: [
            buildBottomNavigationBarView(Icons.assignment_return,
                Colors.redAccent.shade400, "返回", DataMenu),
            buildBottomNavigationBarView(Icons.content_paste_search,
                Colors.yellow.shade400, "使用紀錄", DataMenu),
            buildBottomNavigationBarView(
                Icons.campaign, Colors.lightGreen.shade400, "新訊息", DataMenu),
            buildBottomNavigationBarView(
                Icons.error_rounded, Colors.blue.shade300, "關於", DataMenu),
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
    backgroundColor: DarkMode(
        DataMenu[0].isdark, "background", Colors.grey.shade800, Colors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    title: RichText(
      text: TextSpan(
        children: [
          const WidgetSpan(
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
              color: DarkMode(
                  DataMenu[0].isdark, "Text", Colors.black, Colors.white),
            ),
          ),
        ],
      ),
    ),
    actions: [
      Center(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    DarkMode(DataMenu[0].isdark, "background", Colors.grey,
                        Colors.white),
                  ),
                ),
                child: Text(
                  "取消",
                  style: TextStyle(
                    fontSize: 20,
                    color: DarkMode(
                        DataMenu[0].isdark, "Text", Colors.blue, Colors.white),
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
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
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
  final List<GridViewMenuData> menu = [
    GridViewMenuData(0, Icons.handshake, '需求表達', Colors.orangeAccent.shade100),
    GridViewMenuData(1, Icons.directions_walk, '復健訓練', Colors.indigo.shade200),
    GridViewMenuData(2, Icons.phone_in_talk, '諮詢社群', Colors.green.shade300),
    GridViewMenuData(3, Icons.settings, '設定', Colors.grey),
  ];

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: choosetextscale(DataMenu),
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .padding
                      .top,
                  right: 20.0,
                  left: 20.0,
                  bottom: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Hello",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "病患",
                  style: TextStyle(
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
            Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on,
                    size: 80,
                    color: Colors.yellow.shade800,
                  ),
                  const Text(
                    "顯示金幣數量",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                ],
              ),
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
                                  builder: (
                                      context) => const PhysiologicalPage()),
                            );
                            break;

                        //復健訓練頁面
                          case 1:
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const TrainPage()),
                            );
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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 30,
                            ),
                            Icon(
                              menu[index].icon,
                              size: 60,
                            ),
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 120,
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
            MysqlMenu.add(MysqlDataOfpatient_rehabilitation(row['id'],
                row['name'], row['time'], row['type'], row['score']));
          });
        }
      });
      conn.close();
    });
  }

  @override
  void initState() {
    _getMysqlData();
    DataMenu = widget.DataMenu;
    super.initState();
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

    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: choosetextscale(DataMenu),
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.orange.shade50,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery
                      .of(context)
                      .padding
                      .top,
                  right: 20.0,
                  left: 20.0,
                  bottom: 20.0),
            ),
            const Center(
              child: Text("復健訓練",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
            ),
          SizedBox(
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
                      color: MysqlMenu[index].score>90?Colors.green.shade200:
                      MysqlMenu[index].score>=75?Colors.yellow.shade400:
                      MysqlMenu[index].score>=60?Colors.orange.shade300:Colors.red.shade200,
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
                        trailing:
                        Text(
                          MysqlMenu[index].score.toString(),
                          style: const TextStyle(
                            fontSize: 23,
                            color: Colors.black,
                          ),
                        ),
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
  List<ExpansionPanelListData> expansionpanellist_menu = [
    ExpansionPanelListData(
        false,
        "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "12/31 0",
        false),
    ExpansionPanelListData(
        false,
        "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "12/31 1",
        false),
    ExpansionPanelListData(
        false,
        "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "12/31 2",
        false),
    ExpansionPanelListData(
        false,
        "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "12/31 3",
        false),
    ExpansionPanelListData(
        false,
        "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "12/31 4",
        false),
    ExpansionPanelListData(
        false,
        "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "12/31 5",
        false),
    ExpansionPanelListData(
        false,
        "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "12/31 6",
        false),
    ExpansionPanelListData(
        false,
        "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
        "12/31 7",
        false),
  ];

  Future<Null> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1), () {
      print('refresh');
      setState(() {
        expansionpanellist_menu = [
          ExpansionPanelListData(
              false,
              "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              "12/31 0",
              false),
          ExpansionPanelListData(
              false,
              "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              "12/31 1",
              false),
          ExpansionPanelListData(
              false,
              "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              "12/31 2",
              false),
          ExpansionPanelListData(
              false,
              "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              "12/31 3",
              false),
          ExpansionPanelListData(
              false,
              "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              "12/31 4",
              false),
          ExpansionPanelListData(
              false,
              "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              "12/31 5",
              false),
          ExpansionPanelListData(
              false,
              "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              "12/31 6",
              false),
          ExpansionPanelListData(
              false,
              "Lorem Ipsum is simplyen tnrere recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
              "12/31 7",
              false),
        ];
      });
    });
  }

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 顯示刪除對話框
    void showDeleteAlertDialog(
        List<ExpansionPanelListData> expansionpanellist_menu, index,
        [bool all = false]) {
      // Init
      AlertDialog dialog = AlertDialog(
        backgroundColor: DarkMode(DataMenu[0].isdark, "background",
            Colors.grey.shade800, Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.delete,
                    size: 30,
                    color: DarkMode(
                        DataMenu[0].isdark, "Text", Colors.black, Colors.white),
                  ),
                ),
                TextSpan(
                  text: all ? "刪除全部?" : "刪除該訊息?",
                  style: TextStyle(
                    fontSize: 25,
                    color: DarkMode(
                        DataMenu[0].isdark, "Text", Colors.black, Colors.white),
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
                      DarkMode(DataMenu[0].isdark, "background", Colors.grey,
                          Colors.white),
                    ),
                  ),
                  child: Text(
                    "取消",
                    style: TextStyle(
                      fontSize: 20,
                      color: DarkMode(DataMenu[0].isdark, "Text", Colors.green,
                          Colors.white),
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
                  onPressed: () {
                    setState(() {
                      //刪除全部
                      if (all) {
                        expansionpanellist_menu.clear();
                        print("delete index:all");
                      }
                      //刪除單一項
                      else {
                        print("delete index:$index");
                        expansionpanellist_menu[index].isopen = false;
                        expansionpanellist_menu.removeAt(index);
                      }
                    });
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

    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: choosetextscale(DataMenu),
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DarkMode(DataMenu[0].isdark, "background"),
        appBar: AppBar(
          backgroundColor: DarkMode(DataMenu[0].isdark, "background",
              Colors.grey.shade900, Colors.green.shade50),
          toolbarHeight: 10,
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "訊息通知",
                  style: TextStyle(
                    fontSize: 30,
                    color: DarkMode(
                        DataMenu[0].isdark, "Text", Colors.green, Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: Padding(
            padding:
            const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
            child: Column(
              children: [
                if (expansionpanellist_menu.isEmpty)
                  Column(
                    children: [
                      SwitchListTile(
                          dense: true,
                          activeColor: Colors.green,
                          contentPadding: const EdgeInsets.all(10),
                          value: DataMenu[0].RehabilitationNotice,
                          title: Text(
                            "復健通知",
                            style: TextStyle(
                              fontSize: 30,
                              color: DarkMode(DataMenu[0].isdark, "Text"),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              DataMenu[0].RehabilitationNotice =
                              !DataMenu[0].RehabilitationNotice;
                            });
                          }),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: DarkMode(DataMenu[0].isdark, "Text",
                            Colors.green.shade500, Colors.white),
                      ),
                      SwitchListTile(
                          dense: true,
                          activeColor: Colors.green,
                          contentPadding: const EdgeInsets.all(10),
                          value: DataMenu[0].QuestionnaireNotice,
                          title: Text(
                            "問卷填寫通知",
                            style: TextStyle(
                              fontSize: 30,
                              color: DarkMode(DataMenu[0].isdark, "Text"),
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              DataMenu[0].QuestionnaireNotice =
                              !DataMenu[0].QuestionnaireNotice;
                            });
                          }),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: DarkMode(DataMenu[0].isdark, "Text",
                            Colors.green.shade500, Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: DarkMode(DataMenu[0].isdark, "Text", Colors.grey,
                            Colors.white),
                        thickness: 2,
                      )
                    ],
                  ),
                Expanded(
                  child: ListView.separated(
                    itemCount: expansionpanellist_menu.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          if (index == 0)
                            Column(
                              children: [
                                SwitchListTile(
                                    dense: true,
                                    activeColor: Colors.green,
                                    contentPadding: const EdgeInsets.all(10),
                                    value: DataMenu[0].RehabilitationNotice,
                                    title: Text(
                                      "復健通知",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: DarkMode(
                                            DataMenu[0].isdark, "Text"),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        DataMenu[0].RehabilitationNotice =
                                        !DataMenu[0].RehabilitationNotice;
                                      });
                                    }),
                                Container(
                                  width: double.infinity,
                                  height: 2,
                                  color: DarkMode(DataMenu[0].isdark, "Text",
                                      Colors.green.shade500, Colors.white),
                                ),
                                SwitchListTile(
                                    dense: true,
                                    activeColor: Colors.green,
                                    contentPadding: const EdgeInsets.all(10),
                                    value: DataMenu[0].QuestionnaireNotice,
                                    title: Text(
                                      "問卷填寫通知",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: DarkMode(
                                            DataMenu[0].isdark, "Text"),
                                      ),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        DataMenu[0].QuestionnaireNotice =
                                        !DataMenu[0].QuestionnaireNotice;
                                      });
                                    }),
                                Container(
                                  width: double.infinity,
                                  height: 2,
                                  color: DarkMode(DataMenu[0].isdark, "Text",
                                      Colors.green.shade500, Colors.white),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showDeleteAlertDialog(
                                              expansionpanellist_menu,
                                              index,
                                              true); //顯示刪除全部的提示對話框
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 30,
                                        color: DarkMode(
                                            DataMenu[0].isdark, "Text"),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: DarkMode(DataMenu[0].isdark, "Text",
                                      Colors.grey, Colors.white),
                                  thickness: 2,
                                )
                              ],
                            ),
                          ExpansionPanelList(
                              animationDuration:
                              const Duration(milliseconds: 500),
                              elevation: 0,
                              expandedHeaderPadding: const EdgeInsets.all(8),
                              children: [
                                ExpansionPanel(
                                  backgroundColor: DarkMode(
                                      DataMenu[0].isdark,
                                      "background",
                                      Colors.grey.shade900,
                                      Colors.white),
                                  isExpanded:
                                  expansionpanellist_menu[index].isopen,
                                  canTapOnHeader: true,
                                  //能按標題展開
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                      leading: !expansionpanellist_menu[index]
                                          .isread
                                          ? Icon(Icons.circle,
                                          size: 16,
                                          color:
                                          Colors.greenAccent.shade200)
                                          : const Icon(Icons.circle_outlined,
                                          size: 16, color: Colors.grey),
                                      title: Text(
                                        "${expansionpanellist_menu[index]
                                            .date}復健通知",
                                        style: TextStyle(
                                            color: DarkMode(
                                                DataMenu[0].isdark, "Text"),
                                            fontSize: 25,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight:
                                            //未讀嗎?未讀的話粗體，已讀的話復原
                                            !expansionpanellist_menu[index]
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
                                          expansionpanellist_menu[index].detail,
                                          style: TextStyle(
                                            color: DarkMode(
                                                DataMenu[0].isdark, "Text"),
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
                                                  index); //顯示刪除提示對話框
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            size: 30,
                                            color: DarkMode(
                                                DataMenu[0].isdark, "Text"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              expansionCallback: (i, isExpanded) {
                                setState(() {
                                  expansionpanellist_menu[index].isopen =
                                  !isExpanded;
                                  expansionpanellist_menu[index].isread = true;
                                });
                              }),
                        ],
                      );
                    },
                    //選擇分隔線的
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        color: DarkMode(DataMenu[0].isdark, "Text",
                            Colors.grey.shade200, Colors.white),
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
    );
  }
}

//設定轉跳網址的expansionpanellist_menu的格式
// expansionpanellist_menu
class ExpansionPanelListData {
  ExpansionPanelListData(this.isread, this.detail, this.date, this.isopen);

  bool isread;
  String detail;
  String date;
  bool isopen;
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
    DataMenu = widget.DataMenu;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: choosetextscale(DataMenu),
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: DarkMode(DataMenu[0].isdark, "background"),
        appBar: AppBar(
          backgroundColor: DarkMode(DataMenu[0].isdark, "background",
              Colors.grey.shade900, Colors.blue.shade50),
          toolbarHeight: 10,
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "關於我們",
                  style: TextStyle(
                    fontSize: 30,
                    color: DarkMode(
                        DataMenu[0].isdark, "Text", Colors.blue, Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding:
          const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
          child: ListView(
            children: [
              Card(
                color: DarkMode(
                  DataMenu[0].isdark,
                  "background",
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildAboutAs("發展單位", "高科大", DataMenu),
                    buildAboutAs("合作公司", "高醫", DataMenu),
                    buildAboutAs("APP使用", "", DataMenu),
                    buildAboutAs(
                        "最後更新時間",
                        "${DateTime
                            .now()
                            .year}/${DateTime
                            .now()
                            .month}/${DateTime
                            .now()
                            .day}",
                        DataMenu),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//關於我們頁面的list
Widget buildAboutAs(String title, String trailing,
    List<AllPagesNeedData> DataMenu) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 28,
          color: DarkMode(DataMenu[0].isdark, "Text"),
        ),
      ),
      Text(
        trailing,
        style: TextStyle(
          fontSize: 24,
          color:
          DarkMode(DataMenu[0].isdark, "Text", Colors.grey, Colors.white),
        ),
      ),
      Container(
        width: double.infinity,
        height: 2,
        color: DarkMode(DataMenu[0].isdark, "Text", Colors.blue, Colors.white),
      ),
    ],
  );
}

//設定GridViewMenuData格式
class GridViewMenuData {
  GridViewMenuData(this.index, this.icon, this.title, this.self_color);

  final int index;
  final IconData icon;
  final String title;
  final Color self_color;
}

//BottomNavigationBarItem模板
BottomNavigationBarItem buildBottomNavigationBarView(IconData icon, Color color,
    String label, List<AllPagesNeedData> DataMenu) {
  return BottomNavigationBarItem(
    icon: Icon(
      icon,
      color: color,
      size: 45,
    ),
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
      color: DarkMode(
          DataMenu[0].isdark, "Text", Colors.grey.shade800, Colors.white),
    ),
    title: Text(title,
        style: TextStyle(
          color: DarkMode(
              DataMenu[0].isdark, "Text", Colors.grey.shade800, Colors.white),
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
void ChoosePage(BuildContext context, int index,
    List<AllPagesNeedData> DataMenu) {
  switch (index) {
  //訓練頁面
    case 0:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const TrainPage()),
      );
      break;

  //生理需求頁面
    case 1:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PhysiologicalPage()),
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
