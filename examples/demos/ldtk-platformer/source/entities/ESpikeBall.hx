package entities;

import aeons.Aeons;
import aeons.components.CSimpleBody;
import aeons.components.CSprite;
import aeons.components.CTransform;
import aeons.core.Entity;

class ESpikeBall extends Entity {
  final levelData: Ldtk.Entity_Spike_ball;

  var transform: CTransform;

  var minY: Float;

  var maxY: Float;

  public function new(levelData: Ldtk.Entity_Spike_ball) {
    super();
    this.levelData = levelData;
  }

  public override function init(id: Int) {
    super.init(id);

    transform = addComponent(new CTransform({ x: levelData.pixelX, y: levelData.pixelY }));
    minY = transform.y - 3;
    maxY = transform.y + 3;

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(new CSprite({ atlas: atlas, frameName: 'spike_ball' }));

    addComponent(new CSimpleBody({
      width: 16,
      height: 16,
      type: KINEMATIC,
      tags: [Tag.Death]
    }));

    moveUp();
  }

  function moveUp() {
    Aeons.tweens.create(transform, 0.3, { y: minY }).setOnComplete(moveDown);
  }

  function moveDown() {
    Aeons.tweens.create(transform, 0.3, { y: maxY }).setOnComplete(moveUp);
  }
}
