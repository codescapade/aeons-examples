package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

/**
 * The goal flag entity.
 */
class EFlag extends Entity {
  // Store the position here so we can use it in init.
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

    final atlas = Aeons.assets.getAtlas('sprites');

    addComponent(new CTransform({
      x: startX,
      y: startY
    }));

    addComponent(new CSprite({
      atlas: atlas,
      frameName: 'flag_00'
    }));

    addComponent(new CSimpleBody({
      width: 18,
      height: 36,
      type: STATIC,
      tags: [Tag.Flag],
      isTrigger: true
    }));

    final waveAnim = new Animation('wave', atlas, ['flag_00', 'flag_01'], 0.2, LOOP);
    addComponent(new CAnimation([waveAnim])).play('wave');
  }
}
