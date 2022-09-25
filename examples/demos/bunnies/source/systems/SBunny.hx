package systems;

import aeons.Aeons;
import aeons.bundles.Bundle;
import aeons.components.CTransform;
import aeons.core.System;
import aeons.core.Updatable;

import components.CBunnyMove;

class SBunny extends System implements Updatable {
  final gravity = 0.5;

  final maxX = Aeons.display.viewWidth;
  final maxY = Aeons.display.viewHeight;

  // Bundles are created when an entity has the components required by the bundle.
  // Each component can be accessed from the bundle.
  @:bundle
  var bunnyBundles: Bundle<CBunnyMove, CTransform>;

  public function create(): SBunny {
    return this;
  }

  public function update(dt: Float) {
    // Loop though all the bundles.
    for (bunny in bunnyBundles) {
      // Get the components.
      final transform = bunny.cTransform;
      final move = bunny.cBunnyMove;

      // Update the position and rotation.
      transform.x += move.speedX;
      transform.y += move.speedY;
      transform.angle += move.rotationSpeed;

      // Add gravity.
      move.speedY += gravity;

      // Reverse if the bunny is hitting x axis bounds.
      if (transform.x > maxX) {
        transform.x = maxX;
        move.speedX *= -1;
      } else if (transform.x < 0) {
        transform.x = 0;
        move.speedX *= -1;
      }

      // Hitting the ground. Bounce back up at a ranom speed.
      if (transform.y > maxY) {
        transform.y = maxY;

        // Decrease the up speed a bit.
        move.speedY *= -0.8;

        // 50% chance to bounce with more speed.
        if (Aeons.random.float() > 0.5) {
          move.speedY -= 3 + Aeons.random.float(0, 4);
        }
        // Hit the top. Reset the vertical speed.
      } else if (transform.y < 0) {
        transform.y = 0;
        move.speedY = 0;
      }
    }
  }
}
