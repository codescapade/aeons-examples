package components;

import aeons.components.CText;
import aeons.core.Component;

class CCoinCounter extends Component {

  var totalCoins: Int;

  var text: CText;

  var collected = 0;

  public function new(totalCoins: Int) {
    super();
    this.totalCoins = totalCoins;
  }

  public override function init(entityId: Int) {
    super.init(entityId);

    text = getComponent(CText);
    text.text = '${collected} / ${totalCoins}';
  }

  public function addCoin() {
    collected++;
    text.text = '${collected} / ${totalCoins}';
  }

  override function get_requiredComponents():Array<Class<Component>> {
    return [CText];
  }
}
