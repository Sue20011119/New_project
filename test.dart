import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as math;

// Main
void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

// HomePage
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AlertDialog Demo"),
      ),
      body: Container(),
    );
  }
}

// Show AlertDialog
showAlertDialog(BuildContext context) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text("AlertDialog component"),
    actions: [
      ElevatedButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          }
      ),
      ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          }
      ),
    ],
  );

  // Show the dialog (showDialog() => showGeneralDialog())
  showGeneralDialog(
    context: context,
    pageBuilder: (context, anim1, anim2) {return Wrap();},
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform(
        transform: Matrix4.translationValues(
          0.0,
          (1.0-Curves.easeInOut.transform(anim1.value))*400,
          0.0,
        ),
        child: dialog,
      );
    },
    transitionDuration: Duration(milliseconds: 400),
  );
}