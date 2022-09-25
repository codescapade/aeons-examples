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
   * Initialize the component.
   */
  public function create(): CFPSUpdate {
    // Get the text component reference.
    text = getComponent(CText);

    return this;
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
