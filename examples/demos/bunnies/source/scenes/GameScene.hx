package scenes;

import aeons.Aeons;
import aeons.core.Scene;
import aeons.events.input.MouseEvent;
import aeons.input.MouseButton;
import aeons.systems.RenderSystem;

import entities.EBunny;
import entities.ECamera;
import entities.EText;
import systems.BunnySystem;

/**
 * The is the scene where the bunnies live.
 */
class GameScene extends Scene {

  var fps: EText;

  var bunnyCount: EText;

  var bunnies: Array<EBunny> = [];

  var addBunnies = false;

  var removeBunnies = false;

  /**
   * Initialize the scene.
   */
  public override function init() {
    // Add the system that renders everything in the scene.
    addSystem(new RenderSystem());

    // Add the system that updates the bunny movement.
    addSystem(new BunnySystem());

    // Load the sprite atlas so we can use it when creating bunnies in the EBunny entity.
    Aeons.assets.loadAtlas('atlas');

    // Add a camera entity to the scene.
    addEntity(new ECamera());

    // Add a text entity to the scene to display the FPS.
    fps = addEntity(new EText({ x: 10, y: 10, text: 'FPS: 60' }));

    // Add another text entity to dislay the bunny count.
    bunnyCount = addEntity(new EText({ x: 10, y: 40, text: 'Bunnies: 0' }));

    // Create the first bunny.
    createBunny();

    // Add the left and right mouse button listeners.
    Aeons.events.on(MouseEvent.MOUSE_DOWN, mouseDown);
    Aeons.events.on(MouseEvent.MOUSE_UP, mouseUp);
  }

  /**
   * Gets called every update cycle.
   * @param dt The time passed since the last update in seconds.
   */
  public override function update(dt: Float) {
    // Super update calls update on the base Scene so systems and other things get updated as well.
    super.update(dt);

    // Update the fps text.
    fps.setText('FPS: ${Aeons.timeStep.fps}');

    if (addBunnies) {
      // Create 20 new bunnies.
      for (i in 0...20) {
        createBunny();
      }
    } else if (removeBunnies) {
      // Remove 20 bunnies.
      for (i in 0...20) {
        if (bunnies.length > 0) {
          final bunny = bunnies.pop();
          removeEntity(bunny);
          bunnyCount.setText('Bunnies: ${bunnies.length}');
        }
      }
    }
  }

  // Create a new bunny entity and add it to the list to keep track of them.
  function createBunny() {
    final bunny = addEntity(new EBunny());
    bunnies.push(bunny);
    bunnyCount.setText('Bunnies: ${bunnies.length}');
  }

  // Mouse button down listener.
  function mouseDown(event: MouseEvent) {
    // Set the add or remove bunnies variables depending on the button that was pressed.
    if (event.button == LEFT) {
      addBunnies = true;
    } else if (event.button == RIGHT) {
      removeBunnies = true;
    }
  }

  // Mouse button up listener.
  function mouseUp(event: MouseEvent) {
    // Set the add or remove bunnies variables depending on the button that was pressed.
    if (event.button == LEFT) {
      addBunnies = false;
    } else if (event.button == RIGHT) {
      removeBunnies = false;
    }
  }
}