package transitions;

import aeons.math.Quaternion;
import aeons.Aeons;
import aeons.graphics.RenderTarget;
import aeons.graphics.Color;
import aeons.core.Scene;
import aeons.core.Transition;

using aeons.math.FastMatrix4Ex;

class SquaresTransition extends Transition {

  var color: Color;

  var rotation = new Quaternion();

  var scale = 0.0;

  var size: Float;

  var squaresPerRow: Int;

  var squaresPerColumn: Int;

  public function new(nextScene: Scene, duration: Float, color: Color, squaresPerRow = 10) {
    super(nextScene, duration);

    this.color = color;
    this.squaresPerRow = squaresPerRow;
    size = Aeons.display.viewWidth / squaresPerRow;
    squaresPerColumn = Math.ceil(Aeons.display.viewHeight / size);
  }

  public override function render(target: RenderTarget) {
    target.start(false);
    for (x in 0...squaresPerRow) {
      for (y in 0...squaresPerColumn) {
        target.transform.fromRotationTranslationScaleVal(rotation, x * size + size * 0.5, y * size + size * 0.5,
            0, scale, scale, 1);
        target.drawSolidRect(-size * 0.5, -size * 0.5, size, size, color);
      }
    }
    target.present();
  }

  public override function transitionFromOld() {
    Aeons.tweens.create(this, duration - duration * 0.2, { scale: 1.0 });
  }

  public override function transitionToNew() {
    Aeons.tweens.create(this, duration, { scale: 0.0 });
  }
}
