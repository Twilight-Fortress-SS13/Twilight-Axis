/datum/vampire_project/vitae_collar
	display_name = "Кровавый Ошейник"
	description = "Зачарованный ошейник привязывает витэ смертного к Тигелю: лишает заклинаний и чудес, сковывает ноги и понемногу сцеживает кровь в чашу."
	mechanics_description = "Блокирует заклинания, чудеса и бег. Раз в минуту откачивает витэ в Тигель с КПД 70%, не опуская кровь до урона кислородом. Действует только в пределах Поместья Вампира; снять можно только парным ключом."
	category = TA_CRUCIBLE_CATEGORY_SUMMONING
	total_cost = TA_CRUCIBLE_VITAE_COLLAR_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/vitae_collar/on_complete(obj/structure/vampire/bloodpool/creation_point)
	var/turf/drop_turf = get_turf(creation_point)
	var/obj/item/clothing/neck/roguetown/collar/vitae_collar/collar = new(drop_turf)
	var/obj/item/vitae_collar_key/key = new(drop_turf)
	collar.pool_ref = WEAKREF(creation_point)
	collar.key_ref = WEAKREF(key)
	creation_point.visible_message(span_notice("Кровь тигля густеет, и на камни падают ошейник и парный к нему ключ."))

/obj/item/clothing/neck/roguetown/collar/vitae_collar
	name = "кровавый ошейник"
	desc = "Холодный металл в тёмных камнях. Он едва слышно гудит голодом тигля."
	icon_state = "manabindingcollar"
	item_state = "manabindingcollar"
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NONE
	var/datum/weakref/pool_ref
	var/datum/weakref/key_ref
	var/mob/living/carbon/human/wearer
	var/effects_active = FALSE
	COOLDOWN_DECLARE(harvest_cooldown)

/obj/item/clothing/neck/roguetown/collar/vitae_collar/Destroy()
	unbind_wearer()
	pool_ref = null
	key_ref = null
	return ..()

/obj/item/clothing/neck/roguetown/collar/vitae_collar/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Пока надет в Поместье Вампира: блокирует магию, чудеса и бег.")
	. += span_info("Раз в минуту откачивает витэ хозяина в Тигель.")
	. += span_info("Снять можно только парным ключом.")

/obj/item/clothing/neck/roguetown/collar/vitae_collar/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(slot == SLOT_NECK && ishuman(user))
		bind_wearer(user)
	else
		unbind_wearer()

/obj/item/clothing/neck/roguetown/collar/vitae_collar/dropped(mob/user, silent)
	. = ..()
	unbind_wearer()

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/bind_wearer(mob/living/carbon/human/new_wearer)
	if(wearer == new_wearer)
		return
	unbind_wearer()
	wearer = new_wearer
	ADD_TRAIT(src, TRAIT_NODROP, TA_VITAE_COLLAR_TRAIT_SOURCE)
	RegisterSignal(wearer, COMSIG_HUMAN_LIFE, PROC_REF(on_wearer_life))
	RegisterSignal(wearer, COMSIG_ENTER_AREA, PROC_REF(on_wearer_area))
	RegisterSignal(wearer, COMSIG_PARENT_QDELETING, PROC_REF(on_wearer_deleted))
	update_effects()

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/unbind_wearer()
	if(!wearer)
		return
	UnregisterSignal(wearer, list(COMSIG_HUMAN_LIFE, COMSIG_ENTER_AREA, COMSIG_PARENT_QDELETING))
	set_effects(FALSE, silent = TRUE)
	REMOVE_TRAIT(src, TRAIT_NODROP, TA_VITAE_COLLAR_TRAIT_SOURCE)
	wearer = null

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/on_wearer_deleted(datum/source)
	SIGNAL_HANDLER
	unbind_wearer()

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/on_wearer_area(datum/source)
	SIGNAL_HANDLER
	update_effects()

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/update_effects()
	if(!wearer)
		return
	set_effects(istype(get_area(wearer), /area/rogue/indoors/vampire_manor))

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/set_effects(active, silent = FALSE)
	if(active == effects_active)
		return
	effects_active = active
	if(active)
		ADD_TRAIT(wearer, TRAIT_NORUN, TA_VITAE_COLLAR_TRAIT_SOURCE)
		ADD_TRAIT(wearer, TRAIT_SPELLCOCKBLOCK, TA_VITAE_COLLAR_TRAIT_SOURCE)
		if(wearer.m_intent == MOVE_INTENT_RUN)
			INVOKE_ASYNC(wearer, TYPE_PROC_REF(/mob, toggle_rogmove_intent), MOVE_INTENT_WALK, TRUE)
		if(!silent)
			to_chat(wearer, span_warning("Ошейник на моей шее наливается теплом и берёт надо мной власть."))
		return
	REMOVE_TRAIT(wearer, TRAIT_NORUN, TA_VITAE_COLLAR_TRAIT_SOURCE)
	REMOVE_TRAIT(wearer, TRAIT_SPELLCOCKBLOCK, TA_VITAE_COLLAR_TRAIT_SOURCE)
	if(!silent)
		to_chat(wearer, span_notice("Вдали от поместья ошейник остывает и слабеет."))

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/on_wearer_life(mob/living/carbon/human/source)
	SIGNAL_HANDLER
	if(!effects_active || source.stat == DEAD || !COOLDOWN_FINISHED(src, harvest_cooldown))
		return
	COOLDOWN_START(src, harvest_cooldown, TA_VITAE_COLLAR_HARVEST_INTERVAL)
	if(source.bleed_rate > 0 || (NOBLOOD in source.dna?.species?.species_traits))
		return
	harvest(source)

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/get_pool()
	var/obj/structure/vampire/bloodpool/pool = pool_ref?.resolve()
	if(pool)
		return pool
	var/nearest_distance = INFINITY
	for(var/obj/structure/vampire/bloodpool/candidate in GLOB.vampire_objects)
		var/distance = get_dist(wearer, candidate)
		if(candidate.z != wearer.z || distance >= nearest_distance)
			continue
		nearest_distance = distance
		pool = candidate
	if(pool)
		pool_ref = WEAKREF(pool)
	return pool

/obj/item/clothing/neck/roguetown/collar/vitae_collar/proc/harvest(mob/living/carbon/human/victim)
	var/obj/structure/vampire/bloodpool/pool = get_pool()
	if(!pool || pool.get_cup_space() <= 0)
		return

	var/vitae_multiplier = (victim.mind && !victim.clan) ? CLIENT_VITAE_MULTIPLIER : 1
	var/available_vitae = victim.bloodpool * vitae_multiplier
	var/spare_blood = victim.blood_volume - TA_VITAE_COLLAR_BLOOD_FLOOR
	if(available_vitae <= 0 || spare_blood <= 0)
		return

	var/harvested
	if(available_vitae >= TA_VITAE_COLLAR_HARVEST_THRESHOLD)
		harvested = TA_VITAE_COLLAR_HARVEST_THRESHOLD
		victim.blood_volume = TA_VITAE_COLLAR_BLOOD_FLOOR
		to_chat(victim, span_userdanger("Ошейник вспыхивает жаром на моей шее, вытягивая силы!"))
	else
		harvested = min(spare_blood * TA_CRUCIBLE_DONATION_VITAE / TA_CRUCIBLE_DONATION_BLOOD, available_vitae)
		victim.blood_volume -= harvested * TA_CRUCIBLE_DONATION_BLOOD / TA_CRUCIBLE_DONATION_VITAE
		to_chat(victim, span_warning("Ошейник холодит шею, забирая часть моей крови."))

	victim.adjust_bloodpool(-CEILING(harvested / vitae_multiplier, 1))
	pool.receive_vitae(harvested * TA_VITAE_COLLAR_EFFICIENCY)

/obj/item/vitae_collar_key
	name = "ключ от ошейника"
	desc = "Маленький витой ключ, тёплый на ощупь. Он выкован вместе с одним-единственным ошейником и к другим не подходит."
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "vampkey"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/items/gems (1).ogg'
	throwforce = 0
	dropshrink = 0.75
	grid_height = 32
	grid_width = 32

/obj/item/vitae_collar_key/attack(mob/living/M, mob/living/user)
	if(!ishuman(M))
		return ..()
	var/mob/living/carbon/human/target = M
	var/obj/item/clothing/neck/roguetown/collar/vitae_collar/collar = target.get_item_by_slot(SLOT_NECK)
	if(!istype(collar))
		return ..()
	if(collar.key_ref?.resolve() != src)
		to_chat(user, span_warning("Этот ключ не подходит к ошейнику [target]."))
		return
	to_chat(user, span_notice("Я подношу ключ к ошейнику [target]..."))
	if(!do_mob(user, target, 3 SECONDS, can_move = FALSE))
		return
	if(QDELETED(src) || QDELETED(collar) || target.get_item_by_slot(SLOT_NECK) != collar)
		return
	if(!target.dropItemToGround(collar, force = TRUE))
		return
	target.visible_message(
		span_notice("Ошейник со щелчком открывается и падает с шеи [target]."),
		span_notice("Ошейник со щелчком открывается и падает с моей шеи."),
	)
	playsound(target, 'sound/items/pickgood1.ogg', 30, TRUE)
