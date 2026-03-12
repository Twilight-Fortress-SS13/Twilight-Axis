// ==========================================================
// EARTH RUNES + DEBUFF
// ==========================================================

/datum/status_effect/debuff/rune_stagger
	id = "rune_stagger"
	duration = 2 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	effectedstats = list(STATKEY_SPD = -2, STATKEY_CON = -1)

/datum/status_effect/debuff/rune_stagger/on_creation(mob/living/new_owner, custom_duration = 2 SECONDS)
	duration = custom_duration
	return ..()

/datum/status_effect/debuff/rune_stagger/on_apply()
	. = ..()
	if(owner)
		owner.OffBalance(1 SECONDS)
		owner.Knockdown(10)
	return TRUE


/datum/rune/earth
	element = RUNE_ELEMENT_EARTH
	color = "#9b7b54"

/datum/rune/earth/proc/get_living_target(atom/target)
	if(!isliving(target))
		return null
	return target


/datum/rune/earth/stone
	id = "earth_stone"
	name = "Камень"
	desc = "Повышает выносливость."
	color = "#8a6f4d"
	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE
	can_stack = FALSE
	carve_ingredients = list(
		/obj/item/natural/stone = 1,
		/obj/item/natural/stoneblock = 1
	)

/datum/rune/earth/stone/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.change_stat(STATKEY_CON, 2)

/datum/rune/earth/stone/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.change_stat(STATKEY_CON, -2)


/datum/rune/earth/fracture
	id = "earth_fracture"
	name = "Разлом"
	desc = "Шанс наложить exposed."
	color = "#a3684f"
	cooldown = 25
	proc_chance = 35
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/natural/stone = 1,
		/obj/item/natural/thorn = 1
	)

/datum/rune/earth/fracture/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.apply_status_effect(/datum/status_effect/debuff/exposed)


/datum/rune/earth/gravel
	id = "earth_gravel"
	name = "Гравий"
	desc = "Снижает скорость движения цели."
	color = "#7b6a58"
	cooldown = 20
	proc_chance = 40
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/natural/dirtclod = 1,
		/obj/item/natural/stone = 1
	)

/datum/rune/earth/gravel/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.apply_status_effect(/datum/status_effect/debuff/vampiric_slowdown)


/datum/rune/earth/bedrock
	id = "earth_bedrock"
	name = "Порода"
	desc = "Повышает силу."
	color = "#6b5842"
	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE
	can_stack = FALSE
	carve_ingredients = list(
		/obj/item/natural/stoneblock = 1,
		/obj/item/rogueore/iron = 1
	)

/datum/rune/earth/bedrock/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.change_stat(STATKEY_STR, 2)

/datum/rune/earth/bedrock/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.change_stat(STATKEY_STR, -2)


/datum/rune/earth/geyser
	id = "earth_geyser"
	name = "Гейзер"
	desc = "Шанс нанести токсин-урон цели."
	color = "#b28b5c"
	cooldown = 25
	proc_chance = 30
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/natural/dirtclod = 1,
		/obj/item/reagent_containers/powder/salt = 1
	)

/datum/rune/earth/geyser/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.adjustToxLoss(scale_amount(8))


/datum/rune/earth/landslide
	id = "earth_landslide"
	name = "Оползень"
	desc = "Имеет шанс наложить стаггер."
	color = "#8c7355"
	cooldown = 30
	proc_chance = 25
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/natural/dirtclod = 1,
		/obj/item/natural/stone = 1
	)

/datum/rune/earth/landslide/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.apply_status_effect(/datum/status_effect/debuff/rune_stagger, scale_duration(2 SECONDS, applied))
