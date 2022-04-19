package scenes;

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

  public override function init() {
    addSystem(new SimplePhysicsSystem({ worldWidth: 814, worldHeight: 616, gravity: { x: 0, y: 600 } }));
    addSystem(new RenderSystem());
    addSystem(new DebugRenderSystem());

    addEntity(new ECamera());

    var world = new Ldtk();
    var level = world.all_levels.Level_01;

    var bgTileset = Tileset.fromLdtkTileset(level.l_Background.tileset);
    var levelTileset = Tileset.fromLdtkTileset(level.l_Collision.tileset);

    var backgroundLayer = LdtkLayer.fromTilesLayer(level.l_Background, bgTileset);
    var collisionLayer = LdtkLayer.fromIntAutoLayer(level.l_Collision, levelTileset);
    var plantsLayer = LdtkLayer.fromAutoLayer(level.l_Plants, levelTileset);
    var treeLayer = LdtkLayer.fromTilesLayer(level.l_Trees, levelTileset);

    var entity = addEntity(new Entity());
    entity.addComponent(new CTransform());

    var tilemap = entity.addComponent(new CLdtkTilemap());
    tilemap.addLayers([backgroundLayer, collisionLayer, plantsLayer, treeLayer]);
    var collider = entity.addComponent(new CSimpleTilemapCollider());
    collider.setCollisionsFromLdtkLayer(collisionLayer, 0, 0, []);
  }
}
