package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CAudio;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;
import aeons.math.Vector2;

import components.CPlayer;

/**
 * The player entity.
 */
class EPlayer extends Entity {
  // Making the transform component public so it can be followed by the camera.
  public var transform(default, null): CTransform;

  public function create(x: Float, y: Float, flipped: Bool, health: Int): EPlayer {
    transform = addComponent(CTransform).create({
      x: x,
      y: y,
      zIndex: 3,
      scaleX: flipped ? -1 : 1
    });

    final atlas = Aeons.assets.getAtlas('sprites');

    addComponent(CSprite).create({ atlas: atlas, frameName: 'orange_alien_00' });

    addComponent(CSimpleBody).create({
      width: 16,
      height: 22,
      offset: { x: 0, y: 1 },
      tags: [Tag.Player]
    });

    addComponent(CPlayer).create(new Vector2(x, y), health);

    final idleAnim = new Animation(PlayerAnims.Idle, atlas, ['orange_alien_00'], 1);
    final walkAnim = new Animation(PlayerAnims.Walk, atlas, ['orange_alien_00', 'orange_alien_01'], 0.15, LOOP);
    final jumpAnim = new Animation(PlayerAnims.Jump, atlas, ['orange_alien_01'], 1);
    addComponent(CAnimation).create([idleAnim, walkAnim, jumpAnim]);

    final jumpSound = Aeons.assets.getSound('jump');
    addComponent(CAudio).create({ sound: jumpSound });

    return this;
  }
}
