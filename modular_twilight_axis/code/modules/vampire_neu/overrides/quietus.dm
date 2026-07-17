/*
 * Quietus rework ported from Azure-Peak/Azure-Peak#7383.
 *
 * Custom types are TA-prefixed where possible. Existing Quietus paths are
 * overridden only at the late module include point.
 */

#define TA_BLOODBLADE_BONUS 10
#define TA_BLOODBLADE_HITS 3
#define TA_BLOODBLADE_DURATION (30 SECONDS)
#define TA_BLACK_VITAE_MULTIPLIER 1.375

/atom/movable/screen/alert/status_effect/debuff/ta_black_vitae
	name = "Кровавая гниль"
	desc = span_bloody("ЧЁРНАЯ ГНИЛЬ ПРОНИКАЕТ В МОИ РАНЫ! ВСЁ БОЛИТ!")
	icon_state = "ritesexpended"

/datum/status_effect/debuff/ta_black_vitae
	id = "ta_black_vitae"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ta_black_vitae
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	var/applied_physiology_modifiers = FALSE
	var/temporary_colour = rgb(67, 67, 67)

/datum/status_effect/debuff/ta_black_vitae/on_apply()
	. = ..()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/target = owner
	var/datum/physiology/physiology = target.physiology
	physiology.bleed_mod *= TA_BLACK_VITAE_MULTIPLIER
	physiology.pain_mod *= TA_BLACK_VITAE_MULTIPLIER
	applied_physiology_modifiers = TRUE
	target.add_atom_colour(temporary_colour, TEMPORARY_COLOUR_PRIORITY)

/datum/status_effect/debuff/ta_black_vitae/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/target = owner
		if(applied_physiology_modifiers)
			var/datum/physiology/physiology = target.physiology
			physiology.bleed_mod /= TA_BLACK_VITAE_MULTIPLIER
			physiology.pain_mod /= TA_BLACK_VITAE_MULTIPLIER
			applied_physiology_modifiers = FALSE
		target.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, temporary_colour)
	return ..()

/datum/component/ta_bloodblade
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/hits_remaining = 0
	var/poison_pending = TRUE
	var/original_colour
	var/timeout_timer

/datum/component/ta_bloodblade/Initialize()
	if(!istype(parent, /obj/item/rogueweapon))
		return COMPONENT_INCOMPATIBLE

	var/obj/item/rogueweapon/weapon = parent
	hits_remaining = TA_BLOODBLADE_HITS
	poison_pending = TRUE
	original_colour = weapon.color
	weapon.force += TA_BLOODBLADE_BONUS
	weapon.force_wielded += TA_BLOODBLADE_BONUS
	weapon.update_force_dynamic()
	weapon.color = "#6b2828"
	weapon.add_filter("ta_bloodblade", 2, list("type" = "outline", "color" = "#000000", "alpha" = 200, "size" = 1))
	timeout_timer = addtimer(CALLBACK(src, PROC_REF(timeout)), TA_BLOODBLADE_DURATION, TIMER_STOPPABLE)

/datum/component/ta_bloodblade/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_EFFECT_SELF, PROC_REF(on_hit))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/ta_bloodblade/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_ATTACK_EFFECT_SELF, COMSIG_PARENT_EXAMINE))

/datum/component/ta_bloodblade/Destroy()
	if(timeout_timer)
		deltimer(timeout_timer)
		timeout_timer = null

	if(istype(parent, /obj/item/rogueweapon))
		var/obj/item/rogueweapon/weapon = parent
		weapon.force -= TA_BLOODBLADE_BONUS
		weapon.force_wielded -= TA_BLOODBLADE_BONUS
		weapon.update_force_dynamic()
		weapon.color = original_colour
		weapon.remove_filter("ta_bloodblade")

	return ..()

/datum/component/ta_bloodblade/proc/on_hit(obj/item/source, mob/user, obj/item/bodypart/affecting, intent, mob/living/victim, selzone)
	SIGNAL_HANDLER
	if(!isliving(victim))
		return

	// COMSIG_ITEM_ATTACK_EFFECT_SELF fires only after armor was penetrated and
	// damage was actually applied, alongside the wound/critical-hit handling.
	if(poison_pending)
		victim.reagents?.add_reagent(/datum/reagent/bloodacid, 1)
		poison_pending = FALSE

	hits_remaining--
	if(hits_remaining <= 0)
		qdel(src)

/datum/component/ta_bloodblade/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_red("Оружие покрыто болезненным чёрным люксом. Усиленных ударов осталось: [hits_remaining].")

/datum/component/ta_bloodblade/proc/timeout()
	timeout_timer = null
	qdel(src)

/datum/component/ta_bloodblade/proc/refresh_coating()
	hits_remaining = TA_BLOODBLADE_HITS
	poison_pending = TRUE
	if(timeout_timer)
		deltimer(timeout_timer)
	timeout_timer = addtimer(CALLBACK(src, PROC_REF(timeout)), TA_BLOODBLADE_DURATION, TIMER_STOPPABLE)

// SILENCE OF DEATH
/datum/coven_power/quietus/silence_of_death
	duration_length = 20 SECONDS
	silence_range = 7

/datum/coven_power/quietus/silence_of_death/apply_silence(mob/living/carbon/human/target)
	if(!should_affect_target(target))
		return
	if(!HAS_TRAIT(target, TRAIT_SILENT_FOOTSTEPS))
		ADD_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, "quietus")
	if(!HAS_TRAIT(target, TRAIT_DEAF))
		ADD_TRAIT(target, TRAIT_DEAF, "quietus")
	if(target.confused < 5)
		target.confused += 1

// SCORPION'S TOUCH
/datum/coven_power/quietus/scorpions_touch
	desc = "Используйте витэ, чтобы раны жертвы сильнее болели и быстрее кровоточили."

/datum/coven_power/quietus/scorpions_touch/activate()
	. = ..()
	owner.put_in_hands(new /obj/item/melee/touch_attack/quietus(owner))

/obj/item/melee/touch_attack/quietus
	desc = "Мерзкий чёрный люкс стекает по руке, готовый проникнуть в чужие раны."
	color = COLOR_ALMOST_BLACK
	catchphrase = ""
	on_use_sound = 'sound/magic/heartbeat.ogg'

/obj/item/melee/touch_attack/quietus/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_status_effect(/datum/status_effect/debuff/ta_black_vitae)
		living_target.visible_message(span_warning("Раны [living_target] начинают гнить и чернеть!"))
		to_chat(living_target, span_danger("БОЛЬ В РАНАХ СТАНОВИТСЯ НЕВЫНОСИМОЙ!"))
	return ..()

// DAGON'S CALL
/datum/coven_power/quietus/dagons_call
	level = 3
	research_cost = 2
	vitae_cost = 200
	minimal_generation = null
	cooldown_length = 120 SECONDS

/datum/coven_power/quietus/dagons_call/can_activate(atom/target, alert = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/last_attacker = owner.lastattacker_weakref?.resolve()
	if(isliving(last_attacker))
		return TRUE

	if(alert)
		to_chat(owner, span_warning("I have no recent attacker to curse."))
	return FALSE

/datum/coven_power/quietus/dagons_call/activate()
	. = ..()
	var/mob/living/last_attacker = owner.lastattacker_weakref?.resolve()
	if(!isliving(last_attacker))
		return FALSE

	owner.emote("snap", forced = TRUE)
	playsound(last_attacker, 'sound/magic/heartbeat.ogg', 40, FALSE)
	last_attacker.reagents?.add_reagent(/datum/reagent/bloodacid, 3)
	to_chat(owner, span_notice("I send my curse into [last_attacker], the last creature to attack me."))

// BAAL'S CARESS
/datum/coven_power/quietus/baals_caress
	desc = "Пронзите себя, чтобы усилить острое оружие на три удара и отравить первую жертву."
	level = 4
	research_cost = 3
	vitae_cost = 250
	target_type = NONE
	range = 0

/datum/coven_power/quietus/baals_caress/can_activate(atom/target, alert = FALSE)
	. = ..()
	if(!.)
		return FALSE

	var/obj/item/rogueweapon/target_weapon = owner.get_active_held_item()
	if(!istype(target_weapon))
		if(alert)
			to_chat(owner, span_warning("Для [src] мне нужно держать оружие в активной руке."))
		return FALSE
	if(!target_weapon.sharpness)
		if(alert)
			to_chat(owner, span_warning("[src] может усилить только острое оружие."))
		return FALSE
	return TRUE

/datum/coven_power/quietus/baals_caress/activate(obj/item/rogueweapon/ignored_target)
	. = ..()
	var/obj/item/rogueweapon/target_weapon = owner.get_active_held_item()
	if(!istype(target_weapon) || !target_weapon.sharpness)
		return FALSE

	var/datum/component/ta_bloodblade/existing_coating = target_weapon.GetComponent(/datum/component/ta_bloodblade)
	owner.visible_message(span_danger("[owner] пронзает себя оружием [target_weapon]!"))
	playsound(owner, 'sound/combat/wound_tear.ogg', 100, TRUE, -2)
	if(existing_coating)
		existing_coating.refresh_coating()
	else
		target_weapon.AddComponent(/datum/component/ta_bloodblade)
	playsound(owner, 'sound/foley/flesh_rem.ogg', 100, TRUE, -2)
	to_chat(owner, span_notice("Чёрный люкс покрывает [target_weapon]."))
	return TRUE

// TASTE OF DEATH
/datum/coven_power/quietus/taste_of_death
	level = 5
	research_cost = 4
	minimal_generation = GENERATION_ANCILLAE

/obj/effect/proc_holder/spell/invoked/projectile/acidsplash/quietus
	invocations = list(" lobs a glob of acid!")
	invocation_type = "emote"

/obj/projectile/magic/acidsplash/quietus
	damage = 40
	flag = "acid"

/obj/projectile/magic/acidsplash/quietus/on_hit(atom/target, blocked = FALSE)
	. = ..()
	for(var/mob/living/carbon/victim in range(aoe_range, get_turf(src)))
		victim.reagents?.add_reagent(/datum/reagent/bloodacid, 1)

#undef TA_BLOODBLADE_BONUS
#undef TA_BLOODBLADE_HITS
#undef TA_BLOODBLADE_DURATION
#undef TA_BLACK_VITAE_MULTIPLIER
