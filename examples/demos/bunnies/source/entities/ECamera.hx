package entities;

import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;

/**
 * Camera entity.
 */
class ECamera extends Entity {
  public function create(): ECamera {
    // Transform component.
    addComponent(CTransform).create();

    // Camera component.
    addComponent(CCamera).create();

    return this;
  }
}
