// ==========================================================
// FIRE RUNES + RELATED STATUS EFFECTS
// ==========================================================

/datum/status_effect/debuff/rune_silence
	id = "rune_silence"
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/debuff/rune_silence/on_creation(mob/living/new_owner, custom_duration = 5 SECONDS)
	duration = custom_duration
	return ..()

/datum/status_effect/debuff/rune_silence/on_apply()
	. = ..()
	if(owner)
		ADD_TRAIT(owner, TRAIT_MUTE, id)

/datum/status_effect/debuff/rune_silence/on_remove()
	. = ..()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_MUTE, id)


/datum/status_effect/debuff/rune_accuracy_down
	id = "rune_accuracy_down"
	duration = 4 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	effectedstats = list(STATKEY_PER = 1)

/datum/status_effect/debuff/rune_accuracy_down/on_creation(mob/living/new_owner, custom_duration = 4 SECONDS)
	duration = custom_duration
	return ..()


/datum/status_effect/buff/rune_hypothermia_resist
	id = "rune_hypothermia_resist"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null

/datum/status_effect/buff/rune_hypothermia_resist/on_apply()
	. = ..()
	if(owner)
		owner.change_stat(STATKEY_CON, 1)
	return TRUE

/datum/status_effect/buff/rune_hypothermia_resist/on_remove()
	if(owner)
		owner.change_stat(STATKEY_CON, -1)
	. = ..()


// ==========================================================
// FIRE RUNES
// ==========================================================

#define FORGE_REPAIR_INTERVAL 60 SECONDS
/datum/rune/fire
	element = RUNE_ELEMENT_FIRE
	color = "#ff6a00"

/datum/rune/fire/proc/get_living_target(atom/target)
	if(!isliving(target))
		return null
	return target


/datum/rune/fire/ignition
	id = "fire_ignition"
	name = "Возгорание"
	desc = "Шанс нанести ожоговый урон на цель."
	color = "#ff5a1f"
	cooldown = 20 SECONDS
	proc_chance = 15
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/rogueore/coal = 1,
		/obj/item/natural/thorn = 1
	)

/datum/rune/fire/ignition/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.adjustFireLoss(scale_amount(6))


/datum/rune/fire/ash
	id = "fire_ash"
	name = "Пепел"
	desc = "Шанс наложить немоту."
	color = "#c96a4c"
	cooldown = 25 SECONDS
	proc_chance = 20 
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/rogueore/coal = 1,
		/obj/item/natural/bone = 1
	)

/datum/rune/fire/ash/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.apply_status_effect(/datum/status_effect/debuff/rune_silence, scale_duration(5 SECONDS, applied))

#define FORGE_RUNE_REPAIR_PERCENT 5

/datum/rune/fire/forge
	id = "fire_forge"
	name = "Горн"
	desc = "Клинок медленно восстанавливает прочность."
	color = "#ff8c2e"
	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE
	can_stack = FALSE
	carve_ingredients = list(
		/obj/item/rogueore/coal = 1,
		/obj/item/rogueore/iron = 1
	)

/datum/rune/fire/forge/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon || !applied)
		return

	addtimer(CALLBACK(src, PROC_REF(_forge_tick), weapon, storage, applied), FORGE_REPAIR_INTERVAL)

/datum/rune/fire/forge/proc/_forge_tick(obj/item/weapon, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon || QDELETED(weapon) || !storage || !applied)
		return
	if(!(applied in storage.persistent_runes))
		return

	var/percent = (weapon.max_integrity / 100) * FORGE_RUNE_REPAIR_PERCENT
	if(weapon.obj_integrity < weapon.max_integrity)
		weapon.obj_integrity = min(weapon.obj_integrity + percent, weapon.max_integrity)

	addtimer(CALLBACK(src, PROC_REF(_forge_tick), weapon, storage, applied), 60 SECONDS)

#undef FORGE_RUNE_REPAIR_PERCENT

/datum/rune/fire/brand
	id = "fire_brand"
	name = "Клеймо"
	desc = "Удар по раненой цели усиливает боль и снижает точность."
	color = "#e3482b"
	cooldown = 25 SECONDS
	proc_chance = 15
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/natural/thorn = 1,
		/obj/item/rogueore/coal = 1
	)

/datum/rune/fire/brand/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	if(L.health >= L.maxHealth)
		return

	L.apply_status_effect(/datum/status_effect/debuff/rune_accuracy_down, scale_duration(4 SECONDS, applied))
	L.OffBalance(scale_duration(1 SECONDS, applied))


/datum/rune/fire/melting
	id = "fire_melting"
	name = "Плавление"
	desc = "Урон по броне наносит ей дополнительный урон."
	color = "#ff7f50"
	cooldown = 30 SECONDS
	proc_chance = 20
	is_persistent = FALSE
	carve_ingredients = list(
		/obj/item/rogueore/coal = 1,
		/obj/item/rogueore/copper = 1
	)

/datum/rune/fire/melting/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!ishuman(target) || !user)
		return

	var/mob/living/carbon/human/H = target
	var/hit_zone = user.zone_selected || BODY_ZONE_CHEST
	var/cover_flag

	switch(hit_zone)
		if(BODY_ZONE_HEAD)
			cover_flag = HEAD
		if(BODY_ZONE_CHEST)
			cover_flag = CHEST
		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			cover_flag = ARMS
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			cover_flag = LEGS
		else
			cover_flag = CHEST

	for(var/obj/item/clothing/C in H.contents)
		if(C.loc != H)
			continue
		if(!(C.body_parts_covered & cover_flag))
			continue
		if(!C.armor)
			continue

		C.take_damage(scale_amount(5), BRUTE, "fire")
		break


/datum/rune/fire/bonfire
	id = "fire_bonfire"
	name = "Костёр"
	desc = "Владелец получает сопротивление гипотермии, но клинок быстрее изнашивается."
	color = "#ffb347"
	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE
	can_stack = FALSE
	carve_ingredients = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/rogueore/coal = 1
	)

/datum/rune/fire/bonfire/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.apply_status_effect(/datum/status_effect/buff/rune_hypothermia_resist)

/datum/rune/fire/bonfire/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.remove_status_effect(/datum/status_effect/buff/rune_hypothermia_resist)

/datum/rune/fire/bonfire/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon)
		return

	weapon.take_damage(scale_amount(1), BRUTE, "blunt")

#undef FORGE_REPAIR_INTERVAL
