package components;

import aeons.components.CCamera;
import aeons.math.AeMath;
import aeons.math.Rect;
import aeons.components.CTransform;
import aeons.core.Updatable;
import aeons.core.Component;

class CCameraFollow extends Component implements Updatable {
  public var bounds: Rect;

  public var target: CTransform;

  public var speed = 0.1;

  var transform: CTransform;
  var camera: CCamera;

  public function new(options: CCameraFollowOptions) {
    super();
    target = options.target;
    bounds = options.bounds;
  }

  public override function init(entityId: Int) {
    super.init(entityId);
    transform = getComponent(CTransform);
    camera = getComponent(CCamera);
  }

  public function update(dt: Float) {
    if (transform == null) {
      return;
    }

    var x = AeMath.lerp(transform.x, target.x, speed);
    var y = AeMath.lerp(transform.y, target.y, speed);
    x = AeMath.clamp(x, bounds.x + camera.viewWidth * 0.5, bounds.width - camera.viewWidth * 0.5);
    y = AeMath.clamp(y, bounds.y + camera.viewHeight * 0.5, bounds.height - camera.viewHeight * 0.5);
    transform.x = x;
    transform.y = y;
  }
}

typedef CCameraFollowOptions = {
  var target: CTransform;
  var bounds: Rect;
}
