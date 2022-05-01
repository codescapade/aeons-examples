package;

import aeons.core.Game;

import scenes.LoadScene;

class Main {

  static function main() {
    new Game({
      title: 'ldtk-platformer',
      preload: true,
      startScene: new LoadScene(),
      designWidth: 400,
      designHeight: 300,
      windowWidth: 800,
      windowHeight: 600,
      pixelArt: true
    });
  }
}
