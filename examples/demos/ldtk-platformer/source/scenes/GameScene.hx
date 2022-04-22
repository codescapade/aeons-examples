package scenes;

import ldtk.Level;
import aeons.math.Vector2;
import systems.PhysicsInteractions;
import aeons.events.input.KeyboardEvent;
import components.CCoinCounter;
import aeons.graphics.Color;
import aeons.components.CText;
import aeons.systems.AnimationSystem;
import aeons.components.CAnimation;
import aeons.graphics.animation.Animation;
import aeons.graphics.atlas.Atlas;
import systems.PlayerMovement;
import components.CPlayer;
import aeons.components.CSimpleBody;
import aeons.systems.UpdateSystem;
import aeons.math.Rect;
import aeons.components.CSprite;
import aeons.Aeons;
import aeons.systems.DebugRenderSystem;
import aeons.systems.SimplePhysicsSystem;
import aeons.components.CSimpleTilemapCollider;
import aeons.components.CLdtkTilemap;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.tilemap.ldtk.LdtkLayer;
import aeons.tilemap.Tileset;
import aeons.core.Scene;
import aeons.systems.RenderSystem;

import entities.ECamera;

class GameScene extends Scene {

  var transform: CTransform;

  var debug: DebugRenderSystem;

  public override function init() {
    var world = new Ldtk();
    var level = world.all_levels.Level_01;

    addSystem(new SimplePhysicsSystem({ worldY: -200, worldWidth: level.pxWid, worldHeight: level.pxHei + 200, gravity: { x: 0, y: 800 } }));
    addSystem(new AnimationSystem());
    addSystem(new UpdateSystem());
    addSystem(new PlayerMovement());
    addSystem(new RenderSystem());
    addSystem(new PhysicsInteractions());
    debug = addSystem(new DebugRenderSystem());
    debug.enabled = false;

    var bgTileset = Tileset.fromLdtkTileset(level.l_Background.tileset);
    var levelTileset = Tileset.fromLdtkTileset(level.l_Collision.tileset);

    var backgroundLayer = LdtkLayer.fromTilesLayer(level.l_Background, bgTileset);
    var collisionLayer = LdtkLayer.fromIntAutoLayer(level.l_Collision, levelTileset);
    var plantsLayer = LdtkLayer.fromAutoLayer(level.l_Plants, levelTileset);
    var decorLayer = LdtkLayer.fromIntAutoLayer(level.l_Decor, levelTileset);
    var levelEntities = level.l_Entities;

    var entity = addEntity(new Entity());
    entity.addComponent(new CTransform());

    var tilemap = entity.addComponent(new CLdtkTilemap());
    tilemap.addLayers([backgroundLayer, collisionLayer, plantsLayer, decorLayer]);
    var collider = entity.addComponent(new CSimpleTilemapCollider());
    collider.setCollisionsFromLdtkLayer(collisionLayer, 0, 0, []);
    collider.addTag(Tag.Ground);

    var atlas = Aeons.assets.loadAtlas('sprites');

    createCoins(levelEntities.all_Coin, atlas);
    createFlag(levelEntities.all_Flag[0], atlas);

    var playerData = levelEntities.all_Player[0];
    createPlayer(playerData, atlas, level.pxHei);

    addOwnWayPlatforms(levelEntities.all_One_way);
    createDeathZones(levelEntities.all_Death);

    var bounds = new Rect(0, 0, level.pxWid, level.pxHei);
    var camera = addEntity(new ECamera(transform, bounds));
    camera.setPosition(playerData.pixelX, playerData.pixelY);

    createCoinCounter(camera, atlas, levelEntities.all_Coin.length);

    Aeons.events.on(KeyboardEvent.KEY_DOWN, keyDown);
  }

  function addOwnWayPlatforms(platforms: Array<Ldtk.Entity_One_way>) {
    for (platform in platforms) {
      var entity = addEntity(new Entity());
      entity.addComponent(new CTransform({ x: platform.pixelX, y: platform.pixelY }));
      entity.addComponent(new CSimpleBody({ width: platform.width, height: platform.height, canCollide: TOP, type: STATIC }));
    }
  }

  function createPlayer(data: Ldtk.Entity_Player, atlas: Atlas, levelBottom: Float) {
    var player = addEntity(new Entity());
    trace('player: ${player.id}');
    transform = player.addComponent(new CTransform({ x: data.pixelX, y: data.pixelY, scaleX: data.f_Flipped ? -1 : 1 }));
    player.addComponent(new CSprite({ atlas: atlas, frameName: 'blue_alien_00' }));
    player.addComponent(new CSimpleBody({ width: 20, height: 22, offset: { x: 0, y: 1 }, tags: [Tag.Player] }));
    player.addComponent(new CPlayer({ spawn: new Vector2(data.pixelX, data.pixelY), levelBottom: levelBottom }));

    var idle = new Animation(PlayerAnims.Idle, atlas, ['blue_alien_00'], 1);
    var walk = new Animation(PlayerAnims.Walk, atlas, ['blue_alien_00', 'blue_alien_01'], 0.15, LOOP);
    var jump = new Animation(PlayerAnims.Jump, atlas, ['blue_alien_01'], 1);
    player.addComponent(new CAnimation({ animations: [idle, walk, jump]}));
  }

  function createCoins(data: Array<Ldtk.Entity_Coin>, atlas: Atlas) {
    for (coinData in data) {
      var coin = addEntity(new Entity());
      coin.addComponent(new CTransform({ x: coinData.pixelX, y: coinData.pixelY }));
      coin.addComponent(new CSprite({ atlas: atlas, frameName: 'coin_00' }));

      var coinAnim = new Animation('coin', atlas, ['coin_00', 'coin_01' ], Aeons.random.float(0.15, 0.3), LOOP);
      var anim = coin.addComponent(new CAnimation({ animations: [coinAnim] }));
      anim.play('coin');

      coin.addComponent(new CSimpleBody({ width: 10, height: 10, type: STATIC, isTrigger: true, tags: [Tag.Coin] }));
    }
  }

  function createCoinCounter(camera: ECamera, atlas: Atlas, totalCoins: Int) {
    var icon = addEntity(new Entity());
    var iconTransform = icon.addComponent(new CTransform({ x: 20, y: 20, zIndex: 1 }));
    icon.addComponent(new CSprite({ atlas: atlas, frameName: 'coin_00' }));
    camera.addChild(iconTransform);

    var counter = addEntity(new Entity());
    counter.addComponent(new CTransform({ x: 12, y: -1, zIndex: 1, parent: iconTransform }));

    var font = Aeons.assets.getFont('kenney_mini');
    counter.addComponent(new CText({ font: font, fontSize: 20, anchorX: 0, color: Color.Black }));
    counter.addComponent(new CCoinCounter({ totalCoins: totalCoins }));
  }

  function createDeathZones(zones: Array<Ldtk.Entity_Death>) {
    for (zone in zones) {
      var entity = addEntity(new Entity());
      entity.addComponent(new CTransform({ x: zone.pixelX, y: zone.pixelY }));
      entity.addComponent(new CSimpleBody({ width: zone.width, height: zone.height, type: STATIC, tags: [Tag.Death], isTrigger: true }));
    }
  }

  function createFlag(flagData: Ldtk.Entity_Flag, atlas: Atlas) {
    var flag = addEntity(new Entity());
    flag.addComponent(new CTransform({ x: flagData.pixelX, y: flagData.pixelY }));
    flag.addComponent(new CSprite({ atlas: atlas, frameName: 'flag_00' }));
    flag.addComponent(new CSimpleBody({ width: flagData.width, height: flagData.height, type: STATIC, tags: [Tag.Flag], isTrigger: true }));

    var flagAnim = new Animation('flag', atlas, ['flag_00', 'flag_01'], 0.2, LOOP);
    var anim = flag.addComponent(new CAnimation({ animations: [flagAnim] }));
    anim.play('flag');
  }

  function keyDown(event: KeyboardEvent) {
    if (event.key == Q) {
      debug.enabled = !debug.enabled;
    }
  }
}
