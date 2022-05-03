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

class EPlayer extends Entity {
  public var transform(default, null): CTransform;

  final startX: Float;

  final startY: Float;

  final startFlipped: Bool;

  final health: Int;

  public function new(x: Float, y: Float, flipped: Bool, health: Int) {
    super();
    startX = x;
    startY = y;
    startFlipped = flipped;
    this.health = health;
  }

  public override function init(id: Int) {
    super.init(id);

    transform = addComponent(new CTransform({
      x: startX,
      y: startY,
      zIndex: 3,
      scaleX: startFlipped ? -1 : 1
    }));

    final atlas = Aeons.assets.getAtlas('sprites');

    addComponent(new CSprite({
      atlas: atlas,
      frameName: 'orange_alien_00'
    }));

    addComponent(new CSimpleBody({
      width: 16,
      height: 22,
      offset: { x: 0, y: 1},
      tags: [Tag.Player]
    }));

    addComponent(new CPlayer({
      spawn: new Vector2(startX, startY),
      health: health
    }));

    final idleAnim = new Animation(PlayerAnims.Idle, atlas, ['orange_alien_00'], 1);
    final walkAnim = new Animation(PlayerAnims.Walk, atlas, ['orange_alien_00', 'orange_alien_01'], 0.15, LOOP);
    final jumpAnim = new Animation(PlayerAnims.Jump, atlas, ['orange_alien_01'], 1);
    addComponent(new CAnimation({
      animations: [idleAnim, walkAnim, jumpAnim]
    }));

    final jumpSound = Aeons.assets.getSound('jump');
    addComponent(new CAudio({
      sound: jumpSound
    }));
  }
}
