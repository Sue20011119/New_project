import 'package:flutter/material.dart';
import 'package:my_topic_project/MysqlInterface.dart';
import 'package:my_topic_project/home.dart';
import "package:my_topic_project/LoginJumpPage.dart";
import 'dart:io';
import 'package:my_topic_project/ConnectMysql.dart';
import 'package:my_topic_project/MysqlList.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
// import 'package:flutter/services.dart';

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

  //判斷是否有按眼睛
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  var db = new Mysql();

  //取得Mysql裡patient_database資料表的資料
  _getMysqlData(String login_account) {
    MysqlMenu.clear();
    db.getConnection().then((conn) {
      String sql =
          "SELECT * FROM patient_database WHERE account='$login_account'";
      conn.query(sql).then((results) {
        print("連線成功!");
        for (var row in results) {
          // print(row);
          setState(() {
            MysqlMenu.add(MysqlDataOflogin_patient_database(
                row['id'], row['account'], row['password']));
          });
        }
      });
      conn.close();
    });
  }

  //登入條件判斷
  _LoginJudgment(String account, String password, BuildContext context) {
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
    MysqlMenu.clear();
    DataMenu.clear();
    //初始化DataMenu
    //  id, account, Carer, RehabilitationNotice, QuestionnaireNotice, isdark;
    DataMenu.add(AllPagesNeedData("", "", false, true, true, true, 5));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> RequestPop() async {
      showAlertDialog(context);
      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: RequestPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
        body: ProgressHUD(
          indicatorColor: Colors.white,
          backgroundColor: Colors.lightBlue.shade100,
          textStyle: TextStyle(
            fontSize: 40,
          ),
          child: Builder(
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  right: 20.0,
                  left: 20.0,
                  bottom: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'lib/images/logo.jpg',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(
                      height: 40.0,
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
                          // ErrorText(login_state),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPassWordPage()));
                            },
                            child: Text(
                              "忘記密碼",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                                color: Colors.blue[400],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    //登入按鈕
                    buildButtonContainer(context),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 30,
                            ),
                            const Text("沒帳戶請按"),
                            const SizedBox(
                              width: 6.0,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAccountPage()));
                              },
                              child: Text(
                                "註冊帳戶",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
    return TextField(
      controller: hintText == "帳號" ? _accountcontroller : _pwcontroller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon:
            hintText == "帳號" ? const Icon(Icons.email) : const Icon(Icons.lock),
        suffixIcon: hintText == "密碼"
            ? IconButton(
                onPressed: _toggleVisibility,
                icon: _isHidden
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: hintText == "密碼" ? _isHidden : false,
    );
  }

  //登入按鈕
  Widget buildButtonContainer(BuildContext context) {
    return SizedBox(
      //取得裝置的數據
      width: MediaQuery.of(context).size.width - 48.0,
      height: 48.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
          primary: Colors.blueAccent, // background
          onPrimary: Colors.white, // foreground
        ),
        child: const Text(
          "登入",
          style: TextStyle(fontSize: 25),
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
