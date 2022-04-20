package scenes;

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
    addSystem(new PlayerMovement());
    addSystem(new SimplePhysicsSystem({ worldWidth: 814, worldHeight: 616, gravity: { x: 0, y: 600 } }));
    addSystem(new AnimationSystem());
    addSystem(new RenderSystem());
    addSystem(new UpdateSystem());
    // addSystem(new DebugRenderSystem());


    var world = new Ldtk();
    var level = world.all_levels.Level_01;

    var bgTileset = Tileset.fromLdtkTileset(level.l_Background.tileset);
    var levelTileset = Tileset.fromLdtkTileset(level.l_Collision.tileset);

    var backgroundLayer = LdtkLayer.fromTilesLayer(level.l_Background, bgTileset);
    var collisionLayer = LdtkLayer.fromIntAutoLayer(level.l_Collision, levelTileset);
    var plantsLayer = LdtkLayer.fromAutoLayer(level.l_Plants, levelTileset);
    var treeLayer = LdtkLayer.fromTilesLayer(level.l_Trees, levelTileset);
    var levelEntities = level.l_Entities;

    var entity = addEntity(new Entity());
    entity.addComponent(new CTransform());

    var tilemap = entity.addComponent(new CLdtkTilemap());
    tilemap.addLayers([backgroundLayer, collisionLayer, plantsLayer, treeLayer]);
    var collider = entity.addComponent(new CSimpleTilemapCollider());
    collider.setCollisionsFromLdtkLayer(collisionLayer, 0, 0, []);

    var atlas = Aeons.assets.loadAtlas('sprites');

    var playerData = levelEntities.all_Player[0];
    createPlayer(playerData, atlas);

    addOwnWayPlatforms(levelEntities.all_One_way);

    var bounds = new Rect(0, 0, level.pxWid, level.pxHei);
    var camera = addEntity(new ECamera(transform, bounds));
    camera.setPosition(playerData.pixelX, playerData.pixelY);
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
    transform = player.addComponent(new CTransform({ x: data.pixelX, y: data.pixelY, scaleX: data.f_Flipped ? -1 : 1 }));
    player.addComponent(new CSprite({ atlas: atlas, frameName: 'green_alien_00', anchorX: 0.5, anchorY: 0.5 }));
    player.addComponent(new CSimpleBody({ width: 20, height: 22, offset: { x: 0, y: 1 } }));
    player.addComponent(new CPlayer());

    var idle = new Animation('idle', atlas, ['green_alien_00'], 1);
    var walk = new Animation('walk', atlas, ['green_alien_00', 'green_alien_01'], 0.15, LOOP);
    var jump = new Animation('jump', atlas, ['green_alien_01'], 1);
    player.addComponent(new CAnimation({ animations: [idle, walk, jump]}));
  }
}

