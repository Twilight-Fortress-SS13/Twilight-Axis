/datum/action/cooldown/spell/touch/asperges
	name = "ASPERGES"
	desc = "A solemn rite of the Grand Architect. Beseech the Psydon to condense a small measure of sacred, structural moisture within a touched vessel.\n \
	<b>Fill</b>: Beseech the Psydon to condense holy moisture. Fills containers with water, dampens soil, cloth, or raw ingredients.\n \
	<b>Clean</b>: Form a righteous prayer to purge chaotic grime. Scours blood, filth, and mundane stains from people, items, or the ground, restoring order through the absolute will of Psydon."

	background_icon = 'icons/mob/actions/psydonmiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/psydonmiracles.dmi'
	button_icon_state = "asperges"

	draw_message = span_notice("I steady my breathing, aligning my thoughts with the unyielding order of the Psydon.")
	drop_message = span_notice("I release my focus from the divine domain.")

	hand_path = /obj/item/melee/new_touch_attack/asperges
	can_cast_on_self = TRUE
	infinite_use = TRUE
	ignore_armor_penalty = TRUE

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE_ORISON

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_CANTRIP

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	cooldown_time = 10 SECONDS

	attunement_school = null

	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

	var/clean_devotion = 5
	var/water_moisten = 2

/datum/action/cooldown/spell/touch/asperges/cast_on_hand_hit(obj/item/melee/new_touch_attack/asperges/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	if(!istype(hand))
		return FALSE

	switch(caster.used_intent.type)
		if(/datum/intent/fill)
			if(hand.create_water(victim, caster))
				return TRUE
		if(/datum/intent/hand/clean)
			if(hand.clean_target(victim, caster))
				return TRUE
	return FALSE

// --- Touch Attack Item ---

/obj/item/melee/new_touch_attack/asperges
	name = "\improper rite of asperges"
	possible_item_intents = list(/datum/intent/fill, /datum/intent/hand/clean)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#70d1e2"
	associated_skill = /datum/skill/magic/holy
	var/base_cleanspeed = 35

/obj/item/melee/new_touch_attack/asperges/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	var/datum/action/cooldown/spell/touch/asperges/spell = spell_which_made_us?.resolve()
	if(spell)
		spell.cast_on_hand_hit(src, target, user)

/obj/item/melee/new_touch_attack/asperges/proc/get_holy_speed_mult(mob/living/user)
	var/holy_skill = user.get_skill_level(/datum/skill/magic/holy)
	return clamp(1 - (holy_skill * 0.085), 0.5, 1)

// --- INTENT: FILL ---

/obj/item/melee/new_touch_attack/asperges/proc/create_water(atom/victim, mob/living/carbon/human/caster)
	var/datum/action/cooldown/spell/touch/asperges/spell = spell_which_made_us?.resolve()
	if(!spell)
		return FALSE

	var/holy_skill = caster.get_skill_level(/datum/skill/magic/holy)

	if (victim.is_refillable())
		if (victim.reagents.holder_full())
			to_chat(caster, span_warning("[victim] is already filled to its capacity."))
			return FALSE
		
		var/god_title = caster.patron ? caster.patron.name : "Psydon"
		caster.visible_message(span_info("[caster] closes [caster.p_their()] eyes in orthodox prayer, extending a hand over [victim] as pure, blessed moisture condenses..."), span_notice("I beseech [god_title] for succour, commanding reality to yield to His divine order above [victim]..."))

		var/drip_speed = 1.5 SECONDS
		var/water_qty = 5
		
		while (do_after(caster, drip_speed, target = victim))
			if (victim.reagents.holder_full())
				break

			water_qty = holy_skill * 5
			var/list/water_contents = list(/datum/reagent/water/blessed = water_qty)

			var/datum/reagents/reagents_to_add = new()
			reagents_to_add.add_reagent_list(water_contents)
			reagents_to_add.trans_to(victim, reagents_to_add.total_volume, transfered_by = caster)
			
			if (prob(80))
				playsound(caster, 'sound/items/fillcup.ogg', 55, TRUE)
		
		spell.StartCooldown()
		return TRUE

	if (istype(victim, /obj/item/natural/cloth))
		var/obj/item/natural/cloth/the_cloth = victim
		if(the_cloth.wet >= holy_skill * 5)
			to_chat(caster, span_warning("This cloth is already perfectly dampened by divine providence."))
			return FALSE
		the_cloth.wet = holy_skill * 5
		caster.visible_message(span_info("[caster] lowers [caster.p_their()] head, beads of sacred moisture coalescing into [the_cloth] by righteous will."), span_notice("I command moisture into [the_cloth] in the name of the Psydon."))
		caster.devotion?.update_devotion(-spell.water_moisten)
		spell.StartCooldown()
		return TRUE

	if (istype(victim, /obj/item/reagent_containers/powder/flour))
		var/obj/item/reagent_containers/powder/flour/the_flour = victim
		the_flour.wet(src, caster)
		spell.StartCooldown()
		return TRUE
	if (istype(victim, /obj/item/reagent_containers/food/snacks/grown/rice))
		var/obj/item/reagent_containers/food/snacks/grown/rice/the_rice = victim
		the_rice.wet(src, caster)
		spell.StartCooldown()
		return TRUE
	if (istype(victim, /obj/item/reagent_containers/powder/mineral))
		var/obj/item/reagent_containers/powder/mineral/the_mineral = victim
		the_mineral.wet(src, caster)
		spell.StartCooldown()
		return TRUE

	if (istype(victim, /obj/structure/soil))
		caster.visible_message(span_info("[caster] conjures a righteous drizzle over the soil."), span_notice("I offer a brief liturgy to the Wounded God, restoring order and moisture to the soil."))
		spell.StartCooldown()
		return TRUE

	to_chat(caster, span_info("I must find a proper object or container to bless with moisture."))
	return FALSE

// --- INTENT: CLEAN ---

/obj/item/melee/new_touch_attack/asperges/proc/clean_target(atom/target, mob/living/carbon/human/user)
	var/datum/action/cooldown/spell/touch/asperges/spell = spell_which_made_us?.resolve()
	if(!spell)
		return FALSE

	var/cleanspeed = initial(base_cleanspeed) * get_holy_speed_mult(user)

	if(istype(target, /obj/effect/decal/cleanable))
		if(!should_clean_rune(target))
			user.visible_message(span_notice("[user] gestures at \the [target.name]... but the active rune's power rebukes the ritual!"), span_notice("I attempt to purge \the [target.name], but the active ritual stands stubborn against the Psydon's authority."))
			return FALSE

		user.visible_message(span_notice("[user] begins a sweeping gesture above \the [target.name]..."), span_notice("I begin to cleanse \the [target.name] from this space..."))
		
		if(do_after(user, cleanspeed, target = target))
			var/turf/T = get_turf(target)
			new /obj/effect/temp_visual/censer_dust(T)
			
			for(var/obj/effect/decal/cleanable/C in T)
				if(!should_clean_rune(C))
					return FALSE
			
			wash_atom(T, CLEAN_MEDIUM)
			playsound(user, 'sound/items/firesnuff.ogg', 60, TRUE)
			to_chat(user, span_notice("I have successfully cleansed \the [target.name]."))
			
			user.devotion?.update_devotion(-spell.clean_devotion)
			spell.StartCooldown()
			return TRUE
		return FALSE

	else
		var/clean_name = isturf(target) ? "the ground" : "\the [target.name]"
		user.visible_message(span_notice("[user] signs a holy cross over [clean_name], wiping away the filth..."), span_notice("I begin to cleanse [clean_name] of grime..."))
		
		if(do_after(user, cleanspeed, target = target))
			var/turf/T = get_turf(target)
			new /obj/effect/temp_visual/censer_dust(T)
			
			for(var/obj/effect/decal/cleanable/C in T)
				if(!should_clean_rune(C))
					return FALSE
					
			wash_atom(target, CLEAN_MEDIUM)
			playsound(user, 'sound/items/firesnuff.ogg', 60, TRUE)
			
			if(isliving(target))
				var/mob/living/carbon/human/H = target
				if(istype(H))
					H.update_inv_wear_suit()
					H.update_inv_w_uniform()
				
			to_chat(user, span_notice("I render [clean_name] clean of filth."))
			
			user.devotion?.update_devotion(-spell.clean_devotion)
			spell.StartCooldown()
			return TRUE
		return FALSE

/obj/item/melee/new_touch_attack/asperges/proc/should_clean_rune(obj/effect/decal/cleanable/C)
	var/obj/effect/decal/cleanable/roguerune/rune = C
	if(istype(rune) && rune.active)
		return FALSE
	return TRUE
