package components;

import aeons.Aeons;
import aeons.components.CText;
import aeons.core.Component;
import aeons.core.Updatable;

/**
 * This component updates the fps text.
 */
class CFPSUpdate extends Component implements Updatable {

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

    // Get the text component reference.
    text = getComponent(CText);
  }

  /**
   * Update loop.
   * @param dt The time passed since the last update in seconds.
   */
  public function update(dt: Float) {
    // Update the text.
    text.text = 'FPS: ${Aeons.timeStep.fps}';
  }

  /**
   * This component needs a text component.
   */
  override function get_requiredComponents(): Array<Class<Component>> {
    return [CText];
  }
}
