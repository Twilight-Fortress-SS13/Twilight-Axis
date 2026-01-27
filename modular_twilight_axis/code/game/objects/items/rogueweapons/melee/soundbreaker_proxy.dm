/obj/item/soundbreaker_proxy
	name = "soundbreaking strike"
	desc = ""
	icon = null
	w_class = 0
	force = 0
	damtype = BRUTE
	thrown_bclass = BCLASS_PUNCH
	armor_penetration = 0
	anchored = TRUE
	var/tmp/last_attack_success = FALSE
	var/tmp/mob/living/last_attack_target = null

/obj/item/soundbreaker_proxy/Initialize()
	. = ..()
	invisibility = 101
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

#define ATTACK_OVERRIDE_NODEFENSE 2

/obj/item/soundbreaker_proxy/attack(mob/living/M, mob/living/user)
	var/override_status
	last_attack_success = FALSE
	last_attack_target = null

	var/breaker = FALSE
	var/datum/status_effect/buff/soundbreaker_breaker_window/buff = user.has_status_effect(/datum/status_effect/buff/soundbreaker_breaker_window)
	if(buff)
		breaker = prob(buff.success_chance)

	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK, M, user) & COMPONENT_ITEM_NO_ATTACK)
		return FALSE

	var/_receiver_signal = SEND_SIGNAL(M, COMSIG_MOB_ITEM_BEING_ATTACKED, M, user, src)
	if(_receiver_signal & COMPONENT_ITEM_NO_ATTACK)
		return FALSE
	else if(_receiver_signal & COMPONENT_ITEM_NO_DEFENSE)
		override_status = ATTACK_OVERRIDE_NODEFENSE

	var/_attacker_signal = SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK, M, user, src)
	if(_attacker_signal & COMPONENT_ITEM_NO_ATTACK)
		return FALSE
	else if(_attacker_signal & COMPONENT_ITEM_NO_DEFENSE)
		override_status = ATTACK_OVERRIDE_NODEFENSE

	if(item_flags & NOBLUDGEON)
		return FALSE

	if(force && HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("I don't want to harm other living beings!"))
		return

	M.lastattacker = user.real_name
	M.lastattackerckey = user.ckey
	M.lastattacker_weakref = WEAKREF(user)
	if(M.mind)
		M.mind.attackedme[user.real_name] = world.time

	if(force)
		if(user.used_intent)
			if(!user.used_intent.noaa)
				playsound(get_turf(src), pick(swingsound), 100, FALSE, -1)
			if(user.used_intent.no_attack)
				return
	else
		return

	var/swingdelay = user.used_intent.swingdelay
	var/_swingdelay_mod = SEND_SIGNAL(src, COMSIG_LIVING_SWINGDELAY_MOD)
	if(_swingdelay_mod)
		swingdelay += _swingdelay_mod

	var/datum/intent/cached_intent = user.used_intent
	if(swingdelay)
		if(!user.used_intent.noaa && isnull(user.mind))
			if(get_dist(get_turf(user), get_turf(M)) <= user.used_intent.reach)
				user.do_attack_animation(M, user.used_intent.animname, user.used_intent.masteritem, used_intent = user.used_intent, simplified = TRUE)
		sleep(swingdelay)

	if(user.a_intent != cached_intent)
		return
	if(QDELETED(src) || QDELETED(M))
		return

	if(user.incapacitated())
		return

	if((M.mobility_flags & MOBILITY_STAND))
		if(!breaker && M.checkmiss(user))
			if(!swingdelay)
				if(get_dist(get_turf(user), get_turf(M)) <= user.used_intent.reach)
					user.do_attack_animation(M, user.used_intent.animname, used_item = src, used_intent = user.used_intent, simplified = TRUE)
			return

	_attacker_signal = null
	_attacker_signal = SEND_SIGNAL(user, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, M, user, src)
	if(_attacker_signal & COMPONENT_ITEM_NO_ATTACK)
		return FALSE
	else if(_attacker_signal & COMPONENT_ITEM_NO_DEFENSE)
		override_status = ATTACK_OVERRIDE_NODEFENSE

	if(!breaker && override_status != ATTACK_OVERRIDE_NODEFENSE)
		if(M.checkdefense(user.used_intent, user))
			return

	SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SUCCESS, M, user)
	SEND_SIGNAL(M, COMSIG_ITEM_ATTACKED_SUCCESS, src, user)

	var/sb_zone = user.zone_selected

	if(sb_zone == BODY_ZONE_PRECISE_R_INHAND)
		var/offh = 0
		var/obj/item/W = M.held_items[1]
		if(W)
			if(!(M.mobility_flags & MOBILITY_STAND))
				M.throw_item(get_step(M, turn(M.dir, 90)), offhand = offh)
			else
				M.dropItemToGround(W)
			M.visible_message(span_notice("[user] disarms [M]!"), \
							span_boldwarning("I'm disarmed by [user]!"))
			return

	if(sb_zone == BODY_ZONE_PRECISE_L_INHAND)
		var/offh = 0
		var/obj/item/W = M.held_items[2]
		if(W)
			if(!(M.mobility_flags & MOBILITY_STAND))
				M.throw_item(get_step(M, turn(M.dir, 270)), offhand = offh)
			else
				M.dropItemToGround(W)
			M.visible_message(span_notice("[user] disarms [M]!"), \
							span_boldwarning("I'm disarmed by [user]!"))
			return

	var/selzone = accuracy_check(sb_zone, user, M, /datum/skill/combat/unarmed, user.used_intent)
	if(!isliving(M))
		return FALSE

	var/mob/living/L = M
	var/hit_zone = check_zone(selzone) || BODY_ZONE_CHEST

	if(!iscarbon(L))
		last_attack_success = FALSE
		last_attack_target = L

		var/nodmg = FALSE

		var/success = !!L.attacked_by(src, user)
		if(!success)
			nodmg = TRUE

		SEND_SIGNAL(L, COMSIG_ATOM_ATTACK_HAND, user)

		last_attack_success = success
		if(user?.used_intent)
			if(!nodmg)
				if(user.used_intent.hitsound)
					playsound(L.loc, user.used_intent.hitsound, 100, FALSE, -1)
			else
				playsound(L.loc, "nodmg", 100, FALSE, -1)

		return success

	var/mob/living/carbon/C = L
	var/obj/item/bodypart/affecting = C.get_bodypart(hit_zone)
	if(!affecting)
		to_chat(user, span_warning("Unfortunately, there's nothing there."))
		return FALSE

	var/mob/living/carbon/human/target = C
	if(!target)
		return FALSE

	if(!target.lying_attack_check(user))
		return FALSE

	if(target.has_status_effect(/datum/status_effect/buff/clash) && target.get_active_held_item() && ishuman(user))
		var/obj/item/IM = target.get_active_held_item()
		target.process_clash(user, IM)
		return FALSE

	var/attack_flag = "blunt"
	switch(thrown_bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PUNCH)
			attack_flag = "blunt"
		if(BCLASS_CHOP, BCLASS_CUT, BCLASS_LASHING, BCLASS_PUNISH)
			attack_flag = "slash"
		if(BCLASS_PICK, BCLASS_STAB, BCLASS_PIERCE)
			attack_flag = "stab"

	var/armor_block = target.run_armor_check(
		selzone,
		attack_flag,
		armor_penetration = armor_penetration,
		blade_dulling = user.used_intent?.blade_class,
		damage = force_dynamic,
		intdamfactor = user.used_intent?.intent_intdamage_factor
	)

	target.next_attack_msg.Cut()
	var/nodmg = FALSE
	if(!target.apply_damage(force_dynamic, damtype, affecting, armor_block))
		nodmg = TRUE
		target.next_attack_msg += VISMSG_ARMOR_BLOCKED
	else
		affecting.bodypart_attacked_by(
			thrown_bclass,
			force_dynamic,
			user,
			selzone,
			crit_message = TRUE,
			armor = armor_block,
			weapon = src
		)

		SEND_SIGNAL(target, COMSIG_ATOM_ATTACK_HAND, user)
		if(affecting.body_zone == BODY_ZONE_HEAD)
			SEND_SIGNAL(user, COMSIG_HEAD_PUNCHED, target)

	target.send_item_attack_message(src, user, selzone)

	target.next_attack_msg.Cut()
	target.retaliate(user)

	last_attack_target = target
	last_attack_success = TRUE

	if(user?.used_intent)
		if(!nodmg)
			if(user.used_intent.hitsound)
				playsound(target.loc, user.used_intent.hitsound, 100, FALSE, -1)
		else
			playsound(target.loc, "nodmg", 100, FALSE, -1)

	return last_attack_success
