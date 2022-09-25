package transitions;

import aeons.Aeons;
import aeons.core.Scene;
import aeons.core.Transition;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;

class FadeTransition extends Transition {
  var color: Color;

  var currentColor = Color.Transparent;

  public override function create() {
    super.create();
    color = userData.color;
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

typedef FadeTransitionData = {
  var nextScene: Class<Scene>;
  var duration: Float;
  var color: Color;
  var ?data: Dynamic;
}
