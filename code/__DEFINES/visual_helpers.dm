/// What world.time will we next complete a visual tick?
/// This is important because we often want to avoid moving an object twice in a tick, since this can lead to teleportation instead of gliding
/// (such as when you move an atom that just spawned)
#define NEXT_VISUAL_TICK (GLOB.last_maptick_time + world.tick_lag)
