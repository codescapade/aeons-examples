package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

class EFlag extends Entity {

  final startX: Float;
  final startY: Float;
  final width: Float;
  final height: Float;

  public function new(x: Float, y: Float, width: Float, height: Float) {
    super();

    startX = x;
    startY = y;
    this.width = width;
    this.height = height;
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
      width: width,
      height: height,
      type: STATIC,
      tags: [Tag.Flag],
      isTrigger: true
    }));

    final flagAnim = new Animation('flag', atlas, ['flag_00', 'flag_01'], 0.2, LOOP);
    final anim = addComponent(new CAnimation([flagAnim]));
    anim.play('flag');
  }
}
