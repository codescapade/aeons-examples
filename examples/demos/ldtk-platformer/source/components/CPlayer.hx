package components;

import aeons.core.Component;
import aeons.math.Vector2;

/**
 * This component has the player properties.
 */
class CPlayer extends Component {
  /**
   * True if hit by an enemy or water.
   */
  public var dead: Bool;

  /**
   * True if you hit the flag.
   */
  public var complete: Bool;

  /**
   * The player health.
   */
  public var health: Int;

  /**
   * The position the player starts in the leve.
   */
  public var spawnPosition(default, null): Vector2;

  /**
   * Constructor.
   * @param spawn The start position.
   * @param health The current player health.
   */
  public function create(spawn: Vector2, health: Int): CPlayer {
    spawnPosition = spawn;
    this.health = health;

    return this;
  }
}
