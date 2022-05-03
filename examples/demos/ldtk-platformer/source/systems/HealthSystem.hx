package systems;

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

  public var currentHealth(default, null): Int;

  @:bundle
  var bundles: Bundle<CHealthIcon, CSprite>;

  final fullHeart = 'heart_full';

  final emptyHeart = 'heart_empty';

  public function new(health: Int) {
    super();
    currentHealth = health;
  }

  public override function init() {
    bundles.onAdded(bundleAdded);
    Aeons.events.on(HealthEvent.HEALTH_DOWN, healthDown);
    Aeons.events.on(HealthEvent.HEALTH_UP, healthUp);
  }

  function healthUp(event: HealthEvent) {
    if (currentHealth < bundles.count) {
      currentHealth++;
      updateSprites();
    }
  }

  function healthDown(event: HealthEvent) {
    if (currentHealth > 1) {
      currentHealth--;
      updateSprites();
    } else {
      updateSprites();
      SceneEvent.emit(SceneEvent.PUSH, new SquaresTransition(new IntroScene(), 1.8, Color.Black, 12));
    }
  }

  function updateSprites() {
    for (index => bundle in bundles.bundles) {
      if (index < currentHealth) {
        bundle.c_sprite.setFrame(fullHeart);
      } else {
        bundle.c_sprite.setFrame(emptyHeart);
      }
    }
  }

  function bundleAdded(bundle: aeons.bundles.BundleCHealthIconCSprite) {
    updateSprites();
  }
}