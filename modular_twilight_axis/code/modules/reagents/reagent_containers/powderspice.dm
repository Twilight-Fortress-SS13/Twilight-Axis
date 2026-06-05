/datum/reagent/sleep_powder
	name = "sleep powder"
	description = ""
	color = "#ddd3df" // rgb: 96, 165, 132
	metabolization_rate = 1

// TO DO: eventually rewrite drowsyness code to do this instead then it can be expanded
// The reason why I haven't is because vampire lords have some special code for drowsyness I'll ave to get to...
/datum/reagent/sleep_powder/on_mob_metabolize(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/debuff/knockout)
	..()


/obj/item/reagent_containers/powder/sleep_powder
	name = "powder"
	desc = ""
	gender = PLURAL
	icon_state = "flour"
	list_reagents = list(/datum/reagent/sleep_powder = 5)
	grind_results = null
	volume = 10

/obj/item/reagent_containers/powder/smartium
	name = "smartium"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/items/produce.dmi'
	icon_state = "smartium"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/smartium = 15)
	grind_results = list(/datum/reagent/smartium = 15)
	sellprice = 5

/datum/reagent/smartium
	name = "smartium"
	description = ""
	color = "#74f9ec"
	overdose_threshold = 16
	metabolization_rate = 0.2
	taste_description = ""

/datum/reagent/smartium/overdose_process(mob/living/M)
	M.adjustToxLoss(5, 0)
	..()
	. = 1

/datum/reagent/smartium/on_mob_metabolize(mob/living/M)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/color_vision/light_blue)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)
	if(M.client)
		animate(M.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)

/atom/movable/screen/fullscreen/color_vision/light_blue
	color = "#00e5ff4e"

/datum/reagent/smartium/on_mob_end_metabolize(mob/living/M)
	animate(M.client)
	M.clear_fullscreen("druqk")

/datum/reagent/smartium/on_mob_life(mob/living/carbon/M)
	M.handle_hallucinations_custome(/datum/hallucination/floor_shift)
	narcolepsy_drug_up(M)
	M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/smartium)
	if(prob(5))
		M.flash_fullscreen("whiteflash")

	..()

/datum/reagent/smartium/overdose_start(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/debuff/smartium)
	M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/obj/item/reagent_containers/powder/corps_dust
	name = "corps dust"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/items/produce.dmi'
	icon_state = "body_dust"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/corps_dust = 15)
	grind_results = list(/datum/reagent/corps_dust = 15)
	sellprice = 5

/datum/reagent/corps_dust
	name = "corps dust"
	description = ""
	color = "#e7967b"
	overdose_threshold = 16
	metabolization_rate = 0.2
	taste_description = ""

/datum/reagent/corps_dust/overdose_process(mob/living/M)
	M.adjustToxLoss(5, 0)
	..()
	. = 1

/datum/reagent/corps_dust/on_mob_metabolize(mob/living/M)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/color_vision/light_red)
	animate(M.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/atom/movable/screen/fullscreen/color_vision/light_red
	color = "#ff00004e"

/datum/reagent/corps_dust/on_mob_end_metabolize(mob/living/M)
	animate(M.client)
	M.clear_fullscreen("druqk")

/datum/reagent/corps_dust/on_mob_life(mob/living/carbon/M)
	narcolepsy_drug_up(M)
	M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/corps_dust)
	M.handle_hallucinations_custome(/datum/hallucination/delusion)
	M.handle_hallucinations_custome(/datum/hallucination/self_delusion)
	if(prob(15))
		shake_camera(M, 5, 5)
	..()

/datum/reagent/corps_dust/overdose_start(mob/living/M)
	M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/obj/item/reagent_containers/powder/grave_powder
	name = "grave powder"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/items/produce.dmi'
	icon_state = "grave_dust"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/grave_powder = 15)
	grind_results = list(/datum/reagent/grave_powder = 15)
	sellprice = 5

/datum/reagent/grave_powder
	name = "grave powder"
	description = ""
	color = "#822b32"
	overdose_threshold = 31
	metabolization_rate = 0.4
	taste_description = ""

/datum/reagent/grave_powder/overdose_process(mob/living/M)
	M.adjustToxLoss(5, 0)
	M.adjustBruteLoss(5, 0)
	..()
	. = 1

/datum/reagent/grave_powder/on_mob_metabolize(mob/living/carbon/M)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/color_vision/red)
	M.set_resting(TRUE, TRUE)
	animate(M.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/datum/reagent/grave_powder/on_mob_end_metabolize(mob/living/M)
	animate(M.client)
	M.clear_fullscreen("druqk")

/datum/reagent/grave_powder/on_mob_life(mob/living/carbon/M)
	narcolepsy_drug_up(M)
	M.handle_hallucinations_custome(/datum/hallucination/death)
	M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/grave_powder)
	M.Immobilize(10 SECONDS)
	M.OffBalance(10 SECONDS)
	M.Knockdown(10 SECONDS)
	if(prob(50))
		shake_camera(M, 5, 5)

	..()

/datum/reagent/grave_powder/overdose_start(mob/living/M)
	M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/obj/item/reagent_containers/powder/inferrum
	name = "inferrum"
	desc = ""
	icon = 'modular_twilight_axis/icons/roguetown/items/produce.dmi'
	icon_state = "inferrum"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/inferrum = 15)
	grind_results = list(/datum/reagent/inferrum = 15)
	sellprice = 5

/datum/reagent/inferrum
	name = "inferrum"
	description = ""
	color = "#fd9400"
	overdose_threshold = 31
	metabolization_rate = 0.1
	taste_description = ""

/atom/movable/screen/fullscreen/color_vision/orange
	color = "#ff880052"

/datum/reagent/inferrum/overdose_process(mob/living/M)
	M.adjustToxLoss(5, 0)
	M.adjustFireLoss(5, 0)
	M.adjust_fire_stacks(1)
	M.ignite_mob()
	..()
	. = 1

/datum/reagent/inferrum/on_mob_metabolize(mob/living/carbon/M)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/color_vision/orange)
	animate(M.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/datum/reagent/inferrum/on_mob_end_metabolize(mob/living/M)
	animate(M.client)
	M.clear_fullscreen("druqk")

/datum/reagent/inferrum/on_mob_life(mob/living/carbon/M)
	M.handle_hallucinations_custome(/datum/hallucination/fire)
	narcolepsy_drug_up(M)
	M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.adjustFireLoss(0.2)
	M.apply_status_effect(/datum/status_effect/buff/dragonhide/TAfireresistinferrum)

	..()

/datum/reagent/inferrum/overdose_start(mob/living/M)
	M.playsound_local(M, 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/mob/living/carbon/proc/handle_hallucinations_custome(var/hallucination_type)
	if(!hallucination || !client || stat)
		return
	hallucination--
	new hallucination_type(src, FALSE)
