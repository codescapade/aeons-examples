package events;

import aeons.events.EventType;
import aeons.events.Event;

class HealthEvent extends Event {
  public static final HEALTH_DOWN: EventType<HealthEvent> = 'aeons_health_down';

  public static final HEALTH_UP: EventType<HealthEvent> = 'aeons_health_up';
}