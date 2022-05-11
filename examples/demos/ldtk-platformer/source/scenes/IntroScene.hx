package scenes;

import aeons.Aeons;
import aeons.components.CAnimation;
import aeons.components.CLdtkTilemap;
import aeons.components.CText;
import aeons.components.CTransform;
import aeons.core.Entity;
import aeons.core.Scene;
import aeons.events.SceneEvent;
import aeons.events.input.KeyboardEvent;
import aeons.graphics.Color;
import aeons.math.Rect;
import aeons.systems.AnimationSystem;
import aeons.systems.RenderSystem;
import aeons.tilemap.Tileset;
import aeons.tilemap.ldtk.LdtkLayer;

import components.CTextBlink;

import entities.ECamera;
import entities.EFlag;
import entities.EPlayer;

import transitions.SquaresTransition;

class IntroScene extends Scene {
  public override function init() {
    final world = new Ldtk();
    final level = world.getLevel('Menu');
    final levelEntities = level.l_Entities;

    addSystem(new AnimationSystem());
    addSystem(new RenderSystem());
    createTilemap(level);

    final flagData = levelEntities.all_Flag[0];
    addEntity(new EFlag(flagData.pixelX, flagData.pixelY));

    final playerData = levelEntities.all_Player[0];
    final player = addEntity(new EPlayer(playerData.pixelX, playerData.pixelY, playerData.f_Flipped, 0));
    final anim = player.getComponent(CAnimation);
    anim.getByName(PlayerAnims.Walk).frameDuration = 0.5;
    anim.play(PlayerAnims.Walk);

    final bounds = new Rect(0, 0, level.pxWid, level.pxHei);
    addEntity(new ECamera(player.transform, bounds));

    createText();

    Aeons.events.on(KeyboardEvent.KEY_DOWN, keyDown);
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
  }

  function createText() {
    final font = Aeons.assets.getFont('kenney_pixel');

    final title = addEntity(new Entity());
    title.addComponent(new CTransform({ x: 224, y: 44 }));
    title.addComponent(new CText({
      font: font,
      fontSize: 36,
      text: 'LDtk Platformer',
      color: Color.Black
    }));

    final demo = addEntity(new Entity());
    demo.addComponent(new CTransform({ x: 200, y: 90 }));
    demo.addComponent(new CText({
      font: font,
      fontSize: 36,
      text: 'Demo',
      color: Color.Black
    }));

    final demo = addEntity(new Entity());
    demo.addComponent(new CTransform({ x: 190, y: 206 }));
    demo.addComponent(new CText({
      font: font,
      fontSize: 24,
      text: 'Press Spacebar',
      color: Color.Black
    }));
    demo.addComponent(new CTextBlink());
  }

  function keyDown(event: KeyboardEvent) {
    if (event.key == Space) {
      var data = {
        health: 5,
        level: 1,
        coins: 0
      };

      SceneEvent.emit(SceneEvent.PUSH, new SquaresTransition(new GameScene(data), 1.8, Color.Black, 12));
    }
  }
}
