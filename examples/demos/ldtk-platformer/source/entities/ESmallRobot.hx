package entities;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CLayer;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.graphics.animation.Animation;

import components.CPatrol;

/**
 * The small robot enemy entity.
 */
class ESmallRobot extends Entity {
  public function create(levelData: Ldtk.Entity_Robot_small): ESmallRobot {
    addComponent(CTransform).create({ x: levelData.pixelX, y: levelData.pixelY });

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(CSprite).create({ atlas: atlas, frameName: 'robot_small_00' });
    addComponent(CLayer).create();

    addComponent(CSimpleBody).create({
      width: 14,
      height: 12,
      offset: { x: 0, y: 6 },
      type: KINEMATIC,
      tags: [Tag.Enemy]
    });

    final minX = GridHelper.gridToWorld(levelData.f_Path[0].cx);
    final maxX = GridHelper.gridToWorld(levelData.f_Path[1].cx);
    addComponent(CPatrol).create(minX, maxX, 18);

    final walk = new Animation('walk', atlas, ['robot_small_00', 'robot_small_01', 'robot_small_02'], 0.15, LOOP);
    addComponent(CAnimation).create([walk]).play('walk');

    return this;
  }
}
