package systems;

import aeons.core.Transition;
import aeons.components.CAnimation;
import aeons.audio.SoundChannel;
import aeons.components.CAudio;
import scenes.GameScene;
import aeons.events.SceneEvent;
import aeons.components.CTransform;
import components.CPlayer;
import aeons.Aeons;
import aeons.core.Bundle;
import aeons.core.System;
import aeons.physics.simple.Body;
import aeons.systems.SimplePhysicsSystem;

import components.CCoinCounter;

class PhysicsInteractions extends System {

  var physics: SimplePhysicsSystem;

  @:bundle
  var counterBundle: Bundle<CCoinCounter>;

  @:bundle
  var playerBundle: Bundle<CTransform, CPlayer>;

  var deadSoundChannel: SoundChannel;

  public function new() {
    super();
  }

  public override function init() {
    super.init();

    final deathSound = Aeons.assets.getSound('dead');
    deadSoundChannel = Aeons.audio.addChannel(deathSound);

    physics = getSystem(SimplePhysicsSystem);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Coin, collectCoin);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Death, hitDeath);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Flag, hitFlag);
    physics.addInteractionListener(COLLISION_START, Tag.Player, Tag.Enemy, hitEnemy);
  }

  public override function cleanup() {
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Coin, collectCoin);
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Death, hitDeath);
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Flag, hitFlag);
    Aeons.audio.removeChannel(deadSoundChannel);
  }

  function collectCoin(player: Body, coin: Body) {
    counterBundle.get(0).c_coin_counter.addCoin();

    final entity = Aeons.entities.getEntityById(coin.component.entityId);
    entity.getComponent(CAudio).play();
    entity.active = false;

    // Wait for the audio to finish before removing the entity so the audio plays.
    Aeons.timers.create(0.2, () -> {
      Aeons.entities.removeEntityById(coin.component.entityId);
    }, 0, true);
  }

  function hitDeath(playerBody: Body, death: Body) {
    die(playerBody);
  }

  function hitFlag(player: Body, flag: Body) {
    SceneEvent.emit(SceneEvent.PUSH, new GameScene());
  }

  function hitEnemy(playerBody: Body, enemy: Body) {
    if (playerBody.component.isTouching(BOTTOM) && enemy.component.isTouching(TOP)) {
      playerBody.velocity.y = -200;
      final entity = Aeons.entities.getEntityById(enemy.component.entityId);
      enemy.type = DYNAMIC;
      enemy.velocity.x = 0;
      enemy.isTrigger = true;
      entity.getComponent(CTransform).scaleY = -0.5;
      entity.getComponent(CAnimation).stop();

      Aeons.timers.create(5, () -> {
        Aeons.entities.removeEntityById(enemy.component.entityId);
      }, 0, true);
    } else {
      die(playerBody);
    }
  }

  function die(playerBody: Body) {
    var bundle = playerBundle.get(0);
    if (!bundle.c_player.dead) {
      bundle.c_player.dead = true;
      bundle.c_transform.scaleY = -1;
      playerBody.velocity.set(0, -100);
      playerBody.isTrigger = true;
      deadSoundChannel.play();
    }
  }
}
