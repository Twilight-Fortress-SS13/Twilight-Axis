/datum/status_effect/buff/rune_fallen_volf
	id = "rune_fallen_volf"
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/buff/rune_fallen_volf/on_apply()
	. = ..()
	if(owner)
		owner.change_stat(STATKEY_STR, 2)
	return TRUE

/datum/status_effect/buff/rune_fallen_volf/on_remove()
	if(owner)
		owner.change_stat(STATKEY_STR, -2)
	. = ..()

/datum/status_effect/debuff/rune_apocalypse
	id = "rune_apocalypse"
	duration = 8 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	var/stat

/datum/status_effect/debuff/rune_apocalypse/on_creation(mob/living/new_owner)
	stat = pick(STATKEY_STR, STATKEY_CON, STATKEY_SPD, STATKEY_PER)
	return ..()

/datum/status_effect/debuff/rune_apocalypse/on_apply()
	. = ..()
	if(owner)
		owner.change_stat(stat, -1)
	return TRUE

/datum/status_effect/debuff/rune_apocalypse/on_remove()
	if(owner)
		owner.change_stat(stat, 1)
	. = ..()

/datum/rune/fire/fallen_volf
	id = "fire_fallen_volf"
	name = "Павший волк"
	desc = "При успешном ударе увеличивает силу."
	element = RUNE_ELEMENT_FIRE
	color = "#c0392b"

	cooldown = 35
	proc_chance = 20
	is_persistent = FALSE

	carve_ingredients = list(
		/obj/item/rogueore/iron = 1,
		/obj/item/rogueore/coal = 1
	)

/datum/rune/fire/fallen_volf/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!user)
		return

	user.apply_status_effect(/datum/status_effect/buff/rune_fallen_volf, scale_duration(10 SECONDS, applied))

/datum/rune/fire/spellflame
	id = "fire_spellflame"
	name = "Магическое пламя"
	desc = "Успешные удары могут объять пламенем вашего врага."
	element = RUNE_ELEMENT_FIRE
	color = "#ff7a3a"

	cooldown = 30
	proc_chance = 25
	is_persistent = FALSE

	carve_ingredients = list(
		/obj/item/rogueore/coal = 1,
		/obj/item/natural/thorn = 1
	)

/datum/rune/fire/spellflame/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!isliving(target))
		return

	var/mob/living/L = target
	var/stacks = max(1, scale_amount(3))
	L.apply_status_effect(/datum/status_effect/fire_handler/fire_stacks, stacks)

/datum/rune/air/blade
	id = "air_blade"
	name = "Лезвие"
	desc = "Увеличивает общую силу клинка."
	element = RUNE_ELEMENT_AIR
	color = "#dcdcdc"

	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE

	carve_ingredients = list(
		/obj/item/natural/feather = 1,
		/obj/item/natural/fibers = 1
	)

/datum/rune/air/blade/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon)
		return

	weapon.force = round(weapon.force * 1.08)

/datum/rune/air/blade/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!weapon)
		return

	weapon.force = round(weapon.force / 1.08)

/datum/rune/air/execution
	id = "air_execution"
	name = "Казнь"
	desc = "Успешные удары по лежащему противнику воссполняют силы."
	element = RUNE_ELEMENT_AIR
	color = "#eeeeee"

	cooldown = 25
	proc_chance = 30
	is_persistent = FALSE

	carve_ingredients = list(
		/obj/item/natural/feather = 1,
		/obj/item/natural/bone = 1
	)

/datum/rune/air/execution/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!isliving(target) || !user)
		return

	var/mob/living/L = target
	if(!(L.mobility_flags & MOBILITY_STAND))
		user.stamina_add(-scale_amount(15))

/datum/rune/earth/stoneskin
	id = "earth_stoneskin"
	name = "Каменная кожа"
	desc = "Улучшает характеристики защиты клинка."
	element = RUNE_ELEMENT_EARTH
	color = "#7f6a52"

	cooldown = 0
	proc_chance = 100
	is_persistent = TRUE

	carve_ingredients = list(
		/obj/item/natural/stone = 1,
		/obj/item/natural/stoneblock = 1
	)

/datum/rune/earth/stoneskin/on_persistent_apply(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(weapon)
		weapon.wdefense = round(weapon.wdefense * 1.1)

/datum/rune/earth/stoneskin/on_persistent_remove(obj/item/weapon, mob/living/user, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(weapon)
		weapon.wdefense = round(weapon.wdefense / 1.1)

/datum/rune/earth/apocalypse
	id = "earth_apocalypse"
	name = "Конец эпох"
	desc = "Успешные удары ослабляют вашего врага."
	element = RUNE_ELEMENT_EARTH
	color = "#5a2b2b"

	cooldown = 35
	proc_chance = 25
	is_persistent = FALSE

	carve_ingredients = list(
		/obj/item/natural/bone = 1,
		/obj/item/natural/thorn = 1
	)

/datum/rune/earth/apocalypse/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!isliving(target))
		return

	var/mob/living/L = target
	L.apply_status_effect(/datum/status_effect/debuff/rune_apocalypse, scale_duration(8 SECONDS, applied))

/datum/rune/water/razorice
	id = "water_razorice"
	name = "Режущий лед"
	desc = "Успешные удары наносят урон холодом и накладывают стак гипотермии."
	element = RUNE_ELEMENT_WATER
	color = "#9fdfff"

	cooldown = 30
	proc_chance = 30
	is_persistent = FALSE

	carve_ingredients = list(
		/obj/item/reagent_containers/powder/salt = 1,
		/obj/item/natural/glass = 1
	)

/datum/rune/water/razorice/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!isliving(target))
		return

	var/mob/living/L = target
	L.adjustFireLoss(scale_amount(4))

	var/hypo_stacks = max(1, scale_amount(1))
	L.apply_status_effect(/datum/status_effect/stacking/hypothermia, hypo_stacks)

/datum/rune/water/vampirism
	id = "water_vampirism"
	name = "Пресыщение"
	desc = "Успешные удары восстанавливают часть здоровья."
	element = RUNE_ELEMENT_WATER
	color = "#8b0000"

	cooldown = 30
	proc_chance = 20
	is_persistent = FALSE

	carve_ingredients = list(
		/obj/item/natural/bone = 1,
		/obj/item/reagent_containers/powder/salt = 1
	)

/datum/rune/water/vampirism/on_trigger(obj/item/weapon, mob/living/user, atom/target, datum/component/rune_storage/storage, datum/applied_rune/applied)
	if(!user)
		return

	user.adjustBruteLoss(-scale_amount(5))
