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
import 'package:http/http.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';

//需求表達1頁面
class PhysiologicalPage1 extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  PhysiologicalPage1(this.DataMenu);

  @override
  _PhysiologicalPage1State createState() => _PhysiologicalPage1State();
}

class _PhysiologicalPage1State extends State<PhysiologicalPage1> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;

  Widget buildPhysiologicalPage(String audio, String image, String title) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width / 3,
      child: TextButton(
        onPressed: () {
          final player = AudioCache();
          player.play(audio);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 10,
              child: Image.asset(
                image,
                width: 50,
                height: 50,
              ),
            ),
            Container(
              color: Colors.white,
              child: Text(
                title,
                style: const TextStyle(fontSize: 30, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("PhysiologicalPage1", "AllPagesNeedData", DataMenu);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
        backgroundColor: Colors.orangeAccent.shade100,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 7,
                color: Colors.white,
              ),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 8,
                          child: Image.asset(
                            'lib/images/need.png',
                          ),
                        ),
                        const Text(
                          '需 求 表 達',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //肚子餓
                        buildPhysiologicalPage(
                            "hungry.mp3", "lib/images/hungry.png", "肚子餓"),
                        //口渴
                        buildPhysiologicalPage(
                            "thirsty.mp3", "lib/images/thirsty.png", "口渴"),
                        //小號
                        buildPhysiologicalPage(
                            "small.mp3", "lib/images/small.png", "小號"),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //大號
                        buildPhysiologicalPage(
                            "big.mp3", "lib/images/large.png", "大號"),
                        //換尿布
                        buildPhysiologicalPage(
                            "change.mp3", "lib/images/change.png", "換尿布"),
                        //翻身
                        buildPhysiologicalPage(
                            "body.mp3", "lib/images/body.png", "翻身"),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 12,
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.deepOrange.shade800,
                          border:
                              Border.all(color: Colors.deepOrange.shade800)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PhysiologicalPage2(DataMenu)),
                          );
                        },
                        child: const Text(
                          '下一頁',
                          style: TextStyle(fontSize: 27, color: Colors.white),
                        ),
                      ),
                    ),
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

//需求表達2頁面
class PhysiologicalPage2 extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  PhysiologicalPage2(this.DataMenu);

  @override
  _PhysiologicalPage2State createState() => _PhysiologicalPage2State();
}

class _PhysiologicalPage2State extends State<PhysiologicalPage2> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;

  Widget buildPhysiologicalPage(String audio, String image, String title) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      width: MediaQuery.of(context).size.width / 3,
      child: TextButton(
        onPressed: () {
          final player = AudioCache();
          player.play(audio);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3,
              height: MediaQuery.of(context).size.height / 10,
              child: Image.asset(
                image,
                width: 50,
                height: 50,
              ),
            ),
            Container(
              color: Colors.white,
              child: Text(
                title,
                style: const TextStyle(fontSize: 30, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("PhysiologicalPage2", "AllPagesNeedData", DataMenu);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
        backgroundColor: Colors.orangeAccent.shade100,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 7,
                color: Colors.white,
              ),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.height / 8,
                          child: Image.asset(
                            'lib/images/need.png',
                          ),
                        ),
                        const Text(
                          '需 求 表 達',
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //很熱
                        buildPhysiologicalPage(
                            "hot.mp3", "lib/images/hot.png", "很熱"),
                        //很冷
                        buildPhysiologicalPage(
                            "cold.mp3", "lib/images/cold.png", "很冷"),
                        //頭暈
                        buildPhysiologicalPage(
                            "faint.mp3", "lib/images/faint.png", "頭暈"),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //頭痛
                        buildPhysiologicalPage(
                            "head.mp3", "lib/images/head.png", "頭痛"),
                        //腹痛
                        buildPhysiologicalPage(
                            "stomach.mp3", "lib/images/stomach.png", "腹痛"),
                        //下床
                        buildPhysiologicalPage(
                            "bed.mp3", "lib/images/bed.png", "下床"),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 12,
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.deepOrange.shade800,
                          border:
                          Border.all(color: Colors.deepOrange.shade800)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '上一頁',
                          style: TextStyle(fontSize: 27, color: Colors.white),
                        ),
                      ),
                    ),
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

//復健訓練頁面
class TrainPage extends StatefulWidget {
  List<AllPagesNeedData> DataMenu = [];

  TrainPage(this.DataMenu);

  @override
  _TrainPageState createState() => _TrainPageState();
}

class _TrainPageState extends State<TrainPage> {
  var db = new Mysql();
  List<MysqlDataOfpatient_rehabilitation> MysqlMenu = [];
  late List<AllPagesNeedData> DataMenu;

  void initState() {
    DataMenu = widget.DataMenu;
    PrintList("TrainPage", "AllPagesNeedData", DataMenu);
    super.initState();
  }

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
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
        backgroundColor: Colors.green.shade300,
        body: SingleChildScrollView(
          child: Column(
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
                      children: [
                        Image.asset(
                          'lib/images/phone.png',
                        ),
                        const Text(
                          "諮",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "群",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "社",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "群",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 15,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        primary: Colors.blue.shade100,
                        // background
                        onPrimary: Colors.white, // foreground
                      ),
                      child: const Text(
                        "返回",
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                      onPressed: () {
                        print(context);
                        Navigator.pop(context);
                      },
                    ),
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

//設定頁面
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
  String id = ""; //病患編號
  String name = ""; //姓名
  final _nicknamecontroller = TextEditingController(); //暱稱
  final _namecontroller = TextEditingController(); //暱稱
  DateTime _birthday = DateTime.now(); //生日
  String gender = ""; //性別
  bool diagnosis_left = false; //診斷左側
  bool diagnosis_right = false; //診斷右側
  bool diagnosis_hemorrhagic = false; //診斷出血性
  bool diagnosis_ischemic = false; //診斷缺血性
  bool affected_side_left = false; //患側左側
  bool affected_side_right = false; //患側右側
  final _phonecontroller = TextEditingController(); //手機號碼
  final _emergency_contactcontroller = TextEditingController(); //緊急聯絡人
  final _emergency_contact_phonecontroller =
      TextEditingController(); //緊急聯絡人手機號碼
  String emergency_contact = ""; //緊急連絡人
  String emergency_contact_phone = ""; //緊急連絡人電話
  DateTime joindate = DateTime.now(); //加入日期

  String ip = "192.168.10.5";

  // String ip = "192.168.43.133";
  late bool error, sending, success;
  late String msg;

  List request_php = [
    "insert_patient_database.php", //新增
    "delete_patient_database.php", //刪除
    "update_patient_database.php", //修改
  ];

  late String phpurl;

  //本地不能使用 http://localhost/
  //使用本地 IP 地址或 URL
  //Windows 使用 ipconfig ；在 Linux 上使用 ip a 取得 IP 地址

  //送出資料
  Future<void> sendData(int num) async {
    print(request_php[num]);
    String phpurl = "http://$ip/appproject/${request_php[num]}";
    //發送帶有標題data的post request
    var res = await http.post(Uri.parse(phpurl), body: {
      //傳過去的值
      "ip": ip, //網路資料庫ip
      "id": id,
      "name": _namecontroller.text,
      "nickname": _nicknamecontroller.text,
      "birthday": _birthday.toString(),
      "diagnosis_left": (diagnosis_left ? 1 : 0).toString(),
      "diagnosis_right": (diagnosis_right ? 1 : 0).toString(),
      "diagnosis_hemorrhagic": (diagnosis_hemorrhagic ? 1 : 0).toString(),
      "diagnosis_ischemic": (diagnosis_ischemic ? 1 : 0).toString(),
      "affected_side_left": (affected_side_left ? 1 : 0).toString(),
      "affected_side_right": (affected_side_right ? 1 : 0).toString(),
      "phone": _phonecontroller.text,
      "emergency_contact": _emergency_contactcontroller.text,
      "emergency_contact_phone": _emergency_contact_phonecontroller.text,
      "joindate": joindate.toString(),
    });

    if (res.statusCode == 200) {
      print("res.body：${res.body}"); //印出回傳回來的data
      var data = json.decode(res.body); //將json解碼為陣列形式
      if (data["error"]) {
        //沒有錯誤的話
        setState(() {
          //從 server 收到錯誤時刷新 UI 介面顯示文字
          sending = false;
          error = true;
          msg = data["message"]; //來自server 的錯誤消息
          print("msg:$msg");
        });
      } else {
        setState(() {
          sending = false;
          success = true; //使用 setState 設定success為成功狀態(true)並刷新 UI 介面顯示文字
        });
      }
    } else {
      //存在錯誤的話
      setState(() {
        error = true;
        msg = "Error!";
        sending = false; //標記錯誤並使用 setState 刷新 UI 介面顯示文字
        print("msg:$msg");
      });
    }
  }

  pic(String sex) {
    if (sex == "男")
      return 'lib/images/male.png';
    else
      return 'lib/images/female.png';
  }

  @override
  void initState() {
    DataMenu = widget.DataMenu;
    _getMysqlData();
    // _delayText();
    PrintList("BasicSettingsPage", "AllPagesNeedData", DataMenu);
    error = false;
    sending = false;
    success = false;
    msg = "";
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
            id = PersonalMenu[0].id.toString();
            _namecontroller.text = PersonalMenu[0].name.toString();
            _nicknamecontroller.text = row['nickname'].toString();
            _birthday = row['birthday'];
            gender = PersonalMenu[0].gender.toString();
            diagnosis_left = row['diagnosis_left'] == 0 ? false : true;
            diagnosis_right = row['diagnosis_right'] == 0 ? false : true;
            diagnosis_hemorrhagic =
                row['diagnosis_hemorrhagic'] == 0 ? false : true;
            diagnosis_ischemic = row['diagnosis_ischemic'] == 0 ? false : true;
            affected_side_left = row['affected_side_left'] == 0 ? false : true;
            affected_side_right =
                row['affected_side_right'] == 0 ? false : true;
            _phonecontroller.text = row['phone'];
            _emergency_contactcontroller.text = row['emergency_contact'];
            _emergency_contact_phonecontroller.text =
                row['emergency_contact_phone'];
            joindate =
                row['joindate'].difference(DateTime(2000, 1, 1)).inDays <= 1
                    ? DateTime.now()
                    : row['joindate']; //如果不是null，就加入今天日期

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

  //延遲取得資料庫資料，因為會有非同步的情況
  Future _delayText() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        id = PersonalMenu[0].id.toString();
        name = PersonalMenu[0].name.toString();
        gender = PersonalMenu[0].gender.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
            //移除上面出現的白色部分
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: list.abs(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 120,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(200.0)),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      gender == "男" ? pic("男") : pic("女"),
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //帳號
                                      Row(
                                        children: [
                                          const Text(
                                            "帳號：",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Expanded(
                                            child: Text(
                                              DataMenu[0].account,
                                              style:
                                                  const TextStyle(fontSize: 30),
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //姓名
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                170,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "姓名：",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Flexible(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(8),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black,
                                                ),
                                                controller: _namecontroller,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      //暱稱
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                170,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "暱稱：",
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Flexible(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(8),
                                                ),
                                                style: const TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.black,
                                                ),
                                                controller: _nicknamecontroller,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //生日
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "生日：",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    "${_birthday.year}/${_birthday.month}/${_birthday.day}",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                FlatButton(
                                  child: Icon(Icons.date_range),
                                  onPressed: () async {
                                    var result = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1920, 01),
                                        lastDate: DateTime.now());
                                    if (result != null) {
                                      setState(() {
                                        _birthday = result;
                                        print(_birthday);
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //年齡
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "年齡：",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    "${(DateTime.now().difference(_birthday).inDays / 365).truncate()}", //截斷
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //性別
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "性別：",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    gender,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //診斷
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "診斷：",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                //診斷左側
                                Expanded(
                                  child: Checkbox(
                                    value: diagnosis_left,
                                    onChanged: (newValue) {
                                      setState(() {
                                        diagnosis_left = newValue ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "左側",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                //診斷右側
                                Expanded(
                                  child: Checkbox(
                                    value: diagnosis_right,
                                    onChanged: (newValue) {
                                      setState(() {
                                        diagnosis_right = newValue ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "右側",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                            //腦中風
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                //出血性
                                Expanded(
                                  child: Checkbox(
                                    value: diagnosis_hemorrhagic,
                                    onChanged: (newValue) {
                                      setState(() {
                                        diagnosis_hemorrhagic =
                                            newValue ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "出血性",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                //缺血性
                                Expanded(
                                  child: Checkbox(
                                    value: diagnosis_ischemic,
                                    onChanged: (newValue) {
                                      setState(() {
                                        diagnosis_ischemic = newValue ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "缺血性",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //患側
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "患側：",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                //患側左側
                                Expanded(
                                  child: Checkbox(
                                    value: affected_side_left,
                                    onChanged: (newValue) {
                                      setState(() {
                                        affected_side_left = newValue ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "左側",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                                //患側右側
                                Expanded(
                                  child: Checkbox(
                                    value: affected_side_right,
                                    onChanged: (newValue) {
                                      setState(() {
                                        affected_side_right = newValue ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "右側",
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //連絡電話
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "連絡電話：",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 20.0,
                                    ),
                                    child: TextFormField(
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
                                      controller: _phonecontroller,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //緊急聯絡人
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "緊急聯絡人：",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 20.0,
                                    ),
                                    child: TextFormField(
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
                                      controller: _emergency_contactcontroller,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //緊急聯絡人電話
                            Row(
                              children: const [
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Text(
                                    "緊急聯絡人電話：",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.fade),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 20.0,
                                left: 20.0,
                              ),
                              child: TextFormField(
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
                                controller: _emergency_contact_phonecontroller,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                const Text(
                                  "加入日期：",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(
                                    "${joindate.year}/${joindate.month}/${joindate.day}",
                                    // "${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}",
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    primary: Colors.blueAccent.shade100,
                                    // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                  child: const Text(
                                    "儲存資料",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      sending = true;
                                    });
                                    sendData(2); //修改 update
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    primary: Colors.green.shade100,
                                    // background
                                    onPrimary: Colors.white, // foreground
                                  ),
                                  child: const Text(
                                    "返回",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
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
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
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
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
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
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
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
            textScaleFactor: 1,
          ),
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false, //避免鍵盤出現而造成overflow
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
