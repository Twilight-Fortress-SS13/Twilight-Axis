/obj/effect/landmark/start/wyvern
	name = "wyvern"
	icon_state = "arrow"
	jobspawn_override = list("Wyvern")

/obj/effect/landmark/start/wyvernlate
	name = "wyvernlate"
	icon_state = "arrow"
	delete_after_roundstart = FALSE
	jobspawn_override = list("Wyvern")

// Wyvern stature — always returns "wyvern" regardless of pronouns
/datum/mob_descriptor/stature/wyvern
	name = "Wyvern"

/datum/mob_descriptor/stature/wyvern/get_description(mob/living/described)
	return "wyvern"

/obj/structure/bed/rogue/eora/wyvern
	name = "bed of onyx"
	desc = "A nest of massive, dark, red-tinted gemstones. Too hard and rough for mere mortals to sleep on, but the perfect resting spot for a dastardly dragon."
	max_integrity = 500
	color = "#333333"

/obj/structure/bed/rogue/eora/wyvern/New()
	..()
	var/matrix/M = matrix()
	M.Scale(2, 1.5)
	M.Translate(0, 0)
	src.transform = M
