package;

class GridHelper {
  /**
   * The size of the collider tiles in the levels in pixels.
   */
  public static final size = 18;

  /**
   * Convert a grid position to a world position in pixels.
   * @param pos The grid position.
   * @return The world position.
   */
  public static function gridToWorld(pos: Int): Float {
    return pos * size + size * 0.5;
  }
}
