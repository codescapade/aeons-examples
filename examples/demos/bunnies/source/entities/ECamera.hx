package entities;

import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;

/**
 * Camera entity.
 */
class ECamera extends Entity {
  public function new() {
    super();
  }

  // Init gets called after the entity has been created. This is where you can add components and access other
  // entity variables that are not available in the constructor.
  public override function init(id: Int) {
    super.init(id);

    // Transform component.
    addComponent(new CTransform());

    // Camera component.
    addComponent(new CCamera());
  }
}
