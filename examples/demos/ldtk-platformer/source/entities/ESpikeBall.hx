package entities;

import aeons.Aeons;
import aeons.components.CLayer;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;

/**
 * The spikeball enemy entity.
 */
class ESpikeBall extends Entity {
  var transform: CTransform;

  var minY: Float;

  var maxY: Float;

  public function create(levelData: Ldtk.Entity_Spike_ball): ESpikeBall {
    transform = addComponent(CTransform).create({ x: levelData.pixelX, y: levelData.pixelY });
    minY = transform.y - 3;
    maxY = transform.y + 3;

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(CSprite).create({ atlas: atlas, frameName: 'spike_ball' });
    addComponent(CLayer).create();

    addComponent(CSimpleBody).create({
      width: 16,
      height: 16,
      type: KINEMATIC,
      tags: [Tag.Death],
      isTrigger: true
    });

    moveUp();

    return this;
  }

  // These tweens move the enemy up and down repeatedly.
  function moveUp() {
    Aeons.tweens.create(transform, 0.3, { y: minY }).setOnComplete(moveDown);
  }

  function moveDown() {
    Aeons.tweens.create(transform, 0.3, { y: maxY }).setOnComplete(moveUp);
  }
}
