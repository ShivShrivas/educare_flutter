import 'dart:io';
import 'dart:async';
import 'package:educareadmin/databaseschools/clientmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, "SchoolDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE Client ("
              "id INTEGER PRIMARY KEY,"
              "school_code TEXT,"
              "user_id TEXT,"
              "user_code TEXT,"
              "school_name TEXT,"
              "user_name TEXT,"
              "designation TEXT,"
              "type TEXT,"
              "relationship_id TEXT,"
              "session_id TEXT,"
              "fyId TEXT,"
              "loginAs TEXT,"
              "mobileNo TEXT,"
              "isActive TEXT"
              ")");
        });
  }

  newClient(Client newClient) async {
    final db = await database;
    //get the biggest id in the table
    var id=null;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    id = table.first["id"];
    if(id==null){
      id=1;
    }else{
      id = table.first["id"];
    }

    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Client (id,school_code,user_id,user_code,school_name,user_name,designation,type,relationship_id,session_id,fyId,loginAs,mobileNo,isActive)"
            " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
        [id, newClient.school_code,newClient.user_id,newClient.user_code,newClient.school_name,newClient.user_name,newClient.designation,newClient.type
        ,newClient.relationship_id,newClient.session_id,newClient.fyId,newClient.loginAs,newClient.mobileNo,newClient.isActive]);
    return raw;
  }


  updateClient(String schoolcode,String usercode) async {
    final db = await database;
    int updateCount = await db.rawUpdate("UPDATE Client SET isActive = '1' WHERE (school_code='$schoolcode' AND loginAs='$usercode')");
    return updateCount;
  }

  updateIsActiveAll() async {
    final db = await database;
    int res = await db.rawUpdate("UPDATE Client SET isActive = '0' ");
    return res;
  }



  Future<int> getClientAll() async {
    final db = await database;
   // var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    var res = await db.rawQuery("SELECT COUNT (*) FROM Client");
    int? count = Sqflite.firstIntValue(res);
    if(count==0){
      return 0;
    }else{
      return 1;
    }
    //return res.isNotEmpty ? 1 : 0;
  }

  Future<int> getClient(String schoolcode,String usercode) async {
    final db = await database;
    // var res = await db.query("Client", where: "id = ?", whereArgs: [id]);
    var res = await db.rawQuery("SELECT COUNT (*) FROM Client WHERE (school_code='$schoolcode' AND loginAs='$usercode')");
    int? count = Sqflite.firstIntValue(res);
    if(count==0){
      return 0;
    }else{
      return 1;
    }
    //return res.isNotEmpty ? 1 : 0;
  }

  Future<List<Client>> getSchoolData(String schoolCode,String loginId) async {
    final db = await database;
    print("works");
    // var res = await db.rawQuery("SELECT * FROM Client WHERE blocked=1");
    var res = await db.query("Client", where: "school_code = ? AND loginAs = ? ", whereArgs: [schoolCode,loginId]);
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Client ORDER BY isActive DESC ");
   // var res = await db.query("Client");
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  deleteClient(String schoolCode,String loginId) async {
    final db = await database;
    return db.delete("Client", where: "school_code = ? AND loginAs = ?", whereArgs: [schoolCode,loginId]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Client");
  }
}

