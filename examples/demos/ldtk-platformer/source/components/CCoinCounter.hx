package components;

import aeons.components.CText;
import aeons.core.Component;

/**
 * This component updates the text that shows how many coins you have collected.
 */
class CCoinCounter extends Component {
  /**
   * The text component reference.
   */
  var text: CText;

  /**
   * The amount of coins collected.
   */
  public var collected(default, null): Int;

  /**
   * Constructor.
   * @param collected The amount of coins currently connected. 
   */
  public function create(collected: Int): CCoinCounter {
    this.collected = collected;

    text = getComponent(CText);
    text.text = '${collected}';

    return this;
  }

  /**
   * Gets called when a coin is collected to update the text.
   */
  public function addCoin() {
    collected++;
    text.text = '${collected}';
  }

  /**
   * This component needs a text component to work.
   */
  override function get_requiredComponents(): Array<Class<Component>> {
    return [CText];
  }
}
