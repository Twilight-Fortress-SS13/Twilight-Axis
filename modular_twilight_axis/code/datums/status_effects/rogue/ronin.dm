#define TANUKI_INSIGHT_PER_BONUS 4
/datum/status_effect/buff/tanuki_insight
	id = "tanuki_insight"
	status_type = STATUS_EFFECT_REFRESH
	duration = -1
	tick_interval = 0
	alert_type = null
	effectedstats = list(STATKEY_PER = TANUKI_INSIGHT_PER_BONUS)

#undef TANUKI_INSIGHT_PER_BONUS
