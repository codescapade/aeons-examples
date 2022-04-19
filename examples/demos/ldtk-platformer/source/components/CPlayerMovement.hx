package components;

import aeons.components.CTransform;
import aeons.Aeons;
import aeons.components.CSimpleBody;
import aeons.core.Component;
import aeons.core.Updatable;
import aeons.events.input.KeyboardEvent;

class CPlayerMovement extends Component implements Updatable {

  var body: CSimpleBody;

  var transform: CTransform;

  var goingLeft = false;

  var goingRight = false;

  var grounded = false;

  var jumping = false;

  public function new() {
    super();
  }

  public override function init(entityId: Int) {
    super.init(entityId);
    body = getComponent(CSimpleBody);
    transform = getComponent(CTransform);

    body.maxVelocity.x = 150;
    body.drag.x = 5;

    Aeons.events.on(KeyboardEvent.KEY_DOWN, keyDown);
    Aeons.events.on(KeyboardEvent.KEY_UP, keyUp);
  }

  public override function cleanup() {
    super.cleanup();
    Aeons.events.off(KeyboardEvent.KEY_DOWN, keyDown);
    Aeons.events.off(KeyboardEvent.KEY_UP, keyUp);
  }

  public function update(dt: Float) {
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
  }

  function keyDown(event: KeyboardEvent) {
    if (event.key == Left || event.key == J) {
      goingLeft = true;
    } else if (event.key == Right || event.key == L) {
      goingRight = true;
    } else if ((event.key == Space || event.key == X) && grounded) {
      body.velocity.y = -350;
      grounded = false;
      jumping = true;
    }
  }

  function keyUp(event: KeyboardEvent) {
    if (event.key == Left || event.key == J) {
      goingLeft = false;
    } else if (event.key == Right || event.key == L) {
      goingRight = false;
    } else if (event.key == Space || event.key == X) {
      if (jumping && body.velocity.y < -200) {
        body.velocity.y = -200;
        jumping = false;
      }
    }
  }
}