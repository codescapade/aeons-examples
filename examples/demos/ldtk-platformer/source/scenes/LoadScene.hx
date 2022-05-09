package scenes;

import aeons.Aeons;
import aeons.core.Scene;
import aeons.events.SceneEvent;

class LoadScene extends Scene {
  public override function init() {
    super.init();
    Aeons.assets.loadAtlas('sprites');

    SceneEvent.emit(SceneEvent.REPLACE, new IntroScene());
  }
}
