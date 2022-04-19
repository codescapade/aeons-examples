package entities;

import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;

class ECamera extends Entity {
  
  public function new() {
    super();
  }

  public override function init(id: Int) {
    super.init(id);

    addComponent(new CTransform());
    addComponent(new CCamera());
  }
}