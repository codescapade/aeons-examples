package components;

import aeons.core.Component;

/**
 * This component helps the enemies patrol between two positions.
 */
class CPatrol extends Component {
  /**
   * True if the enemy has been jumped on by the player.
   */
  public var dead = false;

  /**
   * The left x position of the patrol path.
   */
  public var minX(default, null): Float;

  /**
   * The right x position of the patrol path.
   */
  public var maxX(default, null): Float;

  /**
   * The horizontal velocity when moving.
   */
  public var speed(default, null): Float;

  /**
   * The current direction the enemy is moving in.
   */
  public var direction = Direction.Left;

  /**
   * Constructor.
   * @param minX The path left position.
   * @param maxX The path right position.
   * @param speed The horizontal velocity.
   */
  public function new(minX: Float, maxX: Float, speed: Float) {
    super();
    this.minX = Math.min(minX, maxX);
    this.maxX = Math.max(minX, maxX);
    this.speed = speed;
  }
}
