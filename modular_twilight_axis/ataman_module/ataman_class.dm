/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/ataman_iron
	name = "iron crossbow"
	desc = "A sturdy crossbow whose lock and fittings are wrought from iron."
	smeltresult = /obj/item/ingot/iron

/datum/advclass/wretch/ataman
	name = "Атаман"
	tutorial = "Ты вёл горстку оборванцев-головорезов по глухим тропам и просёлкам, всегда мечтая о чём-то большем. Теперь ты пришёл в эти земли, чтобы установить собственные порядки - мечом, силком и петлёй, если придётся."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/wretch/ataman
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_PERFECT_TRACKER, TRAIT_CICERONE, TRAIT_ALCHEMY_EXPERT, TRAIT_SMITHING_EXPERT, TRAIT_MEDICINE_EXPERT, TRAIT_KEENEARS, TRAIT_SEEPRICES)
	maximum_possible_slots = 1
	extra_context = "Ты ведёшь собственную небольшую банду дорогой славы. Грабь, то, что можно награбить, а неограбляемое делай ограбляемым"
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/wretch/ataman/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	neck = /obj/item/clothing/neck/roguetown/coif
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	cloak = /obj/item/clothing/cloak/thief_cloak
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/iron
	gloves = /obj/item/clothing/gloves/roguetown/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		)

	if(H.mind)
		var/weapon_sets = list("Меч и щит", "Копьё и щит", "Лук и кинжал", "Булава, щит и арбалет")
		var/weapon_choice = input(H, "Выбери вооружение своей банды.", "Снаряжение Атамана") as anything in weapon_sets
		switch(weapon_choice)
			if("Меч и щит")
				sword_shield_equip(H)
			if("Копьё и щит")
				spear_shield_equip(H)
			if("Лук и кинжал")
				bow_dagger_equip(H)
			if("Булава, щит и арбалет")
				mace_shield_crossbow_equip(H)

		grant_ataman_spells(H)

/datum/outfit/job/roguetown/wretch/ataman/proc/sword_shield_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/sword/iron
	backr = /obj/item/rogueweapon/shield/wood
	beltr = /obj/item/rogueweapon/scabbard/sword
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)

/datum/outfit/job/roguetown/wretch/ataman/proc/spear_shield_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/spear
	backr = /obj/item/rogueweapon/shield/wood
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)

/datum/outfit/job/roguetown/wretch/ataman/proc/bow_dagger_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	beltl = /obj/item/quiver/arrows
	beltr = /obj/item/rogueweapon/huntingknife/idagger
	H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)

/datum/outfit/job/roguetown/wretch/ataman/proc/mace_shield_crossbow_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/rogueweapon/mace
	backr = /obj/item/rogueweapon/shield/wood
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/ataman_iron
	beltl = /obj/item/quiver/bolt/standard
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)

/datum/outfit/job/roguetown/wretch/ataman/proc/grant_ataman_spells(mob/living/carbon/human/H)
	H.mind.AddSpell(new /datum/action/cooldown/spell/ataman_ambush)
	H.mind.AddSpell(new /datum/action/cooldown/spell/ataman_trap)
	H.mind.AddSpell(new /datum/action/cooldown/spell/ataman_execute)
	H.mind.AddSpell(new /datum/action/cooldown/spell/ataman_exchange)

/datum/action/cooldown/spell/ataman_ambush
	name = "Set an Ambush"
	desc = "Spend seven undisturbed seconds placing a hidden ambush trigger. The first intruder to disturb it will be surrounded by my bandits. I can maintain no more than three ambushes at once."
	click_to_activate = TRUE
	self_cast_possible = FALSE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_SUMMON
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 3 MINUTES
	cast_range = 1
	associated_skill = null
	associated_stat = null
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ataman_ambush/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(ataman_active_ambush_count(H) >= ATAMAN_MAX_ACTIVE_AMBUSHES)
		if(feedback)
			H.balloon_alert(H, "three ambushes already set!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/ataman_ambush/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf || target_turf.density)
		return FALSE
	if(istype(target_turf, /turf/open/transparent/openspace))
		return FALSE
	if(ataman_turf_has_trap(target_turf))
		owner.balloon_alert(owner, "another trap is already here!")
		return FALSE
	var/area/rogue/place = get_area(target_turf)
	if(istype(place) && (place.town_area || place.keep_area))
		owner.balloon_alert(owner, "I cannot set an ambush here!")
		return FALSE
	var/spot_error = ataman_trap_spot_error(owner, target_turf)
	if(spot_error)
		owner.balloon_alert(owner, spot_error)
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || ataman_active_ambush_count(H) >= ATAMAN_MAX_ACTIVE_AMBUSHES)
		owner.balloon_alert(owner, "three ambushes already set!")
		return FALSE
	if(ataman_too_close_to_own(H, target_turf, H.ataman_active_ambushes, ATAMAN_TRAP_MIN_SPACING))
		owner.balloon_alert(owner, "too close to my other ambush!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/ataman_ambush/cast(atom/target)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(!target_turf || ataman_turf_has_trap(target_turf))
		H.balloon_alert(H, "another trap is already here!")
		return FALSE
	if(ataman_active_ambush_count(H) >= ATAMAN_MAX_ACTIVE_AMBUSHES)
		H.balloon_alert(H, "three ambushes already set!")
		return FALSE

	var/list/disguises = list(
		"Stone" = list("stone", "A piece of rough ground stone.", 'icons/roguetown/items/natural.dmi', "stone1"),
		"Clod of Earth" = list("clod", "A handful of earth.", 'icons/roguetown/items/natural.dmi', "clod1"),
		"Stick" = list("stick", "A tree branch perhaps.", 'icons/roguetown/items/natural.dmi', "stick1"),
	)
	var/choice = input(H, "What should the ambush look like?", "Set an Ambush") as null|anything in disguises
	if(!choice)
		return FALSE
	if(QDELETED(H) || H.z != target_turf.z || get_dist(H, target_turf) > cast_range || ataman_turf_has_trap(target_turf))
		if(!QDELETED(H))
			H.balloon_alert(H, "I can no longer set an ambush there!")
		return FALSE
	var/spot_error = ataman_trap_spot_error(H, target_turf)
	if(spot_error)
		H.balloon_alert(H, spot_error)
		return FALSE
	if(ataman_too_close_to_own(H, target_turf, H.ataman_active_ambushes, ATAMAN_TRAP_MIN_SPACING))
		H.balloon_alert(H, "too close to my other ambush!")
		return FALSE
	var/list/picked = disguises[choice]
	if(!ataman_trap_channel(H, target_turf))
		H.balloon_alert(H, "interrupted!")
		return FALSE
	if(QDELETED(H) || H.z != target_turf.z || get_dist(H, target_turf) > cast_range || ataman_turf_has_trap(target_turf) || ataman_trap_spot_error(H, target_turf) || ataman_too_close_to_own(H, target_turf, H.ataman_active_ambushes, ATAMAN_TRAP_MIN_SPACING))
		if(!QDELETED(H))
			H.balloon_alert(H, "I can no longer set an ambush there!")
		return FALSE
	. = ..()

	var/obj/structure/trap/ataman_ambush_stone/ambush = new(target_turf)
	ambush.disguise_as_prop(picked[1], picked[2], picked[3], picked[4])
	ambush.set_placer(H)
	to_chat(H, span_notice("I conceal [ambush] as [picked[1]]."))
	return TRUE

/datum/action/cooldown/spell/ataman_trap
	name = "Set a Snare"
	desc = "Spend seven undisturbed seconds burying a disguised trap. Anyone caught is mauled, left bleeding badly, and marked for my Finishing Blow until the mark fades. I can maintain no more than three traps at once."
	click_to_activate = TRUE
	self_cast_possible = FALSE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 2 MINUTES
	cast_range = 1
	associated_skill = /datum/skill/craft/traps
	associated_stat = null
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ataman_trap/get_adjusted_cooldown()
	var/mob/living/carbon/human/H = owner
	if(istype(H) && H.ataman_loot_tier >= 5)
		return 15 MINUTES
	return ..()

/datum/action/cooldown/spell/ataman_trap/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(ataman_active_trap_count(H) >= ATAMAN_MAX_ACTIVE_TRAPS)
		if(feedback)
			H.balloon_alert(H, "three traps already set!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/ataman_trap/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf || target_turf.density)
		return FALSE
	if(istype(target_turf, /turf/open/transparent/openspace))
		return FALSE
	if(ataman_turf_has_trap(target_turf))
		owner.balloon_alert(owner, "another trap is already here!")
		return FALSE
	var/area/rogue/place = get_area(target_turf)
	if(istype(place) && (place.town_area || place.keep_area))
		owner.balloon_alert(owner, "I cannot set a trap here!")
		return FALSE
	var/spot_error = ataman_trap_spot_error(owner, target_turf)
	if(spot_error)
		owner.balloon_alert(owner, spot_error)
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || ataman_active_trap_count(H) >= ATAMAN_MAX_ACTIVE_TRAPS)
		owner.balloon_alert(owner, "three traps already set!")
		return FALSE
	if(ataman_too_close_to_own(H, target_turf, H.ataman_active_traps, ATAMAN_TRAP_MIN_SPACING))
		owner.balloon_alert(owner, "too close to my other trap!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/ataman_trap/cast(atom/target)
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/target_turf = get_turf(target)
	if(!target_turf || ataman_turf_has_trap(target_turf))
		H.balloon_alert(H, "another trap is already here!")
		return FALSE
	if(ataman_active_trap_count(H) >= ATAMAN_MAX_ACTIVE_TRAPS)
		H.balloon_alert(H, "three traps already set!")
		return FALSE

	var/list/flavors = list(
		"Mantrap" = /obj/structure/trap/ataman_snare/beartrap_type,
		"Buried charge" = /obj/structure/trap/ataman_snare/bomb_type,
		"Stake pit" = /obj/structure/trap/ataman_snare/stakes_type,
	)
	var/choice = input(H, "Which trap will I set?", "Set a Snare") as null|anything in flavors
	if(!choice)
		return FALSE
	if(QDELETED(H) || H.z != target_turf.z || get_dist(H, target_turf) > cast_range || ataman_turf_has_trap(target_turf))
		if(!QDELETED(H))
			H.balloon_alert(H, "I can no longer set a trap there!")
		return FALSE
	var/spot_error = ataman_trap_spot_error(H, target_turf)
	if(spot_error)
		H.balloon_alert(H, spot_error)
		return FALSE
	if(ataman_too_close_to_own(H, target_turf, H.ataman_active_traps, ATAMAN_TRAP_MIN_SPACING))
		H.balloon_alert(H, "too close to my other trap!")
		return FALSE
	var/chosen_type = flavors[choice]
	if(!chosen_type)
		return FALSE
	if(!ataman_trap_channel(H, target_turf))
		H.balloon_alert(H, "interrupted!")
		return FALSE
	if(QDELETED(H) || H.z != target_turf.z || get_dist(H, target_turf) > cast_range || ataman_turf_has_trap(target_turf) || ataman_trap_spot_error(H, target_turf) || ataman_active_trap_count(H) >= ATAMAN_MAX_ACTIVE_TRAPS || ataman_too_close_to_own(H, target_turf, H.ataman_active_traps, ATAMAN_TRAP_MIN_SPACING))
		if(!QDELETED(H))
			H.balloon_alert(H, "I can no longer set a trap there!")
		return FALSE
	. = ..()

	var/obj/structure/trap/ataman_snare/snare = new chosen_type(target_turf)
	snare.set_placer(H)
	to_chat(H, span_notice("I bury [snare] in the ground."))
	return TRUE

/proc/ataman_weapon_skill(obj/item/weapon)
	if(istype(weapon, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		return /datum/skill/combat/bows
	return weapon?.associated_skill

/proc/ataman_get_owned_mark(mob/living/target, mob/living/carbon/human/marker)
	if(!target || !marker)
		return null
	var/datum/component/ataman_marked/mark = target.GetComponent(/datum/component/ataman_marked)
	if(mark?.get_marker() != marker)
		return null
	return mark

/proc/ataman_can_finish_with(mob/living/carbon/human/user, obj/item/weapon, feedback = FALSE)
	var/weapon_skill = ataman_weapon_skill(weapon)
	if(weapon_skill && user.get_skill_level(weapon_skill) >= SKILL_LEVEL_EXPERT)
		return TRUE
	if(feedback)
		user.balloon_alert(user, "I lack mastery with this weapon!")
	return FALSE

/datum/action/cooldown/spell/ataman_execute
	name = "Finishing Blow"
	desc = "Prepare my next expert melee strike or aimed/arc projectile against a target bearing my mark. A clean hit consumes the mark and lands with all my weight behind it, though armor protects as it always does."
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 4 SECONDS
	associated_skill = null
	associated_stat = null
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ataman_execute/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(H.has_status_effect(/datum/status_effect/buff/ataman_finishing_blow))
		if(feedback)
			H.balloon_alert(H, "a finishing blow is already prepared!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/ataman_execute/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H) || H.has_status_effect(/datum/status_effect/buff/ataman_finishing_blow))
		return FALSE
	H.apply_status_effect(/datum/status_effect/buff/ataman_finishing_blow)
	to_chat(H, span_notice("Я приготовился нанести сокрушительный удар!"))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/ataman_finishing_blow
	name = "Finishing Blow"
	desc = "My next expert strike or aimed/arc shot against one of my marked targets will finish the hunt."
	icon_state = "buff"

/datum/status_effect/buff/ataman_finishing_blow
	id = "ataman_finishing_blow"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ataman_finishing_blow
	duration = 10 SECONDS
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE

	var/obj/item/pending_melee_weapon
	var/datum/weakref/pending_melee_target_ref
	var/datum/weakref/pending_mark_ref

	var/obj/item/gun/pending_gun
	var/datum/weakref/pending_ranged_target_ref

/datum/status_effect/buff/ataman_finishing_blow/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(on_melee_swing))
	RegisterSignal(owner, COMSIG_MOB_ITEM_AFTERATTACK, PROC_REF(on_ranged_attack))

/datum/status_effect/buff/ataman_finishing_blow/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, COMSIG_MOB_ITEM_AFTERATTACK))
	clear_pending_melee()
	clear_pending_ranged()
	. = ..()

/datum/status_effect/buff/ataman_finishing_blow/proc/on_melee_swing(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(user != owner || !isliving(target) || !weapon || user.used_intent?.tranged)
		return
	var/mob/living/carbon/human/H = owner
	var/datum/component/ataman_marked/mark = ataman_get_owned_mark(target, H)
	if(!mark || !ataman_can_finish_with(H, weapon, TRUE))
		return
	clear_pending_melee()
	pending_melee_weapon = weapon
	pending_melee_target_ref = WEAKREF(target)
	pending_mark_ref = WEAKREF(mark)
	RegisterSignal(weapon, COMSIG_ITEM_ATTACK_SUCCESS, PROC_REF(on_melee_success))

/datum/status_effect/buff/ataman_finishing_blow/proc/on_melee_success(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(source != pending_melee_weapon || user != owner || pending_melee_target_ref?.resolve() != target)
		return
	var/datum/component/ataman_marked/mark = pending_mark_ref?.resolve()
	if(QDELETED(mark) || ataman_get_owned_mark(target, owner) != mark)
		clear_pending_melee()
		return
	addtimer(CALLBACK(src, PROC_REF(complete_finisher), target, mark), 0)

/datum/status_effect/buff/ataman_finishing_blow/proc/clear_pending_melee()
	if(pending_melee_weapon && !QDELETED(pending_melee_weapon))
		UnregisterSignal(pending_melee_weapon, COMSIG_ITEM_ATTACK_SUCCESS)
	pending_melee_weapon = null
	pending_melee_target_ref = null
	pending_mark_ref = null

/datum/status_effect/buff/ataman_finishing_blow/proc/complete_finisher(mob/living/target, datum/component/ataman_marked/mark)
	if(!QDELETED(target) && !QDELETED(mark) && ataman_get_owned_mark(target, owner) == mark)
		qdel(mark)
	if(owner && !QDELETED(owner))
		owner.visible_message(
			span_danger("[owner]'s finishing blow crashes into [target]!"),
			span_notice("My finishing blow crashes into [target]!"),
		)
		owner.remove_status_effect(/datum/status_effect/buff/ataman_finishing_blow)

/datum/status_effect/buff/ataman_finishing_blow/proc/on_ranged_attack(mob/living/source, atom/target, obj/item/item, proximity, params)
	SIGNAL_HANDLER
	if(source != owner || !istype(item, /obj/item/gun) || !isliving(target))
		return
	if(!istype(source.used_intent, /datum/intent/shoot) && !istype(source.used_intent, /datum/intent/arc))
		return
	var/mob/living/carbon/human/H = owner
	var/mob/living/living_target = target
	var/datum/component/ataman_marked/mark = ataman_get_owned_mark(living_target, H)
	if(!mark || !ataman_can_finish_with(H, item, TRUE))
		return
	clear_pending_ranged()
	pending_gun = item
	pending_ranged_target_ref = WEAKREF(living_target)
	RegisterSignal(pending_gun, COMSIG_PROJECTILE_BEFORE_FIRE, PROC_REF(on_projectile_created))

/datum/status_effect/buff/ataman_finishing_blow/proc/on_projectile_created(obj/item/gun/source, obj/projectile/projectile, atom/original_target)
	SIGNAL_HANDLER
	var/mob/living/expected_target = pending_ranged_target_ref?.resolve()
	if(source != pending_gun || projectile.firer != owner || original_target != expected_target)
		return
	var/datum/component/ataman_marked/mark = ataman_get_owned_mark(expected_target, owner)
	if(!mark)
		clear_pending_ranged()
		return
	UnregisterSignal(source, COMSIG_PROJECTILE_BEFORE_FIRE)
	projectile.AddComponent(/datum/component/ataman_finishing_projectile, owner, expected_target, mark)
	addtimer(CALLBACK(src, PROC_REF(consume_ranged_preparation)), 0)

/datum/status_effect/buff/ataman_finishing_blow/proc/clear_pending_ranged()
	if(pending_gun && !QDELETED(pending_gun))
		UnregisterSignal(pending_gun, COMSIG_PROJECTILE_BEFORE_FIRE)
	pending_gun = null
	pending_ranged_target_ref = null

/datum/status_effect/buff/ataman_finishing_blow/proc/consume_ranged_preparation()
	if(owner && !QDELETED(owner))
		owner.remove_status_effect(/datum/status_effect/buff/ataman_finishing_blow)
