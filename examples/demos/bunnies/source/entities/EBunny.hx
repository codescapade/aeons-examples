package entities;

import aeons.Aeons;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.Color;

import components.CBunnyMove;

/**
 * The bunny entity. This basically just adds the components needed so you don't have to do that every time you
 * make a new entity. It is a bit like a prefab.
 */
class EBunny extends Entity {

  public function new() {
    super();
  }

  // Init gets called after the entity has been created. This is where you can add components and access other
  // entity variables that are not available in the constructor.
  public override function init(id: Int) {
    super.init(id);

    // Transform component.
    addComponent(new CTransform());

    // Bunny move component.
    addComponent(new CBunnyMove());

    // Random color.
    final color = Color.fromBytes(Aeons.random.int(0, 255), Aeons.random.int(0, 255), Aeons.random.int(0, 255));

    // Get the atlas loaded in the game scene.
    final atlas = Aeons.assets.getAtlas('atlas');

    // Sprite component.
    addComponent(new CSprite({ atlas: atlas, frameName: 'bunny', color: color }));
  }
}