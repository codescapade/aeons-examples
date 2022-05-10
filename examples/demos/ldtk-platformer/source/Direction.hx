package;

/**
 * Direction is used in the patrol system for the enemies.
 */
enum abstract Direction(Int) to Int {
  var Left = -1;
  var Right = 1;
}
