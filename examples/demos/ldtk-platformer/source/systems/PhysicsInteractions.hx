package systems;

import scenes.GameScene;
import aeons.events.SceneEvent;
import aeons.components.CCamera;
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

  public function new() {
    super();
  }

  public override function init() {
    super.init();

    physics = getSystem(SimplePhysicsSystem);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Coin, collectCoin);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Death, hitDeath);
    physics.addInteractionListener(TRIGGER_START, Tag.Player, Tag.Flag, hitFlag);
  }

  public override function cleanup() {
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Coin, collectCoin);
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Death, hitDeath);
    physics.removeInteractionListener(TRIGGER_START, Tag.Player, Tag.Flag, hitFlag);
  }

  function collectCoin(player: Body, coin: Body) {
    Aeons.entities.removeEntityById(coin.component.entityId);
    counterBundle.get(0).c_coin_counter.addCoin();
  }

  function hitDeath(playerBody: Body, death: Body) {
    var bundle = playerBundle.get(0);
    if (!bundle.c_player.dead) {
      bundle.c_player.dead = true;
      bundle.c_transform.scaleY = -1;
      playerBody.velocity.set(0, -100);
      playerBody.isTrigger = true;
    }
  }

  function hitFlag(player: Body, flag: Body) {
    SceneEvent.emit(SceneEvent.REPLACE, GameScene);
  }
}
