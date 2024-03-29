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
 * The flyer enemy entity.
 */
class EFlyer extends Entity {
  public function create(levelData: Ldtk.Entity_Flyer): EFlyer {
    addComponent(CTransform).create({ x: levelData.pixelX, y: levelData.pixelY });

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(CSprite).create({ atlas: atlas, frameName: 'flyer_00' });

    addComponent(CSimpleBody).create({
      width: 12,
      height: 12,
      type: KINEMATIC,
      tags: [Tag.Enemy]
    });

    // Get the world position of the min an max patrol positions.
    final minX = GridHelper.gridToWorld(levelData.f_Path[0].cx);
    final maxX = GridHelper.gridToWorld(levelData.f_Path[1].cx);
    addComponent(CPatrol).create(minX, maxX, 20);

    final fly = new Animation('fly', atlas, ['flyer_00', 'flyer_01', 'flyer_02'], 0.15, LOOP);
    addComponent(CAnimation).create([fly]).play('fly');

    return this;
  }
}
