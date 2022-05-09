package components;

import aeons.Aeons;
import aeons.components.CText;
import aeons.core.Component;

class CTextBlink extends Component {
  var text: CText;

  public function new() {
    super();
  }

  public override function init(entityId: Int) {
    super.init(entityId);

    text = getComponent(CText);
    Aeons.timers.create(1.0, () -> {
      text.active = !text.active;
    }, -1, true);
  }

  override function get_requiredComponents(): Array<Class<Component>> {
    return [CText];
  }
}
