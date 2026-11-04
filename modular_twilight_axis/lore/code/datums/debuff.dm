/datum/status_effect/debuff/lost_drow_inq_mask
	id = "lost_drow_inq_mask"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/lost_drow_inq_mask
	effectedstats = list(STATKEY_WIL = -2)

/atom/movable/screen/alert/status_effect/debuff/lost_drow_inq_mask
	name = "Exposed"
	desc = "Without a mask, all can see I am of Archtraitor's own now. I'd do best to hide my visage once more."
	icon_state = "muscles"

/datum/stressevent/lost_drow_inq_mask
	stressadd = 3
	desc = span_boldred("I have lost my mask! My authority dwindles, as all can see I am of Archtraitor's own!")
	timer = 999 MINUTES
