package scenes;

import components.CCoinCounter;
import aeons.graphics.Color;
import aeons.components.CText;
import systems.CoinCollection;
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

  public override function init() {
    var world = new Ldtk();
    var level = world.all_levels.Level_01;

    var physics = addSystem(new SimplePhysicsSystem({ worldWidth: level.pxWid, worldHeight: level.pxHei, gravity: { x: 0, y: 800 } }));
    physics.showQuadTreeDebug = false;
    addSystem(new AnimationSystem());
    addSystem(new UpdateSystem());
    addSystem(new PlayerMovement());
    addSystem(new RenderSystem());
    addSystem(new CoinCollection());
    addSystem(new DebugRenderSystem());

    var bgTileset = Tileset.fromLdtkTileset(level.l_Background.tileset);
    var levelTileset = Tileset.fromLdtkTileset(level.l_Collision.tileset);

    var backgroundLayer = LdtkLayer.fromTilesLayer(level.l_Background, bgTileset);
    var collisionLayer = LdtkLayer.fromIntAutoLayer(level.l_Collision, levelTileset);
    var plantsLayer = LdtkLayer.fromAutoLayer(level.l_Plants, levelTileset);
    var treeLayer = LdtkLayer.fromIntAutoLayer(level.l_Trees, levelTileset);
    var levelEntities = level.l_Entities;

    var entity = addEntity(new Entity());
    entity.addComponent(new CTransform());

    var tilemap = entity.addComponent(new CLdtkTilemap());
    tilemap.addLayers([backgroundLayer, collisionLayer, plantsLayer, treeLayer]);
    var collider = entity.addComponent(new CSimpleTilemapCollider());
    collider.setCollisionsFromLdtkLayer(collisionLayer, 0, 0, []);

    var atlas = Aeons.assets.loadAtlas('sprites');

    createCoins(levelEntities.all_Coin, atlas);

    var playerData = levelEntities.all_Player[0];
    createPlayer(playerData, atlas);

    addOwnWayPlatforms(levelEntities.all_One_way);

    var bounds = new Rect(0, 0, level.pxWid, level.pxHei);
    var camera = addEntity(new ECamera(transform, bounds));
    camera.setPosition(playerData.pixelX, playerData.pixelY);

    createCoinCounter(camera, atlas, levelEntities.all_Coin.length);
  }

  function addOwnWayPlatforms(platforms: Array<Ldtk.Entity_One_way>) {
    for (platform in platforms) {
      var entity = addEntity(new Entity());
      entity.addComponent(new CTransform({ x: platform.pixelX, y: platform.pixelY }));
      entity.addComponent(new CSimpleBody({ width: platform.width, height: platform.height, canCollide: TOP, type: STATIC }));
    }
  }

  function createPlayer(data: Ldtk.Entity_Player, atlas: Atlas) {
    var player = addEntity(new Entity());
    trace('player: ${player.id}');
    transform = player.addComponent(new CTransform({ x: data.pixelX, y: data.pixelY, scaleX: data.f_Flipped ? -1 : 1 }));
    player.addComponent(new CSprite({ atlas: atlas, frameName: 'green_alien_00' }));
    player.addComponent(new CSimpleBody({ width: 20, height: 22, offset: { x: 0, y: 1 }, tags: [Constants.PLAYER_TAG] }));
    player.addComponent(new CPlayer());

    var idle = new Animation(PlayerAnims.Idle, atlas, ['green_alien_00'], 1);
    var walk = new Animation(PlayerAnims.Walk, atlas, ['green_alien_00', 'green_alien_01'], 0.15, LOOP);
    var jump = new Animation(PlayerAnims.Jump, atlas, ['green_alien_01'], 1);
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

      coin.addComponent(new CSimpleBody({ width: 10, height: 10, type: STATIC, isTrigger: true, tags: [Constants.COIN_TAG] }));
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
}
