package entities;

import aeons.Aeons;
import aeons.components.CText;
import aeons.components.CTransform;
import aeons.core.Entity;

class EText extends Entity {

  var cText: CText;

  var options: ETextOptions;

  public function new(options: ETextOptions) {
    super();
    this.options = options;
  }

  public override function init(id: Int) {
    super.init(id);

    var font = Aeons.assets.getFont('pixelFont');
    addComponent(new CTransform({ x: options.x, y: options.y, zIndex: 1 }));
    cText = addComponent(new CText({ font: font, fontSize: 20, text: options.text, anchorX: 0, anchorY: 0 }));
  }

  public function setText(text: String) {
    cText.text = text;
  }
}

typedef ETextOptions = {
  var x: Float;

  var y: Float;

  var text: String;
}