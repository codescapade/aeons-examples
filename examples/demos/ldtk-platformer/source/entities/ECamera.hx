package entities;

import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.math.Rect;

import components.CCameraFollow;

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
    addComponent(new CCameraFollow(target, bounds));
  }

  public function setPosition(x: Float, y: Float) {
    transform.x = x;
    transform.y = y;
  }

  public function addChild(transform: CTransform) {
    camera.addChild(transform);
  }
}
