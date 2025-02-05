import 'package:mysql1/mysql1.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<MySqlConnection> _getConnection() async {
    final settings = ConnectionSettings(
      host: 'your-host',
      port: 3306,
      user: 'your-username',
      password: 'your-password',
      db: 'your-database',
    );
    return await MySqlConnection.connect(settings);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final conn = await _getConnection();
    final results = await conn.query('SELECT * FROM your_table');
    final data = results.map((row) => row.fields).toList();
    await conn.close();
    return data;
  }
}