import "package:flutter/material.dart";
class ForgotPassWordPage extends StatefulWidget {
  const ForgotPassWordPage({Key? key}) : super(key: key);

  @override
  _ForgotPassWordPageState createState() => _ForgotPassWordPageState();
}

class _ForgotPassWordPageState extends State<ForgotPassWordPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text(
            "忘記密碼頁面",
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

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text(
            "註冊帳戶頁面",
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