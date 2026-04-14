// ==========================================================
// AIR RUNES + BUFFS
// ==========================================================

/datum/status_effect/buff/rune_attack_speed
	id = "rune_attack_speed"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null

/datum/status_effect/buff/rune_attack_speed/on_apply()
	. = ..()
	if(owner)
		owner.change_stat(STATKEY_SPD, 1)
	return TRUE

/datum/status_effect/buff/rune_attack_speed/on_remove()
	if(owner)
		owner.change_stat(STATKEY_SPD, -1)
	. = ..()


/datum/status_effect/buff/rune_echo
	id = "rune_echo"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/proc_bonus = 25


/datum/rune/air
	element = RUNE_ELEMENT_AIR
	color = "#d9f0ff"

/datum/rune/air/proc/get_living_target(atom/target)
	if(!isliving(target))
		return null
	return target


/datum/rune/air/wind
	id = "air_wind"
	name = "Ветер"
	desc = "Ускоряет атаки владельца."
	color = "#f0fbff"
	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE
	can_stack = FALSE
	carve_ingredients = list(
		/obj/item/natural/feather = 1,
		/obj/item/natural/fibers = 1
	)

/datum/rune/air/wind/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.apply_status_effect(/datum/status_effect/buff/rune_attack_speed)

/datum/rune/air/wind/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.remove_status_effect(/datum/status_effect/buff/rune_attack_speed)


/datum/rune/air/gust
	id = "air_gust"
	name = "Порыв"
	desc = "Шанс оттолкнуть цель."
	color = "#cfeeff"
	cooldown = 45 SECONDS
	proc_chance = 20
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/natural/feather = 1,
		/obj/item/natural/thorn = 1
	)

/datum/rune/air/gust/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!user || !isliving(target))
		return

	var/mob/living/L = target
	var/dir_to_push = get_dir(user, L)

	var/dist = scale_amount(1, applied)

	var/turf/start = get_turf(L)
	var/turf/dest = get_ranged_target_turf(start, dir_to_push, dist)

	if(dest)
		L.safe_throw_at(dest, dist, 1, user, force = MOVE_FORCE_STRONG)


/datum/rune/air/thunder
	id = "air_thunder"
	name = "Гром"
	desc = "Наносит shock."
	color = "#a9d7ff"
	cooldown = 30 SECONDS
	proc_chance = 15
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/rogueore/copper = 1,
		/obj/item/natural/feather = 1
	)

/datum/rune/air/thunder/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.adjustStaminaLoss(scale_amount(18))
	L.OffBalance(scale_duration(1 SECONDS))


/datum/rune/air/thinning
	id = "air_thinning"
	name = "Разрежение"
	desc = "Наносит окси-урон на цель."
	color = "#bfe6f5"
	cooldown = 25 SECONDS
	proc_chance = 10
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/natural/feather = 1,
		/obj/item/natural/bone = 1
	)

/datum/rune/air/thinning/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.adjustOxyLoss(scale_amount(8))


/datum/rune/air/echo
	id = "air_echo"
	name = "Эхо"
	desc = "Повышает шанс срабатывания следующей руны."
	color = "#ddefff"
	cooldown = 30 SECONDS
	proc_chance = 100
	is_persistent = TRUE
	can_stack = FALSE
	carve_ingredients = list(
		/obj/item/natural/bowstring = 1,
		/obj/item/natural/feather = 1
	)

/datum/rune/air/echo/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.apply_status_effect(/datum/status_effect/buff/rune_echo)

/datum/rune/air/echo/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.remove_status_effect(/datum/status_effect/buff/rune_echo)

/datum/rune/air/echo/can_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon || !storage || !applied)
		return FALSE

	if(applied.next_trigger_time > world.time)
		return FALSE

	var/chance_to_roll = proc_chance

	var/datum/status_effect/buff/rune_echo/E = user?.has_status_effect(/datum/status_effect/buff/rune_echo)
	if(E)
		chance_to_roll = min(chance_to_roll + E.proc_bonus, 100)
		user.remove_status_effect(/datum/status_effect/buff/rune_echo)

	if(chance_to_roll < 100 && !prob(chance_to_roll))
		return FALSE

	return TRUE


/datum/rune/air/lightning
	id = "air_lightning"
	name = "Молния"
	desc = "Имеет шанс на иммобилизацию противника."
	color = "#8fc5ff"
	cooldown = 40 SECONDS
	proc_chance = 20
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/rogueore/copper = 1,
		/obj/item/natural/glass = 1
	)

/datum/rune/air/lightning/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.Immobilize(scale_duration(2 SECONDS, applied))
