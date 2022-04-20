package systems;

import aeons.components.CAnimation;
import aeons.Aeons;
import aeons.events.input.KeyboardEvent;
import aeons.input.KeyCode;
import components.CPlayer;
import aeons.components.CSimpleBody;
import aeons.components.CTransform;
import aeons.core.Bundle;
import aeons.core.System;
import aeons.core.Updatable;

class PlayerMovement extends System implements Updatable {

  @:bundle
  var playerBundles: Bundle<CTransform, CSimpleBody, CPlayer, CAnimation>;

  var transform: CTransform;

  var body: CSimpleBody;

  var animation: CAnimation;

  var grounded = false;

  var jumping = false;

  var goingLeft = false;

  var goingRight = false;

  var leftKeys: Array<KeyCode> = [Left, J];
  var rightKeys: Array<KeyCode> = [Right, L];
  var jumpKeys: Array<KeyCode> = [Space, X];

  var hasPlayer = false;

  public function new() {
    super();
  }

  public override function init() {
    playerBundles.onAdded(onPlayerAdded);
    Aeons.events.on(KeyboardEvent.KEY_DOWN, keyDown);
    Aeons.events.on(KeyboardEvent.KEY_UP, keyUp);
  }

  public override function cleanup() {
    Aeons.events.off(KeyboardEvent.KEY_DOWN, keyDown);
    Aeons.events.off(KeyboardEvent.KEY_UP, keyUp);
  }

  public function update(dt: Float) {
    if (!hasPlayer) {
      return;
    }

    grounded = false;
    if (body.isTouching(BOTTOM)) {
      grounded = true;
      jumping = false;
    }

    if (goingLeft) {
      transform.scaleX = 1;
      body.acceleration.x = -10;
    } else if (goingRight) {
      transform.scaleX = -1;
      body.acceleration.x = 10;
    } else {
      body.acceleration.x = 0;
    }

    if (grounded) {
      if (body.velocity.x > 10 || body.velocity.x < -10) {
        if (animation.current != 'walk') {
          animation.play('walk');
        }
      } else if (animation.current != 'idle') {
        animation.play('idle');
      }
    } else if (animation.current != 'jump') {
      animation.play('jump');
    }
  }

  function onPlayerAdded(bundle: aeons.bundles.BundleCTransformCSimpleBodyCPlayerCAnimation) {
    transform = bundle.c_transform;
    body = bundle.c_simple_body;
    animation = bundle.c_animation;
    animation.play('idle');

    body.maxVelocity.x = 160;
    body.drag.x = 4;
    hasPlayer = true;
  }

  function keyDown(event: KeyboardEvent) {
    if (!hasPlayer) {
      return;
    }

    if (leftKeys.contains(event.key)) {
      goingLeft = true;
    } else if (rightKeys.contains(event.key)) {
      goingRight = true;
    } else if (jumpKeys.contains(event.key) && grounded) {
      body.velocity.y = -350;
      grounded = false;
      jumping = true;
    }
  }

  function keyUp(event: KeyboardEvent) {
    if (!hasPlayer) {
      return;
    }

    if (leftKeys.contains(event.key)) {
      goingLeft = false;
    } else if (rightKeys.contains(event.key)) {
      goingRight = false;
    } else if (jumpKeys.contains(event.key) && jumping && body.velocity.y < -200) {
      body.velocity.y = -200;
      jumping = false;
    }
  }
}