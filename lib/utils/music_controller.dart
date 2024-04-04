import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:realm/realm.dart';
import 'package:explore/widgets/sound_library.dart';



// this controller will save the id so user data can easily be accessed from the DB
class MusicController extends GetxController {
  late bool music = true;

  void toggleMusic(){
    music = !music;
    if(music == true){
      playTitleMusic();
    }
    else {
      stopMusic();
    } //toggle
  }
  bool getMusic(){
    return music;
  }

}
