package entities;

import aeons.components.CSprite;
import aeons.Aeons;
import aeons.graphics.Color;
import components.CBunnyMove;
import aeons.components.CTransform;
import aeons.core.Entity;

class EBunny extends Entity {

  public function new() {
    super();
  }

  public override function init(id: Int) {
    super.init(id);

    addComponent(new CTransform());
    addComponent(new CBunnyMove());
    final color = Color.fromBytes(Aeons.random.int(0, 255), Aeons.random.int(0, 255), Aeons.random.int(0, 255));
    final atlas = Aeons.assets.getAtlas('atlas');
    addComponent(new CSprite({ atlas: atlas, frameName: 'bunny', color: color }));
  }
}