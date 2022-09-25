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

  public function create(x: Float, y: Float, text: String): EText {
    // Transform component. Z index bigger than default 0 so will be drawn on top of the bunnies.
    addComponent(CTransform).create({ x: x, y: y, zIndex: 1 });

    // Text component.
    final font = Aeons.assets.getFont('pixelFont');
    cText = addComponent(CText).create({
      font: font,
      fontSize: 20,
      text: text,
      anchorX: 0,
      anchorY: 0
    });

    return this;
  }

  // Helper function to set the text so you don't need to get a reference to the text component.
  public function setText(text: String) {
    cText.text = text;
  }
}
