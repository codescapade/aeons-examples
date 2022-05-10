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

  /**
   * Initialize the component. This is called automatically.
   * @param id The entity for this id.
   */
  public override function init(id: Int) {
    super.init(id);

    // Add component doesn't work in the constructor.
    transform = addComponent(new CTransform());
    camera = addComponent(new CCamera({ zoom: 1 }));
    addComponent(new CCameraFollow(target, bounds));
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
