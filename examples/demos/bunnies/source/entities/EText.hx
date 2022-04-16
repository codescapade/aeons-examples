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

  // We can't set the options in the constructor so we hold it here and use it in init.
  var options: ETextOptions;

  public function new(options: ETextOptions) {
    super();
    this.options = options;
  }

  public override function init(id: Int) {
    super.init(id);

    
    // Transform component. Z index bigger than default 0 so will be drawn on top of the bunnies.
    addComponent(new CTransform({ x: options.x, y: options.y, zIndex: 1 }));

    // Text component.
    var font = Aeons.assets.getFont('pixelFont');
    cText = addComponent(new CText({ font: font, fontSize: 20, text: options.text, anchorX: 0, anchorY: 0 }));
  }

  // Helper function to set the text so you don't need to get a reference to the text component.
  public function setText(text: String) {
    cText.text = text;
  }
}

typedef ETextOptions = {
  // The x position in pixels.
  var x: Float;

  // The y position in pixels.
  var y: Float;

  // The text to display.
  var text: String;
}