import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:my_topic_project/home.dart';
import 'package:my_topic_project/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mysql1/mysql1.dart';
import 'package:my_topic_project/ConnectMysql.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:my_topic_project/MysqlList.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:settings_ui/settings_ui.dart';

//生理需求頁面
class PhysiologicalPage extends StatefulWidget {
  const PhysiologicalPage({Key? key}) : super(key: key);

  @override
  _PhysiologicalPageState createState() => _PhysiologicalPageState();
}

class _PhysiologicalPageState extends State<PhysiologicalPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text(
            "生理需求頁面",
            style: TextStyle(fontSize: 30),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000),
              ),
              primary: Colors.blueAccent, // background
              onPrimary: Colors.white, // foreground
            ),
            child: const Text(
              "返回",
              style: TextStyle(fontSize: 25),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

//復健訓練頁面
class TrainPage extends StatefulWidget {
  const TrainPage({Key? key}) : super(key: key);

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text(
            "語言訓練頁面",
            style: TextStyle(fontSize: 30),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1000),
              ),
              primary: Colors.blueAccent, // background
              onPrimary: Colors.white, // foreground
            ),
            child: const Text(
              "返回",
              style: TextStyle(fontSize: 25),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

//諮詢社群頁面
class CommunityCommunicationPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  CommunityCommunicationPage(this.DataMenu);

  @override
  _CommunityCommunicationPageState createState() =>
      _CommunityCommunicationPageState();
}

class _CommunityCommunicationPageState
    extends State<CommunityCommunicationPage> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("CommunityCommunicationPage", "AllPagesNeedData", DataMenu);
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
        backgroundColor: Colors.green.shade300,
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 7,
              color: Colors.white,
            ),
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Icon(Icons.phone_in_talk, size: 60,),
                      Text(
                        "諮",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "群",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "社",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "群",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        " ",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                  Image.asset('lib/images/LINE_Link.png'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//基本設定頁面
class BasicSettingsPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  BasicSettingsPage(this.DataMenu);

  @override
  _BasicSettingsPageState createState() => _BasicSettingsPageState();
}

class _BasicSettingsPageState extends State<BasicSettingsPage> {
  var db = new Mysql();
  List<MysqlDataOfPersonal> PersonalMenu = []; //個人資料
  late List<AllPagesNeedData> DataMenu;
  int list = 1; //設置ListView.builder顯示的倍數
  String personal_id = "";
  String personal_name = "";
  String personal_gender = "";

  pic(String sex) {
    if (sex == "男")
      return 'lib/images/mpatient.jpg';
    else
      return 'lib/images/wpatient.jpg';
  }

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    _getMysqlData();
    // _delayText();
    PrintList("BasicSettingsPage", "AllPagesNeedData", DataMenu);
    super.initState();
  }

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
            personal_id = PersonalMenu[0].id.toString();
            personal_name = PersonalMenu[0].name.toString();
            personal_gender = PersonalMenu[0].gender.toString();
          });
        }
      });
      conn.close();
    });
  }

  //延遲取得資料庫資料，因為會有非同步的情況
  Future _delayText() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        personal_id = PersonalMenu[0].id.toString();
        personal_name = PersonalMenu[0].name.toString();
        personal_gender = PersonalMenu[0].gender.toString();
      });
    });
  }

  //建造版面
  buildlayout(BuildContext context, String title, String detail,
      List<AllPagesNeedData> DataMenu) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 30,
              color: DarkMode(DataMenu[0].isdark, "Text"),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width - 20,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: DarkMode(DataMenu[0].isdark, "background",
                  Colors.grey.shade900, Colors.white),
              border: Border.all(color: Colors.black38)),
          child: Text(
            detail,
            style: TextStyle(
              fontSize: 30,
              color: DarkMode(DataMenu[0].isdark, "Text"),
            ), //字串的大小
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
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
          backgroundColor: Colors.cyan.shade700,
          centerTitle: true,
          title: const Text(
            "使用者頁面",
            style: TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_return,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: list.abs(),
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(200.0)),
                                    color: DarkMode(
                                        DataMenu[0].isdark, "background"),
                                    border: Border.all(color: Colors.black)),
                                child: ClipOval(
                                  child: Image.asset(
                                    personal_gender == "男"
                                        ? pic("男")
                                        : pic("女"),
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Column(
                            children: [
                              buildlayout(
                                  context, "名稱", personal_name, DataMenu),
                              buildlayout(
                                  context, "性別", personal_gender, DataMenu),
                              buildlayout(context, "年齡", "暫無", DataMenu),
                              buildlayout(context, "診斷", "暫無", DataMenu),
                              buildlayout(context, "連絡電話", "暫無", DataMenu),
                              buildlayout(
                                  context, "個案編號", personal_id, DataMenu),
                              buildlayout(context, "使用日期", "暫無", DataMenu),
                              buildlayout(context, "個案來源", "暫無", DataMenu),
                              buildlayout(context, "緊急聯絡人", "暫無", DataMenu),
                            ],
                          ),
                        ],
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

//認識失語症頁面
class RecognizePage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  RecognizePage(this.DataMenu);

  @override
  _RecognizePageState createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  late List<AllPagesNeedData> DataMenu;
  final List<ListViewMenuData> listview_menu = [
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
  ];

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("RecognizePage", "AllPagesNeedData", DataMenu);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //分隔線顏色
    Widget divider0 = const Divider(
      color: Colors.orange,
      thickness: 2,
    );
    Widget divider1 = const Divider(
      color: Colors.green,
      thickness: 2,
    );
    Widget divider2 = const Divider(
      color: Colors.blue,
      thickness: 2,
    );

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
        backgroundColor: DarkMode(
            DataMenu[0].isdark, "background", Colors.black, Colors.white),
        appBar: AppBar(
          backgroundColor: DarkMode(DataMenu[0].isdark, "background",
              Colors.grey.shade900, Colors.brown.shade50),
          toolbarHeight: 0,
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.keyboard_return,
                    size: 35,
                    color: DarkMode(DataMenu[0].isdark, "Text", Colors.orange,
                        Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => HomePage(DataMenu)),
                    );
                    // Navigator.pop(context);
                  },
                ),
                const Text(""),
                Text(
                  "認識失語症",
                  style: TextStyle(
                    fontSize: 30,
                    color: DarkMode(DataMenu[0].isdark, "Text", Colors.orange,
                        Colors.white),
                  ),
                ),
                const Text(""),
                const Text(""),
                const Text(""),
              ],
            ),
          ),
        ),
        body: Builder(
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                right: 20.0,
                left: 20.0,
                bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: DarkMode(DataMenu[0].isdark, "background",
                      Colors.grey.shade900, Colors.orange.shade50),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: const EdgeInsets.only(
                  top: 0.0, right: 20.0, left: 20.0, bottom: 20.0),
              child: ListView.separated(
                itemCount: listview_menu.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.add_link,
                      size: 50,
                      color: Colors.blue,
                    ),
                    title: Text(
                      "${listview_menu[index].name}$index",
                      style: TextStyle(
                        fontSize: 23,
                        color: DarkMode(
                          DataMenu[0].isdark,
                          "Text",
                        ),
                      ),
                    ),
                    onTap: () {
                      launchURL(listview_menu[index].url);
                    },
                  );
                },
                //選擇分隔線的
                separatorBuilder: (BuildContext context, int index) {
                  return index % 3 == 0
                      ? divider0
                      : index % 3 == 1
                          ? divider1
                          : divider2;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//相關連結頁面
class RelateLinkPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  RelateLinkPage(this.DataMenu);

  @override
  _RelateLinkPageState createState() => _RelateLinkPageState();
}

class _RelateLinkPageState extends State<RelateLinkPage> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;
  final List<ListViewMenuData> listview_menu = [
    ListViewMenuData(
        '台灣腦中風醫學會', 'https://www.stroke.org.tw/GoWeb2/include/index.php'),
    ListViewMenuData('台灣腦中風醫病友協會', 'http://www.strokecare.org.tw/'),
    ListViewMenuData('衛福部福利諮詢網', 'https://www.mohw.gov.tw/cp-23-135-1.html'),
    ListViewMenuData('衛服部長照專區', 'https://1966.gov.tw/LTC/mp-207.html'),
    ListViewMenuData('病後人生│一站式服務網', 'https://afterthatday.blogspot.com/'),
  ];

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("RelateLinkPage", "AllPagesNeedData", DataMenu);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //分隔線顏色
    Widget divider0 = const Divider(
      color: Colors.orange,
      thickness: 2,
    );
    Widget divider1 = const Divider(
      color: Colors.green,
      thickness: 2,
    );
    Widget divider2 = const Divider(
      color: Colors.blue,
      thickness: 2,
    );

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
          backgroundColor: Colors.cyan,
          centerTitle: true,
          title: const Text(
            "相關連結",
            style: TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_return,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Builder(
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                right: 20.0,
                left: 20.0,
                bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                  color: DarkMode(DataMenu[0].isdark, "background",
                      Colors.grey.shade900, Colors.blue.shade50),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              padding: const EdgeInsets.only(
                  top: 0.0, right: 20.0, left: 20.0, bottom: 20.0),
              child: ListView.separated(
                itemCount: listview_menu.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.add_link,
                      size: 50,
                      color: Colors.blue,
                    ),
                    title: Text(
                      listview_menu[index].name,
                      style: TextStyle(
                        fontSize: 23,
                        color: DarkMode(
                          DataMenu[0].isdark,
                          "Text",
                        ),
                      ),
                    ),
                    onTap: () {
                      launchURL(listview_menu[index].url);
                    },
                  );
                },
                //選擇分隔線的
                separatorBuilder: (BuildContext context, int index) {
                  return index % 3 == 0
                      ? divider0
                      : index % 3 == 1
                          ? divider1
                          : divider2;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//問卷系統頁面
class QuestionnairePage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  QuestionnairePage(this.DataMenu);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  late List<AllPagesNeedData> DataMenu;
  final List<ListViewMenuData> listview_menu = [
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
    ListViewMenuData('Google', 'https://www.google.com/'),
  ];

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("RelateLinkPage", "AllPagesNeedData", DataMenu);
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
          backgroundColor: Colors.purple,
          centerTitle: true,
          title: const Text(
            "問卷系統",
            style: TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_return,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Builder(
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                right: 20.0,
                left: 20.0,
                bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: DarkMode(DataMenu[0].isdark, "background",
                    Colors.grey.shade900, Colors.purple.shade50),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: ListView.separated(
                itemCount: listview_menu.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.text_snippet,
                      size: 50,
                      color: Colors.purple,
                    ),
                    title: Text(
                      listview_menu[index].name,
                      style: TextStyle(
                        fontSize: 23,
                        color: DarkMode(DataMenu[0].isdark, "Text",
                            Colors.purple, Colors.white),
                      ),
                    ),
                    onTap: () {
                      launchURL(listview_menu[index].url);
                    },
                  );
                },
                //選擇分隔線的
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: DarkMode(DataMenu[0].isdark, "Text", Colors.purple,
                        Colors.white),
                    thickness: 2,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//居家照護頁面
class HomeCarePage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  HomeCarePage(this.DataMenu);

  @override
  _HomeCarePageState createState() => _HomeCarePageState();
}

class _HomeCarePageState extends State<HomeCarePage> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;
  final List<ListViewMenuData> listview_menu = [
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
    ListViewMenuData('暫時', 'https://www.google.com/'),
  ];

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("CommunityCommunicationPage", "AllPagesNeedData", DataMenu);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //分隔線顏色
    Widget divider0 = const Divider(
      color: Colors.orange,
      thickness: 2,
    );
    Widget divider1 = const Divider(
      color: Colors.green,
      thickness: 2,
    );
    Widget divider2 = const Divider(
      color: Colors.blue,
      thickness: 2,
    );

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
          backgroundColor: Colors.lightGreen,
          centerTitle: true,
          title: const Text(
            "居家照護小知識",
            style: TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_return,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Builder(
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                right: 20.0,
                left: 20.0,
                bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: DarkMode(DataMenu[0].isdark, "background",
                    Colors.grey.shade900, Colors.lightGreen.shade50),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: ListView.separated(
                itemCount: listview_menu.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      size: 50,
                      color: DarkMode(DataMenu[0].isdark, "Text",
                          Colors.greenAccent.shade700, Colors.white),
                    ),
                    title: Text(
                      listview_menu[index].name,
                      style: TextStyle(
                        fontSize: 23,
                        color: DarkMode(DataMenu[0].isdark, "Text",
                            Colors.greenAccent.shade700, Colors.white),
                      ),
                    ),
                    onTap: () {
                      launchURL(listview_menu[index].url);
                    },
                  );
                },
                //選擇分隔線的
                separatorBuilder: (BuildContext context, int index) {
                  return index % 3 == 0
                      ? divider0
                      : index % 3 == 1
                          ? divider1
                          : divider2;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//放鬆音樂頁面
class RelaxMusicPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  RelaxMusicPage(this.DataMenu);

  @override
  _RelaxMusicPageState createState() => _RelaxMusicPageState();
}

class _RelaxMusicPageState extends State<RelaxMusicPage> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;
  final List<ListViewMenuData> listview_menu = [
    ListViewMenuData('Youtube', 'https://www.youtube.com/'),
    ListViewMenuData('Youtube', 'https://www.youtube.com/'),
    ListViewMenuData('Youtube', 'https://www.youtube.com/'),
    ListViewMenuData('Youtube', 'https://www.youtube.com/'),
    ListViewMenuData('Youtube', 'https://www.youtube.com/'),
    ListViewMenuData('Youtube', 'https://www.youtube.com/'),
    ListViewMenuData('Youtube', 'https://www.youtube.com/'),
    ListViewMenuData('Youtube', 'https://www.youtube.com/'),
  ];

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("CommunityCommunicationPage", "AllPagesNeedData", DataMenu);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //分隔線顏色
    Widget divider0 = const Divider(
      color: Colors.orange,
      thickness: 2,
    );
    Widget divider1 = const Divider(
      color: Colors.green,
      thickness: 2,
    );
    Widget divider2 = const Divider(
      color: Colors.blue,
      thickness: 2,
    );

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
          backgroundColor: Colors.amber,
          centerTitle: true,
          title: const Text(
            "放鬆音樂",
            style: TextStyle(fontSize: 25),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_return,
              size: 35,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Builder(
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                right: 20.0,
                left: 20.0,
                bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: DarkMode(DataMenu[0].isdark, "background",
                    Colors.grey.shade900, Colors.amber.shade50),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: ListView.separated(
                itemCount: listview_menu.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.ondemand_video,
                      size: 50,
                      color: DarkMode(DataMenu[0].isdark, "Text",
                          Colors.amber.shade900, Colors.white),
                    ),
                    title: Text(
                      listview_menu[index].name,
                      style: TextStyle(
                        fontSize: 23,
                        color: DarkMode(DataMenu[0].isdark, "Text",
                            Colors.amber.shade900, Colors.white),
                      ),
                    ),
                    onTap: () {
                      launchURL(listview_menu[index].url);
                    },
                  );
                },
                //選擇分隔線的
                separatorBuilder: (BuildContext context, int index) {
                  return index % 3 == 0
                      ? divider0
                      : index % 3 == 1
                          ? divider1
                          : divider2;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//設定drawer格式的，因為setState無法即時更新，所以要用一個class來處理
class DrawerClassPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];
  String personal_name;
  String personal_gender;

  DrawerClassPage(
    this.personal_name,
    this.personal_gender,
    this.DataMenu,
  );

  @override
  _DrawerClassPageState createState() => _DrawerClassPageState();
}

class _DrawerClassPageState extends State<DrawerClassPage> {
  var db = new Mysql();
  String personal_name = "";
  String personal_gender = "";
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;

  pic() {
    if (personal_gender == "男")
      return 'lib/images/mpatient.jpg';
    else // (personal_gender == "女")
      return 'lib/images/wpatient.jpg';
  }

  @override
  void initState() {
    personal_name = widget.personal_name;
    print("personal_name:$personal_name");
    personal_gender = widget.personal_gender;
    print("personal_gender:$personal_gender");
    DataMenu = widget.DataMenu;
    PrintList("DrawerClass", "AllPagesNeedData", DataMenu);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: DarkMode(
          DataMenu[0].isdark, "background", Colors.grey.shade900, Colors.white),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 280,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.deepPurpleAccent,
                    Colors.blueAccent,
                  ],
                ),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BasicSettingsPage(DataMenu)));
                },
                child: Column(
                  children: <Widget>[
                    Material(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(2000)),
                      elevation: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.yellow, width: 2),
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          splashColor: Colors.black26,
                          child: Image.asset(
                            pic(),
                            width: 120,
                            height: 120,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "$personal_name你好",
                        textScaleFactor: 1,
                        style:
                            const TextStyle(fontSize: 27, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            //label
            padding: const EdgeInsets.all(15),
            child: Text(
              "功能列",
              style: TextStyle(
                color: DarkMode(DataMenu[0].isdark, "Text"),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const Divider(
            color: Colors.black54,
          ),
          //清單
          buildListTile(context, 0, Icons.list_sharp, "社群交流", DataMenu),
          buildListTile(context, 1, Icons.link, "相關連結", DataMenu),
          buildListTile(context, 2, Icons.receipt_long, "問卷系統", DataMenu),
          if (DataMenu[0].Carer)
            buildListTile(context, 3, Icons.paste_outlined, "居家照護知識", DataMenu),
          if (DataMenu[0].Carer)
            buildListTile(context, 4, Icons.library_music, "放鬆音樂", DataMenu),
          buildListTile(context, 5, Icons.home, "回首頁", DataMenu),
          const SizedBox(
            height: 20,
          ),
          buildListTile(context, 6, Icons.logout_rounded, "登出", DataMenu),
        ],
      ),
    );
  }
}

//網址跳轉
void launchURL(String url) async {
  await launch(url);
}
