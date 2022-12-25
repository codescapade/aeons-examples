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
 * The enemy with a spike on his back entity.
 */
class ESpikey extends Entity {
  public function create(levelData: Ldtk.Entity_Spikey): ESpikey {
    addComponent(CTransform).create({ x: levelData.pixelX, y: levelData.pixelY });

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(CSprite).create({ atlas: atlas, frameName: 'spikey_00' });
    addComponent(CLayer).create();

    addComponent(CSimpleBody).create({
      width: 12,
      height: 16,
      offset: { x: 0, y: 4 },
      type: KINEMATIC,
      tags: [Tag.Death],
      isTrigger: true
    });

    final minX = GridHelper.gridToWorld(levelData.f_Path[0].cx);
    final maxX = GridHelper.gridToWorld(levelData.f_Path[1].cx);
    addComponent(CPatrol).create(minX, maxX, 18);

    final walk = new Animation('walk', atlas, ['spikey_00', 'spikey_01', 'spikey_02'], 0.15, LOOP);
    addComponent(CAnimation).create([walk]).play('walk');

    return this;
  }
}
