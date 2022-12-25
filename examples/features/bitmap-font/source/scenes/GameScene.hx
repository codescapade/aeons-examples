package scenes;

import aeons.Aeons;
import aeons.components.CBitmapText;
import aeons.components.CCamera;
import aeons.components.CLayer;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.graphics.BitmapFont;
import aeons.graphics.Color;
import aeons.systems.SRender;

class GameScene extends Scene {
  var counterText: CBitmapText;

  var count = 0;

  public override function create() {
    addSystem(SRender).create();

    // Fonts only needs to be loaded once when the game launches.
    // Don't call this in a scene that is reused multiple time.
    // Create a preload scene instead for example.
    final font = Aeons.assets.loadBitmapFont('fonts_font');
    final bigFont = Aeons.assets.loadBitmapFont('fonts_bigFont');

    createCamera();

    createText(100, 100, 'Aeons is great', font, Color.Green);
    counterText = createText(400, 400, 'Count: 0', bigFont, Color.Orange);

    Aeons.timers.create(1.0, updateText, -1, true);
  }

  function updateText() {
    count++;
    counterText.text = 'Count: ${count}';
  }

  /**
   * Create the main camera.
   */
  function createCamera() {
    final camera = addEntity(Entity);
    camera.addComponent(CTransform).create();
    camera.addComponent(CCamera).create();
  }

  /**
   * Create entities used to display text.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   * @param text The text to display.
   * @param font The bitmap font to use.
   * @param color The font color.
   * @return The bitmap font component so we can update the text later.
   */
  function createText(x: Float, y: Float, text: String, font: BitmapFont, color: Color): CBitmapText {
    final entity = addEntity(Entity);

    entity.addComponent(CTransform).create({
      x: x,
      y: y
    });

    final bmText = entity.addComponent(CBitmapText).create({
      font: font,
      text: text,
      color: color,
      anchorX: 0
    });

    entity.addComponent(CLayer).create();

    return bmText;
  }
}
