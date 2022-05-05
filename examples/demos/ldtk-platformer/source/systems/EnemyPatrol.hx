package systems;

import aeons.math.Vector2;
import aeons.components.CTransform;
import components.CPatrol;
import aeons.components.CSimpleBody;
import aeons.core.Bundle;
import aeons.core.Updatable;
import aeons.core.System;

class EnemyPatrol extends System implements Updatable {

  @:bundle
  var patrolBundles: Bundle<CTransform, CSimpleBody, CPatrol>;

  public function new() {
    super();
  }

  public function update(dt: Float) {
    for (bundle in patrolBundles) {
      if (bundle.c_patrol.dead) {
        bundle.c_simple_body.velocity.x = 0;
        continue;
      }

      if (bundle.c_transform.x > bundle.c_patrol.maxX) {
        bundle.c_transform.x = bundle.c_patrol.maxX;
        bundle.c_patrol.direction *= -1;
      } else if (bundle.c_transform.x < bundle.c_patrol.minX) {
        bundle.c_transform.x = bundle.c_patrol.minX;
        bundle.c_patrol.direction *= -1;
      }

      bundle.c_simple_body.velocity.x = bundle.c_patrol.speed * bundle.c_patrol.direction;
      bundle.c_transform.scaleX = -bundle.c_patrol.direction;
    }
  }
}
