package scenes;

import aeons.input.MouseButton;
import aeons.Aeons;
import aeons.graphics.atlas.Atlas;
import aeons.core.Scene;
import aeons.events.input.MouseEvent;
import aeons.systems.RenderSystem;

import entities.EBunny;
import entities.ECamera;
import entities.EText;
import systems.BunnySystem;

class GameScene extends Scene {

  var fps: EText;

  var bunnyCount: EText;

  var bunnies: Array<EBunny> = [];

  var addBunnies = false;

  var removeBunnies = false;

  public override function init() {
    addSystem(new RenderSystem());
    addSystem(new BunnySystem());

    Aeons.assets.loadAtlas('atlas', (atlas: Atlas)-> {});
    addEntity(new ECamera());

    fps = addEntity(new EText({ x: 10, y: 10, text: 'FPS: 60' }));
    bunnyCount = addEntity(new EText({ x: 10, y: 40, text: 'Bunnies: 0' }));

    createBunny();

    Aeons.events.on(MouseEvent.MOUSE_DOWN, mouseDown);
    Aeons.events.on(MouseEvent.MOUSE_UP, mouseUp);
  }

  public override function update(dt: Float) {
    super.update(dt);
    fps.setText('FPS: ${Aeons.timeStep.fps}');

    if (addBunnies) {
      for (i in 0...20) {
        createBunny();
      }
    } else if (removeBunnies) {
      for (i in 0...20) {
        if (bunnies.length > 0) {
          final bunny = bunnies.pop();
          removeEntity(bunny, true);
          bunnyCount.setText('Bunnies: ${bunnies.length}');
        }
      }
    }
  }

  function createBunny() {
    final bunny = addEntity(new EBunny());
    bunnies.push(bunny);
    bunnyCount.setText('Bunnies: ${bunnies.length}');
  }

  function mouseDown(event: MouseEvent) {
    if (event.button == LEFT) {
      addBunnies = true;
    } else if (event.button == RIGHT) {
      removeBunnies = true;
    }
  }

  function mouseUp(event: MouseEvent) {
    if (event.button == LEFT) {
      addBunnies = false;
    } else if (event.button == RIGHT) {
      removeBunnies = false;
    }
  }
}