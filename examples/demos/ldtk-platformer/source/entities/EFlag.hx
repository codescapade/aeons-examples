package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CLayer;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

/**
 * The goal flag entity.
 */
class EFlag extends Entity {
  /**
   * Constructor.
   * @param x The x position of the flag in pixels.
   * @param y The y position of the flag in pixels.
   */
  public function create(x: Float, y: Float): EFlag {
    final atlas = Aeons.assets.getAtlas('sprites');

    addComponent(CTransform).create({
      x: x,
      y: y
    });

    addComponent(CSprite).create({
      atlas: atlas,
      frameName: 'flag_00'
    });

    addComponent(CLayer).create();

    addComponent(CSimpleBody).create({
      width: 18,
      height: 36,
      type: STATIC,
      tags: [Tag.Flag],
      isTrigger: true
    });

    final waveAnim = new Animation('wave', atlas, ['flag_00', 'flag_01'], 0.2, LOOP);
    addComponent(CAnimation).create([waveAnim]).play('wave');

    return this;
  }
}
