package components;

import aeons.graphics.Color;
import aeons.graphics.atlas.Frame;
import aeons.graphics.atlas.Atlas;
import aeons.graphics.RenderTarget;
import aeons.math.Rect;
import aeons.core.Renderable;
import aeons.core.Component;

class CTest extends Component implements Renderable {
  public var bounds = new Rect();

  public var anchorX = 0.5;

  public var anchorY = 0.5;

  public var atlas: Atlas;

  public var frame: Frame;

  public function new(options: CTestOptions) {
    super();

    atlas = options.atlas;
    frame = atlas.getFrame(options.frameName);
  }

  public function render(target: RenderTarget, cameraBounds: Rect) {
    target.drawImageSectionWithSize(-(frame.sourceSize.width * anchorX) + frame.sourceRect.x,
        -(frame.sourceSize.height * anchorY) + frame.sourceRect.y, frame.frame.width, frame.frame.height, frame.frame.x, frame.frame.y, frame.frame.width,
        frame.frame.height, atlas.image, Color.White);
  }
}

typedef CTestOptions = {
  var atlas: Atlas;
  var frameName: String;
}