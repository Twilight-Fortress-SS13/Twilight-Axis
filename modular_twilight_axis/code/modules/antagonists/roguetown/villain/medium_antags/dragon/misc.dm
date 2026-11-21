/obj/effect/landmark/start/dragon
	name = "dragon"
	icon_state = "arrow"
	jobspawn_override = list("Dragon")

/obj/effect/landmark/start/dragonlate
	name = "dragonlate"
	icon_state = "arrow"
	delete_after_roundstart = FALSE
	jobspawn_override = list("Dragon")

// Dragon stature — always returns "dragon" regardless of pronouns
/datum/mob_descriptor/stature/dragon
	name = "Dragon"

/datum/mob_descriptor/stature/dragon/get_description(mob/living/described)
	return "dragon"

/obj/structure/bed/rogue/eora/dragon
	name = "bed of onyx"
	desc = "A nest of massive, dark, red-tinted gemstones. Too hard and rough for mere mortals to sleep on, but the perfect resting spot for a dastardly dragon."
	max_integrity = 500
	color = "#333333"

/obj/structure/bed/rogue/eora/dragon/New()
	..()
	var/matrix/M = matrix()
	M.Scale(2, 1.5)
	M.Translate(0, 0)
	src.transform = M
