package systems;

import components.CGameOverText;
import components.CPlayer;
import aeons.Aeons;
import aeons.graphics.Color;
import scenes.IntroScene;
import transitions.SquaresTransition;
import aeons.events.SceneEvent;
import components.CHealthIcon;
import aeons.components.CSprite;
import aeons.core.Bundle;
import events.HealthEvent;
import aeons.core.System;

class HealthSystem extends System {

  @:bundle
  var iconBundles: Bundle<CHealthIcon, CSprite>;

  @:bundle
  var playerBundles: Bundle<CPlayer>;

  @:bundle
  var gameOverBundle: Bundle<CGameOverText>;

  final fullHeart = 'heart_full';

  final emptyHeart = 'heart_empty';

  public function new() {
    super();
  }

  public override function init() {
    iconBundles.onAdded(bundleAdded);
    Aeons.events.on(HealthEvent.HEALTH_DOWN, healthDown);
    Aeons.events.on(HealthEvent.HEALTH_UP, healthUp);
  }

  function healthUp(event: HealthEvent) {
    final player = playerBundles.get(0).c_player;
    if (player.health < iconBundles.count) {
      player.health++;
      updateSprites(player.health);
    }
  }

  function healthDown(event: HealthEvent) {
    final player = playerBundles.get(0).c_player;
    player.health--;
    updateSprites(player.health);
    
    if (player.health == 0) {
      updateSprites(player.health);
      gameOverBundle.get(0).entity.active = true;
      Aeons.timers.create(3, () -> {
        SceneEvent.emit(SceneEvent.PUSH, new SquaresTransition(new IntroScene(), 1.8, Color.Black, 12));
      }, 0, true);
    }
  }

  function updateSprites(health: Int) {
    for (index => bundle in iconBundles.bundles) {
      if (index < health) {
        bundle.c_sprite.setFrame(fullHeart);
      } else {
        bundle.c_sprite.setFrame(emptyHeart);
      }
    }
  }

  function bundleAdded(bundle: aeons.bundles.BundleCHealthIconCSprite) {
    updateSprites(playerBundles.get(0).c_player.health);
  }
}