package components;

import aeons.core.Component;
import aeons.math.Vector2;

class CPlayer extends Component {
  public var dead: Bool;

  public var spawnPosition(default, null): Vector2;


  public function new(options: CPlayerOptions) {
    super();
    spawnPosition = options.spawn;
  }
}

typedef CPlayerOptions = {
  var spawn: Vector2;
}
