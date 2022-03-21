package scenes;

import aeons.components.CLdtkTilemap;
import aeons.tilemap.ldtk.LdtkLayer;
import aeons.tilemap.Tileset;
import aeons.graphics.atlas.Atlas;
import aeons.Aeons;
import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.systems.RenderSystem;

class GameScene extends Scene {

  var tileset: Tileset;

  var tileLayer: LdtkLayer;

  var autoLayer: LdtkLayer;

  var fullAutoLayer: LdtkLayer;

  public override function init() {
    addSystem(new RenderSystem());

    createCamera();
    
    var world = new Ldtk();
    var level = world.all_levels.First_Level;

    tileset = Tileset.fromLdtkTileset(level.l_Test.tileset);
    tileLayer = LdtkLayer.fromTilesLayer(level.l_Test, tileset);
    autoLayer = LdtkLayer.fromIntAutoLayer(level.l_AutoTiles, tileset);
    fullAutoLayer = LdtkLayer.fromAutoLayer(level.l_FullAuto, tileset);

    var entity = addEntity(new Entity());
    entity.addComponent(new CTransform());
    var tilemap = entity.addComponent(new CLdtkTilemap());
    tilemap.addLayers([tileLayer, autoLayer, fullAutoLayer]);
  }

  function createCamera() {
    final eCamera = addEntity(new Entity());
    eCamera.addComponent(new CTransform());
    eCamera.addComponent(new CCamera());
  }
}