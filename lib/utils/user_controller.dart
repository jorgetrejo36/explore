import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:realm/realm.dart';

class UserController extends GetxController {
  late ObjectId id;

  //UserController(this.id);

  // Method to update the id
  void updateId(ObjectId newId) {
    id = newId;
  }
}
