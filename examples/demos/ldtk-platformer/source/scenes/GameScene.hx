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

  public override function init() {
    final world = new Ldtk();
    final level = world.all_levels.Level_01;

    addSystem(new SimplePhysicsSystem({
      worldY: -200,
      worldWidth: level.pxWid,
      worldHeight: level.pxHei + 200,
      gravity: { x: 0, y: 800 }
    }));

    addSystem(new AnimationSystem());
    addSystem(new UpdateSystem());
    addSystem(new PlayerMovement());
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

    final flagData = levelEntities.all_Flag[0];
    addEntity(new EFlag(flagData.pixelX, flagData.pixelY, flagData.width, flagData.height));

    final playerData = levelEntities.all_Player[0];
    final player = addEntity(new EPlayer(playerData.pixelX, playerData.pixelY, playerData.f_Flipped));

    final bounds = new Rect(0, 0, level.pxWid, level.pxHei);
    final camera = addEntity(new ECamera(player.transform, bounds));
    camera.setPosition(playerData.pixelX, playerData.pixelY);

    createCoinCounter(camera, levelEntities.all_Coin.length);

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
      zIndex: 1
    }));
    camera.addChild(iconTransform);

    icon.addComponent(new CSprite({
      atlas: atlas,
      frameName: 'coin_00'
    }));

    final counter = addEntity(new Entity());

    counter.addComponent(new CTransform({
      x: 12,
      y: -1,
      zIndex: 5,
      parent: iconTransform
    }));

    final font = Aeons.assets.getFont('kenney_mini');
    counter.addComponent(new CText({
      font: font,
      fontSize: 20,
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

  function keyDown(event: KeyboardEvent) {
    if (event.key == Q) {
      debug.enabled = !debug.enabled;
    }
  }
}
