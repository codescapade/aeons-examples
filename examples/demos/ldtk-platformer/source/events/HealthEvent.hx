package events;

import aeons.events.Event;
import aeons.events.EventType;

class HealthEvent extends Event {
  public static final HEALTH_DOWN: EventType<HealthEvent> = 'aeons_health_down';

  public static final HEALTH_UP: EventType<HealthEvent> = 'aeons_health_up';
}
