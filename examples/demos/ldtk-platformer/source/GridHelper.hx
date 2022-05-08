package;

class GridHelper {
  public static final size = 18;

  public static function gridToWorld(pos: Int): Float {
    return pos * size + size * 0.5;
  }
}
