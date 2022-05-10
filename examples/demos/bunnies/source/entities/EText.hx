package entities;

import aeons.Aeons;
import aeons.components.CText;
import aeons.components.CTransform;
import aeons.core.Entity;

/**
 * Text entity.
 */
class EText extends Entity {
  var cText: CText;

  var x: Float;

  var y: Float;

  var text: String;

  public function new(x: Float, y: Float, text: String) {
    super();
    this.x = x;
    this.y = y;
    this.text = text;
  }

  public override function init(id: Int) {
    super.init(id);

    // Transform component. Z index bigger than default 0 so will be drawn on top of the bunnies.
    addComponent(new CTransform({ x: x, y: y, zIndex: 1 }));

    // Text component.
    var font = Aeons.assets.getFont('pixelFont');
    cText = addComponent(new CText({
      font: font,
      fontSize: 20,
      text: text,
      anchorX: 0,
      anchorY: 0
    }));
  }

  // Helper function to set the text so you don't need to get a reference to the text component.
  public function setText(text: String) {
    cText.text = text;
  }
}
