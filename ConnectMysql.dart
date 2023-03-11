import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '192.168.10.5',
  // static String host = '192.168.43.133',
      user = 'MyProject',
      password = '123',
      db = 'project';
  static int port = 3306;

  Mysql();
  Future<MySqlConnection> getConnection() async{
    print('嘗試連線資料庫中...');
    var settings = new ConnectionSettings(
      host: host,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }
}