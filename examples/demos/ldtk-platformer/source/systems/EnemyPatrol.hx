package systems;

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

  public override function init() {
    patrolBundles.onAdded(bundleAdded);
  }

  public function update(dt: Float) {
    for (bundle in patrolBundles) {
      if (bundle.c_patrol.direction == 1) {
        bundle.c_simple_body.velocity.x = bundle.c_patrol.speed;
        if (bundle.c_transform.x > bundle.c_patrol.target.x) {
          bundle.c_patrol.setTarget(bundle.c_transform);
        }
      } else {
        bundle.c_simple_body.velocity.x = -bundle.c_patrol.speed;
        if (bundle.c_transform.x < bundle.c_patrol.target.x) {
          bundle.c_patrol.setTarget(bundle.c_transform);
        }
      }
      bundle.c_transform.scaleX = -bundle.c_patrol.direction;
    }
  }

  function bundleAdded(bundle: aeons.bundles.BundleCTransformCSimpleBodyCPatrol) {
    bundle.c_patrol.setTarget(bundle.c_transform);
  }
}