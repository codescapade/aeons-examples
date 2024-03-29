package systems;

import aeons.Aeons;
import aeons.audio.SoundChannel;
import aeons.bundles.Bundle;
import aeons.components.CAnimation;
import aeons.components.CAudio;
import aeons.components.CTransform;
import aeons.core.System;
import aeons.events.SceneEvent;
import aeons.graphics.Color;
import aeons.physics.simple.Body;
import aeons.systems.SSimplePhysics;

import components.CCoinCounter;
import components.CPatrol;
import components.CPlayer;

import events.HealthEvent;

import scenes.GameScene;
import scenes.IntroScene;

import transitions.SquaresTransition;

class SPhysicsInteractions extends System {
  var physics: SSimplePhysics;

  @:bundle
  var counterBundle: Bundle<CCoinCounter>;

  @:bundle
  var playerBundle: Bundle<CTransform, CPlayer>;

  var deadSoundChannel: SoundChannel;

  var flagSoundChannel: SoundChannel;

  var level: Int;

  public function create(level: Int): SPhysicsInteractions {
    this.level = level;

    final deathSound = Aeons.assets.getSound('dead');
    deadSoundChannel = Aeons.audio.addChannel(deathSound);

    final flagSound = Aeons.assets.getSound('flag');
    flagSoundChannel = Aeons.audio.addChannel(flagSound);

    physics = getSystem(SSimplePhysics);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Coin, collectCoin);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Death, hitDeath);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Flag, hitFlag);
    physics.addInteractionListener(COLLISION_START, Tag.Player, Tag.Enemy, hitEnemy);

    return this;
  }

  public override function cleanup() {
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Coin, collectCoin);
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Death, hitDeath);
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Flag, hitFlag);
    Aeons.audio.removeChannel(deadSoundChannel);
    Aeons.audio.removeChannel(flagSoundChannel);
  }

  function collectCoin(player: Body, coin: Body) {
    counterBundle.get(0).cCoinCounter.addCoin();

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
    final player = playerBundle.get(0).cPlayer;
    player.complete = true;
    flagSoundChannel.play();

    Aeons.timers.create(1, () -> {
      final data: SquareTransitionData = {
        nextScene: GameScene,
        duration: 1.8,
        color: Color.Black,
        squaresPerRow: 12
      };

      if (level < 3) {
        level++;

        final coins = counterBundle.get(0).cCoinCounter.collected;
        data.data = {
          level: level,
          health: player.health,
          coins: coins
        };

        SceneEvent.emit(SceneEvent.PUSH, SquaresTransition, data);
      } else {
        data.nextScene = IntroScene;
        SceneEvent.emit(SceneEvent.PUSH, SquaresTransition, data);
      }
    }, 0, true);
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
      entity.getComponent(CPatrol).dead = true;
      deadSoundChannel.play();

      Aeons.timers.create(5, () -> {
        Aeons.entities.removeEntityById(enemy.component.entityId);
      }, 0, true);
    } else {
      die(playerBody);
    }
  }

  function die(playerBody: Body) {
    var bundle = playerBundle.get(0);
    if (!bundle.cPlayer.dead) {
      HealthEvent.emit(HealthEvent.HEALTH_DOWN);
      bundle.cPlayer.dead = true;
      bundle.cTransform.scaleY = -1;
      playerBody.velocity.set(0, -100);
      playerBody.isTrigger = true;
      deadSoundChannel.play();
    }
  }
}
