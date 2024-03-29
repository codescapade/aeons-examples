package components;

import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Component;
import aeons.core.Updatable;
import aeons.math.Rect;

using aeons.math.AeMath;

/**
 * This component follows a target and centers the camera on it.
 */
class CCameraFollow extends Component implements Updatable {
  /**
   * The transform to follow.
   */
  public var target: CTransform;

  /**
   * The follow speed.
   */
  public var speed = 3.0;

  /**
   * The bounds the camera cannot go outside.
   * This is used to only show what is inside the level.
   */
  var bounds: Rect;

  /**
   * Transform component reference.
   */
  var transform: CTransform;

  /**
   * Camera component reference.
   */
  var camera: CCamera;

  /**
   * Constructor.
   * @param target The transform to follow.
   * @param bounds The bounds to the camera cannot go outside.
   */
  public function create(target: CTransform, bounds: Rect): CCameraFollow {
    this.target = target;
    this.bounds = bounds;

    transform = getComponent(CTransform);
    camera = getComponent(CCamera);

    return this;
  }

  /**
   * Update loop.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    if (transform == null) {
      return;
    }

    var x = Math.lerp(transform.x, target.x, speed * dt);
    var y = Math.lerp(transform.y, target.y, speed * dt);

    // Clamp the position to stay inside the bounds.
    x = Math.clamp(x, bounds.x + camera.viewWidth * 0.5, bounds.width - camera.viewWidth * 0.5);
    y = Math.clamp(y, bounds.y + camera.viewHeight * 0.5, bounds.height - camera.viewHeight * 0.5);
    transform.x = x;
    transform.y = y;
  }

  /**
   * This component needs a CCamera and a CTransform component to work so those also need to be on
   * this entity.
   */
  override function get_requiredComponents(): Array<Class<Component>> {
    return [CCamera, CTransform];
  }
}
