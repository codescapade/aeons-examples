package components;

import aeons.Aeons;
import aeons.core.Component;

/**
 * The component holds the move and rotation speed of a bunny.
 */
class CBunnyMove extends Component {
  public var speedX: Float;

  public var speedY: Float;

  public var rotationSpeed: Float;

  public function create(): CBunnyMove {
    // Set the speed and rotation to random values.
    speedX = Aeons.random.float(0.2, 5);
    speedY = Aeons.random.float(0, 5) - 2.5;
    rotationSpeed = Aeons.random.float(-4, 4);

    return this;
  }
}
