import 'package:flutter/cupertino.dart';
import 'package:sqlite/modals/user_modal.dart';

import '../helper/data.dart';

class DbController extends ChangeNotifier {
  DbController() {
    initData();
  }

  List<User> allData = [];

  Future<void> initData() async {
    DbHelper.dbHelper.initDb();
    notifyListeners();
  }

  Future<void> getAllData() async {
    allData = await DbHelper.dbHelper.getAllData();
    notifyListeners();
  }

  Future<void> insertData({required User user}) async {
    await DbHelper.dbHelper.insertData(user: user);
    getAllData();
  }

  Future<void> updateData({required User user}) async {
    await DbHelper.dbHelper.updateData(user: user);
    getAllData();
  }

  Future<void> deleteData({required User user}) async {
    await DbHelper.dbHelper.deleteData(user: user);
    getAllData();
  }
}
