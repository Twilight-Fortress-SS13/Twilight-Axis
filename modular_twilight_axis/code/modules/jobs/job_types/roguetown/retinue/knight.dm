/datum/job/roguetown/knight/after_spawn(
	mob/living/L,
	mob/M,
	latejoin = TRUE,
)
	. = ..()
	if(latejoin || !ishuman(L) || !L.mind)
		return
	var/mob/living/carbon/human/knight = L
	knight.mind.ta_initial_knight_spawn = TRUE
	knight.taRegisterInitialBanneret()
