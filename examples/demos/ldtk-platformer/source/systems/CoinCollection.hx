package systems;

import components.CCoinCounter;
import aeons.core.Bundle;
import aeons.Aeons;
import aeons.physics.simple.Body;
import aeons.systems.SimplePhysicsSystem;
import aeons.core.System;

class CoinCollection extends System {

  var physics: SimplePhysicsSystem;

  @:bundle
  var counterBundle: Bundle<CCoinCounter>;

  public function new() {
    super();
  }

  public override function init() {
    super.init();

    physics = getSystem(SimplePhysicsSystem);
    physics.addInteractionListener(TRIGGER_START, Constants.PLAYER_TAG, Constants.COIN_TAG, collectCoin);
  }

  public override function cleanup() {
    physics.removeInteractionListener(TRIGGER_START, Constants.PLAYER_TAG, Constants.COIN_TAG, collectCoin);
  }

  function collectCoin(player: Body, coin: Body) {
    trace(coin.component.entityId);
    Aeons.entities.removeEntityById(coin.component.entityId);
    counterBundle.get(0).c_coin_counter.addCoin();
  }
}
