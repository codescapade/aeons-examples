package components;

import aeons.core.Component;

class CPatrol extends Component {
  public var dead = false;

  public var minX(default, null): Float;

  public var maxX(default, null): Float;

  public var speed(default, null): Float;
  
  public var direction: Int;

  public function new(minX: Float, maxX: Float, speed: Float, direction: Int) {
    super();
    this.minX = Math.min(minX, maxX);
    this.maxX = Math.max(minX, maxX);
    this.direction = direction;
    this.speed = speed;
  }
}
