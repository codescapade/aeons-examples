package entities;

import aeons.Aeons;
import aeons.components.CLayer;
import aeons.components.CText;
import aeons.components.CTransform;
import aeons.core.Entity;

/**
 * Text entity.
 */
class EText extends Entity {
  var cText: CText;

  public function create(x: Float, y: Float, text: String): EText {
    addComponent(CTransform).create({ x: x, y: y });

    // Text component.
    final font = Aeons.assets.getFont('pixelFont');
    cText = addComponent(CText).create({
      font: font,
      fontSize: 20,
      text: text,
      anchorX: 0,
      anchorY: 0
    });

    // The layer component to set the layer to render on.
    addComponent(CLayer).create(1);

    return this;
  }

  // Helper function to set the text so you don't need to get a reference to the text component.
  public function setText(text: String) {
    cText.text = text;
  }
}
