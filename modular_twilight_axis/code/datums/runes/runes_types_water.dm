/datum/rune/water
	element = RUNE_ELEMENT_WATER
	color = "#6ecbff"

/datum/rune/water/proc/get_living_target(atom/target)
	if(!isliving(target))
		return null
	return target

/datum/rune/water/rime
	id = "water_rime"
	name = "Иней"
	desc = "Накладывает замедление на цель."
	cooldown = 20
	proc_chance = 35
	is_persistent = FALSE

/datum/rune/water/rime/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.apply_status_effect(/datum/status_effect/debuff/vampiric_slowdown)

/datum/rune/water/drizzle
	id = "water_drizzle"
	name = "Морось"
	desc = "Снижает выносливость цели."
	cooldown = 20
	proc_chance = 40
	is_persistent = FALSE

/datum/rune/water/drizzle/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.adjustStaminaLoss(12)

/datum/rune/water/tide
	id = "water_tide"
	name = "Прилив"
	desc = "Повышает силу воли."
	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE

/datum/rune/water/tide/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.change_stat(STATKEY_WIL, 2)

/datum/rune/water/tide/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.change_stat(STATKEY_WIL, -2)

/datum/rune/water/depth
	id = "water_depth"
	name = "Глубина"
	desc = "Шанс нанести окси-урон цели."
	cooldown = 25
	proc_chance = 30
	is_persistent = FALSE

/datum/rune/water/depth/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.adjustOxyLoss(8)

/datum/rune/water/mist
	id = "water_mist"
	name = "Туман"
	desc = "Повышает скорость владельца."
	cooldown = 30
	proc_chance = 100
	is_persistent = TRUE

/datum/rune/water/mist/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.change_stat(STATKEY_SPD, 2)

/datum/rune/water/mist/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.change_stat(STATKEY_SPD, -2)

/datum/rune/water/ice
	id = "water_ice"
	name = "Лёд"
	desc = "Накладывает стак гипотермии."
	cooldown = 20
	proc_chance = 35
	is_persistent = FALSE

/datum/rune/water/ice/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.apply_status_effect(/datum/status_effect/stacking/hypothermia, 1)
