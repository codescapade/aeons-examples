package scenes;

import aeons.math.FastMatrix4;
import ldtk.Level;
import aeons.graphics.Color;
import aeons.graphics.RenderTarget;
import ldtk.Layer_Tiles;
import aeons.tilemap.Tileset;
import aeons.graphics.atlas.Atlas;
import components.CTest;
import aeons.Aeons;
import aeons.components.CCamera;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.systems.RenderSystem;

class GameScene extends Scene {

  var tileset: Tileset;

  var layer: Layer_Tiles;

  var xOffset: Int;
  var yOffset: Int;

  public override function init() {
    addSystem(new RenderSystem());

    createCamera();
    
    var test = new Ldtk();
    var level = test.all_levels.First_Level;

    tileset = Tileset.fromLdtkTileset(level.l_Test.tileset);
    layer = level.l_Test;
    xOffset = level.worldX;
    yOffset = level.worldY;

    Aeons.assets.loadAtlas('atlas', (atlas: Atlas) -> {
      var e = addEntity(new Entity());
      e.addComponent(new CTransform({ x: 100, y: 100 }));
      e.addComponent(new CTest({ atlas: atlas, frameName: 'bunny' }));
    });
  }

  public override function render(target:RenderTarget) {
    super.render(target);

    target.transform.setFrom(FastMatrix4.identity());
    target.start();
    renderLayerTiles(target, xOffset, yOffset, layer, tileset);
    target.present();
  }

  function createCamera() {
    final eCamera = addEntity(new Entity());
    eCamera.addComponent(new CTransform());
    eCamera.addComponent(new CCamera());
  }

  function renderLayerTiles(target: RenderTarget, xOffset: Int, yOffset: Int, layer: Layer_Tiles, tileset: Tileset) {
    for (cy in 0...layer.cHei) {
      for (cx in 0...layer.cWid) {
        if (layer.hasAnyTileAt(cx, cy)) {
          for (tile in layer.getTileStackAt(cx, cy)) {
            var flipX = tile.flipBits & 1 != 0 ? -1 : 1;
            var flipOffsetX = flipX == 1 ? 0 : tileset.tileWidth;
            var flipY = tile.flipBits & 2 != 0 ? -1 : 1;
            var flipOffsetY = flipY == 1 ? 0 : tileset.tileHeight;
            var tileFrame = tileset.getRect(tile.tileId);
            
            target.drawImageSectionWithSize(xOffset + cx * tileset.tileWidth + flipOffsetX,
                yOffset + cy * tileset.tileHeight + flipOffsetY, tileset.tileWidth * flipX,
                tileset.tileHeight * flipY, tileFrame.x, tileFrame.y, tileFrame.width, tileFrame.height,
                tileset.tileImage, Color.White);
          }
        }
      }
    }
  }
}