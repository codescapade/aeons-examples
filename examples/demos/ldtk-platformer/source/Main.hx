package;

import aeons.core.Game;

import scenes.GameScene;

class Main {

  static function main() {
    new Game({ title: 'ldtk-platformer', preload: true, startScene: GameScene, designWidth: 400, designHeight: 300, windowWidth: 800, windowHeight: 600, pixelArt: true });
  }
}
