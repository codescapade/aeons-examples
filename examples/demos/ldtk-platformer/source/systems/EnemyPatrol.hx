package systems;

import aeons.bundles.Bundle;
import aeons.components.CSimpleBody;
import aeons.components.CTransform;
import aeons.core.System;
import aeons.core.Updatable;

import components.CPatrol;

class EnemyPatrol extends System implements Updatable {
  @:bundle
  var patrolBundles: Bundle<CTransform, CSimpleBody, CPatrol>;

  public function new() {
    super();
  }

  public function update(dt: Float) {
    for (bundle in patrolBundles) {
      if (bundle.cPatrol.dead) {
        bundle.cSimpleBody.velocity.x = 0;
        continue;
      }

      if (bundle.cTransform.x > bundle.cPatrol.maxX) {
        bundle.cTransform.x = bundle.cPatrol.maxX;
        bundle.cPatrol.direction = Direction.Left;
      } else if (bundle.cTransform.x < bundle.cPatrol.minX) {
        bundle.cTransform.x = bundle.cPatrol.minX;
        bundle.cPatrol.direction = Direction.Right;
      }

      bundle.cSimpleBody.velocity.x = bundle.cPatrol.speed * bundle.cPatrol.direction;
      bundle.cTransform.scaleX = -bundle.cPatrol.direction;
    }
  }
}
