package systems;

import aeons.Aeons;
import aeons.bundles.Bundle;
import aeons.components.CAnimation;
import aeons.components.CAudio;
import aeons.components.CSimpleBody;
import aeons.components.CTransform;
import aeons.core.System;
import aeons.core.Updatable;
import aeons.events.input.KeyboardEvent;
import aeons.input.KeyCode;
import aeons.math.Vector2;
import aeons.systems.SSimplePhysics;

import components.CPlayer;

class SPlayerMovement extends System implements Updatable {
  @:bundle
  var playerBundles: Bundle<CTransform, CSimpleBody, CPlayer, CAnimation, CAudio>;

  var bundle: Bundle<CTransform, CSimpleBody, CPlayer, CAnimation, CAudio>;

  var grounded = false;

  var jumping = false;

  var goingLeft = false;

  var goingRight = false;

  var onLeftWall = false;

  var onRightWall = false;

  var leftKeys: Array<KeyCode> = [Left, J];
  var rightKeys: Array<KeyCode> = [Right, L];
  var jumpKeys: Array<KeyCode> = [Space, X, Up];

  var hasPlayer = false;

  final acceleration = 10;

  final wallVelocity = 30;

  final airVelocity = 600;

  final drag = 4;

  final xVelocity = 180;

  final moveThreshold = 10;

  final jumpSpeed = 380;

  final jumpCanceledSpeed = 200;

  var wallJumpSpeed = new Vector2(180, -270);

  var physics: SSimplePhysics;

  var rayStart = new Vector2();

  var rayEnd = new Vector2();

  var rayTags = [Tag.Ground];

  public function create(): SPlayerMovement {
    physics = getSystem(SSimplePhysics);
    playerBundles.onAdded(onPlayerAdded);
    Aeons.events.on(KeyboardEvent.KEY_DOWN, keyDown);
    Aeons.events.on(KeyboardEvent.KEY_UP, keyUp);

    return this;
  }

  public override function cleanup() {
    Aeons.events.off(KeyboardEvent.KEY_DOWN, keyDown);
    Aeons.events.off(KeyboardEvent.KEY_UP, keyUp);
  }

  public function update(dt: Float) {
    if (!hasPlayer) {
      return;
    }

    final player = bundle.cPlayer;
    final transform = bundle.cTransform;
    final body = bundle.cSimpleBody;
    final animation = bundle.cAnimation;

    if (player.dead && transform.y > physics.worldY + physics.worldHeight && player.health != 0) {
      transform.setPosition(player.spawnPosition.x, player.spawnPosition.y);
      player.dead = false;
      transform.scaleY = 1;
      body.velocity.set(0, 0);
      body.isTrigger = false;
    }

    grounded = false;
    onLeftWall = false;
    onRightWall = false;

    if (player.dead || player.complete) {
      body.maxVelocity.y = airVelocity;
      body.velocity.x = 0;
      body.acceleration.x = 0;
      animation.stop();
      return;
    }

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

    transform.getWorldPosition(rayStart);
    rayStart.y -= 8;
    if (transform.scaleX == 1) {
      rayEnd.set(rayStart.x - 10, rayStart.y);
    } else {
      rayEnd.set(rayStart.x + 10, rayStart.y);
    }

    var hits = physics.raycast(rayStart, rayEnd, rayTags);
    if (hits.count == 0) {
      rayStart.y += 16;
      rayEnd.y = rayStart.y;
      physics.raycast(rayStart, rayEnd, rayTags, hits);
    }

    if (hits.count > 0) {
      if (transform.scaleX == 1) {
        onLeftWall = true;
      } else {
        onRightWall = true;
      }
    }

    if (!grounded && (onLeftWall || onRightWall) && body.velocity.y > 0) {
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

  function onPlayerAdded(bundle: Bundle<CTransform, CSimpleBody, CPlayer, CAnimation, CAudio>) {
    this.bundle = bundle;
    bundle.cAnimation.play(PlayerAnims.Idle);
    bundle.cSimpleBody.maxVelocity.x = xVelocity;
    bundle.cSimpleBody.drag.x = drag;
    hasPlayer = true;
  }

  function keyDown(event: KeyboardEvent) {
    if (!hasPlayer || bundle.cPlayer.dead) {
      return;
    }

    final body = bundle.cSimpleBody;
    final transform = bundle.cTransform;
    final audio = bundle.cAudio;

    if (leftKeys.contains(event.key)) {
      goingLeft = true;
    } else if (rightKeys.contains(event.key)) {
      goingRight = true;
    } else if (jumpKeys.contains(event.key)) {
      if (grounded) {
        body.velocity.y = -jumpSpeed;
        grounded = false;
        jumping = true;
        audio.play();
      } else if (onLeftWall) {
        body.velocity.set(wallJumpSpeed.x, wallJumpSpeed.y);
        body.maxVelocity.y = airVelocity;
        jumping = true;
        transform.scaleX *= -1;
        audio.play();
      } else if (onRightWall) {
        body.velocity.set(-wallJumpSpeed.x, wallJumpSpeed.y);
        body.maxVelocity.y = airVelocity;
        jumping = true;
        transform.scaleX *= -1;
        audio.play();
      }
    }
  }

  function keyUp(event: KeyboardEvent) {
    if (!hasPlayer || bundle.cPlayer.dead) {
      goingLeft = false;
      goingRight = false;
      return;
    }

    final body = bundle.cSimpleBody;

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
