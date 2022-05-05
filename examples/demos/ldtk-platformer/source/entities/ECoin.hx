package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CAudio;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

class ECoin extends Entity {

  final startX: Float;

  final startY: Float;

  public function new(x: Float, y: Float) {
    super();
    startX = x;
    startY = y;
  }

  public override function init(id: Int) {
    super.init(id);

    final coinSound = Aeons.assets.getSound('coin');
    final atlas = Aeons.assets.getAtlas('sprites');

    addComponent(new CTransform({
      x: startX,
      y: startY
    }));

    addComponent(new CSprite({
      atlas: atlas,
      frameName: 'coin_00'
    }));

    final coinAnim = new Animation('coin', atlas, ['coin_00', 'coin_01' ], Aeons.random.float(0.15, 0.3), LOOP);
    final anim = addComponent(new CAnimation([coinAnim]));
    anim.play('coin');

    addComponent(new CSimpleBody({
      width: 10,
      height: 10,
      type: STATIC,
      isTrigger: true,
      tags: [Tag.Coin]
    }));

    addComponent(new CAudio(coinSound));
  }
}
