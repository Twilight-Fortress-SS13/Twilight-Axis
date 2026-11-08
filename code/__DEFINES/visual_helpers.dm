/// What world.time will we next complete a visual tick?
/// This is important because we often want to avoid moving an object twice in a tick, since this can lead to teleportation instead of gliding
/// (such as when you move an atom that just spawned)
#define NEXT_VISUAL_TICK (GLOB.last_maptick_time + world.tick_lag)

/// Helper define, sets pixel offsets and base pixel offsets together
#define SET_BASE_PIXEL(x, y) \
	pixel_x = x; \
	base_pixel_x = x; \
	pixel_y = y; \
	base_pixel_y = y;
