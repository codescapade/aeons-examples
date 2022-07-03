package transitions;

import aeons.Aeons;
import aeons.core.Scene;
import aeons.core.Transition;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import aeons.math.FastMatrix4;
import aeons.math.Quaternion;

using aeons.math.FastMatrix4Ex;

/**
 * This transition creates a number of squares on the screen that get bigger until the screen is fully covered.
 */
class SquaresTransition extends Transition {
  /**
   * The color of the squares.
   */
  var color: Color;

  /**
   * Used to update the transform.
   */
  var rotation = new Quaternion();

  /**
   * The initial scale of the squares.
   */
  var scale = 0.0;

  /**
   * The size of one square in pixels.
   */
  var size: Float;

  /**
   * How many squares per row on the screen.
   */
  var squaresPerRow: Int;

  /**
   * How many squares per column on the screen.
   */
  var squaresPerColumn: Int;

  /**
   * Constructor.
   * @param nextScene The scene to start after the transition. 
   * @param duration How long the full transition takes. 
   * @param color The square color.
   * @param squaresPerRow How many squares on screen per row.
   */
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
        target.transform = FastMatrix4.fromRotationTranslationScaleVal(rotation, x * size + size * 0.5,
          y * size + size * 0.5, 0, scale, scale, 1);
        target.drawSolidRect(-size * 0.5, -size * 0.5, size, size, color);
      }
    }
    target.present();
  }

  /**
   * Called at the start of the transition.
   */
  public override function transitionFromOld() {
    // Scale the squares up.
    Aeons.tweens.create(this, duration - duration * 0.2, { scale: 1.0 });
  }

  /**
   * Called after the next scene has loaded in behind the transition.
   */
  public override function transitionToNew() {
    // Scale the squares back down.
    Aeons.tweens.create(this, duration, { scale: 0.0 });
  }
}
