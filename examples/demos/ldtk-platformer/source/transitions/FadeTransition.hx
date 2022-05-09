package transitions;

import aeons.Aeons;
import aeons.core.Scene;
import aeons.core.Transition;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;

class FadeTransition extends Transition {
  var color: Color;

  var currentColor = Color.Transparent;

  public function new(nextScene: Scene, duration: Float, color: Color) {
    super(nextScene, duration);
    this.color = color;
  }

  public override function render(target: RenderTarget) {
    target.start(false);
    target.drawSolidRect(0, 0, Aeons.display.viewWidth, Aeons.display.viewHeight, currentColor);
    target.present();
  }

  public override function transitionFromOld() {
    Aeons.tweens.create(this, duration, { currentColor: color }, true);
  }

  public override function transitionToNew() {
    Aeons.tweens.create(this, duration, { currentColor: Color.Transparent }, true);
  }
}
