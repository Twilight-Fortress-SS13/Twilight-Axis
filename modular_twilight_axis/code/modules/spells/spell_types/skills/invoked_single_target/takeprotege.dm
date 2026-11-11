/datum/stressevent/protege_lord_dead
	desc = span_boldred("My liege has fallen. I am abandoned and alone.")

/datum/stressevent/protege_lord_nearby
	desc = span_green("My liege walks beside me. I will not fail them.")

/atom/movable/screen/alert/status_effect/buff/protege_vigilance
	desc = "With hearty will, - for I will not rebel<br>\
			Against your lust, - a tale will I tell.<br>\
			Have me excused if I speak amiss;<br>\
			My will is good; and lo, \
				my tale is this. (Mood buff while around your liege)"

/atom/movable/screen/alert/status_effect/buff/protege_ward
	name = "Noble's Ward"

/mob/living/carbon/human/proc/taNotifyProtegeLiegeDeath(mob/living/liege)
	to_chat(src, span_userdanger("My liege [liege.name] has fallen!"))

/datum/status_effect/buff/protege_vigilance/proc/taNotifyLiegePresence(nearby)
	if(nearby)
		to_chat(
			owner,
			span_blue("My liege stands with me. I will do them proud.")
		)
	else
		to_chat(
			owner,
			span_warning("Without my liege near, my duty rings hollow.")
		)
