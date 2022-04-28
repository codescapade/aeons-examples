package components;

import aeons.Aeons;
import aeons.components.CText;
import aeons.core.Updatable;
import aeons.core.Component;

class CFPSUpdate extends Component implements Updatable {
  var text: CText;

  public function new() {
    super();
  }

  public override function init(entityId: Int) {
    super.init(entityId);

    text = getComponent(CText);
  }

  public function update(dt: Float) {
    text.text = 'FPS: ${Aeons.timeStep.fps}';
  }

  override function get_requiredComponents(): Array<Class<Component>> {
    return [CText];
  }
}