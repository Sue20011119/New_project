import 'package:flutter/material.dart';
import 'package:my_topic_project/MysqlInterface.dart';
import 'package:my_topic_project/home.dart';
import 'dart:io';
import 'package:my_topic_project/ConnectMysql.dart';
import 'package:my_topic_project/MysqlList.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:flutter/services.dart';

//SQLite
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _accountcontroller = TextEditingController();
  final _pwcontroller = TextEditingController();
  bool _isHidden = true;
  String login_state = "";
  List<MysqlDataOflogin_patient_database> MysqlMenu = [];
  List<AllPagesNeedData> DataMenu = [];
  String Textname = "";

  var db = new Mysql();

  //取得Mysql裡patient_database資料表的資料
  _getMysqlData(String login_account) {
    MysqlMenu.clear();
    db.getConnection().then((conn) {
      String sql =
          "SELECT * FROM patient_database WHERE account='$login_account'";
      conn.query(sql).then((results) {
        print("連線成功!");
        // print("result：$results");
        for (var row in results) {
          print("row：$row");
          // print("row['password']：${row['password']}");
          // print("result：$results");
          setState(() {
            MysqlMenu.add(MysqlDataOflogin_patient_database(
                row['id'], row['account'], row['password']));
          });
        }
      });
      conn.close();
    });
  }

  Future _initList() async {
    PersonalListHelper.instance.getData().then((value) async {
      if (value.isNotEmpty) {
        print("value[0].PersonalId：${value[0].PersonalId}");
        print("value[0].RehabilitationNotice：${value[0].RehabilitationNotice}");
        setState(() {
          _accountcontroller.text = value[0].account;
          _pwcontroller.text = value[0].password;
        });
      }
    });
  }

  //登入條件判斷
  _LoginJudgment(String account, String password, BuildContext context) {
    print("account:$account；password:$password");
    setState(() {
      //先將狀態清空
      login_state = "";
    });
    if (account == "") {
      //如果帳號是空的
      print('帳號不得為空!');
      setState(() {
        login_state = "帳號不得為空!";
      });
      return;
    }
    if (password == "") {
      //如果密碼是空的
      print('密碼不得為空!');
      setState(() {
        login_state = "密碼不得為空!";
      });
      return;
    }

    //連線資料庫
    _getMysqlData(account);

    //進度圖案框
    final progress = ProgressHUD.of(context);
    progress?.showWithText("登入中...");

    Future.delayed(const Duration(milliseconds: 1000), () {
      //延遲1秒進行判斷
      progress?.dismiss();
      if (MysqlMenu.isEmpty) {
        //如果取得的列表是空的，也就是帳號錯誤
        print('帳號輸入有誤!');
        setState(() {
          login_state = "帳號輸入有誤!";
        });
        return;
      }
      if (password == MysqlMenu[0].password) {
        //如果帳號密碼都對
        setState(() {
          DataMenu[0].id = MysqlMenu[0].id;
          DataMenu[0].account = MysqlMenu[0].account;
        });
        print('成功登入');
        setState(() {
          login_state = "";
        });

        PersonalListHelper.instance.getData().then((value) async {
          //不是空的就更新
          if (value.isNotEmpty) {
            await PersonalListHelper.instance.update(
                PersonalList(id: 1,
                    PersonalId: DataMenu[0].id,
                    account: DataMenu[0].account,
                    password: _pwcontroller.text,
                    RehabilitationNotice: value[0].RehabilitationNotice),
          );
            //是空的就新增
        } else{
            await PersonalListHelper.instance.insert(
              PersonalList(
                  PersonalId: DataMenu[0].id,
                  account: DataMenu[0].account,
                  password: _pwcontroller.text,
                  RehabilitationNotice: 1),
            );

          }
        });


        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainPage(DataMenu)));
      } else {
        //如果密碼錯誤
        print('密碼輸入有誤');
        setState(() {
          login_state = "密碼輸入有誤";
        });
        return;
      }
    });
  }

  //初始化
  @override
  void initState() {
    super.initState();
    MysqlMenu.clear();
    DataMenu.clear();
    //初始化DataMenu
    //  id, account, Carer, RehabilitationNotice, QuestionnaireNotice, isdark;
    DataMenu.add(AllPagesNeedData("", "", "LoginPage"));
    _initList();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardSize = MediaQuery
        .of(context)
        .viewInsets
        .bottom;
    Future<bool> RequestPop() async {
      showAlertDialog(context);
      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: RequestPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
        backgroundColor: Colors.blue.shade100,
        body: ProgressHUD(
          indicatorColor: Colors.white,
          backgroundColor: Colors.lightBlue.shade100,
          textStyle: const TextStyle(
            fontSize: 40,
          ),
          child: Builder(
            builder: (context) =>
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .padding
                          .top,
                      right: 20.0,
                      left: 20.0,
                      bottom: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: keyboardSize == 0 ? MediaQuery
                              .of(context)
                              .size
                              .height / 5 : 0,
                        ),
                        const Text(
                          "歡迎使用",
                          style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          "整合復健APP使用登入",
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "(高醫X花慈X高科大)",
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        buildTextField("帳號"),
                        const SizedBox(
                          height: 20.0,
                        ),
                        buildTextField("密碼"),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //錯誤文字
                              Text(
                                login_state,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        buildButtonContainer(context), //登入按鈕
                        Padding(padding: MediaQuery
                            .of(context)
                            .viewInsets),
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

  //輸入框格式
  Widget buildTextField(String hintText) {
    return Row(
      children: [
        Text(
          "$hintText：",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: TextField(
            controller: hintText == "帳號" ? _accountcontroller : _pwcontroller,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.all(8),
            ),
            style: const TextStyle(
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  //登入按鈕
  Widget buildButtonContainer(BuildContext context) {
    return SizedBox(
      //取得裝置的數據
      width: MediaQuery
          .of(context)
          .size
          .width * 0.9,
      height: 48.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
          primary: Colors.blueAccent.shade100, // background
          onPrimary: Colors.white, // foreground
        ),
        child: const Text(
          "登入",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        onPressed: () {
          _LoginJudgment(_accountcontroller.text, _pwcontroller.text, context);
        },
      ),
    );
  }
}

// 顯示退出APP對話框
void showAlertDialog(BuildContext context) {
  // Init
  AlertDialog dialog = AlertDialog(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    title: RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: "確定退出APP?",
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          WidgetSpan(
            child: SizedBox(
              width: 40,
            ),
          ),
          WidgetSpan(
            child: Icon(
              Icons.logout,
              size: 30,
              color: Colors.blue,
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
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text(
                  "取消",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
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
                  "確認退出",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  //引入import 'package:flutter/services.dart';
                  //以及import 'dart:io';
                  // if (Platform.isAndroid) {
                  //   SystemNavigator.pop();
                  // } else if (Platform.isIOS) {
                  //   exit(0);
                  // }
                  exit(0);
                },
              ),
            ],
          ),
        ),
      ),
    ],
  );

  // Show the dialog (showDialog() => showGeneralDialog())
  //確認框的動畫
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

//個人的SQLite
class PersonalList {
  final int? id;
  final String PersonalId;
  final String account;
  final String password;
  final int RehabilitationNotice;

  PersonalList({
    this.id,
    required this.PersonalId,
    required this.account,
    required this.password,
    required this.RehabilitationNotice,
  });

  factory PersonalList.fromMap(Map<String, dynamic> json) =>
      PersonalList(
        id: json['id'],
        PersonalId: json['PersonalId'],
        account: json['account'],
        password: json['password'],
        RehabilitationNotice: json['RehabilitationNotice'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'PersonalId': PersonalId,
      'account': account,
      'password': password,
      'RehabilitationNotice': RehabilitationNotice,
    };
  }
}

class PersonalListHelper {
  PersonalListHelper._privateConstructor();

  static final PersonalListHelper instance = PersonalListHelper
      ._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = Path.join(documentsDirectory.path, "PersonalData.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE PersonalData(
      id INTEGER PRIMARY KEY,
      PersonalId TEXT,
      account TEXT,
      password TEXT,
      RehabilitationNotice INTEGER
      )
    ''');
  }

  //查詢
  Future<List<PersonalList>> getData() async {
    Database db = await instance.database;
    var Data = await db.query("PersonalData");
    List<PersonalList> personalList =
    Data.isNotEmpty ? Data.map((c) => PersonalList.fromMap(c)).toList() : [];
    return personalList;
  }

  //新增
  Future<int> insert(PersonalList personalList) async {
    Database db = await instance.database;
    return await db.insert("PersonalData", personalList.toMap());
  }

  //刪除
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete("PersonalData", where: "id=?", whereArgs: [id]);
  }

  //修改
  Future<int> update(PersonalList personalList) async {
    Database db = await instance.database;
    return await db.update("PersonalData", personalList.toMap(),
        where: "id=?", whereArgs: [personalList.id]);
  }
}

