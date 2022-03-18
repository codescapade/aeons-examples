package components;

import aeons.Aeons;
import aeons.core.Component;

class CBunnyMove extends Component {
  public var speedX: Float;
  public var speedY: Float;

  public var rotationSpeed: Float;

  public function new() {
    super();

    speedX = Aeons.random.float(0.2, 5);
    speedY = Aeons.random.float(0, 5) - 2.5;
    rotationSpeed = Aeons.random.float(-4, 4);
  }
}