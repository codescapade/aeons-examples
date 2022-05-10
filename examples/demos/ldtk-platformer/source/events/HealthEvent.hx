package events;

import aeons.events.Event;
import aeons.events.EventType;

/**
 * The health event for when the player gets hit.
 */
class HealthEvent extends Event {
  public static final HEALTH_DOWN: EventType<HealthEvent> = 'aeons_health_down';
}
