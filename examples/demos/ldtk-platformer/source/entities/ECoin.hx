package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CAudio;
import aeons.components.CLayer;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

/**
 * The coin collectable entity.
 */
class ECoin extends Entity {
  /**
   * Constructor.
   * @param x The x position of the flag in pixels.
   * @param y The y position of the flag in pixels.
   */
  public function create(x: Float, y: Float): ECoin {
    addComponent(CTransform).create({ x: x, y: y });

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(CSprite).create({ atlas: atlas, frameName: 'coin_00' });
    addComponent(CLayer).create();

    final coinAnim = new Animation('rotate', atlas, ['coin_00', 'coin_01'], Aeons.random.float(0.15, 0.3), LOOP);

    // Add the animation component and start the 'rotate' animation
    addComponent(CAnimation).create([coinAnim]).play('rotate');

    addComponent(CSimpleBody).create({
      width: 10,
      height: 10,
      type: STATIC,
      isTrigger: true,
      tags: [Tag.Coin]
    });

    final coinSound = Aeons.assets.getSound('coin');
    addComponent(CAudio).create({ sound: coinSound });

    return this;
  }
}
