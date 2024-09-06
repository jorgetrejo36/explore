import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:realm/realm.dart';

// this controller will save the id so user data can easily be accessed from the DB
class UserController extends GetxController {
  late ObjectId id;

  // Method to update the id
  void updateId(ObjectId newId) {
    id = newId;
  }
}
