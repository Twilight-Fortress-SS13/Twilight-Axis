/datum/component/mounted_combat
	var/charge_cooldown = 4
	var/next_charge_strike = 0
	var/slowdown_until = 0
	var/current_step_delay = 6
	var/charge_tiles = 0
	var/last_move_dir = 0
	var/last_step_time = 0

/datum/component/mounted_combat/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_mount_step))
	RegisterSignal(parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_mount_dir_change))

/datum/component/mounted_combat/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_MOVABLE_MOVED, COMSIG_ATOM_DIR_CHANGE))
	return ..()


/datum/component/mounted_combat/proc/on_mount_dir_change(atom/source, old_dir, new_dir)
	SIGNAL_HANDLER
	if(old_dir != new_dir)
		charge_tiles = 0
		last_move_dir = 0


/datum/component/mounted_combat/proc/on_mount_step(atom/movable/AM, turf/old_loc, move_dir, forced)
	SIGNAL_HANDLER

	var/mob/living/mount = parent
	if(!length(mount.buckled_mobs) || !old_loc || !mount.loc)
		charge_tiles = 0
		return

	var/mob/living/carbon/human/rider = mount.buckled_mobs[1]
	if(!istype(rider) || rider.stat != CONSCIOUS)
		charge_tiles = 0
		return

	var/actual_move_dir = get_dir(old_loc, mount.loc)

	if(world.time > last_step_time + 1 SECONDS)
		charge_tiles = 0

	last_step_time = world.time

	if(rider.m_intent == MOVE_INTENT_RUN)
		if(actual_move_dir != mount.dir)
			charge_tiles = 0
			last_move_dir = 0
		else
			if(last_move_dir == actual_move_dir)
				charge_tiles++
			else
				charge_tiles = 1
			last_move_dir = actual_move_dir
	else
		charge_tiles = 0
		last_move_dir = 0


	if(world.time < slowdown_until)
		if(rider.client)
			rider.client.move_delay = max(rider.client.move_delay, world.time + current_step_delay)
		var/datum/component/riding/riding_datum = mount.GetComponent(/datum/component/riding)
		if(riding_datum)
			riding_datum.vehicle_move_delay = max(riding_datum.vehicle_move_delay, current_step_delay)

	if(!rider.cmode || rider.m_intent != MOVE_INTENT_RUN)
		return

	if(world.time < rider.next_move || world.time < next_charge_strike)
		return


	var/obj/item/active_weapon = rider.get_active_held_item()
	if(!active_weapon || !is_valid_weapon(active_weapon))
		return


	if(active_weapon.wielded)
		var/turf/front_turf = get_step(mount, mount.dir)
		var/mob/living/front_target = find_charge_target(front_turf, mount)
		if(front_target)
			next_charge_strike = world.time + charge_cooldown
			INVOKE_ASYNC(src, PROC_REF(perform_mounted_strike), rider, active_weapon, front_target, "front", charge_tiles)
			charge_tiles = 0
		return


	var/is_right_hand = (rider.active_hand_index == 2)

	if(is_right_hand)
		var/right_dir = turn(mount.dir, -90)
		var/turf/right_turf = get_step(mount, right_dir)
		var/mob/living/right_target = find_charge_target(right_turf, mount)
		if(right_target)
			next_charge_strike = world.time + charge_cooldown
			INVOKE_ASYNC(src, PROC_REF(perform_mounted_strike), rider, active_weapon, right_target, "right", charge_tiles)
			return
	else
		var/left_dir = turn(mount.dir, 90)
		var/turf/left_turf = get_step(mount, left_dir)
		var/mob/living/left_target = find_charge_target(left_turf, mount)
		if(left_target)
			next_charge_strike = world.time + charge_cooldown
			INVOKE_ASYNC(src, PROC_REF(perform_mounted_strike), rider, active_weapon, left_target, "left", charge_tiles)
			return


/datum/component/mounted_combat/proc/find_charge_target(turf/T, mob/living/mount)
	if(!T)
		return null
	for(var/mob/living/L in T)
		if(L == mount || (L in mount.buckled_mobs))
			continue
		if(L.stat == DEAD)
			continue
		if(L.lying || L.resting || !(L.mobility_flags & MOBILITY_STAND))
			continue
		return L
	return null


/datum/component/mounted_combat/proc/is_valid_weapon(obj/item/W)
	if(!W || W.force_dynamic <= 5)
		return FALSE
	if(istype(W, /obj/item/rogueweapon/shield))
		return FALSE
	if(istype(W, /obj/item/rogueweapon/huntingknife))
		return FALSE
	if(W.associated_skill == /datum/skill/combat/knives)
		return FALSE
	if(W.wlength <= WLENGTH_SHORT && !W.reach)
		return FALSE
	return TRUE

/datum/component/mounted_combat/proc/perform_mounted_strike(mob/living/carbon/human/rider, obj/item/W, mob/living/target, flank, current_runup = 0)
	if(QDELETED(rider) || QDELETED(W) || QDELETED(target))
		return

	var/mob/living/mount = parent
	var/ride_skill = rider.get_skill_level(/datum/skill/misc/riding)

	var/intent_swingdelay = 0
	if(rider.used_intent && rider.used_intent.swingdelay)
		intent_swingdelay = rider.used_intent.swingdelay

	var/total_slowdown = intent_swingdelay + 1 SECONDS

	if(flank == "front")
		current_step_delay = 8
	else
		current_step_delay = 6

	slowdown_until = world.time + total_slowdown

	if(rider.client)
		rider.client.move_delay = max(rider.client.move_delay, world.time + current_step_delay)
	var/datum/component/riding/riding_datum = mount.GetComponent(/datum/component/riding)
	if(riding_datum)
		riding_datum.vehicle_move_delay = max(riding_datum.vehicle_move_delay, current_step_delay)

	if(ride_skill < SKILL_LEVEL_JOURNEYMAN && prob(30 - (ride_skill * 10)))
		if(length(W.swingsound))
			playsound(get_turf(rider), pick(W.swingsound), 100, FALSE)
		target.visible_message(span_warning("[rider] sweeps past [target] on horseback, swinging [W] wildly and missing!"))
		rider.changeNext_move(CLICK_CD_RAPID)
		return

	var/knockdown_target = FALSE

	if(flank == "front")
		if(current_runup <= 3)
			rider.visible_message(span_warning("[rider] hits [target] with [W], but lacked the momentum to knock them down!"), \
								span_warning("I hit [target], but had no room to build up momentum!"))
		else
			var/self_points = round((rider.STACON + rider.STASTR) / 2)
			var/target_points = round((target.STACON + target.STASTR) / 2)
			if(current_runup in 7 to 9)
				self_points += 1
			else if(current_runup >= 12)
				self_points += 7

			for(var/obj/item/I in target.get_held_items())
				if(istype(I, /obj/item/rogueweapon/shield))
					target_points += 2

			if(target.dir == get_dir(mount, target))
				self_points += 2

			self_points += rand(-3, 1)

			var/clash_deflected = FALSE
			if(target.has_status_effect(/datum/status_effect/buff/clash))
				target.remove_status_effect(/datum/status_effect/buff/clash)
				clash_deflected = TRUE
				to_chat(rider, span_warning("[target] braced themselves and deflected the charge!"))

			if(!clash_deflected && self_points > target_points)
				knockdown_target = TRUE

	switch(flank)
		if("front")
			if(istype(W, /obj/item/rogueweapon/spear))
				rider.visible_message(span_danger("<B>[rider] couches \the [W] and impales [target] in a devastating cavalry charge!</B>"), \
									span_danger("<B>I couch my [W] directly into [target] at full gallop!</B>"))
				playsound(get_turf(target), 'sound/combat/hits/bladed/genstab (3).ogg', 100, TRUE)
			else if(rider.used_intent?.blade_class == BCLASS_BLUNT || istype(W, /obj/item/rogueweapon/eaglebeak))
				rider.visible_message(span_danger("<B>[rider] charges forward, crushing [target] under the weight of \the [W]!</B>"), \
									span_danger("<B>I crush [target] with both hands at full gallop!</B>"))
				playsound(get_turf(target), 'sound/combat/hits/blunt/metalblunt (2).ogg', 100, TRUE)
			else
				rider.visible_message(span_danger("<B>[rider] charges forward with \the [W] held in both hands, cleaving [target]!</B>"), \
									span_danger("<B>I cleave [target] with both hands at full gallop!</B>"))
				playsound(get_turf(target), 'sound/combat/hits/bladed/genslash (2).ogg', 100, TRUE)

			if(knockdown_target)
				target.Knockdown(2)
				target.visible_message(span_danger("[target] is bowled over by the sheer momentum of the charge!"))
				playsound(get_turf(target), 'sound/combat/hits/blunt/metalblunt (2).ogg', 100, TRUE)

		if("right")
			rider.visible_message(span_danger("[rider] gallops past and strikes [target] on their right with \the [W]!"), \
								span_danger("I strike [target] on my right as I gallop past!"))
		if("left")
			rider.visible_message(span_danger("[rider] gallops past and strikes [target] on their left with \the [W]!"), \
								span_danger("I strike [target] on my left as I gallop past!"))


	var/target_dir = get_dir(mount, target)
	var/old_rider_dir = rider.dir

	if(target_dir && flank != "front")
		rider.setDir(target_dir)

	var/attack_anim = rider.used_intent?.animname || "chop"
	rider.do_attack_animation(target, attack_anim, W, simplified = TRUE)

	W.melee_attack_chain(rider, target, list())
	rider.stamina_add(4)

	if(target_dir && flank != "front")
		rider.setDir(old_rider_dir)

	var/intent_cd = CLICK_CD_MELEE
	if(rider.used_intent && rider.used_intent.clickcd)
		intent_cd = rider.used_intent.clickcd
	rider.changeNext_move(intent_cd)
