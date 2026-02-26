/obj/effect/decal/cleanable/roguerune/arcyne/empowerment
	name = "Empowerment Array"
	desc = "arcane symbols pulse upon the ground..."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "empowerment"
	tier = 2
	runesize = 1
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	invocation = "Vires Augeantur!"
	layer = SIGIL_LAYER
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/empowerment/New()
	. = ..()
	rituals += GLOB.t2buffrunerituallist

/obj/effect/decal/cleanable/roguerune/arcyne/empowerment/collect_invokers(mob/living/user)
	var/list/invoker_list = ..()

	for(var/mob/living/invoker in invoker_list)
		if(!isliving(invoker))
			continue

		var/mob/living/living_invoker = invoker
		var/empower_count
		for(var/datum/status_effect/effect in living_invoker.status_effects)
			if(istype(effect, /datum/status_effect/buff/magic))
				empower_count++

		if(empower_count >= 3)
			to_chat(living_invoker, span_warning("I'm already imbued by too many arcyne energies, this ritual does nothing for me!"))
			invoker_list.Remove(living_invoker)

	return invoker_list

/obj/effect/decal/cleanable/roguerune/arcyne/empowerment/invoke(list/invokers, datum/runeritual/buff/runeritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return

	var/buffedstat = runeritual.buff
	for(var/mob/living/invoker in range(runesize, src))
		invoker.apply_status_effect(buffedstat)
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker

		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,  span_italics("[src] saps your strength!"))

	do_invoke_glow()
