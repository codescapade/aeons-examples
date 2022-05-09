package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

import components.CPatrol;

class ESmallRobot extends Entity {
  final levelData: Ldtk.Entity_Robot_small;

  public function new(levelData: Ldtk.Entity_Robot_small) {
    super();
    this.levelData = levelData;
  }

  public override function init(id: Int) {
    super.init(id);

    addComponent(new CTransform({ x: levelData.pixelX, y: levelData.pixelY }));

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(new CSprite({ atlas: atlas, frameName: 'robot_small_00' }));

    addComponent(new CSimpleBody({
      width: 14,
      height: 12,
      offset: { x: 0, y: 6 },
      type: KINEMATIC,
      tags: [Tag.Enemy]
    }));

    final minX = GridHelper.gridToWorld(levelData.f_Path[0].cx);
    final maxX = GridHelper.gridToWorld(levelData.f_Path[1].cx);
    addComponent(new CPatrol(minX, maxX, 18));

    final walk = new Animation('walk', atlas, ['robot_small_00', 'robot_small_01', 'robot_small_02'], 0.15, LOOP);
    addComponent(new CAnimation([walk])).play('walk');
  }
}
