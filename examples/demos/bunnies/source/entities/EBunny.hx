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
  public function create(): EBunny {
    // Transform component.
    addComponent(CTransform).create();

    // Bunny move component.
    addComponent(CBunnyMove).create();

    // Random color.
    final color = Color.fromBytes(Aeons.random.int(0, 255), Aeons.random.int(0, 255), Aeons.random.int(0, 255));

    // Get the atlas loaded in the game scene.
    final atlas = Aeons.assets.getAtlas('atlas');

    // Sprite component.
    addComponent(CSprite).create({ atlas: atlas, frameName: 'bunny', color: color });

    return this;
  }
}
