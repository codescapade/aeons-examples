package components;

import aeons.components.CTransform;
import aeons.math.Vector2;
import aeons.core.Component;

class CPatrol extends Component {
  public var startPosition(default, null): Vector2;

  public var endPosition(default, null): Vector2;

  public var speed(default, null): Float;

  public var target: Vector2;
  
  public var direction: Float;

  public function new(options: CPatrolOptions) {
    super();
    startPosition = new Vector2(options.startX, options.startY);
    endPosition = new Vector2(options.endX, options.endY);
    speed = options.speed;
  }

  public function setTarget(transform: CTransform) {
    if (target == null) {
      target = startPosition;
    } else {
      if (target == startPosition) {
        target = endPosition;
      } else {
        target = startPosition;
      }
    }
    direction = transform.x < target.x ? 1 : -1;
  }
}

typedef CPatrolOptions = {
  var startX: Float;
  var startY: Float;
  var endX: Float;
  var endY: Float;
  var speed: Float;
}