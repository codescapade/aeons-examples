package systems;

import aeons.math.Vector2;
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

  var acceleration = 10;

  var wallVelocity = 30;

  var airVelocity = 600;

  var drag = 4;

  var xVelocity = 160;

  var moveThreshold = 10;

  var jumpSpeed = 380;

  var jumpCanceledSpeed = 200;

  var wallJumpSpeed = new Vector2(200, -250);

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
      body.acceleration.x = -acceleration;
    } else if (goingRight) {
      transform.scaleX = -1;
      body.acceleration.x = acceleration;
    } else {
      body.acceleration.x = 0;
    }

    if (!grounded && body.isTouchingAny([LEFT, RIGHT]) && body.velocity.y > 0) {
      body.maxVelocity.y = wallVelocity;
    } else {
      body.maxVelocity.y = airVelocity;
    }

    if (grounded) {
      if (body.velocity.x > moveThreshold || body.velocity.x < -moveThreshold) {
        if (animation.current != PlayerAnims.Walk) {
          animation.play(PlayerAnims.Walk);
        }
      } else if (animation.current != PlayerAnims.Idle) {
        animation.play(PlayerAnims.Idle);
      }
    } else if (animation.current != PlayerAnims.Jump) {
      animation.play(PlayerAnims.Jump);
    }
  }

  function onPlayerAdded(bundle: aeons.bundles.BundleCTransformCSimpleBodyCPlayerCAnimation) {
    transform = bundle.c_transform;
    body = bundle.c_simple_body;
    animation = bundle.c_animation;
    animation.play(PlayerAnims.Idle);

    body.maxVelocity.x = xVelocity;
    body.drag.x = drag;
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
    } else if (jumpKeys.contains(event.key)) {
      if (grounded) {
        body.velocity.y = -jumpSpeed;
        grounded = false;
        jumping = true;
      } else if (body.isTouching(LEFT)) {
        body.velocity.set(wallJumpSpeed.x, wallJumpSpeed.y);
        body.maxVelocity.y = airVelocity;
        jumping = true;
      } else if (body.isTouching(RIGHT)) {
        body.velocity.set(-wallJumpSpeed.x, wallJumpSpeed.y);
        body.maxVelocity.y = airVelocity;
        jumping = true;
      }
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
    } else if (jumpKeys.contains(event.key) && body.velocity.y < -jumpCanceledSpeed) {
      body.velocity.y = -jumpCanceledSpeed;
      jumping = false;
    }
  }
}