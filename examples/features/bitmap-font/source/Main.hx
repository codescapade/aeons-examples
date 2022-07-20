package;

import aeons.core.Game;

import scenes.GameScene;

class Main {
  static function main() {
    new Game({
      title: 'bitmap-font',
      preload: true,
      startScene: new GameScene(),
      designWidth: 800,
      designHeight: 600
    });
  }
}
