package components;

import aeons.math.Vector2;
import aeons.core.Component;

class CPlayer extends Component {
  public var dead: Bool;

  public var spawnPosition(default, null): Vector2;

  public var levelBottom(default, null): Float;

  public function new(options: CPlayerOptions) {
    super();
    spawnPosition = options.spawn;
    levelBottom = options.levelBottom;
  }
}

typedef CPlayerOptions = {
  var spawn: Vector2;
  var levelBottom: Float;
}
