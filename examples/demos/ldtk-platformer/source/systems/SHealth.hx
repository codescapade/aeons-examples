package systems;

import aeons.Aeons;
import aeons.bundles.Bundle;
import aeons.components.CSprite;
import aeons.core.System;
import aeons.events.SceneEvent;
import aeons.graphics.Color;

import components.CGameOverText;
import components.CHealthIcon;
import components.CPlayer;

import events.HealthEvent;

import scenes.IntroScene;

import transitions.SquaresTransition;

class SHealth extends System {
  @:bundle
  var iconBundles: Bundle<CHealthIcon, CSprite>;

  @:bundle
  var playerBundles: Bundle<CPlayer>;

  @:bundle
  var gameOverBundle: Bundle<CGameOverText>;

  final fullHeart = 'heart_full';

  final emptyHeart = 'heart_empty';

  public function create(): SHealth {
    iconBundles.onAdded(bundleAdded);
    Aeons.events.on(HealthEvent.HEALTH_DOWN, healthDown);

    return this;
  }

  function healthDown(event: HealthEvent) {
    final player = playerBundles.get(0).cPlayer;
    player.health--;
    updateSprites(player.health);

    if (player.health == 0) {
      updateSprites(player.health);
      gameOverBundle.get(0).entity.active = true;
      Aeons.timers.create(3, () -> {
        final data: SquareTransitionData = {
          nextScene: IntroScene,
          duration: 1.8,
          color: Color.Black,
          squaresPerRow: 12
        };
        SceneEvent.emit(SceneEvent.PUSH, SquaresTransition, data);
      }, 0, true);
    }
  }

  function updateSprites(health: Int) {
    for (index => bundle in iconBundles.bundles) {
      if (index < health) {
        bundle.cSprite.setFrame(fullHeart);
      } else {
        bundle.cSprite.setFrame(emptyHeart);
      }
    }
  }

  function bundleAdded(bundle: Bundle<CHealthIcon, CSprite>) {
    updateSprites(playerBundles.get(0).cPlayer.health);
  }
}
