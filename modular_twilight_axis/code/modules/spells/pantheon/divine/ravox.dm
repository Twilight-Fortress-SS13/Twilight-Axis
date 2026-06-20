/obj/effect/proc_holder/spell/self/TAdivine_strike
	name = "Divine Strike"
	desc = "Bless your next strike to do extra damage and slow the target."
	overlay = "createlight"
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "divine_strike"
	recharge_time = 1 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/timestop.ogg'
	invocations = list("By Ravox, stand and fight!")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/self/TAdivine_strike/cast(mob/living/user)
	if(!isliving(user))
		return FALSE
	user.apply_status_effect(/datum/status_effect/TAdivine_strike, user.get_active_held_item())
	return TRUE

/atom/movable/screen/alert/status_effect/buff/TAdivine_strike
	name = "Divine Strike"
	desc = "Your next attack slows your target, lowering their WIL and SPD."
	icon = 'icons/mob/actions/ravoxmiracles.dmi'
	icon_state = "divine_strike"

/datum/status_effect/TAdivine_strike
	id = "divine_strike"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/TAdivine_strike
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

/datum/status_effect/TAdivine_strike/on_creation(mob/living/new_owner, obj/item/I)
	. = ..()
	if(!.)
		return
	if(istype(I) && !(I.item_flags & ABSTRACT))
		buffed_item = WEAKREF(I)
		if(!I.light_outer_range && I.light_system == STATIC_LIGHT)
			I.set_light(1)
		RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(hand_attack))

/datum/status_effect/TAdivine_strike/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(istype(I))
			I.set_light(0)
			UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/datum/status_effect/TAdivine_strike/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!isliving(target))
		return
	var/mob/living/living_target = target
	living_target.apply_status_effect(/datum/status_effect/debuff/TAravox_burden)
	living_target.visible_message(span_warning("The strike from [user]'s weapon causes [living_target] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/TAdivine_strike/proc/hand_attack(datum/source, mob/living/carbon/human/M, mob/living/carbon/human/H, datum/martial_art/attacker_style)
	if(!istype(M))
		return
	if(!istype(H))
		return
	if(!istype(M.used_intent, INTENT_HARM))
		return
	H.apply_status_effect(/datum/status_effect/debuff/TAravox_burden)
	H.visible_message(span_warning("The strike from [M]'s fist causes [H] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/debuff/TAravox_burden
	id = "ravox_burden"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/TAravox_burden
	effectedstats = list(STATKEY_SPD = -2, STATKEY_WIL = -1)
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/debuff/TAravox_burden
	name = "Ravox's Burden"
	desc = "My arms and legs are restrained by divine chains!\n"
	icon_state = "restrained"

/datum/status_effect/debuff/TAravox_burden/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/TAravox_burden/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

/atom/movable/screen/alert/status_effect/debuff/ravox_burden
	parent_type = /atom/movable/screen/alert/status_effect/debuff/TAravox_burden

/datum/status_effect/debuff/ravox_burden
	parent_type = /datum/status_effect/debuff/TAravox_burden
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ravox_burden

//Call to Arms - AoE buff for all people surrounding you.
/obj/effect/proc_holder/spell/self/TAcall_to_arms
	name = "Call to Arms"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution."
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "call_to_arms"
	recharge_time = 5 MINUTES
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	invocations = list("FOR GLORY AND HONOR!")
	invocation_type = "shout"
	sound = 'sound/magic/battle_cry.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 40
	range = 3

/obj/effect/proc_holder/spell/self/TAcall_to_arms/cast(list/targets,mob/living/user = usr)
	for(var/mob/living/carbon/target in view(range, get_turf(user)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/debuff/call_to_arms)	//Debuffs inhumen worshipers.
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("You feel a hot-wave wash over you, leaving as quickly as it came.."))	//No effect on Psydonians!
			continue
		if(!user.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/buff/call_to_arms)
	return TRUE

//Persistence - Harms the shit out of an undead mob/player while causing bleeding/pain wounds to clot at higher rate for living ones. Basically a 'shittier' yet still good greater heal effect.
/obj/effect/proc_holder/spell/invoked/TApersistence
	name = "Persistence"
	desc = "Harms Undead and encourages the livings wounds to close faster."
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "persistence"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/persistence.ogg'
	invocations = list("Ravox deems your persistence worthy!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 50

/obj/effect/proc_holder/spell/invoked/TApersistence/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD)
			if(spell_guard_check(target, TRUE))
				target.visible_message(span_warning("[target] resists Ravox's judgment!"))
				return TRUE
			if(ishuman(target)) //BLEED AND PAIN
				var/mob/living/carbon/human/human_target = target
				var/datum/physiology/phy = human_target.physiology
				phy.bleed_mod *= 1.5
				phy.pain_mod *= 1.5
				addtimer(CALLBACK(src, PROC_REF(restore_modifiers), phy), 19 SECONDS)
				human_target.visible_message(span_danger("[target]'s wounds become inflamed as their vitality is sapped away!"), span_userdanger("Ravox inflames my wounds and weakens my body!"))
				return TRUE
			return FALSE

		target.visible_message(span_info("Warmth radiates from [target] as their wounds seal over!"), span_notice("The pain from my wounds fade as warmth radiates from my soul!"))
		var/situational_bonus = 0.25
		for(var/obj/effect/decal/cleanable/blood/O in oview(5, target))
			situational_bonus = min(situational_bonus + 0.015, 1)
		if(situational_bonus > 0.25)
			to_chat(user, "Channeling Ravox's power is easier in these conditions!")

		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
			if(affecting)
				for(var/datum/wound/bleeder in affecting.wounds)
					bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
					if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
						var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
						bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference * situational_bonus))
		else if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
			for(var/datum/wound/bleeder in target.simple_wounds)
				bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
				if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
					var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
					bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference * situational_bonus))
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/TApersistence/proc/restore_modifiers(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.bleed_mod /= 1.5
	physiology.pain_mod /= 1.5

/obj/effect/proc_holder/spell/invoked/TAtug_of_war
	name = "Tug of War"
	desc = "Casts out a chain that tries to pull the target closer."
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "ravox_tug"
	recharge_time = 30 SECONDS
	movement_interrupt = FALSE //WTF, targeted fetch and one minute recharge
	chargedrain = 0
	chargetime = 5
	charging_slowdown = 0
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/battletrance.ogg'
	invocations = list("By Ravox, let your sins guide you to justice!")
	invocation_type = "shout"
	antimagic_allowed = FALSE
	miracle = TRUE
	devotion_cost = 25
	var/pull_distance = 1
	var/slowdown = 1

/obj/effect/proc_holder/spell/invoked/TAtug_of_war/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] holds firm against the pull!"))
			return TRUE
		var/chance = 0
		if(target.mob_biotypes & MOB_UNDEAD)
			pull_distance++
			chance += 20
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/strdiff = user.STASTR - H.STASTR
			var/condiff = user.STACON - H.STACON

			var/list/statdiffs = list(strdiff, condiff)
			var/count = 0
			for(var/diff in statdiffs)
				if(diff > 0)
					chance += 10
					count++
				else if(diff < 0)
					chance -= 10
			var/holymod = user.get_skill_level(/datum/skill/magic/holy) * 10
			pull_distance += floor((user.get_skill_level(/datum/skill/magic/holy) - 1) / 2)	//+1 pull dist at Jman and Master Holy skill
			chance += holymod
			user.visible_message(span_boldwarning("[user] yanks on a transluscent chain sticking out of [target]!"))
			if(count > 3)	//More than half of the stats are in our favor.
				pull_distance++
				slowdown++
			if(prob(chance))
				H.throw_at(user, pull_distance, 1, H, FALSE)
				H.visible_message(span_warning("[H]'s body moves on its own!"))
				user.Beam(target, icon_state = "chain", time = 5)
			else
				H.visible_message(span_warning("[H] holds firm!"))
			H.Slowdown(slowdown)
			return TRUE
		revert_cast()
		return FALSE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/TAchallenge
	name = "Challenge"
	desc = "Bring an opponent with you to Ravoxian Trial. Engage in 3 minute combat."
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "ravoxchallenge"
	action_icon_state = "ravoxchallenge"
	recharge_time = 10 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	range = 5
	chargetime = 3 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/battletrance.ogg'
	invocations = list("By Ravox, I challenge you!!")
	chargedloop = /datum/looping_sound/invokeholy
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 100

GLOBAL_LIST_EMPTY(TAarenafolks) // we're just going to use a list and add to it. Since /entered doesnt work on teleported mobs.

/obj/effect/proc_holder/spell/invoked/TAchallenge/cast(list/targets, mob/living/user)
	var/area/rogue/indoors/ravoxarena/thearena = GLOB.areas_by_type[/area/rogue/indoors/ravoxarena]
	var/turf/challengerspawnpoint
	var/turf/challengedspawnpoint
	var/arenacount = GLOB.TAarenafolks.len
	if(arenacount >= 2)
		to_chat(user, span_italics("The arena is not yet ready for the next trial! Wait your turn!"))
		revert_cast()
		return FALSE

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/carbon/target = targets[1]
	var/originalcmodeuser = user.cmode_music
	var/originalcmodetarget = target.cmode_music
	var/turf/storedchallengerturf = get_turf(user)
	var/turf/storedchallengedturf = get_turf(target)

	if(user.z != target.z)
		revert_cast()
		return FALSE
	if(target == user)
		revert_cast()
		return FALSE
	if(
		(target.stat > CONSCIOUS) || \
		!(target.mobility_flags & MOBILITY_STAND) || \
		!(target.mobility_flags & MOBILITY_MOVE) || \
		(HAS_TRAIT(target, TRAIT_PACIFISM)) || \
		(target.handcuffed) || \
		(target.legcuffed)
	)
		to_chat(user, span_warning("[target] is in no shape to accept the duel!"))
		revert_cast()
		return FALSE

	if(spell_guard_check(target, TRUE))
		target.visible_message(span_warning("[target] stands firm, refusing the trial!"))
		return TRUE

	for(var/obj/structure/fluff/ravox/challenger/aflag in thearena)
		challengerspawnpoint = get_turf(aflag)
	for(var/obj/structure/fluff/ravox/challenged/bflag in thearena)
		challengedspawnpoint = get_turf(bflag)

	do_teleport(user, challengerspawnpoint)
	do_teleport(target, challengedspawnpoint)
	GLOB.TAarenafolks += user
	GLOB.TAarenafolks += target
	storedchallengerturf.visible_message((span_cult("[user] calls upon the Ravoxian rite of Trial! [target] and [user] are brought to Trial!")))

	new /obj/structure/fluff/ravox/challenger/recall(storedchallengerturf)
	new /obj/structure/fluff/ravox/challenged/recall(storedchallengedturf)

	to_chat(user, span_userdanger("THE TRIAL IS CALLED, IMPRESS US, PROSECUTOR!!"))
	to_chat(target, span_userdanger("A TRIAL OF RAVOX BEGINS. IMPRESS US, DEFENDANT!!"))

	user.cmode_change('sound/music/ravoxarena.ogg')
	target.cmode_change('sound/music/ravoxarena.ogg')

	addtimer(CALLBACK(user, GLOBAL_PROC_REF(do_teleport), user, storedchallengerturf), 3 MINUTES)
	addtimer(CALLBACK(target, GLOBAL_PROC_REF(do_teleport), target, storedchallengedturf), 3 MINUTES)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, cmode_change), originalcmodeuser), 3 MINUTES)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob, cmode_change), originalcmodetarget), 3 MINUTES)
	addtimer(CALLBACK(thearena, TYPE_PROC_REF(/area/rogue/indoors/ravoxarena, cleanthearena), storedchallengedturf), 3 MINUTES) // shunt all items from the arena out onto the challenged spot.

	if(iscarbon(target))
		var/mob/living/carbon/human/spawnprotectiontarget = target
		addtimer(CALLBACK(spawnprotectiontarget, TYPE_PROC_REF(/mob/living/carbon/human, do_invisibility), 10 SECONDS), 3 MINUTES)

	return TRUE

/obj/structure/fluff/ravox/proc/TAspawnprotection()
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromflag
	var/maxthrow = 6
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/push_range = 3

	playsound(src, 'sound/magic/repulse.ogg', 80, TRUE)
	for(var/turf/T in view(push_range, src))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == src || AM.anchored)
			continue

		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue

		throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(AM, src)))
		distfromflag = get_dist(src, AM)
		if(distfromflag == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(10)
				M.adjustBruteLoss(20)
				to_chat(M, "<span class='danger'>You're slammed into the floor by Ravox's strength!!</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(src, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(5)
				to_chat(M, "<span class='danger'>You're thrown back by Ravox's strength!!</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromflag - 2, 0, distfromflag))), 3, maxthrow))), 1, null, force = repulse_force)

/obj/structure/fluff/ravox/challenger/recall/Initialize()
	. = ..()
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), 3 MINUTES)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), 179 SECONDS)

/obj/structure/fluff/ravox/challenged/recall/Initialize()
	. = ..()
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), 3 MINUTES)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), 179 SECONDS)

//T0

/obj/effect/proc_holder/spell/self/TAbalance_immune
	name = "Strong Stance"
	desc = "Regain balance and become immune to any form of stun for the next 10 seconds."
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "balance_immune"
	recharge_time = 1 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/battletrance.ogg'
	invocations = list("I stand, by Ravox!")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/self/TAbalance_immune/cast(mob/living/user)
	if(!isliving(user))
		return FALSE
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	user.apply_status_effect(/datum/status_effect/TAbalance_immune)
	if(user.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		user.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	if(skill >= 2)
		if(!(user.mobility_flags & MOBILITY_STAND))
			user.SetUnconscious(0)
			user.SetSleeping(0)
			user.SetParalyzed(0)
			user.SetImmobilized(0)
			user.SetStun(0)
			user.SetKnockdown(0)
			user.set_resting(FALSE)
	if(skill >= 3)
		user.apply_status_effect(/datum/status_effect/buff/order/onfeet)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/TAbalance_immune
	name = "Strong Stance"
	desc = "I stand firm for Ravox."
	icon = 'icons/mob/actions/ravoxmiracles.dmi'
	icon_state = "balance_immune"

/datum/status_effect/TAbalance_immune
	id = "balance_immune"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/TAbalance_immune
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

//T0

/obj/effect/proc_holder/spell/self/TAprovocation
	name = "Provocation"
	desc = "Forces hostile creatures around to target you."
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "provocation"
	recharge_time = 1 MINUTES
	movement_interrupt = FALSE
	chargedrain = 0
	chargetime = 1 SECONDS
	charging_slowdown = 2
	chargedloop = null
	associated_skill = /datum/skill/magic/holy
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/battletrance.ogg'
	invocations = list("By Ravox, come to me!")
	invocation_type = "shout"
	antimagic_allowed = TRUE
	miracle = TRUE
	devotion_cost = 30

/obj/effect/proc_holder/spell/self/TAprovocation/cast(mob/living/user)
	if(!isliving(user))
		return FALSE
	var/checkgate = FALSE
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	var/dist = (3 + skill)
	for(var/mob/living/mob in view(dist, get_turf(user)))
		if(!mob.mind && mob.ai_controller)
			mob.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, user)
			mob.ai_controller.set_blackboard_key(BB_HIGHEST_THREAT_MOB, user)
			var/datum/component/ai_aggro_system/aggro = mob.GetComponent(/datum/component/ai_aggro_system)
			if(aggro)
				aggro.add_threat_to_mob(user, 50)
			checkgate = TRUE
	if(checkgate == TRUE)
		user.apply_status_effect(/datum/status_effect/buff/TAravox_provocation, skill)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/TAravox_provocation
	name = "Provocation"
	desc = "All hostile creatures are targeting me! For Ravox!"
	icon = 'icons/mob/actions/ravoxmiracles.dmi'
	icon_state = "provocation"

/datum/status_effect/buff/TAravox_provocation
	id = "ravox_provocation"
	alert_type = /atom/movable/screen/alert/status_effect/buff/TAravox_provocation
	duration = 10 SECONDS

/datum/status_effect/buff/TAravox_provocation/on_creation(mob/living/new_owner, assocskill)
	var/con_bonus = 0
	if(assocskill)
		if(assocskill == 1)
			duration = duration
		else
			duration *= assocskill - 1
		con_bonus = assocskill - 1
	if(con_bonus > 0)
		effectedstats = list(STATKEY_CON = con_bonus, STATKEY_WIL = con_bonus)
	. = ..()

#define RAVOX_SIMPLE "SIMPLE"
#define RAVOX_CARBON "CARBON"

/datum/action/cooldown/spell/ravox/TAraise_warrior_spirits
	name = "Warrior Spirits"
	desc = "Tear out part of your spirit, and manifest it into a spectral warrior! Toggle spell mode, to choise - One Carbon Warrior or Three Siple Spirits"
	button_icon_state = "warriors"
	sound = 'sound/magic/magnet.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("Ravox calls upon you once more!")

	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/spell_mode = RAVOX_SIMPLE
	var/list/spell_modes = list(RAVOX_SIMPLE, RAVOX_CARBON)
	var/static/list/spell_mode_labels = list(RAVOX_SIMPLE = "SIMPLE", RAVOX_CARBON = "CARBON")

/datum/action/cooldown/spell/ravox/TAraise_warrior_spirits/cast(atom/cast_on)
	. = ..()

	var/mob/living/carbon/human/user = owner
	if(!istype(user))
		return FALSE

	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		return FALSE

	if(!("[user.mind.current.real_name]_faction" in user.faction))
		user.faction |= "[user.mind.current.real_name]_faction"

	if(!locate(/datum/action/cooldown/spell/gravemark) in user.mind?.spell_list)
		user.mind?.AddSpell(new /datum/action/cooldown/spell/gravemark/no_sprite)

	if(!locate(/datum/action/cooldown/spell/minion_order) in user.mind?.spell_list) 
		user.mind?.AddSpell(new /datum/action/cooldown/spell/minion_order)

	var/spirit_type = get_spirit_type()
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	var/time = 1 MINUTES
	time *= skill

	var/turf/spawn_turf = get_step(user, user.dir)

	if(!spawn_turf)
		spawn_turf = get_turf(user)

	if(isliving(cast_on))
		var/mob/living/target = cast_on
		if(spirit_type == "carbon")
			new /mob/living/carbon/human/species/human/northern/ravox_spirit(spawn_turf, user)
			for(var/mob/living/carbon/human/species/human/northern/ravox_spirit/swarm in view(6, user))
				swarm.faction |= list("ravox_spirit", "[user.mind.current.real_name]_faction")
				swarm.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
				swarm.ai_controller.set_blackboard_key(BB_MAIN_TARGET, target)
				swarm.ai_controller.insert_blackboard_key_lazylist(BB_BASIC_MOB_RETALIATE_LIST, target)
				swarm.visible_message(span_notice("A [swarm] manifests following after [target]... !"))
				if(swarm.buffed_r == FALSE)
					addtimer(CALLBACK(swarm, TYPE_PROC_REF(/mob/living/simple_animal/hostile/rogue/skeleton, deathtime), TRUE), time)
					swarm.buffed_r = TRUE
					swarm.name = "[user.real_name]'s Spirit"
			return TRUE
		if(spirit_type == "simple")
			if(user.dir == SOUTH || user.dir == NORTH)
				new /mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/spear(spawn_turf, user)
				new /mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/axe(get_step(spawn_turf, EAST),user)
				new /mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/sword(get_step(spawn_turf, WEST),user)
			else
				new /mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/spear(spawn_turf,user)
				new /mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/axe(get_step(spawn_turf, NORTH),user)
				new /mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/sword(get_step(spawn_turf, SOUTH),user)
			for(var/mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/swarm in view(6, user))
				swarm.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target) 
				if(swarm.buffed_r == FALSE)
					swarm.maxHealth *= skill
					swarm.health *= skill
					addtimer(CALLBACK(swarm, TYPE_PROC_REF(/mob/living/simple_animal/hostile/rogue/skeleton, deathtime), TRUE), time)
					swarm.buffed_r = TRUE
			return TRUE
	return FALSE


/datum/action/cooldown/spell/ravox/TAraise_warrior_spirits/proc/get_spirit_type()
	switch(spell_mode)
		if(RAVOX_SIMPLE)
			return "simple"
		if(RAVOX_CARBON)
			return "carbon"
	return null

/datum/action/cooldown/spell/ravox/TAraise_warrior_spirits/toggle_alt_mode(mob/user)
	var/current_index = spell_modes.Find(spell_mode)
	current_index = (current_index % length(spell_modes)) + 1
	spell_mode = spell_modes[current_index]
	var/label = spell_mode_labels[spell_mode] || uppertext(spell_mode)
	to_chat(user, span_notice("Spell mode set to: [label]."))
	return TRUE

/mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost
	name = "Ravoxian Soul"
	desc = "A portion of a Ravoxian's soul. Kill it to damage and stun them. Metal."
	icon = 'icons/roguetown/mob/monster/ravoxghost.dmi'
	icon_state = "rghost"
	icon_living = "rghost"
	STACON = 10
	STASTR = 10
	STASPD = 8
	maxHealth = 60 //summoned with 60 + 10 hp per skill lvl
	health = 50
	pixel_x = -16
	pixel_y = -16
	harm_intent_damage = 10
	melee_damage_lower = 25
	melee_damage_upper = 30
	icon_dead = ""
	loot = list(/obj/item/ash,	/obj/item/ash)
	can_have_ai = FALSE //disable native ai
	AIStatus = AI_OFF
	var/buffed_r = FALSE

/mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/Initialize(mapload, mob/user, cabal_affine = FALSE, is_summoned = FALSE)
	. = ..(mapload, user, cabal_affine, is_summoned)

/mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/spear
	icon_state = "rghost_s"
	icon_living = "rghost_s"
	attack_sound = 'sound/foley/pierce.ogg'
	base_intents = list(/datum/intent/simple/spear/skeleton)
	ai_controller = /datum/ai_controller/skeleton_spear

/mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/axe
	icon_state = "rghost_a"
	icon_living = "rghost_a"
	base_intents = list(/datum/intent/simple/axe/skeleton)

/mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/sword
	icon_state = "rghost_sw"
	icon_living = "rghost_sw"
	base_intents = list(/datum/intent/simple/axe/skeleton)

/mob/living/simple_animal/hostile/rogue/skeleton/ravox_ghost/get_sound(input)
	switch(input)
		if("laugh")
			return pick('sound/vo/mobs/ghost/laugh (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg','sound/vo/mobs/ghost/laugh (4).ogg','sound/vo/mobs/ghost/laugh (5).ogg','sound/vo/mobs/ghost/laugh (6).ogg')
		if("moan")
			return pick('sound/vo/mobs/ghost/moan (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg')
		if("death")
			return 'sound/vo/mobs/ghost/death.ogg'
		if("whisper")
			return pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg')
		if("aggro")
			return pick('sound/vo/mobs/ghost/aggro (1).ogg','sound/vo/mobs/ghost/aggro (2).ogg','sound/vo/mobs/ghost/aggro (3).ogg','sound/vo/mobs/ghost/aggro (4).ogg','sound/vo/mobs/ghost/aggro (5).ogg','sound/vo/mobs/ghost/aggro (6).ogg')

/obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/TAravoxgrasp
	name = "Ravox Grasp"
	desc = "Summon the sacred light from your soul and let it envelop your hands."
	clothes_req = FALSE
	drawmessage = "I prepare to perform a miracle incantation."
	dropmessage = "I release my miracle focus."
	overlay_state = "justice_hand"
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	chargedrain = 0
	chargetime = 0
	releasedrain = 5 // this influences -every- cost involved in the spell's functionality, if you want to edit specific features, do so in handle_cost
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/rogueweapon/TAravoxgrasp
	devotion_cost = 30
	miracle = TRUE

/obj/item/melee/touch_attack/rogueweapon/TAravoxgrasp
	name = "Justice Hand"
	desc = "The Sacred Light of Ravox. \n\
	click on self to remove it."
	icon = 'icons/roguetown/misc/miraclestuff.dmi'
	mob_overlay_icon = 'icons/roguetown/misc/miraclestuff.dmi'
	lefthand_file = 'icons/roguetown/misc/miraclestuff.dmi'
	righthand_file = 'icons/roguetown/misc/miraclestuff.dmi'
	icon_state = "justicei"
	item_state = "justicei"
	possible_item_intents = list(/datum/intent/use)
	parrysound = list('sound/magic/magic_nulled.ogg')
	swingsound = list('sound/magic/churn.ogg')
	attached_spell = /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/TAravoxgrasp
	wbalance = WBALANCE_HEAVY
	force = 0
	damtype = BURN
	wdefense = 7
	associated_skill = /datum/skill/magic/holy //EHEHEHEHEHEH
	can_parry = TRUE

/obj/item/melee/touch_attack/rogueweapon/TAravoxgrasp/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(skillcheck), src), wait = 1)
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/melee/touch_attack/rogueweapon/TAravoxgrasp/attack(mob/target, mob/living/carbon/user)
	if(!iscarbon(user)) //Look ma, no hands
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, "<span class='warning'>I can't reach out!</span>")
		return
	..()

/obj/item/melee/touch_attack/rogueweapon/TAravoxgrasp/proc/skillcheck()
	var/skill = usr.get_skill_level(/datum/skill/magic/holy)
	wdefense_dynamic += skill
	wdefense += skill

/obj/item/melee/touch_attack/rogueweapon/TAravoxgrasp/afterattack(atom/target, mob/living/carbon/user, params, proximity)
	if(isobj(target))
		var/obj/item/O = target
		var/mob/living/carbon/human/H = usr
		var/cost = 0
		var/dist = get_dist(O, user)
		if(dist > 1)
			return
		if(istype(O, /obj/item/natural/head) || istype(O, /obj/item/bodypart/head))
			if(O.sellprice > 0)
				cost = 100
		if(cost >= 100)
			H.devotion?.update_devotion(cost)
			to_chat(user, "<font color='purple'>I gain [cost] devotion!</font>")
			qdel(O)
		return
	return

/obj/item/melee/touch_attack/rogueweapon/TAravoxgrasp/pre_attack(atom/target, mob/living/user, params)
	if(isliving(target))
		var/mob/living/L = target
		if(do_after(user, 1 SECONDS, target = L))
			wash_atom(target, 1)
			to_chat(user, span_notice("I render \the [target.name] clean."))
			return TRUE
	return ..()

