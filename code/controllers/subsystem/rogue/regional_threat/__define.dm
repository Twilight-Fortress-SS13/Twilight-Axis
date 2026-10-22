/// Minimum time between natural ambushes in the same region. Signal horn bypasses this.
#define AMBUSH_REGION_COOLDOWN (5 MINUTES) // TA EDIT

/// Fraction of the latent_ambush pool spent as budget per ambush.
/// TA region budget balance is preserved while the upstream ambush mechanics are enabled.
#define AMBUSH_BUDGET_PCT_REGULAR 0.03 // TA EDIT
#define AMBUSH_BUDGET_PCT_SAFE_REGION 0.02 // TA EDIT
#define AMBUSH_BUDGET_FLOOR 16

#define AMBUSH_AGGRO_DELAY (1.5 SECONDS)
// Make them focus their original target for a little bit first
#define AMBUSH_AGGRO_THREAT 15

/// Backwards-compatible default budget percentage for older TA code paths.
#define AMBUSH_BUDGET_PCT AMBUSH_BUDGET_PCT_REGULAR

/// Minimum budget (in TP) for the signal horn's budget_floor parameter.
/// budget_floor of N guarantees at least (N * AMBUSH_BUDGET_FLOOR_UNIT) TP budget.
#define AMBUSH_BUDGET_FLOOR_UNIT 10

/// Display thresholds - percentage of max_ambush for each danger level label.
#define DANGER_PCT_SAFE 15 // 0% to this = Safe (green)
#define DANGER_PCT_LOW 35 // to this = Low (yellow)
#define DANGER_PCT_MODERATE 55 // to this = Moderate (orange)
#define DANGER_PCT_DANGEROUS 80 // to this = Dangerous (red), above = Bleak (purple)

/// Tick rate multipliers - fraction of max_ambush added per SS tick.
/// SS fires every 30 minutes = 6 ticks per 3-hour round.
/// Highpop: 10% of max per tick -> full refill in 10 ticks (5 hours).
/// Lowpop: 5% of max per tick -> full refill in 20 ticks (10 hours).
#define THREAT_HIGHPOP_TICK_RATE 0.1
#define THREAT_LOWPOP_TICK_RATE 0.05
