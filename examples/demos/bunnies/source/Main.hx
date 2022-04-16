package;

import aeons.core.Game;

import scenes.GameScene;

class Main {

  static function main() {
    // Create a new Aeons game.
    new Game({
      title: 'bunnies', // The game title shows in the title bar in some targets.
      preload: true, // Load everything in the assets folder when the game starts.
      startScene: GameScene, // The scene to start with.
      designWidth: 800, // The resolution width the game is designed for in pixels.
      designHeight: 600 // The resolution height the game is designedfor in pixels.
    });
  }
}