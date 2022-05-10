package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CAudio;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

/**
 * The coin collectable entity.
 */
class ECoin extends Entity {
  // Store the position for the init function.
  final startX: Float;

  final startY: Float;

  /**
   * Constructor.
   * @param x The x position of the flag in pixels.
   * @param y The y position of the flag in pixels.
   */
  public function new(x: Float, y: Float) {
    super();
    startX = x;
    startY = y;
  }

  public override function init(id: Int) {
    super.init(id);

    addComponent(new CTransform({ x: startX, y: startY }));

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(new CSprite({ atlas: atlas, frameName: 'coin_00' }));

    final coinAnim = new Animation('rotate', atlas, ['coin_00', 'coin_01'], Aeons.random.float(0.15, 0.3), LOOP);

    // Add the animation component and start the 'rotate' animation
    addComponent(new CAnimation([coinAnim])).play('rotate');

    addComponent(new CSimpleBody({
      width: 10,
      height: 10,
      type: STATIC,
      isTrigger: true,
      tags: [Tag.Coin]
    }));

    final coinSound = Aeons.assets.getSound('coin');
    addComponent(new CAudio(coinSound));
  }
}
