package systems;

import aeons.Aeons;
import aeons.components.CTransform;
import components.CBunnyMove;
import aeons.core.Bundle;
import aeons.core.Updatable;
import aeons.core.System;

class BunnySystem extends System implements Updatable {


  final gravity = 0.5;

  var maxX = 800;

  var maxY = 600;

  @:bundle
  var bunnyBundles: Bundle<CBunnyMove, CTransform>;

  public function new() {
    super();
  }

  public function update(dt: Float) {
    for (bunny in bunnyBundles) {
      final transform = bunny.c_transform;
      final move = bunny.c_bunny_move;

      transform.x += move.speedX;
      transform.y += move.speedY;
      transform.angle += move.rotationSpeed;
      move.speedY += gravity;

      if (transform.x > maxX) {
        transform.x = maxX;
        move.speedX *= -1;
      } else if (transform.x < 0) {
        transform.x = 0;
        move.speedX *= -1;
      }

      if (transform.y > maxY) {
        transform.y = maxY;
        move.speedY *= -0.8;

        if (Aeons.random.float() > 0.5) {
          move.speedY -= 3 + Aeons.random.float(0, 4);
        }
      } else if (transform.y < 0) {
        transform.y = 0;
        move.speedY = 0;
      }
    }
  }
}