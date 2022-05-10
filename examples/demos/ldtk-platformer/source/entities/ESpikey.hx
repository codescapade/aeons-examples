package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

import components.CPatrol;

/**
 * The enemy with a spike on his back entity.
 */
class ESpikey extends Entity {
  final levelData: Ldtk.Entity_Spikey;

  public function new(levelData: Ldtk.Entity_Spikey) {
    super();
    this.levelData = levelData;
  }

  public override function init(id: Int) {
    super.init(id);

    addComponent(new CTransform({ x: levelData.pixelX, y: levelData.pixelY }));

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(new CSprite({ atlas: atlas, frameName: 'spikey_00' }));

    addComponent(new CSimpleBody({
      width: 12,
      height: 16,
      offset: { x: 0, y: 4 },
      type: KINEMATIC,
      tags: [Tag.Death]
    }));

    final minX = GridHelper.gridToWorld(levelData.f_Path[0].cx);
    final maxX = GridHelper.gridToWorld(levelData.f_Path[1].cx);
    addComponent(new CPatrol(minX, maxX, 18));

    final walk = new Animation('walk', atlas, ['spikey_00', 'spikey_01', 'spikey_02'], 0.15, LOOP);
    addComponent(new CAnimation([walk])).play('walk');
  }
}
