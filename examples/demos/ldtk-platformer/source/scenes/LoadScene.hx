package scenes;

import aeons.events.SceneEvent;
import aeons.Aeons;
import aeons.core.Scene;

class LoadScene extends Scene {

  public override function init() {
    super.init();
    Aeons.assets.loadAtlas('sprites');

    SceneEvent.emit(SceneEvent.REPLACE, new IntroScene());
  }
}
