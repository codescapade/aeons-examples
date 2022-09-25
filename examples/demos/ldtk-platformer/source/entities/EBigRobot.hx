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
 * Big robot enemy entity.
 */
class EBigRobot extends Entity {
  public function create(levelData: Ldtk.Entity_Robot_big): EBigRobot {
    // Add component doesn't work in the constructor.
    addComponent(CTransform).create({ x: levelData.pixelX, y: levelData.pixelY });

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(CSprite).create({ atlas: atlas, frameName: 'robot_00' });

    addComponent(CSimpleBody).create({
      width: 24,
      height: 22,
      offset: { x: 0, y: 2 },
      type: KINEMATIC,
      tags: [Tag.Enemy]
    });

    final minX = GridHelper.gridToWorld(levelData.f_Path[0].cx);
    final maxX = GridHelper.gridToWorld(levelData.f_Path[1].cx);
    addComponent(CPatrol).create(minX, maxX, 14);

    final walk = new Animation('walk', atlas, ['robot_00', 'robot_01', 'robot_02'], 0.15, LOOP);
    addComponent(CAnimation).create([walk]).play('walk');

    return this;
  }
}
