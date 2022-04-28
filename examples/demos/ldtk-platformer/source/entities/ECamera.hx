package entities;

import aeons.Aeons;
import aeons.events.input.MouseEvent;
import components.CCameraFollow;
import aeons.math.Rect;
import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;

class ECamera extends Entity {
  
  var target: CTransform;

  var bounds: Rect;

  var transform: CTransform;

  var camera: CCamera;

  public function new(target: CTransform, bounds: Rect) {
    super();
    this.target = target;
    this.bounds = bounds;
  }

  public override function init(id: Int) {
    super.init(id);

    transform = addComponent(new CTransform());
    camera = addComponent(new CCamera({ zoom: 1 }));
    addComponent(new CCameraFollow({ target: target, bounds: bounds }));

    Aeons.events.on(MouseEvent.MOUSE_SCROLL, mouseZoom);
  }

  public function setPosition(x: Float, y: Float) {
    transform.x = x;
    transform.y = y;
  }

  public function addChild(transform: CTransform) {
    camera.addChild(transform);
  }

  function mouseZoom(event: MouseEvent) {
    if (event.scrollDirection > 0) {
      camera.zoom += 0.05;
    } else {
      camera.zoom -= 0.05;
    }
  }
}
