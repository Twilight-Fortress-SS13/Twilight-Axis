/atom/movable/screen/alert/status_effect/buff/dendor_vigil
	name = "Dendor's Vigil"
	desc = "The Treefather's blessing quickens my steps and wards me against natural obstacles."
	icon_state = "buff"

/datum/status_effect/buff/dendor_vigil
	id = "dendor_vigil"
	alert_type = /atom/movable/screen/alert/status_effect/buff/dendor_vigil
	effectedstats = list("perception" = 2, "speed" = 1)
	duration = 30 MINUTES

/datum/status_effect/buff/dendor_vigil/dendorite
	effectedstats = list("perception" = 2, "speed" = 2, "willpower" = 1)

/datum/status_effect/buff/dendor_vigil/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	ADD_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, id)
	to_chat(owner, span_green("The Treefather's vigil embraces me — my steps are swift and the thorns will not bite."))

/datum/status_effect/buff/dendor_vigil/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	REMOVE_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, id)
	to_chat(owner, span_warning("The Treefather's vigil fades from me."))

/obj/structure/flora/roguetree/wise/sanctified/proc/is_valid_vigil_follower(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(HAS_TRAIT(H, TRAIT_PSYDONITE))
		return FALSE
	if(istype(H.patron, /datum/patron/old_god))
		return FALSE
	if(istype(H.patron, /datum/patron/inhumen))
		return FALSE
	return TRUE


/datum/sanctified_tree_data
	var/obj/structure/flora/roguetree/wise/sanctified/tree
	var/list/rituals_completed = list()
	var/list/soulbound_players = list()
	var/awaiting_soulbind_ckey = null

	var/active_ritual = null
	var/list/ritual_progress = list()
	var/cat1_all_berries = TRUE
	var/obj/item/ritual_armor = null

	var/has_slow_aura = FALSE
	var/has_heal_aura = FALSE
	var/list/slowed_mobs = list()
	var/slow_aura_elapsed = 0
	var/heal_aura_elapsed = 0
	var/list/heal_player_cooldowns = list()

	var/wedding_active = FALSE
	var/wedding_officiant_ckey = null

/datum/sanctified_tree_data/New(obj/structure/flora/roguetree/wise/sanctified/owner)
	..()
	tree = owner

/obj/structure/flora/roguetree/wise/sanctified
	name = "sanctified tree"
	desc = "A great tree consecrated by the Treefather. Its bark glows with faint light, and the air around it thrums with primal holiness. A nexus of druidic power."
	pixel_x = -11
	max_integrity = 400
	activated = FALSE
	static_debris = list()

	var/datum/sanctified_tree_data/tree_data
	var/show_ritual_hints = TRUE
	var/integrity_bonus = 0
	var/bonus_check_elapsed = 0
	var/integrity_regen_elapsed = 0

/obj/structure/flora/roguetree/wise/sanctified/Initialize(mapload)
	. = ..()
	tree_data = new /datum/sanctified_tree_data(src)
	set_light(3, 3, 3, l_color = "#FFD700")
	START_PROCESSING(SSprocessing, src)
	recalculate_integrity_bonus()

/obj/structure/flora/roguetree/wise/sanctified/Destroy()
	remove_filter("sanctified_outline")
	STOP_PROCESSING(SSprocessing, src)
	if(tree_data)
		if(tree_data.soulbound_players.len)
			curse_soulbound_players()
		for(var/mob/living/M in tree_data.slowed_mobs)
			if(!QDELETED(M))
				var/datum/status_effect/debuff/sanctified_tree_slow/SE = M.has_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
				if(SE)
					qdel(SE)
		tree_data.slowed_mobs = list()
		if(tree_data.ritual_armor && !QDELETED(tree_data.ritual_armor))
			tree_data.ritual_armor.forceMove(get_turf(src))
			tree_data.ritual_armor = null
		qdel(tree_data)
		tree_data = null
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/proc/curse_soulbound_players()
	for(var/ckey in tree_data.soulbound_players)
		for(var/mob/living/carbon/human/H in GLOB.alive_mob_list)
			if(H.ckey != ckey)
				continue
			H.apply_status_effect(/datum/status_effect/debuff/soulbind_broken)
			H.add_stress(/datum/stressevent/soulbind_tree_loss)
			REMOVE_TRAIT(H, "DENDOR_SOULBOUND", "SOULBIND")
			H.dendor_dryad_aggressive_mode = FALSE
			remove_verb(H, /mob/living/carbon/human/proc/toggle_dendor_dryad_aggression)
			for(var/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/S in H.mind?.spell_list)
				H.mind.RemoveSpell(S)
			for(var/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/S in H.mind?.spell_list)
				H.mind.RemoveSpell(S)
			for(var/datum/action/cooldown/spell/minion_order/lesser_dryad/S in H.mind?.spell_list)
				H.mind.RemoveSpell(S)
			break

/obj/structure/flora/roguetree/wise/sanctified/process(dt)
	bonus_check_elapsed += dt
	if(bonus_check_elapsed >= 60 SECONDS)
		bonus_check_elapsed = 0
		recalculate_integrity_bonus()
	integrity_regen_elapsed += dt
	if(integrity_regen_elapsed >= 30 SECONDS)
		integrity_regen_elapsed = 0
		if(obj_integrity < max_integrity)
			obj_integrity = min(obj_integrity + 10, max_integrity)
	if(!tree_data)
		return
	if(tree_data.has_slow_aura)
		tree_data.slow_aura_elapsed += dt
		if(tree_data.slow_aura_elapsed >= 5 SECONDS)
			tree_data.slow_aura_elapsed = 0
			update_slow_aura()
	if(tree_data.has_heal_aura)
		tree_data.heal_aura_elapsed += dt
		if(tree_data.heal_aura_elapsed >= 60 SECONDS)
			tree_data.heal_aura_elapsed = 0
			pulse_heal_aura()


/obj/structure/flora/roguetree/wise/sanctified/proc/recalculate_integrity_bonus()
	var/tree_count = 0
	for(var/obj/structure/flora/newtree/T in range(10, src))
		if(!T.burnt)
			tree_count++
	for(var/obj/structure/flora/roguetree/T in range(10, src))
		if(istype(T, /obj/structure/flora/roguetree/wise))
			continue  // exclude wise and sanctified subtypes
		if(istype(T, /obj/structure/flora/roguetree/burnt))
			continue
		if(istype(T, /obj/structure/flora/roguetree/stump))
			continue
		tree_count++
	var/new_bonus = min(tree_count * 10, 200)
	if(new_bonus == integrity_bonus)
		return
	integrity_bonus = new_bonus
	max_integrity = 400 + integrity_bonus
	obj_integrity = min(obj_integrity, max_integrity)


/obj/structure/flora/roguetree/wise/sanctified/proc/get_ritual_order()
	return list("cat1", "cat8", "cat10", "cat2", "cat5", "cat12", "cat4", "cat7", "cat9", "cat3", "cat6", "cat11")

/obj/structure/flora/roguetree/wise/sanctified/proc/has_dendor_amulet(mob/living/carbon/human/H)
	return istype(H.get_active_held_item(), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
		istype(H.get_item_by_slot(SLOT_NECK), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
		istype(H.get_item_by_slot(SLOT_WRISTS), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
		istype(H.get_item_by_slot(SLOT_RING), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
		istype(H.get_item_by_slot(SLOT_GLOVES), /obj/item/clothing/neck/roguetown/psicross/dendor)

/obj/structure/flora/roguetree/wise/sanctified/proc/can_use_ritual_ui(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.patron?.type != /datum/patron/divine/dendor)
		return FALSE
	if(!has_dendor_amulet(H))
		return FALSE
	if(!H.canUseTopic(src, be_close = TRUE))
		return FALSE
	return TRUE

/obj/structure/flora/roguetree/wise/sanctified/proc/get_ritual_required_level(category)
	switch(category)
		if("cat8", "cat10")
			return SKILL_LEVEL_NOVICE
		if("cat2", "cat5", "cat12")
			return SKILL_LEVEL_APPRENTICE
		if("cat4", "cat7")
			return SKILL_LEVEL_JOURNEYMAN
		if("cat9", "cat3")
			return SKILL_LEVEL_EXPERT
		if("cat6")
			return SKILL_LEVEL_MASTER
		if("cat11")
			return SKILL_LEVEL_LEGENDARY
	return 0

/obj/structure/flora/roguetree/wise/sanctified/proc/get_druidic_level_name(level)
	switch(level)
		if(SKILL_LEVEL_NOVICE)
			return "Novice"
		if(SKILL_LEVEL_APPRENTICE)
			return "Apprentice"
		if(SKILL_LEVEL_JOURNEYMAN)
			return "Journeyman"
		if(SKILL_LEVEL_EXPERT)
			return "Expert"
		if(SKILL_LEVEL_MASTER)
			return "Master"
		if(SKILL_LEVEL_LEGENDARY)
			return "Legendary"
	return "Untrained"

/obj/structure/flora/roguetree/wise/sanctified/proc/get_ritual_description(category)
	switch(category)
		if("cat1") return "Принесите урожай, чтобы получить семена и саженцы из даров Древоотца."
		if("cat2") return "Пробудите грибную стражу вокруг древа и благословите находящихся рядом верных лесной стремительностью."
		if("cat3") return "Вплетите влияние фей в рощу и получите споры грибных фей."
		if("cat4") return "Укрепите освящённое древо и пробудите защиту, замедляющую враждебных незваных гостей."
		if("cat5") return "Пробудите живой свет, который будет излучать исцеляющую силу из освящённого древа."
		if("cat6") return "Закалите доспех друида в благословенный живой доспех с шансом получить дополнительную священную часть экипировки."
		if("cat7") return "Свяжите свою душу с этим древом, получив связь с младшей дриадой ценой серьёзного личного риска."
		if("cat8") return "Начните обряд Союза природы, чтобы две души могли заключить брак под ветвями Древоотца."
		if("cat9") return "Сгустите священную силу роста в Цветокамень урожая, наполненный силой Древоотца."
		if("cat10") return "Освойте Призыв флоры и научитесь призывать семена силой друидизма."
		if("cat11") return "Вплетите образы летучей мыши и ворона в Звериную форму и получите крылатые облики."
		if("cat12") return "Принесите молодые деревья, чтобы освящённое древо даровало взамен благословенную древесину."
	return "Друидский обряд Древоотца."

/obj/structure/flora/roguetree/wise/sanctified/proc/get_ritual_block_reason(category, mob/living/carbon/human/H)
	if(is_once_per_tree(category) && (category in tree_data.rituals_completed))
		return "Уже проведён на этом древе"
	var/required_level = get_ritual_required_level(category)
	if(required_level > 0 && H.get_skill_level(/datum/skill/magic/druidic) < required_level)
		return "Требуется Druidic Trickery: [get_druidic_level_name(required_level)]"
	if(category == "cat10" && H.mind)
		for(var/obj/effect/proc_holder/spell/self/conjure_floral_seed/S in H.mind.spell_list)
			return "Призыв флоры уже изучен"
	return null

/obj/structure/flora/roguetree/wise/sanctified/proc/build_ritual_ui_entry(category, mob/living/carbon/human/H, include_progress = FALSE)
	var/list/entry = list()
	entry["id"] = category
	entry["name"] = get_ritual_display_name(category)
	entry["description"] = get_ritual_description(category)
	entry["xp"] = get_ritual_xp(category)
	entry["repeatable"] = !is_once_per_tree(category)
	entry["completed"] = (category in tree_data.rituals_completed)
	var/required_level = get_ritual_required_level(category)
	entry["required_skill_level"] = required_level
	entry["required_skill"] = get_druidic_level_name(required_level)
	var/block_reason = get_ritual_block_reason(category, H)
	entry["blocked_reason"] = block_reason
	entry["available"] = isnull(block_reason)
	entry["alternative_offerings"] = category == "cat4"
	var/list/requirements = list()
	var/list/req = get_required_offerings(category)
	for(var/key in req)
		var/current = include_progress ? (tree_data.ritual_progress[key] || 0) : 0
		var/needed = req[key]
		requirements += list(list(
			"id" = key,
			"name" = get_offering_desc(key),
			"icon" = get_offering_icon(key),
			"current" = current,
			"required" = needed,
			"fulfilled" = current >= needed
		))
	entry["offerings"] = requirements
	return entry

/obj/structure/flora/roguetree/wise/sanctified/proc/open_ritual_menu(mob/living/user)
	ui_interact(user)

/obj/structure/flora/roguetree/wise/sanctified/ui_interact(mob/user, datum/tgui/ui)
	if(!can_use_ritual_ui(user))
		to_chat(user, span_warning("I need to remain beside the sacred tree while bearing Dendor's amulet to commune with it."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SanctifiedTree", "Ритуалы освящённого древа")
		ui.open()

/obj/structure/flora/roguetree/wise/sanctified/ui_data(mob/user)
	var/list/data = list()
	if(!istype(user, /mob/living/carbon/human) || !tree_data)
		return data
	var/mob/living/carbon/human/H = user
	var/list/rituals = list()
	for(var/category in get_ritual_order())
		rituals += list(build_ritual_ui_entry(category, H, FALSE))
	data["rituals"] = rituals
	data["active_ritual"] = tree_data.active_ritual ? build_ritual_ui_entry(tree_data.active_ritual, H, TRUE) : null
	data["wedding_active"] = tree_data.wedding_active
	data["integrity"] = round(obj_integrity)
	data["max_integrity"] = max_integrity
	data["integrity_bonus"] = integrity_bonus
	data["slow_aura"] = tree_data.has_slow_aura
	data["heal_aura"] = tree_data.has_heal_aura
	data["soulbound_count"] = tree_data.soulbound_players.len
	var/druidic_level = H.get_skill_level(/datum/skill/magic/druidic)
	data["druidic_level"] = druidic_level
	data["druidic_level_name"] = get_druidic_level_name(druidic_level)
	return data

/obj/structure/flora/roguetree/wise/sanctified/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(!tree_data || !can_use_ritual_ui(ui.user))
		return
	var/mob/living/carbon/human/H = ui.user
	switch(action)
		if("start_ritual")
			var/category = params["ritual_id"]
			if(!(category in get_ritual_order()))
				return
			if(try_start_ritual(H, category))
				return TRUE
		if("cancel_ritual")
			if(tree_data.active_ritual)
				cancel_ritual(H)
				return TRUE
		if("cancel_wedding")
			if(tree_data.wedding_active)
				tree_data.wedding_active = FALSE
				tree_data.wedding_officiant_ckey = null
				to_chat(H, span_warning("The wedding ceremony is dissolved. The Treefather withdraws his blessing."))
				return TRUE

/obj/structure/flora/roguetree/wise/sanctified/proc/try_start_ritual(mob/living/carbon/human/H, category)
	if(tree_data.wedding_active)
		to_chat(H, span_warning("A Nature's Union ceremony is already active at this tree."))
		return FALSE
	if(tree_data.active_ritual)
		to_chat(H, span_warning("[get_ritual_display_name(tree_data.active_ritual)] is already active at this tree."))
		return FALSE
	var/block_reason = get_ritual_block_reason(category, H)
	if(block_reason)
		to_chat(H, span_warning("I cannot begin [get_ritual_display_name(category)]: [block_reason]."))
		return FALSE
	tree_data.active_ritual = category
	var/list/req = get_required_offerings(category)
	tree_data.ritual_progress = list()
	for(var/key in req)
		tree_data.ritual_progress[key] = 0
	if(category == "cat1")
		tree_data.cat1_all_berries = TRUE
	to_chat(H, span_notice("I begin the [get_ritual_display_name(category)] ritual. Offer items by clicking the tree while holding them."))
	return TRUE

/obj/structure/flora/roguetree/wise/sanctified/proc/get_ritual_display_name(category)
	switch(category)
		if("cat1") return "Урожай Дендора"
		if("cat2") return "Грибная стража"
		if("cat3") return "Плетение фей"
		if("cat12") return "Древесная десятина"
		if("cat4") return "Оплот Древоотца"
		if("cat5") return "Живой свет"
		if("cat6") return "Закалка природы"
		if("cat7") return "Связь души"
		if("cat8") return "Союз природы"
		if("cat9") return "Цветокамень урожая"
		if("cat10") return "Призыв флоры"
		if("cat11") return "Крылатое перерождение"
	return "Неизвестный ритуал"

/obj/structure/flora/roguetree/wise/sanctified/proc/get_ritual_xp(category)
	switch(category)
		if("cat1")  return 5
		if("cat2")  return 25
		if("cat3")  return 50
		if("cat4")  return 100
		if("cat5")  return 100
		if("cat6")  return 200
		if("cat7")  return 100
		if("cat8")  return 25
		if("cat9")  return 50
		if("cat10") return 100
		if("cat12") return 10
	return 0

/obj/structure/flora/roguetree/wise/sanctified/proc/is_once_per_tree(category)
	return (category in list("cat4", "cat5", "cat6", "cat7", "cat9", "cat10", "cat11")) // cat12 is repeatable

/obj/structure/flora/roguetree/wise/sanctified/proc/get_required_offerings(category)
	switch(category)
		if("cat1") return list("food_item" = 6)
		if("cat2") return list("manabloom_or_manacrystal" = 10)
		if("cat3") return list("runed_or_leyline" = 1, "blessed_powder_alt" = 4)
		if("cat4") return list("boulder_cat4" = 5, "any_stone_cat4" = 15)
		if("cat5") return list("vital_item" = 10, "ash" = 10, "compost" = 10)
		if("cat6") return list("zizobane" = 5, "runed_artifact" = 2, "druid_armor" = 1, "volf_head" = 1, "spider_head" = 1, "tree_seed" = 1, "blessed_seed_powder" = 1, "holy_water_container" = 1)
		if("cat7") return list("leechtick" = 1, "bones" = 4)
		if("cat8") return list("wedding_flower" = 1)
		if("cat9") return list("boulder_only" = 1, "magic_stone_or_essence" = 1, "blessed_powder" = 5)
		if("cat10") return list(
			"herb_atropa"     = 1,
			"herb_matricaria"  = 1,
			"herb_symphitum"   = 1,
			"herb_taraxacum"   = 1,
			"herb_euphrasia"   = 1,
			"herb_paris"       = 1,
			"herb_calendula"   = 1,
			"herb_mentha"      = 1,
			"herb_urtica"      = 1,
			"herb_salvia"      = 1,
			"herb_hypericum"   = 1,
			"herb_benedictus"  = 1,
			"herb_valeriana"   = 1,
			"herb_artemisia"   = 1,
			"herb_rosa"        = 1,
			"manabloom_single" = 1
		)
		if("cat11") return list("feather" = 10, "bonedust" = 10, "essence_of_wilderness" = 1, "bloomstone" = 1)
		if("cat12") return list("tree_sapling_any" = 5)
	return list()

/obj/structure/flora/roguetree/wise/sanctified/proc/get_offering_desc(key)
	switch(key)
		if("food_item") return "Any fresh or rotten produce"
		if("manabloom_or_manacrystal") return "Mana bloom OR crystalized mana"
		if("runed_or_leyline") return "Runed artifact OR leyline shard"
		if("blessed_powder_alt") return "Blessed seed powder"
		if("enchanted_stone_or_boulder") return "Enchanted stone (magic power 5+) OR boulder"
		if("boulder_cat4") return "A large boulder"
		if("any_stone_cat4") return "A stone of any type"
		if("vital_item") return "Sinew, viscera, bonemeal, or skull"
		if("ash") return "Ash"
		if("compost") return "Compost"
		if("zizobane") return "Zizo's bane mushroom"
		if("runed_artifact") return "Runed artifact"
		if("druid_armor") return "Druid armor"
		if("volf_head") return "Volf head"
		if("spider_head") return "Spider head"
		if("tree_seed") return "Tree seed"
		if("tree_sapling_any") return "Any tree sapling"
		if("blessed_seed_powder") return "Blessed seed powder"
		if("holy_water_container") return "Stone mortar or bucket with 30+ drams of blessed water"
		if("lux") return "Lux"
		if("leechtick") return "Bloated leech tick"
		if("bones") return "Bones"
		if("wedding_flower") return "Eoran peace flower"
		if("boulder_only") return "A large boulder"
		if("magic_stone_or_essence") return "An enchanted stone (magic power 5+), essence of wilderness, or essence of lumber"
		if("blessed_powder") return "Blessed seed powder"
		if("herb_atropa") return "Atropa herb"
		if("herb_matricaria") return "Matricaria herb"
		if("herb_symphitum") return "Symphitum herb"
		if("herb_taraxacum") return "Taraxacum herb"
		if("herb_euphrasia") return "Euphrasia herb"
		if("herb_paris") return "Paris herb"
		if("herb_calendula") return "Calendula herb"
		if("herb_mentha") return "Mentha herb"
		if("herb_urtica") return "Urtica herb"
		if("herb_salvia") return "Salvia herb"
		if("herb_hypericum") return "Hypericum herb"
		if("herb_benedictus") return "Benedictus herb"
		if("herb_valeriana") return "Valeriana herb"
		if("herb_artemisia") return "Artemisia herb"
		if("herb_rosa") return "Rosa herb"
		if("manabloom_single") return "A mana bloom flower"
		if("feather") return "Feather"
		if("bonedust") return "Bone meal"
		if("essence_of_wilderness") return "Essence of wilderness"
		if("bloomstone") return "Harvest bloomstone"
	return key

/obj/structure/flora/roguetree/wise/sanctified/proc/get_offering_icon_type(key)
	switch(key)
		if("food_item") return /obj/item/reagent_containers/food/snacks/grown/apple
		if("manabloom_or_manacrystal") return /obj/item/reagent_containers/food/snacks/grown/manabloom
		if("runed_or_leyline", "runed_artifact") return /obj/item/magic/artifact
		if("blessed_powder_alt", "blessed_seed_powder", "blessed_powder") return /obj/item/alch/blessedseedpowder
		if("enchanted_stone_or_boulder", "boulder_cat4", "boulder_only") return /obj/item/natural/rock
		if("any_stone_cat4") return /obj/item/natural/stone
		if("vital_item") return /obj/item/alch/sinew
		if("ash") return /obj/item/ash
		if("compost") return /obj/item/compost
		if("zizobane") return /obj/item/reagent_containers/food/snacks/zizo_bane
		if("druid_armor") return /obj/item/clothing/suit/roguetown/armor/leather/druid
		if("volf_head") return /obj/item/natural/head/volf
		if("spider_head") return /obj/item/natural/head/honeyspider
		if("tree_seed", "tree_sapling_any") return /obj/item/seeds/treesap
		if("holy_water_container") return /obj/item/reagent_containers/glass/mortar
		if("lux") return /obj/item/reagent_containers/lux
		if("leechtick") return /obj/item/leechtick_bloated
		if("bones") return /obj/item/natural/bone
		if("wedding_flower") return /obj/item/clothing/head/peaceflower
		if("magic_stone_or_essence", "essence_of_wilderness") return /obj/item/natural/cured/essence
		if("herb_atropa") return /obj/item/alch/atropa
		if("herb_matricaria") return /obj/item/alch/matricaria
		if("herb_symphitum") return /obj/item/alch/symphitum
		if("herb_taraxacum") return /obj/item/alch/taraxacum
		if("herb_euphrasia") return /obj/item/alch/euphrasia
		if("herb_paris") return /obj/item/alch/paris
		if("herb_calendula") return /obj/item/alch/calendula
		if("herb_mentha") return /obj/item/alch/mentha
		if("herb_urtica") return /obj/item/alch/urtica
		if("herb_salvia") return /obj/item/alch/salvia
		if("herb_hypericum") return /obj/item/alch/hypericum
		if("herb_benedictus") return /obj/item/alch/benedictus
		if("herb_valeriana") return /obj/item/alch/valeriana
		if("herb_artemisia") return /obj/item/alch/artemisia
		if("herb_rosa") return /obj/item/alch/rosa
		if("manabloom_single") return /obj/item/reagent_containers/food/snacks/grown/manabloom
		if("feather") return /obj/item/natural/feather
		if("bonedust") return /obj/item/alch/bonemeal
		if("bloomstone") return /obj/item/alch/bloomstone
	return null

/obj/structure/flora/roguetree/wise/sanctified/proc/get_offering_icon(key)
	var/static/list/icon_cache = list()
	if(key in icon_cache)
		return icon_cache[key]
	var/sample_type = get_offering_icon_type(key)
	if(!sample_type)
		icon_cache[key] = null
		return null
	var/atom/movable/sample = new sample_type()
	if(!sample.icon || !sample.icon_state)
		qdel(sample)
		icon_cache[key] = null
		return null
	var/icon/sample_icon = icon(sample.icon, sample.icon_state, SOUTH)
	var/icon_data = icon2base64(sample_icon)
	qdel(sample)
	icon_cache[key] = icon_data
	return icon_data

/obj/structure/flora/roguetree/wise/sanctified/proc/show_ritual_requirements(mob/living/user, category)
	var/req = get_required_offerings(category)
	to_chat(user, span_info("=== [get_ritual_display_name(category)] requirements ==="))
	if(category == "cat4")
		var/boulder_cur = tree_data.ritual_progress["boulder_cat4"] || 0
		var/boulder_needed = req["boulder_cat4"]
		var/stone_cur = tree_data.ritual_progress["any_stone_cat4"] || 0
		var/stone_needed = req["any_stone_cat4"]
		to_chat(user, span_info("  Offer one of the following alternatives:"))
		if(boulder_cur >= boulder_needed)
			to_chat(user, span_notice("  [get_offering_desc("boulder_cat4")]: [boulder_cur]/[boulder_needed] (fulfilled)"))
		else
			to_chat(user, span_warning("  Option A — [get_offering_desc("boulder_cat4")]: [boulder_cur]/[boulder_needed]"))
		if(stone_cur >= stone_needed)
			to_chat(user, span_notice("  [get_offering_desc("any_stone_cat4")]: [stone_cur]/[stone_needed] (fulfilled)"))
		else
			to_chat(user, span_warning("  Option B — [get_offering_desc("any_stone_cat4")]: [stone_cur]/[stone_needed]"))
		return
	for(var/key in req)
		var/current = tree_data.ritual_progress[key] || 0
		var/needed = req[key]
		if(current >= needed)
			to_chat(user, span_notice("  [get_offering_desc(key)]: [current]/[needed] (fulfilled)"))
		else
			to_chat(user, span_warning("  [get_offering_desc(key)]: [current]/[needed]"))

/obj/structure/flora/roguetree/wise/sanctified/proc/offer_item(mob/living/user)
	if(!tree_data?.active_ritual)
		return FALSE
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("I am not holding anything to offer."))
		return FALSE
	var/req = get_required_offerings(tree_data.active_ritual)
	var/skip_boulder_cat4 = (tree_data.active_ritual == "cat4") && ((tree_data.ritual_progress["any_stone_cat4"] || 0) >= req["any_stone_cat4"])
	var/skip_stone_cat4 = (tree_data.active_ritual == "cat4") && ((tree_data.ritual_progress["boulder_cat4"] || 0) >= req["boulder_cat4"])
	var/obj/item/storage/held_sack = istype(held, /obj/item/storage) ? held : null
	if(held_sack)
		var/any_taken = FALSE
		for(var/key in req)
			var/current = tree_data.ritual_progress[key] || 0
			if(current >= req[key])
				continue
			if(skip_boulder_cat4 && key == "boulder_cat4")
				continue
			if(skip_stone_cat4 && key == "any_stone_cat4")
				continue
			var/list/sack_contents = held_sack.contents.Copy()
			for(var/obj/item/sack_item in sack_contents)
				if(current >= req[key])
					break
				if(!check_offering_match(key, sack_item))
					continue
				if(tree_data.active_ritual == "cat1" && key == "food_item")
					if(!istype(sack_item, /obj/item/reagent_containers/food/snacks/grown/berries))
						tree_data.cat1_all_berries = FALSE
				consume_offering(key, sack_item, user)
				current++
				tree_data.ritual_progress[key] = current
				any_taken = TRUE
		if(any_taken)
			playsound(get_turf(src), 'sound/magic/churn.ogg', 40, FALSE)
			if(check_ritual_complete())
				complete_ritual(user)
			return TRUE
		to_chat(user, span_warning("The tree does not need anything from that container right now."))
		return FALSE
	for(var/key in req)
		var/current = tree_data.ritual_progress[key] || 0
		if(current >= req[key])
			continue
		if(skip_boulder_cat4 && key == "boulder_cat4")
			continue
		if(skip_stone_cat4 && key == "any_stone_cat4")
			continue
		if(!check_offering_match(key, held))
			continue
		if(tree_data.active_ritual == "cat1" && key == "food_item")
			if(!istype(held, /obj/item/reagent_containers/food/snacks/grown/berries))
				tree_data.cat1_all_berries = FALSE
		consume_offering(key, held, user)
		tree_data.ritual_progress[key] = current + 1
		playsound(get_turf(src), 'sound/magic/churn.ogg', 40, FALSE)
		if(check_ritual_complete())
			complete_ritual(user)
		return TRUE
	to_chat(user, span_warning("The tree does not need [held.name] right now."))
	return FALSE

/obj/structure/flora/roguetree/wise/sanctified/proc/is_harvest_offering(obj/item/held)
	if(!istype(held, /obj/item/reagent_containers/food/snacks))
		return FALSE
	if(istype(held, /obj/item/reagent_containers/food/snacks/grown/berries))
		return TRUE
	var/obj/item/reagent_containers/food/snacks/food = held
	if(food.foodtype & (FRUIT | VEGETABLES | GRAIN))
		return TRUE
	var/static/list/extra_harvest_types = list(
		/obj/item/reagent_containers/food/snacks/grown/garlick/rogue,
		/obj/item/reagent_containers/food/snacks/grown/onion/rogue,
		/obj/item/reagent_containers/food/snacks/grown/vegetable/turnip,
		/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue,
		/obj/item/reagent_containers/food/snacks/grown/potato/rogue,
		/obj/item/reagent_containers/food/snacks/grown/rice,
		/obj/item/reagent_containers/food/snacks/grown/cucumber,
		/obj/item/reagent_containers/food/snacks/grown/eggplant,
		/obj/item/reagent_containers/food/snacks/grown/carrot,
		/obj/item/reagent_containers/food/snacks/grown/wheat,
		/obj/item/reagent_containers/food/snacks/grown/oat,
		/obj/item/reagent_containers/food/snacks/grown/sugarcane,
		/obj/item/reagent_containers/food/snacks/grown/coffeebeans,
		/obj/item/reagent_containers/food/snacks/grown/rogue/poppy,
		/obj/item/reagent_containers/food/snacks/grown/nut,
		/obj/item/reagent_containers/food/snacks/grown/tea,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon,
		/obj/item/reagent_containers/food/snacks/grown/fruit/lime,
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine,
		/obj/item/reagent_containers/food/snacks/grown/fruit/plum,
		/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry,
		/obj/item/reagent_containers/food/snacks/grown/fruit/tomato,
		/obj/item/natural/shellplant/pumpkin,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	for(var/path in extra_harvest_types)
		if(istype(held, path))
			return TRUE
	return FALSE

/obj/structure/flora/roguetree/wise/sanctified/proc/check_offering_match(key, obj/item/held)
	if(!held)
		return FALSE
	switch(key)
		if("food_item")
			return is_harvest_offering(held)
		if("manabloom_or_manacrystal")
			return istype(held, /obj/item/reagent_containers/food/snacks/grown/manabloom) || istype(held, /obj/item/magic/manacrystal)
		if("runed_or_leyline")
			return istype(held, /obj/item/magic/artifact) || istype(held, /obj/item/magic/leyline)
		if("blessed_powder_alt")
			return held.type == /obj/item/alch/blessedseedpowder
		if("enchanted_stone_or_boulder")
			if(istype(held, /obj/item/natural/stone))
				var/obj/item/natural/stone/stone = held
				return stone.magic_power >= 5
			return istype(held, /obj/item/natural/rock)
		if("boulder_cat4")
			return istype(held, /obj/item/natural/rock)
		if("any_stone_cat4")
			return istype(held, /obj/item/natural/stone)
		if("vital_item")
			return istype(held, /obj/item/alch/sinew) || istype(held, /obj/item/alch/viscera) || istype(held, /obj/item/alch/bonemeal) || istype(held, /obj/item/skull)
		if("ash")
			return istype(held, /obj/item/ash)
		if("compost")
			return istype(held, /obj/item/compost)
		if("zizobane")
			return istype(held, /obj/item/reagent_containers/food/snacks/zizo_bane)
		if("runed_artifact")
			return istype(held, /obj/item/magic/artifact)
		if("druid_armor")
			return held.type == /obj/item/clothing/suit/roguetown/armor/leather/druid
		if("volf_head")
			return istype(held, /obj/item/natural/head/volf)
		if("spider_head")
			return istype(held, /obj/item/natural/head/honeyspider) || istype(held, /obj/item/natural/head/mirespider)
		if("tree_seed")
			return istype(held, /obj/item/seeds/treesap)
		if("tree_sapling_any")
			return istype(held, /obj/item/seeds/treesap) || istype(held, /obj/structure/tree_sapling)
		if("blessed_seed_powder")
			return istype(held, /obj/item/alch/blessedseedpowder)
		if("holy_water_container")
			if(!(istype(held, /obj/item/reagent_containers/glass/mortar) || istype(held, /obj/item/reagent_containers/glass/bucket)))
				return FALSE
			if(!held.reagents)
				return FALSE
			return held.reagents.get_reagent_amount(/datum/reagent/water/blessed) >= 30
		if("lux")
			return istype(held, /obj/item/reagent_containers/lux)
		if("leechtick")
			return istype(held, /obj/item/leechtick_bloated)
		if("bones")
			return istype(held, /obj/item/natural/bone) || istype(held, /obj/item/alch/bone)
		if("wedding_flower")
			return istype(held, /obj/item/clothing/head/peaceflower)
		if("boulder_only")
			return istype(held, /obj/item/natural/rock)
		if("magic_stone_or_essence")
			if(istype(held, /obj/item/natural/cured/essence))
				return TRUE
			if(!istype(held, /obj/item/natural/stone))
				return FALSE
			var/obj/item/natural/stone/stone = held
			return stone.magic_power >= 5
		if("blessed_powder")
			return held.type == /obj/item/alch/blessedseedpowder
		if("herb_atropa")    return held.type == /obj/item/alch/atropa
		if("herb_matricaria") return held.type == /obj/item/alch/matricaria
		if("herb_symphitum") return held.type == /obj/item/alch/symphitum
		if("herb_taraxacum") return held.type == /obj/item/alch/taraxacum
		if("herb_euphrasia") return held.type == /obj/item/alch/euphrasia
		if("herb_paris")     return held.type == /obj/item/alch/paris
		if("herb_calendula") return held.type == /obj/item/alch/calendula
		if("herb_mentha")    return held.type == /obj/item/alch/mentha
		if("herb_urtica")    return held.type == /obj/item/alch/urtica
		if("herb_salvia")    return held.type == /obj/item/alch/salvia
		if("herb_hypericum") return held.type == /obj/item/alch/hypericum
		if("herb_benedictus") return held.type == /obj/item/alch/benedictus
		if("herb_valeriana") return held.type == /obj/item/alch/valeriana
		if("herb_artemisia") return held.type == /obj/item/alch/artemisia
		if("herb_rosa")      return held.type == /obj/item/alch/rosa
		if("manabloom_single") return istype(held, /obj/item/reagent_containers/food/snacks/grown/manabloom)
		if("feather") return istype(held, /obj/item/natural/feather)
		if("bonedust") return istype(held, /obj/item/alch/bonemeal)
		if("essence_of_wilderness") return istype(held, /obj/item/natural/cured/essence)
		if("bloomstone") return istype(held, /obj/item/alch/bloomstone)
	return FALSE

/obj/structure/flora/roguetree/wise/sanctified/proc/consume_offering(key, obj/item/held, mob/living/user)
	switch(key)
		if("druid_armor")
			held.forceMove(get_turf(src))
			tree_data.ritual_armor = held
		if("holy_water_container")
			held.reagents.remove_reagent(/datum/reagent/water/blessed, 30)
		if("bloomstone")
			held.forceMove(get_turf(src))
			var/obj/item/alch/bloomstone/offered = held
			offered.charges = 1
			qdel(offered)
		else
			qdel(held)

/obj/structure/flora/roguetree/wise/sanctified/proc/check_ritual_complete()
	if(!tree_data?.active_ritual)
		return FALSE
	var/req = get_required_offerings(tree_data.active_ritual)
	if(tree_data.active_ritual == "cat4")
		var/boulder_done = (tree_data.ritual_progress["boulder_cat4"] || 0) >= req["boulder_cat4"]
		var/stone_done = (tree_data.ritual_progress["any_stone_cat4"] || 0) >= req["any_stone_cat4"]
		return boulder_done || stone_done
	for(var/key in req)
		if((tree_data.ritual_progress[key] || 0) < req[key])
			return FALSE
	return TRUE

/obj/structure/flora/roguetree/wise/sanctified/proc/complete_ritual(mob/living/user)
	var/cat = tree_data.active_ritual
	tree_data.active_ritual = null
	tree_data.ritual_progress = list()
	if(is_once_per_tree(cat))
		tree_data.rituals_completed |= cat
	playsound(get_turf(src), 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
	visible_message(span_green("The [src.name] blazes with golden light as [user.name] completes a sacred ritual!"))
	var/ritual_xp = get_ritual_xp(cat)
	if(ritual_xp > 0 && user.mind)
		user.mind.add_sleep_experience(/datum/skill/magic/druidic, ritual_xp)
	switch(cat)
		if("cat1") reward_cat1(user)
		if("cat2") reward_cat2(user)
		if("cat3") reward_cat3(user)
		if("cat4") reward_cat4(user)
		if("cat5") reward_cat5(user)
		if("cat6") reward_cat6(user)
		if("cat7") on_soulbind(user)
		if("cat8") reward_cat8(user)
		if("cat9") reward_cat9(user)
		if("cat10") reward_cat10(user)
		if("cat11") reward_cat11(user)
		if("cat12") reward_cat12(user)

/obj/structure/flora/roguetree/wise/sanctified/proc/cancel_ritual(mob/living/user)
	if(!tree_data?.active_ritual)
		return
	var/cat_name = get_ritual_display_name(tree_data.active_ritual)
	if(tree_data.ritual_armor && !QDELETED(tree_data.ritual_armor))
		tree_data.ritual_armor.forceMove(get_turf(src))
		to_chat(user, span_notice("The offered armor returns to my feet."))
		tree_data.ritual_armor = null
	tree_data.active_ritual = null
	tree_data.ritual_progress = list()
	to_chat(user, span_warning("I cancel the [cat_name] ritual. All progress is lost."))


/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat1(mob/living/user)
	var/turf/T = get_turf(user)
	if(tree_data.cat1_all_berries)
		new /obj/item/seeds/bush(T)
		if(prob(50))
			new /obj/item/seeds/flower(T)
		to_chat(user, span_green("The roots twist with thorny energy — a wild hedge sapling seed tumbles forth."))
		return
	var/misc = pickweight(list(
		/obj/item/seeds/tea                          = 10,
		/obj/item/seeds/coffee                       = 10,
		/obj/item/herbseed/manabloom                 = 8,
		/obj/item/seeds/swampweed                    = 8,
		/obj/item/seeds/apple                        = 6,
		/obj/item/seeds/pear                         = 6,
		/obj/item/seeds/plum                         = 6,
		/obj/item/seeds/strawberry                   = 5,
		/obj/item/seeds/blackberry                   = 5,
		/obj/item/seeds/raspberry                    = 5,
		/obj/item/seeds/tomato                       = 5,
		/obj/item/seeds/potato                       = 5,
		/obj/item/seeds/onion                        = 5,
		/obj/item/seeds/cabbage                      = 5,
		/obj/item/seeds/wheat                        = 5,
		/obj/item/seeds/garlick                      = 5,
		/obj/item/seeds/turnip                       = 5,
		/obj/item/seeds/rice                         = 5,
		/obj/item/seeds/cucumber                     = 5,
		/obj/item/seeds/eggplant                     = 5,
		/obj/item/seeds/carrot                       = 5,
		/obj/item/seeds/wheat/oat                    = 5,
		/obj/item/seeds/sugarcane                    = 4,
		/obj/item/seeds/poppy                        = 4,
		/obj/item/seeds/nut                          = 4,
		/obj/item/seeds/lemon                        = 4,
		/obj/item/seeds/lime                         = 4,
		/obj/item/seeds/tangerine                    = 4,
		/obj/item/seeds/pumpkin                      = 3,
		/obj/item/seeds/berryrogue                   = 3
	))
	new misc(T)
	var/tree_type = pickweight(list(
		/obj/item/seeds/treesap/sakura = 5,
		/obj/item/seeds/treesap/pine   = 10,
		/obj/item/seeds/treesap        = 85
	))
	new tree_type(T)
	to_chat(user, span_green("Seeds tumble from the roots — Dendor's harvest is generous."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat2(mob/living/user)
	var/turf/T = get_turf(src)
	for(var/D in GLOB.cardinals)
		var/turf/adj = get_step(T, D)
		if(adj && !isclosedturf(adj) && !locate(/obj/structure/glowshroom) in adj)
			new /obj/structure/glowshroom(adj)
	for(var/mob/living/carbon/human/H in range(6, src))
		if(!is_valid_vigil_follower(H))
			continue
		if(H.stat == DEAD)
			continue
		if(H.patron?.type == /datum/patron/divine/dendor)
			H.apply_status_effect(/datum/status_effect/buff/dendor_vigil/dendorite)
		else
			H.apply_status_effect(/datum/status_effect/buff/dendor_vigil)
	to_chat(user, span_green("Kneestingers erupt in a ring — the Treefather's vigil strengthens his faithful."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat3(mob/living/user)
	var/turf/T = get_turf(user)
	new /obj/item/seeds/mushroom_fey(T)
	new /obj/item/seeds/mushroom_fey(T)
	to_chat(user, span_green("Two handfuls of mushroom fey spores rise from the roots — the Treefather rewards your patience."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat4(mob/living/user)
	tree_data.has_slow_aura = TRUE
	max_integrity += 100
	obj_integrity = min(obj_integrity + 100, max_integrity)
	visible_message(span_green("The bark of [src.name] hardens like ironwood. A silent ward settles around the tree — those who would defile it will find their feet heavy."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat5(mob/living/user)
	tree_data.has_heal_aura = TRUE
	set_light(5, 5, 5, l_color = "#44AA44")
	add_filter("sanctified_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))
	visible_message(span_green("A warm green aura blooms from [src.name]. The Treefather's life flows to those who revere him."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat6(mob/living/user)
	var/turf/T = get_turf(user)
	if(!tree_data.ritual_armor || QDELETED(tree_data.ritual_armor))
		to_chat(user, span_warning("The druid armor offering was lost — something disrupted the ritual."))
		return
	qdel(tree_data.ritual_armor)
	tree_data.ritual_armor = null
	var/obj/item/clothing/suit/roguetown/armor/leather/druid/blessed/BA = new(T)
	to_chat(user, span_green("[BA.name] rises from the ritual — the Treefather has blessed this armor with living power."))
	if(prob(50))
		var/list/bonus_pool = list(/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/druidic, /obj/item/clothing/gloves/roguetown/elven_gloves/druidic, /obj/item/clothing/shoes/roguetown/boots/elven_boots/druidic, /obj/item/clothing/cloak/forrestercloak/blessed)
		var/bonus_type = pick(bonus_pool)
		var/obj/item/bonus = new bonus_type(T)
		to_chat(user, span_green("The roots also yield [bonus.name] — an additional gift."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat8(mob/living/user)
	if(tree_data.wedding_active)
		to_chat(user, span_warning("A wedding ceremony is already being held at this tree."))
		return
	tree_data.wedding_active = TRUE
	tree_data.wedding_officiant_ckey = user.ckey
	visible_message(span_green("A peace flower drifts to the roots of [src.name] — the blessings of Dendor and Eora are invoked. Two souls may now offer their bitten apple to be wed beneath this tree."))
	to_chat(user, span_notice("The ceremony has begun. Both partners should bite the same apple once each, then hand it to the tree to be wed. The one handing the apple over will decide the surname."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat9(mob/living/user)
	var/turf/T = get_turf(user)
	var/obj/item/alch/bloomstone/B = new(T)
	user.put_in_hands(B)
	to_chat(user, span_green("The tree's roots cradle a glowing stone — and the Harvest Bloomstone rises to my hand, brimming in energy with the Treefather's blessing."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat10(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, span_warning("Only a humanoid may receive the Treefather's floral gift."))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	for(var/obj/effect/proc_holder/spell/self/conjure_floral_seed/S in H.mind.spell_list)
		to_chat(H, span_warning("I already know how to conjure floral seeds — this blessing cannot be received twice."))
		return
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/conjure_floral_seed)
	to_chat(H, span_green("The knowledge of Floral Conjuration flows into my mind — I can call seeds forth with the Treefather's power."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat11(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, span_warning("Only a humanoid may receive the Treefather's trickster blessing."))
		return
	var/mob/living/carbon/human/H = user
	if(!H.mind)
		return
	var/obj/effect/proc_holder/spell/self/wildshape/ws = H.mind.get_spell(/obj/effect/proc_holder/spell/self/wildshape)
	if(!ws)
		to_chat(H, span_warning("I need the Beast Form miracle before I can bind a new shape."))
		return

	var/already_has_bat  = (/mob/living/carbon/human/species/wildshape/bat  in ws.possible_shapes)
	var/already_has_crow = (/mob/living/carbon/human/species/wildshape/crow in ws.possible_shapes)
	if(already_has_bat && already_has_crow)
		to_chat(H, span_notice("These winged guises already reside within my soul."))
		return

	if(!already_has_bat)
		ws.possible_shapes += /mob/living/carbon/human/species/wildshape/bat
	if(!already_has_crow)
		ws.possible_shapes += /mob/living/carbon/human/species/wildshape/crow
	to_chat(H, span_green("The knowledge of bat and crow forms take root in my soul. I can now call shift into them through Beast Form."))

/obj/structure/flora/roguetree/wise/sanctified/proc/reward_cat12(mob/living/user)
	var/turf/T = get_turf(user)
	for(var/i in 1 to 2)
		var/obj/item/grown/log/tree/log = new(T)
		log.bless_log()
	to_chat(user, span_green("Through the Treefather's power, the tree's limbs shed and regrow, with blessed logs now at my feet."))


/obj/structure/flora/roguetree/wise/sanctified/proc/update_slow_aura()
	var/list/in_range = list()
	for(var/mob/living/carbon/human/H in range(5, src))
		if(H.patron && H.patron.type == /datum/patron/divine/dendor)
			continue
		if(H.stat != CONSCIOUS || H.incapacitated())
			continue
		in_range |= H
	var/list/to_remove = list()
	for(var/mob/living/M in tree_data.slowed_mobs)
		if(QDELETED(M) || !(M in in_range))
			if(!QDELETED(M))
				var/datum/status_effect/debuff/sanctified_tree_slow/SE = M.has_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
				if(SE)
					qdel(SE)
			to_remove += M
	tree_data.slowed_mobs -= to_remove
	for(var/mob/living/carbon/human/H in in_range)
		var/datum/status_effect/debuff/sanctified_tree_slow/SE = H.has_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
		if(SE)
			SE.refresh()
		else
			H.apply_status_effect(/datum/status_effect/debuff/sanctified_tree_slow)
			tree_data.slowed_mobs |= H

/obj/structure/flora/roguetree/wise/sanctified/proc/pulse_heal_aura()
	var/healed_any = FALSE
	for(var/mob/living/carbon/human/H in range(5, src))
		if(H.patron?.type != /datum/patron/divine/dendor)
			continue
		if(H.stat == DEAD)
			continue
		if(H.has_status_effect(/datum/status_effect/buff/healing))
			continue
		H.apply_status_effect(/datum/status_effect/buff/healing, 2.5)
		new /obj/effect/temp_visual/heal_rogue(get_turf(H))
		healed_any = TRUE
	for(var/mob/living/simple_animal/A in range(5, src))
		if(A.mob_biotypes & MOB_UNDEAD)
			continue
		if(A.stat == DEAD)
			continue
		if(A.has_status_effect(/datum/status_effect/buff/healing))
			continue
		A.apply_status_effect(/datum/status_effect/buff/healing, 2.5)
		new /obj/effect/temp_visual/heal_rogue(get_turf(A))
		healed_any = TRUE
	if(healed_any)
		playsound(get_turf(src), 'sound/magic/churn.ogg', 30, FALSE)


/obj/structure/flora/roguetree/wise/sanctified/MiddleClick(mob/user, params)
	if(!tree_data?.has_heal_aura)
		return
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type != /datum/patron/divine/dendor)
		return
	if(H.stat != CONSCIOUS || H.incapacitated())
		return
	if(H.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(H, span_warning("The Treefather's warmth already flows through me."))
		return
	var/cooldown_until = tree_data.heal_player_cooldowns[H.ckey]
	if(cooldown_until && world.time < cooldown_until)
		to_chat(H, span_warning("The tree's healing has not yet recovered for me — wait a moment."))
		return
	if(get_dist(H, src) > 1)
		to_chat(H, span_warning("I must be adjacent to the tree to draw from its power."))
		return
	to_chat(H, span_notice("I press my palms to the sacred bark and channel the Treefather's warmth."))
	if(!do_after(H, 3 SECONDS, target = src))
		return
	if(QDELETED(src))
		return
	if(H.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(H, span_warning("The Treefather's warmth already flows through me."))
		return
	H.apply_status_effect(/datum/status_effect/buff/healing, 2.5)
	new /obj/effect/temp_visual/heal_rogue(get_turf(H))
	playsound(get_turf(src), 'sound/magic/churn.ogg', 50, FALSE)
	to_chat(H, span_green("The Treefather's warmth flows into my wounds."))
	tree_data.heal_player_cooldowns[H.ckey] = world.time + 15 SECONDS

/datum/status_effect/debuff/sanctified_tree_slow
	id = "sanctified_tree_slow"
	duration = 8 SECONDS
	effectedstats = list("speed" = -4, "strength" = -2)

/datum/status_effect/debuff/sanctified_tree_slow/on_apply()
	. = ..()
	to_chat(owner, span_warning("An oppressive weight and gnarled roots press against my feet near this tree, causing my movement to slow down."))


/atom/movable/screen/alert/status_effect/debuff/soulbind_broken
	name = "Soulbind Broken"
	desc = "A piece of my soul has been torn away — my body and mind are diminished."
	icon_state = "debuff"

/datum/status_effect/debuff/soulbind_broken
	id = "soulbind_broken"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/soulbind_broken
	effectedstats = list("strength" = -4, "speed" = -4, "perception" = -4, "intelligence" = -4, "constitution" = -4)
	duration = -1

/datum/status_effect/debuff/soulbind_broken/on_apply()
	. = ..()
	playsound(owner, 'sound/magic/soulsteal.ogg', 80, FALSE)
	to_chat(owner, span_userdanger("A piece of my soul has been torn away — my sacred bond is shattered. I am incredibly weakened."))

/datum/status_effect/debuff/soulbind_broken/on_remove()
	. = ..()

/datum/stressevent/soulbind_tree_loss
	timer = 60 MINUTES
	stressadd = 5
	desc = span_boldred("My soulbound tree has fallen. I feel a permanent part of myself torn away.")


/obj/structure/flora/roguetree/wise/sanctified/proc/on_soulbind(mob/living/user)
	if(!istype(user, /mob/living/carbon/human))
		to_chat(user, span_warning("Only a living person may soulbind with this tree."))
		return
	var/mob/living/carbon/human/H = user
	if(H.ckey in tree_data.soulbound_players)
		to_chat(H, span_warning("I am already soulbound to this tree."))
		return
	if(HAS_TRAIT(H, "DENDOR_SOULBOUND"))
		to_chat(H, span_userdanger("My soul is already bound to a sanctified tree. I cannot bind twice."))
		return
	tree_data.awaiting_soulbind_ckey = H.ckey
	to_chat(H, span_warning("The ritual is set. To complete the soulbind, I must attack this tree with harm intent, my hand empty and my arm bleeding."))

/obj/structure/flora/roguetree/wise/sanctified/proc/attempt_soulbind(mob/living/carbon/human/H)
	if(!tree_data)
		return
	if(tree_data.awaiting_soulbind_ckey != H.ckey)
		return
	if(HAS_TRAIT(H, "DENDOR_SOULBOUND"))
		to_chat(H, span_userdanger("My soul is already bound — I cannot bind again."))
		return
	if(H.ckey in tree_data.soulbound_players)
		to_chat(H, span_warning("I am already soulbound to this tree."))
		return

	if(H.used_intent?.type != INTENT_HARM)
		to_chat(H, span_warning("I must punch the tree with my bloodied palm to complete the soulbind."))
		return
	if(H.get_active_held_item())
		to_chat(H, span_warning("My hand must be empty to complete the soulbind."))
		return
	var/obj/item/bodypart/r_arm = H.get_bodypart(BODY_ZONE_R_ARM)
	var/obj/item/bodypart/l_arm = H.get_bodypart(BODY_ZONE_L_ARM)
	if(!(r_arm?.get_bleed_rate() > 0) && !(l_arm?.get_bleed_rate() > 0))
		to_chat(H, span_warning("My arm must be bleeding to seal the soulbind in blood."))
		return

	to_chat(H, span_notice("I press my bleeding palm against the sacred bark, binding my soul to the sanctified tree."))
	if(!do_after(H, 3 SECONDS, target = src))
		return
	if(QDELETED(src) || QDELETED(H))
		return
	if(H.ckey in tree_data.soulbound_players || HAS_TRAIT(H, "DENDOR_SOULBOUND"))
		return

	var/confirm = alert(H, "You will bind your soul to this sanctified tree. If the tree is destroyed, you will suffer a permanent, irreversible penalty to all your attributes. Proceed?", "Soulbind", "Yes", "No")
	if(confirm != "Yes" || QDELETED(src) || QDELETED(H))
		to_chat(H, span_warning("I withdraw from the sacred pact."))
		return

	var/active_zone = H.active_hand_index == 1 ? BODY_ZONE_R_ARM : BODY_ZONE_L_ARM
	var/obj/item/bodypart/active_arm = H.get_bodypart(active_zone)
	if(active_arm)
		active_arm.receive_damage(50, 0)
	else
		H.adjustBruteLoss(50, 0)

	ADD_TRAIT(H, "DENDOR_SOULBOUND", "SOULBIND")
	tree_data.soulbound_players |= H.ckey
	tree_data.awaiting_soulbind_ckey = null

	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summon_lesser_dryad)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/lesser_dryad_special)
	H.mind.AddSpell(new /datum/action/cooldown/spell/minion_order/lesser_dryad)
	add_verb(H, /mob/living/carbon/human/proc/toggle_dendor_dryad_aggression)


	visible_message(span_boldwarning("[H.name]'s hand is pressed against the bark — a flash of gold seals the pact!"))
	playsound(get_turf(src), 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
	to_chat(H, span_green("My soul is bound to this sanctified tree. Should it fall, a part of me falls with it."))


/obj/structure/flora/roguetree/wise/sanctified/proc/perform_wedding(mob/living/user, obj/item/reagent_containers/food/snacks/grown/apple/A)
	var/mob/living/carbon/human/thegroom = null
	var/mob/living/carbon/human/thebride = null
	for(var/bite_name in A.bitten_names)
		var/found = FALSE
		for(var/mob/M in viewers(src, 7))
			if(!ishuman(M)) continue
			var/mob/living/carbon/human/C = M
			if(C.stat == DEAD) continue
			if(!C.client) continue
			if(C.marriedto) continue
			if(C.real_name == bite_name)
				if(!thegroom)
					thegroom = C
				else if(!thebride)
					thebride = C
				found = TRUE
				break
		if(found && thegroom && thebride)
			break

	if(!(thegroom && thebride))
		A.become_rotten()
		to_chat(user, span_danger("The Treefather's blessing falters — the souls who have bitten the fruit are not present or have already been wed. The apple rots."))
		tree_data.wedding_active = FALSE
		tree_data.wedding_officiant_ckey = null
		return

	var/surname = reject_bad_name(input(user, "Enter a shared surname for the couple:", "Nature's Union") as text|null)
	if(QDELETED(src) || QDELETED(user))
		return
	if(!surname || !length(trim(surname)))
		surname = thegroom.dna.species.random_surname()

	priority_announce("[thegroom.real_name] and [thebride.real_name] have been wed beneath the Treefather's boughs!", title = "Nature's Union!", sound = 'sound/misc/bell.ogg')

	var/list/titles = list("Sir", "Ser", "Dame", "Lord", "Lady", "Knight-Captain", "Duke", "Duchess", "Father", "Mother", "Brother", "Sister", "Prelate", "Devotee", "Votary")

	var/list/groom_name_parts = splittext(thegroom.real_name, " ")
	var/title_found = (titles.Find(groom_name_parts[1]) != 0)
	if(title_found)
		thegroom.real_name = "[groom_name_parts[1]] [groom_name_parts[2]] [surname]"
	else
		thegroom.real_name = "[groom_name_parts[1]] [surname]"

	var/list/bride_name_parts = splittext(thebride.real_name, " ")
	title_found = (titles.Find(bride_name_parts[1]) != 0)
	if(title_found)
		thebride.real_name = "[bride_name_parts[1]] [bride_name_parts[2]] [surname]"
	else
		thebride.real_name = "[bride_name_parts[1]] [surname]"

	to_chat(thegroom, span_notice("Your new shared surname is [surname]."))
	to_chat(thebride, span_notice("Your new shared surname is [surname]."))

	thegroom.marriedto = thebride.real_name
	thebride.marriedto = thegroom.real_name
	thegroom.adjust_triumphs(1)
	thebride.adjust_triumphs(1)

	visible_message(span_green("The [src.name] blazes with golden light — Dendor and Eora both bless this union!"))
	playsound(get_turf(src), 'sound/misc/bell.ogg', 80, FALSE)
	qdel(A)
	tree_data.wedding_active = FALSE
	tree_data.wedding_officiant_ckey = null

/obj/structure/flora/roguetree/wise/sanctified/examine(mob/user)
	. = ..()
	var/tree_count = 0
	for(var/obj/structure/flora/newtree/T in range(5, src))
		if(!T.burnt)
			tree_count++
	for(var/obj/structure/flora/roguetree/T in range(5, src))
		if(istype(T, /obj/structure/flora/roguetree/wise) || istype(T, /obj/structure/flora/roguetree/burnt) || istype(T, /obj/structure/flora/roguetree/stump))
			continue
		tree_count++
	. += span_info("[src] draws strength from [tree_count] nearby living tree\s, granting [integrity_bonus] bonus integrity.")
	. += span_info("Integrity: [round(obj_integrity)]/[max_integrity]")
	if(show_ritual_hints)
		. += span_info("Open the ritual menu with the Dendor amulet to begin any druidic ritual, or start the 'Nature's Union' wedding ceremony; the betrothed must each bite the same apple once and offer it to the tree to seal the pact.")
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	if(H.patron?.type != /datum/patron/divine/dendor)
		return
	if(show_ritual_hints)
		. += span_notice("Hold the Dendor amulet against this tree to start or cancel a Treefather bounty.")
		. += span_notice("Alternatively, touch-intent with an empty hand while wearing the amulet opens the ritual menu.")
		. += span_notice("To offer while a bounty is active, click the tree with the required item in-hand.")
	if(show_ritual_hints && tree_data?.active_ritual)
		. += span_notice("Active bounty: [get_ritual_display_name(tree_data.active_ritual)]")
		var/list/req = get_required_offerings(tree_data.active_ritual)
		for(var/key in req)
			var/current = tree_data.ritual_progress[key] || 0
			var/needed = req[key]
			if(current >= needed)
				. += span_notice("  [get_offering_desc(key)]: [current]/[needed] (fulfilled)")
			else
				. += span_warning("  [get_offering_desc(key)]: [current]/[needed]")
	if(tree_data?.has_slow_aura)
		. += span_info("A guardian ward repels those who would defile this grove.")
	if(tree_data?.has_heal_aura)
		. += span_info("A healing aura emanates from this tree. Middle-click the tree while adjacent to channel its healing energies.")

/obj/structure/flora/roguetree/wise/sanctified/attack_hand(mob/user)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(tree_data?.awaiting_soulbind_ckey && H.ckey == tree_data.awaiting_soulbind_ckey)
			attempt_soulbind(H)
			return
		if(!H.get_active_held_item())
			var/has_dendor_amulet = istype(H.get_item_by_slot(SLOT_NECK), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_WRISTS), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_RING), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_GLOVES), /obj/item/clothing/neck/roguetown/psicross/dendor)
			if(has_dendor_amulet)
				if(H.patron?.type != /datum/patron/divine/dendor)
					to_chat(H, span_warning("Only a follower of Dendor may commune with this sacred tree."))
					return
				open_ritual_menu(H)
				return
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/attackby(obj/item/I, mob/living/user, params)
	if(tree_data?.wedding_active && istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		var/obj/item/reagent_containers/food/snacks/grown/apple/A = I
		if(A.bitten_names.len < 2)
			to_chat(user, span_warning("Both partners must bite the apple before offering it to the tree."))
			return
		perform_wedding(user, A)
		return

	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/dendor))
		if(!istype(user, /mob/living/carbon/human))
			return
		var/mob/living/carbon/human/H = user
		if(H.patron?.type != /datum/patron/divine/dendor)
			to_chat(user, span_warning("Only a follower of Dendor may commune with this sacred tree."))
			return
		open_ritual_menu(user)
		return

	if(tree_data?.active_ritual && istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.patron?.type == /datum/patron/divine/dendor)
			if(offer_item(user))
				return
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/obj_destruction(damage_flag)
	set_light(0)
	visible_message(span_warning("The sanctified tree's golden light dies as it falls — the Treefather's blessing is broken!"))
	var/obj/item/grown/log/tree/blessed_log = new(loc)
	blessed_log.bless_log()
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/wise
	name = "sanctified wise tree"
	desc = "An ancient sacred tree directly blessed by a Dendorite acolyte. The Treefather's power flows through its roots — it radiates healing and repels those who would defile the grove — but its deeper mysteries are locked away."
	show_ritual_hints = FALSE

/obj/structure/flora/roguetree/wise/sanctified/wise/Initialize(mapload)
	. = ..()
	tree_data.has_slow_aura = TRUE
	tree_data.has_heal_aura = TRUE
	set_light(5, 5, 5, l_color = "#44AA44")
	add_filter("sanctified_outline", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 60, "size" = 1))

/obj/structure/flora/roguetree/wise/sanctified/wise/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/dendor))
		to_chat(user, span_warning("This blessed tree holds no further rites — its power is already given."))
		return
	if(istype(I, /obj/item/clothing/head/peaceflower))
		to_chat(user, span_warning("Only a fully sanctified tree may officiate a wedding ceremony."))
		return
	return ..()

/obj/structure/flora/roguetree/wise/sanctified/wise/attack_hand(mob/user)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(!H.get_active_held_item())
			var/has_dendor_amulet = istype(H.get_item_by_slot(SLOT_NECK), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_WRISTS), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_RING), /obj/item/clothing/neck/roguetown/psicross/dendor) || \
									istype(H.get_item_by_slot(SLOT_GLOVES), /obj/item/clothing/neck/roguetown/psicross/dendor)
			if(has_dendor_amulet)
				to_chat(H, span_warning("This blessed tree holds no further rites — its power is already given."))
				return
	return ..()
