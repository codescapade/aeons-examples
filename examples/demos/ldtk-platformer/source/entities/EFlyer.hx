package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

import components.CPatrol;

class EFlyer extends Entity {
  final levelData: Ldtk.Entity_Flyer;

  public function new(levelData: Ldtk.Entity_Flyer) {
    super();
    this.levelData = levelData;
  }

  public override function init(id: Int) {
    super.init(id);

    addComponent(new CTransform({ x: levelData.pixelX, y: levelData.pixelY }));

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(new CSprite({ atlas: atlas, frameName: 'flyer_00' }));

    addComponent(new CSimpleBody({
      width: 12,
      height: 12,
      type: KINEMATIC,
      tags: [Tag.Enemy]
    }));

    final minX = GridHelper.gridToWorld(levelData.f_Path[0].cx);
    final maxX = GridHelper.gridToWorld(levelData.f_Path[1].cx);
    addComponent(new CPatrol(minX, maxX, 20));

    final fly = new Animation('fly', atlas, ['flyer_00', 'flyer_01', 'flyer_02'], 0.15, LOOP);
    addComponent(new CAnimation([fly])).play('fly');
  }
}
