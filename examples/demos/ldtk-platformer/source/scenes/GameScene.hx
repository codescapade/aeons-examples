package scenes;

import components.CGameOverText;
import systems.HealthSystem;
import components.CHealthIcon;
import aeons.math.AeMath;
import aeons.events.SceneEvent;
import components.CFPSUpdate;
import aeons.components.CAnimation;
import aeons.graphics.animation.Animation;
import systems.EnemyPatrol;
import components.CPatrol;
import aeons.Aeons;
import aeons.components.CLdtkTilemap;
import aeons.components.CSimpleBody;
import aeons.components.CSimpleTilemapCollider;
import aeons.components.CSprite;
import aeons.components.CText;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.events.input.KeyboardEvent;
import aeons.graphics.Color;
import aeons.math.Rect;
import aeons.systems.AnimationSystem;
import aeons.systems.DebugRenderSystem;
import aeons.systems.RenderSystem;
import aeons.systems.SimplePhysicsSystem;
import aeons.systems.UpdateSystem;
import aeons.tilemap.Tileset;
import aeons.tilemap.ldtk.LdtkLayer;

import components.CCoinCounter;
import entities.ECamera;
import entities.ECoin;
import entities.EFlag;
import entities.EPlayer;
import systems.PhysicsInteractions;
import systems.PlayerMovement;

class GameScene extends Scene {

  var debug: DebugRenderSystem;

  var fpsEntity: Entity;

  public override function init() {
    super.init();
    final world = new Ldtk();
    final level = world.all_levels.Level_01;

    addSystem(new SimplePhysicsSystem({
      worldY: -200,
      worldWidth: level.pxWid,
      worldHeight: level.pxHei + 400,
      gravity: { x: 0, y: 800 }
    }));

    addSystem(new EnemyPatrol());
    addSystem(new AnimationSystem());
    addSystem(new UpdateSystem());
    addSystem(new PlayerMovement());
    addSystem(new HealthSystem());
    addSystem(new RenderSystem());
    addSystem(new PhysicsInteractions());

    debug = addSystem(new DebugRenderSystem());
    debug.enabled = false;

    createTilemap(level);

    final levelEntities = level.l_Entities;
    addOneWayPlatforms(levelEntities.all_One_way);
    createDeathZones(levelEntities.all_Death);

    for (coin in levelEntities.all_Coin) {
      addEntity(new ECoin(coin.pixelX, coin.pixelY));
    }

    createSmallRobots(levelEntities.all_Robot_small, levelEntities.gridSize);
    createBigRobots(levelEntities.all_Robot_big, levelEntities.gridSize);
    createFlyers(levelEntities.all_Flyer, levelEntities.gridSize);
    createSpikeys(levelEntities.all_Spikey, levelEntities.gridSize);
    createSpikeBall(levelEntities.all_Spike_ball, levelEntities.gridSize);

    final flagData = levelEntities.all_Flag[0];
    addEntity(new EFlag(flagData.pixelX, flagData.pixelY, flagData.width, flagData.height));

    final playerData = levelEntities.all_Player[0];
    final player = addEntity(new EPlayer(playerData.pixelX, playerData.pixelY, playerData.f_Flipped, userData.health));

    final bounds = new Rect(0, 0, level.pxWid, level.pxHei);
    final camera = addEntity(new ECamera(player.transform, bounds));

    final camX = AeMath.clamp(playerData.pixelX, 0 + Aeons.display.viewWidth * 0.5,
        level.pxWid - Aeons.display.viewWidth * 0.5);
    final camY = AeMath.clamp(playerData.pixelY, 0 + Aeons.display.viewHeight * 0.5,
        level.pxHei - Aeons.display.viewHeight * 0.5);

    camera.setPosition(camX, camY);

    createCoinCounter(camera, levelEntities.all_Coin.length);
    createHearts(camera, 5);
    createGameOverText(camera);

    createFPS(camera);
    Aeons.events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function addOneWayPlatforms(platforms: Array<Ldtk.Entity_One_way>) {
    for (platform in platforms) {
      final entity = addEntity(new Entity());

      entity.addComponent(new CTransform({
        x: platform.pixelX,
        y: platform.pixelY
      }));

      entity.addComponent(new CSimpleBody({
        width: platform.width,
        height: platform.height,
        canCollide: TOP,
        type: STATIC
      }));
    }
  }

  function createTilemap(level: Ldtk.Ldtk_Level) {
    final bgTileset = Tileset.fromLdtkTileset(level.l_Background.tileset);
    final levelTileset = Tileset.fromLdtkTileset(level.l_Collision.tileset);

    final backgroundLayer = LdtkLayer.fromTilesLayer(level.l_Background, bgTileset);
    final collisionLayer = LdtkLayer.fromIntAutoLayer(level.l_Collision, levelTileset);
    final plantsLayer = LdtkLayer.fromAutoLayer(level.l_Plants, levelTileset);
    final decorLayer = LdtkLayer.fromIntAutoLayer(level.l_Decor, levelTileset);

    final entity = addEntity(new Entity());
    entity.addComponent(new CTransform());

    final tilemap = entity.addComponent(new CLdtkTilemap());
    tilemap.addLayers([backgroundLayer, collisionLayer, plantsLayer, decorLayer]);

    final collider = entity.addComponent(new CSimpleTilemapCollider());
    collider.setCollisionsFromLdtkLayer(collisionLayer, 0, 0, []);
    collider.addTag(Tag.Ground);
  }

  function createCoinCounter(camera: ECamera, totalCoins: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');

    final icon = addEntity(new Entity());

    final iconTransform = icon.addComponent(new CTransform({
      x: 20,
      y: 20,
      scaleX: 1,
      scaleY: 1,
      zIndex: 5
    }));
    camera.addChild(iconTransform);

    icon.addComponent(new CSprite({
      atlas: atlas,
      frameName: 'coin_00'
    }));

    final counter = addEntity(new Entity());

    counter.addComponent(new CTransform({
      x: 12,
      y: 0,
      zIndex: 5,
      parent: iconTransform
    }));

    final font = Aeons.assets.getFont('kenney_pixel');
    counter.addComponent(new CText({
      font: font,
      fontSize: 12,
      anchorX: 0,
      color: Color.Black
    }));

    counter.addComponent(new CCoinCounter({
      totalCoins: totalCoins
    }));
  }

  function createDeathZones(zones: Array<Ldtk.Entity_Death>) {
    for (zone in zones) {
      final entity = addEntity(new Entity());

      entity.addComponent(new CTransform({
        x: zone.pixelX,
        y: zone.pixelY
      }));

      entity.addComponent(new CSimpleBody({
        width: zone.width,
        height: zone.height,
        type: STATIC,
        tags: [Tag.Death],
        isTrigger: true
      }));
    }
  }

  function createSmallRobots(data: Array<Ldtk.Entity_Robot_small>, gridSize: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');

    for (item in data) {
      var entity = addEntity(new Entity());
      entity.addComponent(new CTransform({
        x: item.pixelX,
        y: item.pixelY
      }));

      entity.addComponent(new CSprite({
        atlas: atlas,
        frameName: 'robot_small_00'
      }));
      
      entity.addComponent(new CSimpleBody({
        width: 14,
        height: 12,
        offset: { x: 0, y: 6 },
        type: KINEMATIC,
        tags: [Tag.Enemy]
      }));

      entity.addComponent(new CPatrol({
        startX: gridToWorld(item.f_Path[0].cx, gridSize),
        startY: gridToWorld(item.f_Path[0].cy, gridSize),
        endX: gridToWorld(item.f_Path[1].cx, gridSize),
        endY: gridToWorld(item.f_Path[1].cy, gridSize),
        speed: 20
      }));

      var walk = new Animation('walk', atlas, ['robot_small_00', 'robot_small_01', 'robot_small_02'], 0.15, LOOP);
      var anim = entity.addComponent(new CAnimation({ animations: [walk] }));
      anim.play('walk');
    }
  }

  function createBigRobots(data: Array<Ldtk.Entity_Robot_big>, gridSize: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');

    for (item in data) {
      var entity = addEntity(new Entity());
      entity.addComponent(new CTransform({
        x: item.pixelX,
        y: item.pixelY
      }));

      entity.addComponent(new CSprite({
        atlas: atlas,
        frameName: 'robot_00'
      }));
      
      entity.addComponent(new CSimpleBody({
        width: 24,
        height: 22,
        offset: { x: 0, y: 2 },
        type: KINEMATIC,
        tags: [Tag.Enemy]
      }));

      entity.addComponent(new CPatrol({
        startX: gridToWorld(item.f_Path[0].cx, gridSize),
        startY: gridToWorld(item.f_Path[0].cy, gridSize),
        endX: gridToWorld(item.f_Path[1].cx, gridSize),
        endY: gridToWorld(item.f_Path[1].cy, gridSize),
        speed: 20
      }));

      var walk = new Animation('walk', atlas, ['robot_00', 'robot_01', 'robot_02'], 0.15, LOOP);
      var anim = entity.addComponent(new CAnimation({ animations: [walk] }));
      anim.play('walk');
    }
  }

  function createFlyers(data: Array<Ldtk.Entity_Flyer>, gridSize: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');

    for (item in data) {
      var entity = addEntity(new Entity());
      entity.addComponent(new CTransform({
        x: item.pixelX,
        y: item.pixelY
      }));

      entity.addComponent(new CSprite({
        atlas: atlas,
        frameName: 'flyer_00'
      }));
      
      entity.addComponent(new CSimpleBody({
        width: 12,
        height: 12,
        offset: { x: 0, y: 0 },
        type: KINEMATIC,
        tags: [Tag.Enemy]
      }));

      entity.addComponent(new CPatrol({
        startX: gridToWorld(item.f_Path[0].cx, gridSize),
        startY: gridToWorld(item.f_Path[0].cy, gridSize),
        endX: gridToWorld(item.f_Path[1].cx, gridSize),
        endY: gridToWorld(item.f_Path[1].cy, gridSize),
        speed: 20
      }));

      var fly = new Animation('fly', atlas, ['flyer_00', 'flyer_01', 'flyer_02'], 0.15, LOOP);
      var anim = entity.addComponent(new CAnimation({ animations: [fly] }));
      anim.play('fly');
    }
  }

  function createSpikeys(data: Array<Ldtk.Entity_Spikey>, gridSize: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');

    for (item in data) {
      var entity = addEntity(new Entity());
      entity.addComponent(new CTransform({
        x: item.pixelX,
        y: item.pixelY
      }));

      entity.addComponent(new CSprite({
        atlas: atlas,
        frameName: 'spikey_00'
      }));

      entity.addComponent(new CSimpleBody({
        width: 12,
        height: 16,
        offset: { x: 0, y: 4 },
        type: KINEMATIC,
        isTrigger: true,
        tags: [Tag.Death]
      }));

      entity.addComponent(new CPatrol({
        startX: gridToWorld(item.f_Path[0].cx, gridSize),
        startY: gridToWorld(item.f_Path[0].cy, gridSize),
        endX: gridToWorld(item.f_Path[1].cx, gridSize),
        endY: gridToWorld(item.f_Path[1].cy, gridSize),
        speed: 20
      }));

      var walk = new Animation('walk', atlas, ['spikey_00', 'spikey_01', 'spikey_02'], 0.15, LOOP);
      var anim = entity.addComponent(new CAnimation({ animations: [walk] }));
      anim.play('walk');
    }
  }

  function createSpikeBall(data: Array<Ldtk.Entity_Spike_ball>, gridSize: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');

    for (item in data) {
      var entity = addEntity(new Entity());
      entity.addComponent(new CTransform({
        x: item.pixelX,
        y: item.pixelY
      }));

      entity.addComponent(new CSprite({
        atlas: atlas,
        frameName: 'spike_ball'
      }));

      entity.addComponent(new CSimpleBody({
        width: 16,
        height: 16,
        offset: { x: 0, y: 0 },
        type: STATIC,
        isTrigger: true,
        tags: [Tag.Death]
      }));
    }
  }

  function keyDown(event: KeyboardEvent) {
    if (event.key == Q) {
      debug.enabled = !debug.enabled;
      fpsEntity.active = debug.enabled;
    }
  }

  function gridToWorld(gridPos, gridSize): Float {
    return gridPos * gridSize + gridSize * 0.5;
  }

  function createFPS(camera: ECamera) {
    final font = Aeons.assets.getFont('kenney_pixel');
    fpsEntity = addEntity(new Entity());

    final transform = fpsEntity.addComponent(new CTransform({ x: Aeons.display.viewWidth - 60, y: 10, zIndex: 5 }));
    camera.addChild(transform);

    fpsEntity.addComponent(new CText({ font: font, fontSize: 12, anchorX: 0, text: 'FPS: 0', hasBackground: true }));
    fpsEntity.addComponent(new CFPSUpdate());
    fpsEntity.active = false;
  }

  function createGameOverText(camera: ECamera) {
    final font = Aeons.assets.getFont('kenney_pixel');
    final entity = addEntity(new Entity());
    final transform = entity.addComponent(new CTransform({ x: Aeons.display.viewCenterX, y: 120, zIndex: 5 }));
    camera.addChild(transform);
    entity.addComponent(new CText({ font: font, fontSize: 30, text: 'Game Over', anchorX: 0.5, color: Color.Black }));
    entity.addComponent(new CGameOverText());
    entity.active = false;
  }

  function createHearts(camera: ECamera, totalHearts: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');
    var x = 300;
    final y = 20;

    for (i in 0...totalHearts) {
      var e = addEntity(new Entity());
      var transform = e.addComponent(new CTransform({ x: x, y: y }));
      camera.addChild(transform);

      e.addComponent(new CSprite({ atlas: atlas, frameName: 'heart_empty' }));
      e.addComponent(new CHealthIcon());

      x += 20;
    }
  }
}
