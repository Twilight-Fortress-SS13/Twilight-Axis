#define VITAE_COLLAR_TRAIT_SOURCE "vitae_collar"
#define VITAE_COLLAR_RITUAL_COST 3000
#define VITAE_COLLAR_HARVEST_THRESHOLD 5000
#define VITAE_COLLAR_EFFICIENCY 0.7
#define VITAE_COLLAR_BLOOD_FLOOR_BUFFER 10
#define VITAE_COLLAR_BLOOD_VITAE_RATIO 7.5
#define VITAE_COLLAR_CHECK_INTERVAL 1 MINUTES

GLOBAL_LIST_EMPTY(vampire_bloodpools)

/obj/structure/vampire/bloodpool/Initialize()
	. = ..()
	available_project_types += /datum/vampire_project/vitae_collar
	GLOB.vampire_bloodpools += src

/obj/structure/vampire/bloodpool/Destroy()
	GLOB.vampire_bloodpools -= src
	return ..()

#define TA_VITAE_COLLAR_CRUCIBLE_MAX_BLOOD 20000 // mirrors CRUCIBLE_MAX_BLOOD, which bloodpool.dm #undefs at file scope
/obj/structure/vampire/bloodpool/proc/ta_receive_passive_vitae(amount)
	if(amount <= 0)
		return
	current = min(current + amount, TA_VITAE_COLLAR_CRUCIBLE_MAX_BLOOD)
	SStgui.update_uis(src)
#undef TA_VITAE_COLLAR_CRUCIBLE_MAX_BLOOD

/datum/vampire_project/vitae_collar
	display_name = "Summon Vitae Collar"
	description = "Bind a mortal's vitae to the crucible with an enchanted collar. While worn, it silences magic and miracles, cripples the wearer's legs, and quietly drains their surplus vitae back into the crucible."
	mechanics_description = "Blocks spellcasting and miracles, grants Decayed Flesh. Passively drains vitae into the crucible at 70% efficiency once the wearer's vitae nears 5000, keeping blood near their oxygen damage level. Works only within the Vampire Manor; removable only with its paired key."
	total_cost = VITAE_COLLAR_RITUAL_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/vitae_collar/on_complete(obj/structure/vampire/bloodpool/creation_point)
	var/obj/item/clothing/neck/roguetown/collar/vitae_collar/collar = new(get_turf(creation_point))
	collar.linked_bloodpool = creation_point
	var/obj/item/key/vitae_collar_key/key = new(get_turf(creation_point))
	collar.paired_key_ref = REF(key)
	creation_point.visible_message(span_notice("A vitae collar and its paired key crystallize from the crucible's depths."))

/obj/item/clothing/neck/roguetown/collar/vitae_collar
	name = "vitae collar"
	desc = "A cold metal collar studded with dark gems, humming faintly with the crucible's hunger."
	icon = 'modular_twilight_axis/icons/obj/leashes_collars.dmi'
	icon_state = "manabindingcollar"
	item_state = "manabindingcollar"
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NONE
	var/obj/structure/vampire/bloodpool/linked_bloodpool
	var/paired_key_ref
	var/next_check_time = 0
	var/effects_active = FALSE

/obj/item/clothing/neck/roguetown/collar/vitae_collar/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, VITAE_COLLAR_TRAIT_SOURCE)
	AddElement(/datum/element/vitae_collar)

/obj/item/clothing/neck/roguetown/collar/vitae_collar/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Пока надет: блокирует магию и чудеса, накладывает Гниющую плоть (нельзя бежать).")
	. += span_info("Периодически откачивает витэ хозяина в Тигель, если тот переполнен силой.")
	. += span_info("Действует только в пределах Поместья Вампира. Снять можно только парным ключом.")

/obj/item/key/vitae_collar_key
	name = "collar key"
	desc = "A small ornate key, warm to the touch. It was forged alongside a specific vitae collar and fits no other lock."

/obj/item/key/vitae_collar_key/attack(mob/living/carbon/human/target, mob/living/user)
	var/obj/item/clothing/neck/roguetown/collar/vitae_collar/collar = target.get_item_by_slot(SLOT_NECK)
	if(!istype(collar) || collar.paired_key_ref != REF(src))
		to_chat(user, span_warning("Этот ключ не подходит к ошейнику [target]."))
		return
	to_chat(user, span_notice("Я подношу ключ к ошейнику [target]..."))
	if(!do_mob(user, target, 3 SECONDS))
		return
	if(QDELETED(collar) || QDELETED(target) || target.get_item_by_slot(SLOT_NECK) != collar)
		return
	if(!target.dropItemToGround(collar, force = TRUE))
		return
	target.visible_message(
		span_notice("Ошейник со щелчком открывается и падает с шеи [target]."),
		span_notice("Ошейник со щелчком открывается и падает с моей шеи."),
	)
	playsound(target, 'sound/items/pickgood1.ogg', 30, TRUE)

/datum/element/vitae_collar
	element_flags = ELEMENT_DETACH

/datum/element/vitae_collar/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED), PROC_REF(on_equip_change))

/datum/element/vitae_collar/Detach(datum/source)
	UnregisterSignal(source, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
	return ..()

/datum/element/vitae_collar/proc/on_equip_change(obj/item/clothing/neck/roguetown/collar/vitae_collar/source, mob/living/carbon/human/user, slot)
	SIGNAL_HANDLER
	if(slot == SLOT_NECK && istype(user))
		source.next_check_time = 0
		RegisterSignal(user, COMSIG_HUMAN_LIFE, PROC_REF(on_wearer_life))
	else if(istype(user))
		UnregisterSignal(user, COMSIG_HUMAN_LIFE)
		REMOVE_TRAIT(user, TRAIT_NORUN, VITAE_COLLAR_TRAIT_SOURCE)
		REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, VITAE_COLLAR_TRAIT_SOURCE)
		source.effects_active = FALSE

/datum/element/vitae_collar/proc/on_wearer_life(mob/living/carbon/human/user)
	SIGNAL_HANDLER
	var/obj/item/clothing/neck/roguetown/collar/vitae_collar/collar = user.get_item_by_slot(SLOT_NECK)
	if(!istype(collar))
		UnregisterSignal(user, COMSIG_HUMAN_LIFE)
		return
	if(world.time < collar.next_check_time)
		return
	collar.next_check_time = world.time + VITAE_COLLAR_CHECK_INTERVAL

	var/in_manor = istype(get_area(user), /area/rogue/indoors/vampire_manor)
	if(in_manor != collar.effects_active)
		collar.effects_active = in_manor
		if(in_manor)
			ADD_TRAIT(user, TRAIT_NORUN, VITAE_COLLAR_TRAIT_SOURCE)
			ADD_TRAIT(user, TRAIT_SPELLCOCKBLOCK, VITAE_COLLAR_TRAIT_SOURCE)
			to_chat(user, span_warning("Ошейник на моей шее наливается теплом, вновь беря надо мной власть."))
		else
			REMOVE_TRAIT(user, TRAIT_NORUN, VITAE_COLLAR_TRAIT_SOURCE)
			REMOVE_TRAIT(user, TRAIT_SPELLCOCKBLOCK, VITAE_COLLAR_TRAIT_SOURCE)
			to_chat(user, span_notice("Вдали от поместья ошейник на миг остывает и слабеет."))

	if(!in_manor)
		return
	if(user.bleed_rate > 0)
		return

	try_harvest_vitae(collar, user)

/datum/element/vitae_collar/proc/get_nearest_bloodpool(atom/from)
	var/obj/structure/vampire/bloodpool/nearest
	var/nearest_dist = INFINITY
	for(var/obj/structure/vampire/bloodpool/pool as anything in GLOB.vampire_bloodpools)
		if(QDELETED(pool))
			continue
		var/dist = get_dist(from, pool)
		if(dist < nearest_dist)
			nearest_dist = dist
			nearest = pool
	return nearest

/datum/element/vitae_collar/proc/try_harvest_vitae(obj/item/clothing/neck/roguetown/collar/vitae_collar/collar, mob/living/carbon/human/user)
	var/obj/structure/vampire/bloodpool/pool = collar.linked_bloodpool
	if(QDELETED(pool))
		pool = get_nearest_bloodpool(user)
		if(!pool)
			return
		collar.linked_bloodpool = pool

	var/mortal_scale = user.mind && !user.clan
	var/effective_vitae = mortal_scale ? (user.bloodpool * CLIENT_VITAE_MULTIPLIER) : user.bloodpool
	var/floor_blood = user.getOxyLoss() + VITAE_COLLAR_BLOOD_FLOOR_BUFFER

	if(effective_vitae >= VITAE_COLLAR_HARVEST_THRESHOLD)
		harvest_vitae_amount(user, pool, VITAE_COLLAR_HARVEST_THRESHOLD, mortal_scale)
		if(user.blood_volume > floor_blood)
			user.blood_volume = floor_blood
		to_chat(user, span_userdanger("Ошейник вспыхивает жаром на моей шее, вытягивая силы!"))
		return

	if(user.blood_volume > floor_blood)
		var/blood_to_take = user.blood_volume - floor_blood
		user.blood_volume = floor_blood
		var/vitae_to_take = min(blood_to_take * VITAE_COLLAR_BLOOD_VITAE_RATIO, effective_vitae)
		if(vitae_to_take > 0)
			harvest_vitae_amount(user, pool, vitae_to_take, mortal_scale)
			to_chat(user, span_warning("Ошейник холодит шею, забирая часть моей крови."))

/datum/element/vitae_collar/proc/harvest_vitae_amount(mob/living/carbon/human/user, obj/structure/vampire/bloodpool/pool, vitae_amount, mortal_scale)
	var/bloodpool_cost = mortal_scale ? CEILING(vitae_amount / CLIENT_VITAE_MULTIPLIER, 1) : vitae_amount
	user.adjust_bloodpool(-bloodpool_cost)
	pool.ta_receive_passive_vitae(vitae_amount * VITAE_COLLAR_EFFICIENCY)

#undef VITAE_COLLAR_TRAIT_SOURCE
#undef VITAE_COLLAR_RITUAL_COST
#undef VITAE_COLLAR_HARVEST_THRESHOLD
#undef VITAE_COLLAR_EFFICIENCY
#undef VITAE_COLLAR_BLOOD_FLOOR_BUFFER
#undef VITAE_COLLAR_BLOOD_VITAE_RATIO
#undef VITAE_COLLAR_CHECK_INTERVAL
