#define TRANQUILITY_SHROUD_DURATION 12 MINUTES
#define TRANQUILITY_SHROUD_APPLY_TIME 2 SECONDS
#define TRANQUILITY_SHROUD_FORGET_RANGE 12
#define TRANQUILITY_SHROUD_TRAIT_SOURCE "tranquility_shroud"
#define TRANQUILITY_SHROUD_MODE_RESTLESS "restless"
#define TRANQUILITY_SHROUD_MODE_DEADITE "deadite"
#define TRANQUILITY_SHROUD_MODE_VAMPIRE "vampire"
#define TRANQUILITY_SHROUD_SUN_BURN_DAMAGE 3

/datum/stressevent/tranquility_shroud/restless
	stressadd = 2
	timer = 12 MINUTES
	desc = span_red("Холод окатывает всё моё тело и заставляет меня дрожать от озноба...")

/datum/stressevent/tranquility_shroud/deadite
	stressadd = 4
	timer = 12 MINUTES
	desc = span_boldred("Холод заставляет моё тело коченеть, а ноги с трудом перебирают по земле...")

/datum/stressevent/tranquility_shroud/vampire
	stressadd = 6
	timer = 12 MINUTES
	desc = span_boldred("Бледный туман покрывает мою кожу, а голоса, исходящие от него, желают выместить на мне свою злобу...")

/proc/tranquility_shroud_stress_for_mode(shroud_mode)
	switch(shroud_mode)
		if(TRANQUILITY_SHROUD_MODE_DEADITE)
			return /datum/stressevent/tranquility_shroud/deadite
		if(TRANQUILITY_SHROUD_MODE_VAMPIRE)
			return /datum/stressevent/tranquility_shroud/vampire
	return /datum/stressevent/tranquility_shroud/restless

/datum/action/cooldown/spell/touch/shroud_of_tranquility
	name = "Саван Забвения"
	desc = "Накладывает на цель защиту от нежити, скрывая её от взгляда. Маскировка держится до истечения времени; насилие и касание нежити не разорвут её."

	background_icon = 'icons/mob/actions/genericmiracles.dmi'
	button_icon = 'modular_twilight_axis/code/modules/spells/pantheon/divine/necra/necra_shroud.dmi'
	button_icon_state = "consecrateburial"

	draw_message = span_notice("Я собираю вокруг моей руки туман, что постепенно окутывает её леденящим холодом.<br>О чём я хочу попросить их?")
	drop_message = span_notice("Я взмахиваю рукой, и дымка растворяется в воздухе.")

	hand_path = /obj/item/melee/new_touch_attack/shroud
	can_cast_on_self = TRUE
	ignore_armor_penalty = TRUE

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE_MINOR

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_CANTRIP

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = CLERIC_T0
	spell_impact_intensity = SPELL_IMPACT_NONE

	point_cost = 0
	required_items = list(/obj/item/clothing/neck/roguetown/psicross)
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	cooldown_time = 30 SECONDS
	attunement_school = null
	sound = 'sound/magic/necra_sight.ogg'

/datum/action/cooldown/spell/touch/shroud_of_tranquility/on_hand_deleted(datum/source)
	remove_hand(null, FALSE)

/datum/action/cooldown/spell/touch/shroud_of_tranquility/on_hand_dropped(datum/source, mob/living/dropper)
	remove_hand(dropper, FALSE)

/datum/action/cooldown/spell/touch/shroud_of_tranquility/cast(mob/living/carbon/cast_on)
	if(!QDELETED(attached_hand) && (attached_hand in cast_on.held_items))
		remove_hand(cast_on, FALSE)
		return FALSE
	return ..()

/datum/action/cooldown/spell/touch/shroud_of_tranquility/proc/get_available_shroud_tier(mob/living/carbon/caster)
	var/applied_shroud_tier = spell_tier
	if(ishuman(caster))
		var/mob/living/carbon/human/human_caster = caster
		if(human_caster.devotion)
			applied_shroud_tier = max(applied_shroud_tier, human_caster.devotion.level)
	return applied_shroud_tier

/datum/action/cooldown/spell/touch/shroud_of_tranquility/proc/choose_tranquility_shroud_mode(mob/living/carbon/caster, mob/living/living_target, applied_shroud_tier)
	var/restless_choice = "Вуаль Забвения"
	var/deadite_choice = "Облик зомби"
	var/vampire_choice = "Личина вампира"
	var/list/options = list(restless_choice)
	var/list/descriptions = list()
	var/list/shroud_modes_by_choice = list()
	descriptions[restless_choice] = "T0: скрывает цель от взгляда нежити. T1: дарует к сокрытию одноразовое возмездие против атаки нежити."
	shroud_modes_by_choice[restless_choice] = TRANQUILITY_SHROUD_MODE_RESTLESS

	if(applied_shroud_tier >= CLERIC_T2)
		options += deadite_choice
		descriptions[deadite_choice] = "T2: тело приобретает зелёный оттенок, бег становится невозможен, сердцебиение не слышно, а плоть защищена от становления нежитью."
		shroud_modes_by_choice[deadite_choice] = TRANQUILITY_SHROUD_MODE_DEADITE
	if(applied_shroud_tier >= CLERIC_T3)
		options += vampire_choice
		descriptions[vampire_choice] = "T3: тело приобретает бледный оттенок, а вампиры не чувствуют чужака; взамен свет Астаты жжёт плоть."
		shroud_modes_by_choice[vampire_choice] = TRANQUILITY_SHROUD_MODE_VAMPIRE

	var/choice = tgui_input_list(caster, "Какой туман перенести на [living_target]?", "Саван Забвения", options, options[1], descriptions = descriptions)
	return shroud_modes_by_choice[choice]

/datum/action/cooldown/spell/touch/shroud_of_tranquility/cast_on_hand_hit(obj/item/melee/new_touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	if(QDELETED(hand) || QDELETED(caster))
		return FALSE
	if(!isliving(victim))
		to_chat(caster, span_warning("Туман не ложится на тех, кто ничего не осознаёт."))
		return FALSE
	if(get_dist(caster, victim) > 1)
		to_chat(caster, span_warning("Мне нужно подойти ближе к [victim], чтобы переместить туман на него."))
		return FALSE

	var/mob/living/living_target = victim
	if(QDELETED(living_target) || living_target.stat != CONSCIOUS)
		to_chat(caster, span_warning("Туман не ложится на тех, кто ничего не осознаёт."))
		return FALSE
	if((living_target.mob_biotypes & MOB_UNDEAD) || living_target.mind?.has_antag_datum(/datum/antagonist/zombie))
		to_chat(caster, span_warning("Туман отступает от [living_target] и возвращается назад."))
		return FALSE
	if(living_target.has_tranquility_shroud())
		to_chat(caster, span_notice("Туман отступает от [living_target] и возвращается назад."))
		return FALSE

	var/applied_shroud_tier = get_available_shroud_tier(caster)
	var/selected_shroud_mode = choose_tranquility_shroud_mode(caster, living_target, applied_shroud_tier)
	if(!selected_shroud_mode)
		return FALSE
	if(QDELETED(hand) || QDELETED(caster) || QDELETED(living_target))
		return FALSE
	if(get_dist(caster, living_target) > 1 || living_target.stat != CONSCIOUS)
		to_chat(caster, span_warning("Туман рассеивается, не успев лечь."))
		return FALSE
	if((living_target.mob_biotypes & MOB_UNDEAD) || living_target.mind?.has_antag_datum(/datum/antagonist/zombie))
		to_chat(caster, span_warning("Туман отступает от [living_target] и возвращается назад."))
		return FALSE
	if(living_target.has_tranquility_shroud())
		to_chat(caster, span_notice("Туман отступает от [living_target] и возвращается назад."))
		return FALSE

	caster.visible_message(span_notice("[caster] подносит свою ладонь к [living_target]."), span_notice("Я подношу ладонь, заставляя туман перейти с моей руки на [living_target]."))
	if(living_target != caster)
		to_chat(living_target, span_notice("Туман начинает кружить вокруг меня."))

	if(!do_after(caster, TRANQUILITY_SHROUD_APPLY_TIME, target = living_target))
		return FALSE
	if(QDELETED(hand) || QDELETED(caster) || QDELETED(living_target))
		return FALSE
	if(get_dist(caster, living_target) > 1 || living_target.stat != CONSCIOUS)
		to_chat(caster, span_warning("Туман рассеивается, не успев лечь."))
		return FALSE
	if((living_target.mob_biotypes & MOB_UNDEAD) || living_target.mind?.has_antag_datum(/datum/antagonist/zombie))
		to_chat(caster, span_warning("Туман отступает от [living_target] и возвращается назад."))
		return FALSE
	if(living_target.has_tranquility_shroud())
		to_chat(caster, span_notice("Туман отступает от [living_target] и возвращается назад."))
		return FALSE

	var/datum/status_effect/tranquility_shroud/shroud = living_target.apply_status_effect(/datum/status_effect/tranquility_shroud, caster, caster.get_skill_level(/datum/skill/magic/holy), applied_shroud_tier, selected_shroud_mode)
	if(!shroud)
		to_chat(caster, span_warning("Туман рассеивается, не успев лечь."))
		return FALSE

	playsound(get_turf(living_target), sound, 50, TRUE)
	caster.visible_message(span_notice("Туман покрывает [living_target] и начинает кружить вокруг него."), span_notice("Туман покрывает [living_target] и начинает кружить вокруг него."))
	to_chat(living_target, span_notice("Туман покрывает меня и начинает кружить вокруг."))
	hand.remove_hand_with_no_refund(caster)
	return TRUE

/obj/item/melee/new_touch_attack/shroud
	name = "слабый туман"
	desc = "Туман, состоящий из разных духов, образует полотно вокруг руки и может перейти на другого человека."
	possible_item_intents = list(/datum/intent/use)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	associated_skill = /datum/skill/magic/holy
	experimental_inhand = FALSE
	w_class = WEIGHT_CLASS_TINY

/obj/item/melee/new_touch_attack/shroud/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity)
		return
	var/datum/action/cooldown/spell/touch/shroud_of_tranquility/spell = spell_which_made_us?.resolve()
	if(spell)
		spell.cast_on_hand_hit(src, target, user)

/datum/status_effect/tranquility_shroud
	id = "tranquility_shroud"
	alert_type = /atom/movable/screen/alert/status_effect/buff/shroud
	duration = TRANQUILITY_SHROUD_DURATION
	status_type = STATUS_EFFECT_UNIQUE
	on_remove_on_mob_delete = TRUE
	var/removal_reason
	var/holy_skill = 0
	var/shroud_tier = CLERIC_T0
	var/shroud_mode = TRANQUILITY_SHROUD_MODE_RESTLESS
	var/mask_active = TRUE
	var/protection_active = FALSE
	var/suppress_remove_message = FALSE
	var/stress_event_type
	var/datum/weakref/caster_ref
	var/retaliation_used = FALSE
	var/list/cached_appearance
	var/granted_undead_faction = FALSE
	var/list/granted_shroud_traits
	var/vampire_sunlit = FALSE

/datum/status_effect/tranquility_shroud/on_creation(mob/living/new_owner, mob/living/caster, caster_holy_skill, applied_shroud_tier = CLERIC_T0, selected_mode = TRANQUILITY_SHROUD_MODE_RESTLESS)
	if(caster)
		caster_ref = WEAKREF(caster)
	holy_skill = caster_holy_skill
	if(isnull(holy_skill))
		holy_skill = 0
	shroud_tier = applied_shroud_tier
	if(selected_mode)
		shroud_mode = selected_mode
	stress_event_type = tranquility_shroud_stress_for_mode(shroud_mode)
	. = ..()
	if(.)
		update_shroud_alert()
	return .

/datum/status_effect/tranquility_shroud/on_apply()
	if(!owner || QDELETED(owner) || owner.stat != CONSCIOUS || (owner.mob_biotypes & MOB_UNDEAD) || owner.mind?.has_antag_datum(/datum/antagonist/zombie))
		return FALSE
	mask_active = TRUE
	protection_active = (shroud_mode == TRANQUILITY_SHROUD_MODE_RESTLESS && shroud_tier >= CLERIC_T1)
	owner.AddElement(/datum/element/tranquility_shroud)
	apply_shroud_disguise()
	apply_shroud_stress()
	update_shroud_visuals()
	return TRUE

/datum/status_effect/tranquility_shroud/on_remove()
	if(owner && !QDELETED(owner))
		remove_shroud_stress()
		remove_shroud_disguise()
		owner.RemoveElement(/datum/element/tranquility_shroud)
		if(!suppress_remove_message)
			if(removal_reason)
				to_chat(owner, span_warning("Туман рвётся и больше не может сокрыть от нежити."))
			else
				to_chat(owner, span_notice("Туман рассеивается вокруг меня."))
	return ..()

/datum/status_effect/tranquility_shroud/proc/dispel(reason, mob/living/undead_source)
	if(QDELETED(src))
		return
	removal_reason = reason
	qdel(src)

/datum/status_effect/tranquility_shroud/proc/update_shroud_visuals()
	if(!owner || QDELETED(owner))
		return
	update_shroud_alert()
	examine_text = null
	if(protection_active)
		examine_text = "Туман всё ещё витает возле меня и готовится перейти на нежить."
		return

/datum/status_effect/tranquility_shroud/proc/get_shroud_alert_icon_state()
	if(protection_active)
		return "shroud_defence"
	switch(shroud_mode)
		if(TRANQUILITY_SHROUD_MODE_DEADITE)
			return "shroud_t2"
		if(TRANQUILITY_SHROUD_MODE_VAMPIRE)
			return "shroud_t3"
	return "shroud_t0"

/datum/status_effect/tranquility_shroud/proc/update_shroud_alert()
	if(!linked_alert)
		return
	linked_alert.icon = 'modular_twilight_axis/code/modules/spells/pantheon/divine/necra/necra_shroud.dmi'
	linked_alert.icon_state = get_shroud_alert_icon_state()

/datum/status_effect/tranquility_shroud/proc/apply_shroud_stress()
	if(stress_event_type && owner)
		owner.add_stress(stress_event_type)

/datum/status_effect/tranquility_shroud/proc/remove_shroud_stress()
	if(stress_event_type && owner)
		owner.remove_stress(stress_event_type)

/atom/movable/screen/alert/status_effect/buff/shroud
	name = "Холодный туман"
	desc = "Туман держится вокруг меня. Мёртвые не нападут на меня, пока он на мне."
	icon = 'modular_twilight_axis/code/modules/spells/pantheon/divine/necra/necra_shroud.dmi'
	icon_state = "shroud_t0"

/atom/movable/screen/alert/status_effect/buff/shroud/Click(location, control, params)
	if(!usr || !usr.client)
		return FALSE
	var/list/paramslist = params2list(params)
	if(LAZYACCESS(paramslist, RIGHT_CLICK))
		var/mob/living/user = usr
		var/datum/status_effect/tranquility_shroud/shroud = attached_effect
		if(!istype(user) || !istype(shroud) || shroud.owner != user)
			return FALSE
		qdel(shroud)
		return FALSE
	return ..()

/datum/element/tranquility_shroud

/datum/element/tranquility_shroud/Attach(datum/target)
	. = ..()
	if(!isliving(target))
		return ELEMENT_INCOMPATIBLE

	var/mob/living/owner = target
	RegisterSignal(owner, COMSIG_ATOM_ATTACKBY, PROC_REF(on_owner_attackby))
	RegisterSignals(owner, list(COMSIG_ATOM_ATTACK_HAND, COMSIG_ATOM_ATTACK_PAW), PROC_REF(on_owner_attack_generic))
	RegisterSignal(owner, COMSIG_ATOM_ATTACK_ANIMAL, PROC_REF(on_owner_attack_npc))
	RegisterSignal(owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_owner_bullet_act))
	RegisterSignal(owner, COMSIG_ATOM_HITBY, PROC_REF(on_owner_hitby))
	RegisterSignal(owner, COMSIG_HUMAN_LIFE, PROC_REF(on_owner_life))
	RegisterSignal(owner, COMSIG_PARENT_EXAMINE, PROC_REF(on_owner_examine))
	RegisterSignal(owner, "mob_ai_target_check", PROC_REF(on_owner_ai_target_check))
	owner.tranquility_shroud_hide_from_nearby_undead()

/datum/element/tranquility_shroud/Detach(datum/source, ...)
	UnregisterSignal(source, list(
		COMSIG_ATOM_ATTACKBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACK_PAW,
		COMSIG_ATOM_ATTACK_ANIMAL,
		COMSIG_ATOM_BULLET_ACT,
		COMSIG_ATOM_HITBY,
		COMSIG_HUMAN_LIFE,
		COMSIG_PARENT_EXAMINE,
		"mob_ai_target_check",
	))
	return ..()

/datum/element/tranquility_shroud/proc/break_from_incoming_attack(atom/target, atom/attacker)
	if(!isliving(target) || !isliving(attacker))
		return
	var/mob/living/living_target = target
	var/mob/living/living_attacker = attacker
	if(living_attacker.tranquility_shroud_is_real_undead())
		var/datum/status_effect/tranquility_shroud/shroud = living_target.has_status_effect(/datum/status_effect/tranquility_shroud)
		if(istype(shroud))
			shroud.trigger_shroud_retaliation(living_attacker)

/datum/element/tranquility_shroud/proc/on_owner_ai_target_check(mob/living/source, mob/living/checker)
	SIGNAL_HANDLER
	if(!isliving(source) || !isliving(checker))
		return FALSE
	if(!checker.can_undead_see_target(source))
		return TRUE
	return FALSE

/datum/element/tranquility_shroud/proc/on_owner_attackby(atom/target, obj/item/weapon, mob/attacker, list/modifiers)
	SIGNAL_HANDLER
	break_from_incoming_attack(target, attacker)

/datum/element/tranquility_shroud/proc/on_owner_attack_generic(atom/target, mob/living/attacker, list/modifiers)
	SIGNAL_HANDLER
	break_from_incoming_attack(target, attacker)

/datum/element/tranquility_shroud/proc/on_owner_attack_npc(atom/target, mob/living/attacker)
	SIGNAL_HANDLER
	break_from_incoming_attack(target, attacker)

/datum/element/tranquility_shroud/proc/on_owner_bullet_act(atom/target, obj/projectile/hit_projectile)
	SIGNAL_HANDLER
	if(!hit_projectile)
		return
	break_from_incoming_attack(target, hit_projectile.firer)

/datum/element/tranquility_shroud/proc/on_owner_hitby(atom/target, atom/movable/hit_atom, skipcatch = FALSE, hitpush = TRUE, blocked = FALSE, datum/thrownthing/throwingdatum)
	SIGNAL_HANDLER
	if(!hit_atom)
		return
	var/atom/attacker
	if(isitem(hit_atom))
		var/obj/item/hit_item = hit_atom
		attacker = hit_item.thrownby
	break_from_incoming_attack(target, attacker)

/datum/element/tranquility_shroud/proc/on_owner_life(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(!ishuman(source) || QDELETED(source) || source.stat == DEAD)
		return
	var/datum/status_effect/tranquility_shroud/shroud = source.has_status_effect(/datum/status_effect/tranquility_shroud)
	if(!shroud)
		return
	shroud.process_sun_burn()

/datum/element/tranquility_shroud/proc/on_owner_examine(mob/living/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/H = source
	if(!H.tranquility_shroud_has_vampire_mask())
		return
	if(H.is_face_concealed_for_shroud())
		return
	examine_list += span_redtext("В глазах [H] мерцает чужой свет, а за губами видны клыки!")

/mob/living/proc/has_tranquility_shroud()
	return !!has_status_effect(/datum/status_effect/tranquility_shroud)

/mob/living/proc/has_active_tranquility_shroud_mask()
	var/datum/status_effect/tranquility_shroud/shroud = has_status_effect(/datum/status_effect/tranquility_shroud)
	return !!(shroud && shroud.mask_active)

/mob/living/proc/remove_tranquility_shroud(reason = null, mob/living/undead_source = null)
	var/datum/status_effect/tranquility_shroud/shroud = has_status_effect(/datum/status_effect/tranquility_shroud)
	if(!shroud)
		return FALSE
	shroud.dispel(reason, undead_source)
	return TRUE

/mob/living/proc/is_player_raised_undead()
	if(summoner)
		return TRUE
	if(faction)
		if(FACTION_CABAL in faction)
			return TRUE
		for(var/faction_name as anything in faction)
			if(istext(faction_name) && findtext(faction_name, "_faction"))
				return TRUE
	return FALSE

/mob/living/proc/tranquility_shroud_is_player_controlled()
	return !!(client || ckey || mind?.key)

/mob/living/proc/tranquility_shroud_has_undead_faction()
	if(!faction)
		return FALSE
	var/static/list/undead_factions = list(
		FACTION_UNDEAD,
		FACTION_DUNDEAD,
		FACTION_LICH,
		FACTION_ZOMBIE,
		FACTION_SKELETON,
		FACTION_REVENANTS,
	)
	return !!length(faction & undead_factions)

/mob/living/proc/tranquility_shroud_is_real_undead()
	if(stat == DEAD)
		return FALSE
	if(has_active_tranquility_shroud_mask())
		return FALSE
	if(mob_biotypes & MOB_UNDEAD)
		return TRUE
	if(mind?.has_antag_datum(/datum/antagonist/zombie))
		return TRUE
	if(mind?.has_antag_datum(/datum/antagonist/skeleton))
		return TRUE
	if(mind?.has_antag_datum(/datum/antagonist/lich))
		return TRUE
	if(mind?.has_antag_datum(/datum/antagonist/vampire))
		return TRUE
	return tranquility_shroud_has_undead_faction()

/mob/living/proc/tranquility_shroud_is_npc_undead()
	if(!tranquility_shroud_is_real_undead())
		return FALSE
	if(tranquility_shroud_is_player_controlled())
		return FALSE
	if(is_player_raised_undead())
		return FALSE
	return TRUE

/mob/living/proc/tranquility_shroud_has_deadite_mask()
	var/datum/status_effect/tranquility_shroud/shroud = has_status_effect(/datum/status_effect/tranquility_shroud)
	return !!(shroud && shroud.uses_deadite_mask())

/mob/living/proc/tranquility_shroud_has_vampire_mask()
	var/datum/status_effect/tranquility_shroud/shroud = has_status_effect(/datum/status_effect/tranquility_shroud)
	return !!(shroud && shroud.uses_vampire_mask())

/mob/living/proc/tranquility_shroud_undead_examine_text(mob/examiner)
	var/datum/status_effect/tranquility_shroud/shroud = has_status_effect(/datum/status_effect/tranquility_shroud)
	if(!shroud || !shroud.mask_active || !isliving(examiner))
		return null
	var/mob/living/living_examiner = examiner
	if(shroud.uses_vampire_mask() && living_examiner.mind?.has_antag_datum(/datum/antagonist/vampire))
		return span_boldnotice("Бледная плоть не кажется чуждой моей крови.")
	if(shroud.uses_deadite_mask() && living_examiner.tranquility_shroud_is_real_undead())
		return span_boldnotice("Ещё один зомби.")
	return null

/mob/living/get_villain_text(mob/examiner)
	. = ..()
	var/shroud_text = tranquility_shroud_undead_examine_text(examiner)
	if(!shroud_text)
		return .
	if(.)
		. += "<br>"
	. += shroud_text

/mob/living/proc/tranquility_shroud_respects_deadites()
	if(!tranquility_shroud_is_npc_undead())
		return FALSE
	var/mob/living/simple_animal/hostile/hostile_mob = src
	if(istype(hostile_mob) && hostile_mob.attack_same)
		return FALSE
	var/datum/targetting_datum/basic/ignore_faction/ignore_faction_targeting = ai_controller?.blackboard[BB_TARGETTING_DATUM]
	if(istype(ignore_faction_targeting))
		return FALSE
	return TRUE

/mob/living/proc/tranquility_shroud_respects_vampire_mask()
	return !!mind?.has_antag_datum(/datum/antagonist/vampire)

/mob/living/proc/is_lesser_npc_undead()
	if(!tranquility_shroud_is_npc_undead())
		return FALSE
	if(istype(src, /mob/living/simple_animal/hostile/boss))
		return FALSE
	if(threat_point >= THREAT_ELITE)
		return FALSE
	if(!ai_controller && !istype(src, /mob/living/simple_animal/hostile))
		return FALSE
	return TRUE

/mob/living/proc/can_undead_see_target(mob/living/target)
	if(!target || QDELETED(target))
		return TRUE
	if(!target.has_active_tranquility_shroud_mask())
		return TRUE
	if(target.tranquility_shroud_has_vampire_mask() && tranquility_shroud_respects_vampire_mask())
		return FALSE
	if(target.tranquility_shroud_has_deadite_mask() && tranquility_shroud_respects_deadites())
		return FALSE
	return !is_lesser_npc_undead()

/mob/living/proc/tranquility_shroud_hide_from_nearby_undead()
	for(var/mob/living/undead in viewers(TRANQUILITY_SHROUD_FORGET_RANGE, src))
		if(!undead.can_undead_see_target(src))
			undead.forget_tranquility_shrouded_target(src)

/mob/living/proc/forget_tranquility_shrouded_target(mob/living/target)
	if(!target || can_undead_see_target(target))
		return
	if(ai_controller)
		if(ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] == target)
			ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		if(ai_controller.blackboard[BB_HIGHEST_THREAT_MOB] == target)
			ai_controller.clear_blackboard_key(BB_HIGHEST_THREAT_MOB)
		var/list/aggro_table = ai_controller.blackboard[BB_MOB_AGGRO_TABLE]
		if(aggro_table && aggro_table[target])
			aggro_table -= target
		ai_controller.CancelActions()
	var/mob/living/simple_animal/hostile/hostile_mob = src
	if(istype(hostile_mob) && hostile_mob.target == target)
		hostile_mob.LoseTarget()
