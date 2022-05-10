package components;

import aeons.Aeons;
import aeons.components.CText;
import aeons.core.Component;

/**
 * This component turns the text component on the same entity on and off every second.
 */
class CTextBlink extends Component {
  /**
   * The text component reference.
   */
  var text: CText;

  /**
   * Constructor.
   */
  public function new() {
    super();
  }

  /**
   * Initialize the component.
   * @param entityId The id of the entity for this component.
   */
  public override function init(entityId: Int) {
    super.init(entityId);

    text = getComponent(CText);

    // Create a timer that runs every second forever that turns the text on and off.
    Aeons.timers.create(1.0, () -> {
      text.active = !text.active;
    }, -1, true);
  }

  /**
   * This component needs a CText component.
   */
  override function get_requiredComponents(): Array<Class<Component>> {
    return [CText];
  }
}
