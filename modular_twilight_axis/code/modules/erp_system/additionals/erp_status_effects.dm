/datum/status_effect/mouth_full
	id = "mouth_full"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/mouth_full
	duration = -1

/atom/movable/screen/alert/status_effect/mouth_full
	name = "Full Mouth"
	desc = "Click to swallow a bit."

/atom/movable/screen/alert/status_effect/mouth_full/Click(location, control, params)
	..()

	var/mob/living/user = usr
	if(!istype(user))
		return FALSE

	var/datum/erp_sex_organ/mouth/M = user.get_erp_organ(SEX_ORGAN_MOUTH)
	if(M)
		M.swallow(5)

	return FALSE

/datum/status_effect/love_potion
	id = "love_potion"
	duration = 48 MINUTES
	tick_interval = 0
	alert_type = /atom/movable/screen/alert/status_effect/love_potion

	var/datum/weakref/target_ref

/datum/status_effect/love_potion/proc/get_target()
	if(!target_ref)
		return null
	var/mob/living/T = target_ref.resolve()
	if(!T || QDELETED(T))
		target_ref = null
		return null
	return T

/datum/status_effect/love_potion/proc/_sync_relationship(add)
	var/mob/living/H = owner
	if(!istype(H))
		return

	var/mob/living/T = get_target()
	if(!T)
		return

	var/datum/component/relationships/R = H.GetComponent(/datum/component/relationships)
	if(!R && add)
		R = H.AddComponent(/datum/component/relationships)
	if(!R)
		return

	if(add)
		R.add_relation_mob(T, REL_LOVE_POTION)
	else
		R.remove_relation_mob(T, REL_LOVE_POTION)

/datum/status_effect/love_potion/on_apply()
	. = ..()
	if(!owner)
		return

	_sync_relationship(TRUE)

	var/mob/living/H = owner
	var/mob/living/T = get_target()
	if(T)
		to_chat(H, span_love("Вы чувствуете непреодолимую тягу к [T]."))
		update_alert()
	else
		to_chat(H, span_love("Ваше сердце странно дрожит..."))

/datum/status_effect/love_potion/on_remove()
	_sync_relationship(FALSE)
	if(owner)
		to_chat(owner, span_notice("Чары любви спадают."))
	return ..()

/datum/status_effect/love_potion/proc/set_target(mob/living/new_target)
	if(!owner)
		return

	var/mob/living/old = get_target()
	if(old && old != new_target)
		_sync_relationship(FALSE)

	if(!new_target || QDELETED(new_target))
		target_ref = null
		update_alert()
		return

	target_ref = WEAKREF(new_target)
	_sync_relationship(TRUE)

	var/mob/living/H = owner
	to_chat(H, span_love("Ваше сердце тянется к [new_target]."))
	update_alert()

/datum/status_effect/love_potion/proc/update_alert()
	var/mob/living/T = get_target()
	if(!owner || !T)
		return
	var/atom/movable/screen/alert/status_effect/love_potion/A = linked_alert
	if(A)
		A.desc = "Вы чувствуете непреодолимую тягу к [T]."

/atom/movable/screen/alert/status_effect/love_potion
	name = "love sickness"
	desc = "Непреодолимая тяга к тому, кого вы любите."

#define ERP_COATING_ZONE_GROIN "groin"
#define ERP_COATING_ZONE_CHEST "chest"
#define ERP_COATING_ZONE_BODY  "body"
#define ERP_COATING_DRY_AFTER (4 MINUTES)

/datum/status_effect/erp_coating
	status_type = STATUS_EFFECT_UNIQUE
	tick_interval = ERP_COATING_DRY_AFTER
	duration = -1
	var/coating_zone = "body"
	var/has_dried_up = FALSE
	var/datum/reagents/reagents
	var/reagents_capacity = 30

/datum/status_effect/erp_coating/on_creation(mob/living/new_owner, capacity = 30)
	. = ..()
	reagents_capacity = max(5, capacity)

	if(!reagents)
		reagents = new /datum/reagents(reagents_capacity)
		reagents.my_atom = src

/datum/status_effect/erp_coating/Destroy()
	if(reagents)
		qdel(reagents)
		reagents = null
	return ..()

/datum/status_effect/erp_coating/on_apply()
	. = ..()
	if(owner)
		RegisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(_on_clean_act), override = TRUE)
	has_dried_up = FALSE
	return TRUE

/datum/status_effect/erp_coating/on_remove()
	if(owner)
		UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(_on_clean_act))
	return ..()

/datum/status_effect/erp_coating/tick()
	has_dried_up = TRUE

/datum/status_effect/erp_coating/proc/_on_clean_act(datum/source, clean)
	SIGNAL_HANDLER
	if(clean < CLEAN_WEAK || QDELETED(owner))
		return FALSE

	if(reagents)
		reagents.clear_reagents()

	qdel(src)
	return TRUE

/datum/status_effect/erp_coating/proc/is_empty()
	return !reagents || reagents.total_volume <= 0

/datum/status_effect/erp_coating/proc/add_from(datum/reagents/R, amount = null)
	if(!reagents || !R || R.total_volume <= 0)
		return 0

	var/take = amount
	if(!isnum(take) || take <= 0)
		take = R.total_volume

	take = min(take, R.total_volume)
	R.trans_to(reagents, take, 1, TRUE, TRUE)

	has_dried_up = FALSE
	tick_interval = world.time + initial(tick_interval)

	return take

/datum/status_effect/erp_coating/proc/get_main_reagent_name()
	if(!reagents || reagents.total_volume <= 0)
		return null
	var/datum/reagent/top = reagents.get_master_reagent()
	return top ? top.name : null

/datum/status_effect/erp_coating/groin
	id = "erp_coating_groin"
	coating_zone = "groin"

/datum/status_effect/erp_coating/chest
	id = "erp_coating_chest"
	coating_zone = "chest"

/datum/status_effect/erp_coating/face
	id = "erp_coating_face"
	coating_zone = "face"

#undef ERP_COATING_ZONE_GROIN
#undef ERP_COATING_ZONE_CHEST
#undef ERP_COATING_ZONE_BODY

/datum/status_effect/knot_tied
	id = "knot_tied"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_tied
	effectedstats = list(STATKEY_STR = -1, STATKEY_WIL = -2, STATKEY_SPD = -2, STATKEY_INT = -3)

/atom/movable/screen/alert/status_effect/knot_tied
	name = "Knotted"
	icon_state = "knotted"


/datum/status_effect/knot_fucked_stupid
	id = "knot_fucked_stupid"
	duration = 2 MINUTES
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_fucked_stupid
	effectedstats = list(STATKEY_INT = -10)

/atom/movable/screen/alert/status_effect/knot_fucked_stupid
	name = "Fucked Stupid"
	desc = "Mmmph I can't think straight..."
	icon_state = "knotted_stupid"

/datum/status_effect/knot_gaped
	id = "knot_gaped"
	duration = 60 SECONDS
	tick_interval = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knot_gaped
	effectedstats = list(STATKEY_STR = -1, STATKEY_SPD = -2, STATKEY_INT = -1)

/datum/status_effect/knot_gaped/on_apply()
	last_loc = get_turf(owner)
	return ..()

/datum/status_effect/knot_gaped/tick()
	var/cur_loc = get_turf(owner)
	if(get_dist(cur_loc, last_loc) <= 5)
		return
	var/turf/turf = get_turf(owner)
	new /obj/effect/decal/cleanable/coom(turf)
	playsound(owner, pick('sound/misc/bleed (1).ogg', 'sound/misc/bleed (2).ogg', 'sound/misc/bleed (3).ogg'), 50, TRUE, -2, ignore_walls = FALSE)
	last_loc = cur_loc

/atom/movable/screen/alert/status_effect/knot_gaped
	name = "Gaped"
	desc = "You were forcefully withdrawn from. Warmth runs freely down your thighs..."
	icon_state = "debuff"

/datum/status_effect/knotted
	id = "knotted"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/knotted

/atom/movable/screen/alert/status_effect/knotted
	name = "Knotted"
	desc = "I have to be careful where I step..."
	icon_state = "knotted"

/atom/movable/screen/alert/status_effect/knotted/Click()
	..()
	var/mob/living/user = usr
	if(!istype(user))
		return FALSE

	var/datum/component/erp_knotting/knot_comp = user.GetComponent(/datum/component/erp_knotting)
	if(!knot_comp)
		return FALSE

	if(!knot_comp.active_links || !knot_comp.active_links.len)
		return FALSE

	var/list/arousal_data = list()
	SEND_SIGNAL(user, COMSIG_SEX_GET_AROUSAL, arousal_data)
	var/do_forceful_removal = (arousal_data["arousal"] > MAX_AROUSAL / 2)
	for(var/datum/erp_knot_link/L as anything in knot_comp.active_links)
		if(!istype(L) || !L.is_valid())
			continue
		if(L.top != user)
			continue
		knot_comp.remove_all_for_penis(L.penis_org, who_pulled = user, forceful = do_forceful_removal)

	return FALSE

/datum/status_effect/buff/erp_satisfaction
	id = "erp_satisfaction"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/buff/erp_satisfaction

	var/tier = 0

/atom/movable/screen/alert/status_effect/buff/erp_satisfaction
	name = "Satisfied"
	desc = "A warm afterglow lingers."
	icon_state = "buff"

/datum/status_effect/buff/erp_satisfaction/proc/set_tier(new_tier)
	tier = clamp(new_tier, 0, ERP_SATISFY_MAX_TIER)

/datum/status_effect/debuff/erp_overload
	id = "erp_overload"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/debuff/erp_overload
	duration = ERP_OVERLOAD_DECAY_INTERVAL
	var/stacks = 0

/datum/status_effect/debuff/erp_overload/proc/set_stacks(new_stacks)
	if(owner && islist(effectedstats))
		for(var/S in effectedstats)
			owner.change_stat(S, -(effectedstats[S]))

	stacks = clamp(new_stacks, 0, ERP_OVERLOAD_MAX_OP)
	var/con_bonus = CEILING(stacks / 2, 1)
	effectedstats = list(
		STATKEY_WIL = stacks,
		STATKEY_INT = stacks,
		STATKEY_ACC = stacks,
		STATKEY_CON = -con_bonus
	)
	if(owner)
		for(var/S in effectedstats)
			owner.change_stat(S, effectedstats[S])

/atom/movable/screen/alert/status_effect/debuff/erp_overload
	name = "Overstimulated"
	desc = "Too much pleasure. My mind is foggy and my body is heavy."
	icon_state = "debuff"
