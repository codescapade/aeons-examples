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
  final levelData: Ldtk.Entity_Robot_big;

  public function new(levelData: Ldtk.Entity_Robot_big) {
    super();
    this.levelData = levelData;
  }

  /**
   * Initialize the component. This is called automatically.
   * @param id The entity for this id.
   */
  public override function init(id: Int) {
    super.init(id);

    // Add component doesn't work in the constructor.
    addComponent(new CTransform({ x: levelData.pixelX, y: levelData.pixelY }));

    final atlas = Aeons.assets.getAtlas('sprites');
    addComponent(new CSprite({ atlas: atlas, frameName: 'robot_00' }));

    addComponent(new CSimpleBody({
      width: 24,
      height: 22,
      offset: { x: 0, y: 2 },
      type: KINEMATIC,
      tags: [Tag.Enemy]
    }));

    final minX = GridHelper.gridToWorld(levelData.f_Path[0].cx);
    final maxX = GridHelper.gridToWorld(levelData.f_Path[1].cx);
    addComponent(new CPatrol(minX, maxX, 14));

    final walk = new Animation('walk', atlas, ['robot_00', 'robot_01', 'robot_02'], 0.15, LOOP);
    addComponent(new CAnimation([walk])).play('walk');
  }
}
