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
  public function new(collected: Int) {
    super();
    this.collected = collected;
  }

  /**
   * Initialize the component
   * @param entityId The id of the entity for this component.
   */
  public override function init(entityId: Int) {
    super.init(entityId);

    text = getComponent(CText);
    text.text = '${collected}';
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
  override function get_requiredComponents():Array<Class<Component>> {
    return [CText];
  }
}
