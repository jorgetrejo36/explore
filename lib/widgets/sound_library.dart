import 'package:audioplayers/audioplayers.dart';

final musicPlayer = AudioPlayer();

Future playCorrectSound() async {
  final player = AudioPlayer();
  return player.play(AssetSource("sounds/correct.mp3"));
}

Future playWrongSound() async {
  final player = AudioPlayer();
  return player.play(AssetSource("sounds/wrong.mp3"));
}

Future playLevelComplete() async {
  final player = AudioPlayer();
  await player.setVolume(10);
  return player.play(AssetSource("sounds/levelComplete.wav"));
}

Future playClick() async {
  final player = AudioPlayer();
  await player.setVolume(30);
  return player.play(AssetSource("sounds/buttonClick.wav"));
}

Future playTitleMusic() async {
  await musicPlayer.setVolume(30);
  musicPlayer.setReleaseMode(ReleaseMode.loop);
  return musicPlayer.play(AssetSource("sounds/titleScreen.wav"));
}

Future playMiningMusic() async {
  await musicPlayer.setVolume(30);
  musicPlayer.setReleaseMode(ReleaseMode.loop);
  return musicPlayer.play(AssetSource("sounds/miningMusic.wav"));
}

Future playGeyserMusic() async {
  await musicPlayer.setVolume(30);
  musicPlayer.setReleaseMode(ReleaseMode.loop);
  return musicPlayer.play(AssetSource("sounds/geyserMusic.wav"));
}

Future playRacingMusic() async {
  await musicPlayer.setVolume(30);
  musicPlayer.setReleaseMode(ReleaseMode.loop);
  return musicPlayer.play(AssetSource("sounds/racingMusic.wav"));
}

Future playRocketMusic() async {
  await musicPlayer.setVolume(30);
  musicPlayer.setReleaseMode(ReleaseMode.loop);
  return musicPlayer.play(AssetSource("sounds/rocketMusic.wav"));
}

stopMusic() {
  musicPlayer.stop();
}
