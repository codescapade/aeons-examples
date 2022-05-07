package components;

import aeons.components.CText;
import aeons.core.Component;

class CCoinCounter extends Component {

  var text: CText;

  public var collected(default, null): Int;

  public function new(collected: Int) {
    super();
    this.collected = collected;
  }

  public override function init(entityId: Int) {
    super.init(entityId);

    text = getComponent(CText);
    text.text = '${collected}';
  }

  public function addCoin() {
    collected++;
    text.text = '${collected}';
  }

  override function get_requiredComponents():Array<Class<Component>> {
    return [CText];
  }
}
