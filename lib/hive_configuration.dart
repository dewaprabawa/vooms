import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vooms/shareds/general_helper/firebase_key_constant.dart';

Future<void> registerHives() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.initFlutter();
  await Hive.openBox(HiveKeyConstant.collectionUserKey);
  await Hive.openBox(HiveKeyConstant.collectionTutorKey);
}