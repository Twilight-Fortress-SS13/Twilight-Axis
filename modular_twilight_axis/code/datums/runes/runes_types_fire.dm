/datum/status_effect/debuff/rune_silence
	id = "rune_silence"
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

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
	effectedstats = list(STATKEY_ACC = -2)

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
	cooldown = 20
	proc_chance = 35
	is_persistent = FALSE

/datum/rune/fire/ignition/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.adjustFireLoss(6)

/datum/rune/fire/ash
	id = "fire_ash"
	name = "Пепел"
	desc = "Шанс наложить немоту."
	cooldown = 25
	proc_chance = 20
	is_persistent = FALSE

/datum/rune/fire/ash/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	L.apply_status_effect(/datum/status_effect/debuff/rune_silence)

/datum/rune/fire/forge
	id = "fire_forge"
	name = "Горн"
	desc = "Клинок медленно восстанавливает прочность."
	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE

/datum/rune/fire/forge/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon || !applied)
		return

	addtimer(CALLBACK(src, PROC_REF(_forge_tick), weapon, storage, applied), 60 SECONDS)

/datum/rune/fire/forge/proc/_forge_tick(obj/item/weapon, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon || QDELETED(weapon) || !storage || !applied)
		return
	if(!(applied in storage.persistent_runes))
		return

	if(weapon.obj_integrity < weapon.max_integrity)
		weapon.obj_integrity = min(weapon.obj_integrity + 1, weapon.max_integrity)

	addtimer(CALLBACK(src, PROC_REF(_forge_tick), weapon, storage, applied), 60 SECONDS)

/datum/rune/fire/brand
	id = "fire_brand"
	name = "Клеймо"
	desc = "Удар по раненой цели усиливает боль и кратко снижает её точность."
	cooldown = 25
	proc_chance = 35
	is_persistent = FALSE

/datum/rune/fire/brand/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	var/mob/living/L = get_living_target(target)
	if(!L)
		return

	if(L.health >= L.maxHealth)
		return

	L.apply_status_effect(/datum/status_effect/debuff/rune_accuracy_down)
	L.OffBalance(1 SECONDS)

/datum/rune/fire/melting
	id = "fire_melting"
	name = "Плавление"
	desc = "Урон по броне наносит ей дополнительный урон."
	cooldown = 30
	proc_chance = 40
	is_persistent = FALSE

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

		C.take_damage(5, BRUTE, "fire")
		break

/datum/rune/fire/bonfire
	id = "fire_bonfire"
	name = "Костёр"
	desc = "Владелец получает сопротивление гипотермии, но клинок быстрее изнашивается."
	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE

/datum/rune/fire/bonfire/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.apply_status_effect(/datum/status_effect/buff/rune_hypothermia_resist)

/datum/rune/fire/bonfire/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(user)
		user.remove_status_effect(/datum/status_effect/buff/rune_hypothermia_resist)

/datum/rune/fire/bonfire/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon)
		return

	weapon.take_damage(1, BRUTE, "blunt")
