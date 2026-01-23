#define SEE_SKY_YES 1
#define SEE_SKY_NO 2

/// Turf is currently in the weathered_turfs list and should not be readded to avoid duplicates
#define TURF_BEING_WEATHERED (1<<4)
/// Turf is currently queued in GLOB.SUNLIGHT_QUEUE_CORNER and should not be re-queued to avoid duplicates
#define TURF_SUNLIGHT_QUEUED (1<<5)
