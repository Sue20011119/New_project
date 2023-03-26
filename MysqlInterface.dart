import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mysql1/mysql1.dart';
import 'package:my_topic_project/ConnectMysql.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:my_topic_project/MysqlList.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class PrintInterface extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var db = new Mysql();
  var name = '';

  List<MysqlData> MysqlMenu = [];

  void _getCustomer() {
    MysqlMenu.clear(); //初始化列表
    db.getConnection().then((conn) {
      String sql = "SELECT * FROM patient_database"; //rehabilitation  database
      conn.query(sql).then((results) {
        print("連線成功!");
        for (var row in results) {
          print("$row");
          setState(() {
            MysqlMenu.add(MysqlData(row['id'], row['name'], row['time'],
                row['type'], row['score']));
          });
        }
      });
      conn.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("連線資料庫"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '',
                style: TextStyle(fontSize: 40),
              ),
              const Text(
                "",
                style: TextStyle(fontSize: 30),
              ),
              TextButton(
                onPressed: _getCustomer,
                child: const Text(
                  "查詢",
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Container(
                height: 500,
                color: Colors.brown[50],
                padding: const EdgeInsets.all(20),
                child: ListView.separated(
                  itemCount: MysqlMenu.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "${MysqlMenu[index].name}",
                        style: const TextStyle(fontSize: 23),
                      ),
                      subtitle: const Text(""
                          // listview_menu[index].url,
                          // style: const TextStyle(fontSize: 18),
                          ),
                      onTap: () {},
                    );
                  },
                  //選擇分隔線的
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.black,
                      thickness: 2,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red, //primary color for theme
        ),
        home: WriteSQLdata() //set the class here
        );
  }
}

class WriteSQLdata extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WriteSQLdataState();
  }
}

class WriteSQLdataState extends State<WriteSQLdata> {
  TextEditingController idctl = TextEditingController();
  TextEditingController namectl = TextEditingController();
  TextEditingController timectl = TextEditingController();
  TextEditingController typectl = TextEditingController();
  TextEditingController scorectl = TextEditingController();

  String ip = "192.168.0.13";
  late bool error, sending, success;
  late String msg;

  late List request_php = [
    "insert.php", //新增
    "delete.php", //刪除
    "update.php", //修改
  ];

  late String phpurl;

  //本地不能使用 http://localhost/
  //使用本地 IP 地址或 URL
  //Windows 使用 ipconfig ；在 Linux 上使用 ip a 取得 IP 地址

  @override
  //初始化參數
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData(int num) async {
    print(request_php[num]);
    String phpurl = "http://$ip/appproject/${request_php[num]}";
    //發送帶有標題data的post request
    var res = await http.post(Uri.parse(phpurl), body: {
      "ip": ip, //網路資料庫ip
      "id": idctl.text,
      "name": namectl.text,
      "time": timectl.text,
      "type": typectl.text,
      "score": scorectl.text,
    });

    if (res.statusCode == 200) {
      print(res.body);
      var data = json.decode(res.body); //將json解碼為陣列形式
      if (data["error"]) {
        //錯誤的話
        setState(() {
          //從 server 收到錯誤時刷新 UI 介面顯示文字
          sending = false;
          error = true;
          msg = data["message"]; //來自server 的錯誤消息
        });
      } else {
        //寫入成功後，清空輸入框的值
        idctl.text = "";
        namectl.text = "";
        timectl.text = "";
        typectl.text = "";
        scorectl.text = "";

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("PHP and Mysql 測試"),
          backgroundColor: Colors.redAccent),
      body: SingleChildScrollView(
        //能滾動，鍵盤出現時，高度變小，防止溢出
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Container(
                child: Text(error ? msg : "Input"),
                //如果有錯誤則顯示消息，否則顯示文本消息
              ),
              Container(
                child: Text(success ? "success!" : "send data"),
                //如果成功顯示成功，否則顯示寄送資料
              ),
              Container(
                  child: TextField(
                controller: idctl,
                decoration: const InputDecoration(
                  labelText: "id:",
                ),
              )),
              Container(
                child: TextField(
                  controller: namectl,
                  decoration: const InputDecoration(
                    labelText: "name:",
                  ),
                ),
              ),
              Container(
                child: TextField(
                  controller: timectl,
                  decoration: const InputDecoration(
                    labelText: "time:",
                  ),
                ),
              ),
              Container(
                child: TextField(
                  controller: typectl,
                  decoration: const InputDecoration(
                    labelText: "type:",
                  ),
                ),
              ),
              Container(
                child: TextField(
                  controller: scorectl,
                  decoration: const InputDecoration(
                    labelText: "score:",
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      //按下按鈕後設定sending為true
                      setState(() {
                        sending = true;
                      });
                      sendData(0);
                    },
                    color: Colors.redAccent,
                    colorBrightness: Brightness.dark,
                    child: Text(
                      sending
                          ? "寄送中..."
                          : "新增資料", //如果 sending == true 顯示寄送中...，否則顯示送新增資料；
                    ),
                    //background of button is darker color, so set brightness to dark
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      //按下按鈕後設定sending為true
                      setState(() {
                        sending = true;
                      });
                      sendData(1);
                    },
                    color: Colors.green,
                    colorBrightness: Brightness.dark,
                    child: Text(
                      sending
                          ? "寄送中..."
                          : "刪除資料(以id為主)", //如果 sending == true 顯示寄送中...，否則顯示刪除資料；
                    ),
                    //background of button is darker color, so set brightness to dark
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () {
                      //按下按鈕後設定sending為true
                      setState(() {
                        sending = true;
                      });
                      sendData(2);
                    },
                    color: Colors.blue,
                    colorBrightness: Brightness.dark,
                    child: Text(
                      sending
                          ? "寄送中..."
                          : "修改資料(以id為主)", //如果 sending == true 顯示寄送中...，否則顯示修改  資料；
                    ),
                    //background of button is darker color, so set brightness to dark
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MysqlData {
  MysqlData(this.id, this.name, this.time, this.type, this.score);

  final String? id;
  final String? name;
  final DateTime? time;
  final String? type;
  final int? score;
}

class Testface extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Test(),
    );
  }
}

class Test extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  late String videoTitle;

  //影片網址
  final List<String> _videoUrlList = [
    'https://www.youtube.com/watch?v=9mplI5qEhxk',
    'https://www.youtube.com/watch?v=o9xmNAlhdYU',
    'https://www.youtube.com/watch?v=R1iJSPn2okQ',
    'https://www.youtube.com/watch?v=kPcu_5RkJpU',
    'https://www.youtube.com/watch?v=fRzPUjFMwI4',
    'https://www.youtube.com/watch?v=kfXdP7nZIiE',
  ];

  List<YoutubePlayerController> lYTC = [];

  Map<String, dynamic> cStates = {};

  @override
  void initState() {
    super.initState();
    fillYTlists();
  }

  fillYTlists() {
    for (var element in _videoUrlList) {
      String _id = YoutubePlayer.convertUrlToId(element)!;
      YoutubePlayerController _ytController = YoutubePlayerController(
        initialVideoId: _id,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          enableCaption: true,
          captionLanguage: 'en',
        ),
      );

      _ytController.addListener(() {
        print('$_id 播放  ${_ytController.value.isPlaying}');
        if (cStates[_id] != _ytController.value.isPlaying) {
          if (mounted) {
            setState(() {
              cStates[_id] = _ytController.value.isPlaying;
            });
          }
        }
      });

      lYTC.add(_ytController);
    }
  }

  @override
  void dispose() {
    for (var element in lYTC) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('放影片測試'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: _videoUrlList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            YoutubePlayerController _ytController = lYTC[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 220.0,
                    decoration: const BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: YoutubePlayer(
                        controller: _ytController,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.lightBlueAccent,
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(isExpanded: true),
                          FullScreenButton(),
                        ],
                        onReady: () {
                          print('onReady for $index');
                        },
                        onEnded: (YoutubeMetaData _md) {
                          _ytController.seekTo(const Duration(seconds: 0));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  late FlutterLocalNotificationsPlugin localNotification;

  Future _showNotification() async {
    var androidDetails =
        const AndroidNotificationDetails("channelId", "channelName");
    var iosDetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await localNotification.show(
        0, "測試測試，這是通知的標題", "測試測試，這是通知的內容", generalNotificationDetails);
  }

  @override
  void initState() {
    super.initState();
    var androidInitialize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitialize = const IOSInitializationSettings();
    var initialzationSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification = FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        appBar: AppBar(
          title: const Text(
            "通知測試",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 50),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Center(
            child: Container(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showNotification,
          child: const Icon(Icons.notifications),
        ),
      ),
    );
  }
}

class NotifyPage extends StatefulWidget {
  const NotifyPage({Key? key}) : super(key: key);

  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  bool isOn = false;
  int alarmId = 1;

  @override
  void initState() {
    super.initState();
    var androidInitialize =
    const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitialize = const IOSInitializationSettings();
    var initialzationSettings =
    InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    localNotification = FlutterLocalNotificationsPlugin();
    localNotification.initialize(initialzationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white.withOpacity(.94),
        appBar: AppBar(
          title: const Text(
            "通知測試2",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 50),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Center(
            child: Transform.scale(
              scale: 2,
              child: Switch(
                value: isOn,
                onChanged: (value) {
                  setState(() {
                    isOn = value;
                    print("isOn:$isOn");
                  });
                  //開啟Switch
                  if (isOn) {
                    //定期的
                    // print("time is:${DateTime.now()}");
                    // print(
                    //     "y/m/d/h=>${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().hour}");
                    AndroidAlarmManager.periodic(
                      const Duration(seconds: 30),
                      alarmId,
                      _showNotification,
                      startAt: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        DateTime.now().hour,
                        6,
                      ),
                    );

                    //固定一個時間
                    // AndroidAlarmManager.oneShotAt(
                    // DateTime(2023, 3, 18, 21, 50), alarmId, firmAlarm);
                  } else {
                    AndroidAlarmManager.cancel(alarmId);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

late FlutterLocalNotificationsPlugin localNotification;
Future<void> _showNotification() async {
  var androidInitialize =
  const AndroidInitializationSettings("@mipmap/ic_launcher");
  var iOSInitialize = const IOSInitializationSettings();
  var initialzationSettings =
  InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
  localNotification = FlutterLocalNotificationsPlugin();
  localNotification.initialize(initialzationSettings);


  print("已在:${DateTime.now()} 寄出");
  var androidDetails =
  const AndroidNotificationDetails("channelId",
      "channelName",
      importance: Importance.max,
      priority: Priority.max);
  var iosDetails = const IOSNotificationDetails();
  var generalNotificationDetails =
  NotificationDetails(android: androidDetails, iOS: iosDetails);
  await localNotification.show(
      0, "測試測試，這是通知的標題", "測試測試，這是通知的內容", generalNotificationDetails);
}
