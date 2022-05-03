package components;

import aeons.core.Component;
import aeons.math.Vector2;

class CPlayer extends Component {
  public var dead: Bool;

  public var health: Int;

  public var spawnPosition(default, null): Vector2;


  public function new(options: CPlayerOptions) {
    super();
    spawnPosition = options.spawn;
    health = options.health;
  }
}

typedef CPlayerOptions = {
  var spawn: Vector2;
  var health: Int;
}
