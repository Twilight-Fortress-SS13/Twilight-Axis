/obj/structure/alch_prop
	name = "suspicious object"
	desc = "Something about this doesn't look right."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "woodbucket"
	density = TRUE
	anchored = TRUE

/datum/reagent/advanced
	name = "Advanced Reagent"
	metabolization_rate = 0.4

/datum/reagent/advanced/on_mob_add(mob/living/living)
	if(living.mind.has_antag_datum(/datum/antagonist/hag))
		qdel(src)
		return

/datum/reagent/advanced/growth
	name = "Giant's Might"
	description = "A thick, muddy-brown liquid that feels unnaturally heavy. The bottle seems to pull down on your hand with significant weight."
	color = "#5a3a22"
	taste_description = "earth and raw iron"
	metabolization_rate = REAGENTS_METABOLISM * 0.1

/datum/reagent/advanced/growth/on_mob_add(mob/living/carbon/human/M)
	. = ..()

	M.dna.features["body_size"] = 1.5
	M.dna.update_body_size()
	ADD_TRAIT(M, TRAIT_BIGGUY, src)

/datum/reagent/advanced/growth/on_mob_delete(mob/living/carbon/human/M)
	M.dna.features["body_size"] = 1.0
	M.dna.update_body_size()
	REMOVE_TRAIT(M, TRAIT_BIGGUY, src)

/datum/reagent/advanced/paralysis
	name = "Spider's Kiss"
	description = "A viscous, dark purple syrup. It leaves thick, web-like trails against the glass that move on their own."
	color = "#4b0082"
	taste_description = "cloying bitterness"
	metabolization_rate = REAGENTS_METABOLISM * 0.6

/datum/reagent/advanced/paralysis/on_mob_life(mob/living/M)
	M.Paralyze(40)
	..()

/datum/reagent/advanced/grace
	name = "Cat's Grace"
	description = "A shimmering golden oil that feels impossibly slippery. The container feels like it could slide from your hand at any moment."
	color = "#ffd700"
	taste_description = "creamy butter"
	metabolization_rate = REAGENTS_METABOLISM * 0.01

/datum/reagent/advanced/grace/on_mob_life(mob/living/M)
	ADD_TRAIT(M, TRAIT_NOFALLDAMAGE2, src)
	..()

/datum/reagent/advanced/grace/on_mob_delete(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_NOFALLDAMAGE2, src)

/datum/reagent/advanced/speed
	name = "Swift Feet"
	description = "A crackling yellow liquid resembling captured lightning. It vibrates with intense, suppressed energy."
	color = "#ffff00"
	taste_description = "citric acid"
	metabolization_rate = REAGENTS_METABOLISM * 0.2

/datum/reagent/advanced/speed/on_mob_add(mob/living/M)
	. = ..()

	M.add_movespeed_modifier("swift_feet", multiplicative_slowdown = -1.5)
	M.AddComponent(/datum/component/after_image)

/datum/reagent/advanced/speed/on_mob_delete(mob/living/M)
	M.remove_movespeed_modifier("swift_feet")
	qdel(M.GetComponent(/datum/component/after_image))

/datum/reagent/advanced/elixir_of_life
	name = "Elixir of Life"
	description = "A shimmering, pearlescent liquid that seems to pulse with a golden light. It represents the ultimate harmony of body and soul."
	reagent_state = LIQUID
	color = "#ffd788"
	taste_description = "eternal youth and fresh honey"
	scent_description = "morning dew"
	metabolization_rate = REAGENTS_METABOLISM * 0.7

/datum/reagent/advanced/elixir_of_life/on_mob_life(mob/living/carbon/M)
	if(volume >= 60)
		M.reagents.remove_reagent(type, 2)

	if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
		M.energy_add(120)

	if(volume > 0.99)
		M.stamina_add(-50)

	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume + 50, BLOOD_VOLUME_NORMAL)

	M.heal_wounds(15)

	if(volume > 0.99)
		M.adjustBruteLoss(-6  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-6  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-5, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-6  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -2.5 * REAGENTS_EFFECT_MULTIPLIER)

	..()
	return TRUE

/datum/reagent/advanced/mist_form
	name = "Vapor of the Void"
	description = "A swirling, semi-transparent liquid that feels like it's not even there. Holding it gives a strange sensation of weightlessness."
	reagent_state = LIQUID
	color = "#dcdcdc"
	alpha = 150
	metabolization_rate = REAGENTS_METABOLISM * 0.8
	taste_description = "butter"

/datum/reagent/advanced/mist_form/on_mob_add(mob/living/carbon/human/M)
	. = ..()

	M.apply_status_effect(/datum/status_effect/buff/mist_form)
	to_chat(M, span_purple("Ваше тело теряет плотность и превращается в холодный, зыбкий туман..."))
	playsound(M.loc, 'sound/effects/hood_ignite.ogg', 50, TRUE)

/datum/reagent/advanced/mist_form/on_mob_delete(mob/living/carbon/human/M)
	M.remove_status_effect(/datum/status_effect/buff/mist_form)
	to_chat(M, span_notice("Ваша плоть снова обретает тяжесть и форму."))
