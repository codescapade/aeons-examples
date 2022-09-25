package scenes;

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
import aeons.systems.SAnimation;
import aeons.systems.SDebugRender;
import aeons.systems.SRender;
import aeons.systems.SSimplePhysics;
import aeons.systems.SUpdate;
import aeons.tilemap.Tileset;
import aeons.tilemap.ldtk.LdtkLayer;

import components.CCoinCounter;
import components.CFPSUpdate;
import components.CGameOverText;
import components.CHealthIcon;

import entities.EBigRobot;
import entities.ECamera;
import entities.ECoin;
import entities.EFlag;
import entities.EFlyer;
import entities.EPlayer;
import entities.ESmallRobot;
import entities.ESpikeBall;
import entities.ESpikey;

import systems.SEnemyPatrol;
import systems.SHealth;
import systems.SPhysicsInteractions;
import systems.SPlayerMovement;

using aeons.math.AeMath;

class GameScene extends Scene {
  var debug: SDebugRender;

  var fpsEntity: Entity;

  public override function create() {
    final world = new Ldtk();
    final level = world.getLevel('Level_0${userData.level}');

    addSystem(SSimplePhysics).create({
      worldY: -200,
      worldWidth: level.pxWid,
      worldHeight: level.pxHei + 400,
      gravity: { x: 0, y: 800 }
    });

    addSystem(SEnemyPatrol).create();
    addSystem(SAnimation).create();
    addSystem(SUpdate).create();
    addSystem(SPlayerMovement).create();
    addSystem(SHealth).create();
    addSystem(SRender).create();
    addSystem(SPhysicsInteractions).create(userData.level);

    debug = addSystem(SDebugRender).create();
    debug.enabled = false;

    createTilemap(level);

    final levelEntities = level.l_Entities;
    addOneWayPlatforms(levelEntities.all_One_way);
    createDeathZones(levelEntities.all_Death);

    for (coin in levelEntities.all_Coin) {
      addEntity(ECoin).create(coin.pixelX, coin.pixelY);
    }

    for (robotData in levelEntities.all_Robot_small) {
      addEntity(ESmallRobot).create(robotData);
    }

    for (robotData in levelEntities.all_Robot_big) {
      addEntity(EBigRobot).create(robotData);
    }

    for (flyerData in levelEntities.all_Flyer) {
      addEntity(EFlyer).create(flyerData);
    }

    for (spikeyData in levelEntities.all_Spikey) {
      addEntity(ESpikey).create(spikeyData);
    }

    for (spikeData in levelEntities.all_Spike_ball) {
      addEntity(ESpikeBall).create(spikeData);
    }

    final flagData = levelEntities.all_Flag[0];
    addEntity(EFlag).create(flagData.pixelX, flagData.pixelY);

    final playerData = levelEntities.all_Player[0];
    final player = addEntity(EPlayer).create(playerData.pixelX, playerData.pixelY, playerData.f_Flipped,
      userData.health);

    final bounds = new Rect(0, 0, level.pxWid, level.pxHei);
    final camera = addEntity(ECamera).create(player.transform, bounds);

    final camX = Math.clamp(playerData.pixelX, 0 + Aeons.display.viewWidth * 0.5,
      level.pxWid - Aeons.display.viewWidth * 0.5);
    final camY = Math.clamp(playerData.pixelY, 0 + Aeons.display.viewHeight * 0.5,
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
      final entity = addEntity(Entity);

      entity.addComponent(CTransform).create({
        x: platform.pixelX,
        y: platform.pixelY
      });

      entity.addComponent(CSimpleBody).create({
        width: platform.width,
        height: platform.height,
        canCollide: TOP,
        type: STATIC
      });
    }
  }

  function createTilemap(level: Ldtk.Ldtk_Level) {
    final bgTileset = Tileset.fromLdtkTileset(level.l_Background.tileset);
    final levelTileset = Tileset.fromLdtkTileset(level.l_Collision.tileset);

    final backgroundLayer = LdtkLayer.fromTilesLayer(level.l_Background, bgTileset);
    final collisionLayer = LdtkLayer.fromIntAutoLayer(level.l_Collision, levelTileset);
    final plantsLayer = LdtkLayer.fromAutoLayer(level.l_Plants, levelTileset);
    final decorLayer = LdtkLayer.fromIntAutoLayer(level.l_Decor, levelTileset);

    final entity = addEntity(Entity);
    entity.addComponent(CTransform).create();

    final tilemap = entity.addComponent(CLdtkTilemap).create();
    tilemap.addLayers([backgroundLayer, collisionLayer, plantsLayer, decorLayer]);

    final collider = entity.addComponent(CSimpleTilemapCollider).create();
    collider.setCollisionsFromLdtkLayer(collisionLayer, 0, 0, []);
    collider.addTag(Tag.Ground);
  }

  function createCoinCounter(camera: ECamera, totalCoins: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');

    final icon = addEntity(Entity);

    final iconTransform = icon.addComponent(CTransform).create({
      x: 20,
      y: 20,
      scaleX: 1,
      scaleY: 1,
      zIndex: 5
    });
    camera.addChild(iconTransform);

    icon.addComponent(CSprite).create({
      atlas: atlas,
      frameName: 'coin_00'
    });

    final counter = addEntity(Entity);

    counter.addComponent(CTransform).create({
      x: 12,
      y: 0,
      zIndex: 5,
      parent: iconTransform
    });

    final font = Aeons.assets.getFont('kenney_pixel');
    counter.addComponent(CText).create({
      font: font,
      fontSize: 12,
      anchorX: 0,
      color: Color.Black
    });

    counter.addComponent(CCoinCounter).create(userData.coins);
  }

  function createDeathZones(zones: Array<Ldtk.Entity_Death>) {
    for (zone in zones) {
      final entity = addEntity(Entity);

      entity.addComponent(CTransform).create({
        x: zone.pixelX,
        y: zone.pixelY
      });

      entity.addComponent(CSimpleBody).create({
        width: zone.width,
        height: zone.height,
        type: STATIC,
        tags: [Tag.Death],
        isTrigger: true
      });
    }
  }

  function keyDown(event: KeyboardEvent) {
    if (event.key == Q) {
      debug.enabled = !debug.enabled;
      fpsEntity.active = debug.enabled;
    }
  }

  function createFPS(camera: ECamera) {
    final font = Aeons.assets.getFont('kenney_pixel');
    fpsEntity = addEntity(Entity);

    final transform = fpsEntity.addComponent(CTransform).create({ x: Aeons.display.viewWidth - 50, y: 6, zIndex: 5 });
    camera.addChild(transform);

    fpsEntity.addComponent(CText).create({
      font: font,
      fontSize: 12,
      anchorX: 0,
      text: 'FPS: 0',
      hasBackground: true
    });
    fpsEntity.addComponent(CFPSUpdate).create();
    fpsEntity.active = false;
  }

  function createGameOverText(camera: ECamera) {
    final font = Aeons.assets.getFont('kenney_pixel');
    final entity = addEntity(Entity);
    final transform = entity.addComponent(CTransform).create({ x: Aeons.display.viewCenterX, y: 120, zIndex: 5 });
    camera.addChild(transform);
    entity.addComponent(CText).create({
      font: font,
      fontSize: 30,
      text: 'Game Over',
      anchorX: 0.5,
      color: Color.Black
    });
    entity.addComponent(CGameOverText).create();
    entity.active = false;
  }

  function createHearts(camera: ECamera, totalHearts: Int) {
    final atlas = Aeons.assets.getAtlas('sprites');
    var x = 300;
    final y = 20;

    for (i in 0...totalHearts) {
      var e = addEntity(Entity);
      var transform = e.addComponent(CTransform).create({ x: x, y: y });
      camera.addChild(transform);

      e.addComponent(CSprite).create({ atlas: atlas, frameName: 'heart_empty' });
      e.addComponent(CHealthIcon).create();

      x += 20;
    }
  }
}
