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

  public function create(target: CTransform, bounds: Rect): ECamera {
    this.target = target;
    this.bounds = bounds;

    transform = addComponent(CTransform).create();
    camera = addComponent(CCamera).create({ zoom: 1 });
    addComponent(CCameraFollow).create(target, bounds);

    return this;
  }

  /**
   * Helper to set the camera position.
   * @param x The x position in pixels.
   * @param y The y position in pixels.
   */
  public function setPosition(x: Float, y: Float) {
    transform.x = x;
    transform.y = y;
  }

  /**
   * Helper to add a child to the camera transform.
   * @param transform The transform to add.
   */
  public function addChild(transform: CTransform) {
    camera.addChild(transform);
  }
}
