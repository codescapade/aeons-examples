package;

import aeons.core.Game;

import scenes.GameScene;

class Main {
  static function main() {
    new Game({
      title: 'bitmap-font',
      preload: true,
      startScene: GameScene,
      designWidth: 800,
      designHeight: 600
    });
  }
}
