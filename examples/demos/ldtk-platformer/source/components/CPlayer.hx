package components;

import aeons.core.Component;
import aeons.math.Vector2;

class CPlayer extends Component {
  public var dead: Bool;

  public var complete: Bool;

  public var health: Int;

  public var spawnPosition(default, null): Vector2;

  public function new(spawn: Vector2, health: Int) {
    super();
    spawnPosition = spawn;
    this.health = health;
  }
}
