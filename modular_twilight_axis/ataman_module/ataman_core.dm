#define BB_ATAMAN_FLEE_TURF "bb_ataman_flee_turf"
#define BB_ATAMAN_SPAWN_TURF "bb_ataman_spawn_turf"
#define BB_ATAMAN_OWNER "bb_ataman_owner"
#define BB_ATAMAN_TARGET "bb_ataman_target"
#define BB_ATAMAN_ROLE "bb_ataman_role"
#define BB_ATAMAN_SQUAD "bb_ataman_squad"
#define BB_ATAMAN_TACTICS_COOLDOWN "bb_ataman_tactics_cooldown"
#define BB_ATAMAN_INTERCEPT_TURF "bb_ataman_intercept_turf"

#define ATAMAN_ROLE_GRABBER "grabber"
#define ATAMAN_ROLE_BINDER "binder"
#define ATAMAN_ROLE_ENFORCER "enforcer"

#define ATAMAN_LEASH_RANGE 24
#define ATAMAN_GIVEUP_RANGE 12
#define ATAMAN_IDLE_DESPAWN_MIN (5 SECONDS)
#define ATAMAN_IDLE_DESPAWN_MAX (10 SECONDS)

#define ATAMAN_INTERCEPT_WINDOW (4 SECONDS)
#define ATAMAN_INTERCEPT_COOLDOWN (6 SECONDS)
#define ATAMAN_INTERCEPT_STALE (3 SECONDS)

#define ATAMAN_EXCIDIUM "The Excidium"
#define ATAMAN_BOUNTY_CATEGORY_MURDER "murder"
#define ATAMAN_BOUNTY_CATEGORY_THEFT "theft"

#define ATAMAN_MAX_ACTIVE_AMBUSHES 3
#define ATAMAN_MAX_ACTIVE_TRAPS 3
#define ATAMAN_TRAP_SETUP_TIME (7 SECONDS)
#define ATAMAN_TRAP_TOMB_EXCLUSION 15
#define ATAMAN_TRAP_MAX_CROWD 5
#define ATAMAN_TRAP_CROWD_RANGE 7
#define ATAMAN_TRAP_PLAYER_EXCLUSION_RANGE 8
#define ATAMAN_TRAP_MIN_SPACING 8

#define ATAMAN_TRADE_MIN_ITEM_VALUE 25
#define ATAMAN_TRADE_MIN_VALUE 200
#define ATAMAN_TRADE_PAYOUT_MULTIPLIER 0.55
#define ATAMAN_TREASURY_DAMAGE_MULTIPLIER 0.4
#define ATAMAN_TIER_BASE_BOUNTY 100

GLOBAL_VAR_INIT(ataman_ai_logging, TRUE)
GLOBAL_VAR_INIT(ataman_ai_log_file, null)

/proc/ataman_ai_log(mob/living/source, message)
	if(!GLOB.ataman_ai_logging)
		return
	if(!GLOB.ataman_ai_log_file)
		GLOB.ataman_ai_log_file = "[GLOB.log_directory]/ataman_ai.log"
	var/tag = "SQUAD"
	if(istype(source, /mob/living/carbon/human/npc/ataman_bandit))
		var/mob/living/carbon/human/npc/ataman_bandit/bandit = source
		tag = "[bandit.real_name]#[REF(bandit)] role=[bandit.ataman_role]"
	else if(source)
		tag = "[source.real_name]"
	WRITE_LOG(GLOB.ataman_ai_log_file, "\[[station_time_timestamp()]\] [tag]: [message]")

/mob/living/carbon/human
	var/list/ataman_active_ambushes
	var/list/ataman_active_traps
	var/ataman_loot_sold_total = 0
	var/ataman_loot_tier = 0
	var/list/recent_attackers = list()
	var/ataman_deathmark_bound = FALSE

/datum/bounty
	var/ataman_reason_category
	var/list/ataman_victim_names = list()

/proc/ataman_turf_has_trap(turf/target_turf)
	if(!target_turf)
		return FALSE
	if(locate(/obj/structure/trap) in target_turf)
		return TRUE
	if(locate(/obj/item/restraints/legcuffs/beartrap) in target_turf)
		return TRUE
	return FALSE

/proc/ataman_active_ambush_count(mob/living/carbon/human/owner)
	if(!owner)
		return 0
	LAZYINITLIST(owner.ataman_active_ambushes)
	for(var/datum/weakref/ambush_ref as anything in owner.ataman_active_ambushes.Copy())
		var/obj/structure/trap/ataman_ambush_stone/ambush = ambush_ref.resolve()
		if(QDELETED(ambush))
			owner.ataman_active_ambushes -= ambush_ref
	return length(owner.ataman_active_ambushes)

/proc/ataman_register_ambush(mob/living/carbon/human/owner, obj/structure/trap/ataman_ambush_stone/ambush)
	if(!owner || !ambush)
		return
	LAZYINITLIST(owner.ataman_active_ambushes)
	owner.ataman_active_ambushes += WEAKREF(ambush)

/proc/ataman_active_trap_count(mob/living/carbon/human/owner)
	if(!owner)
		return 0
	LAZYINITLIST(owner.ataman_active_traps)
	for(var/datum/weakref/trap_ref as anything in owner.ataman_active_traps.Copy())
		var/obj/structure/trap/ataman_snare/trap = trap_ref.resolve()
		if(QDELETED(trap))
			owner.ataman_active_traps -= trap_ref
	return length(owner.ataman_active_traps)

/proc/ataman_register_trap(mob/living/carbon/human/owner, obj/structure/trap/ataman_snare/trap)
	if(!owner || !trap)
		return
	LAZYINITLIST(owner.ataman_active_traps)
	owner.ataman_active_traps += WEAKREF(trap)

/proc/ataman_too_close_to_own(mob/living/carbon/human/owner, turf/target_turf, list/existing_refs, min_distance)
	if(!owner || !length(existing_refs))
		return FALSE
	for(var/datum/weakref/existing_ref as anything in existing_refs)
		var/obj/structure/trap/existing = existing_ref.resolve()
		if(QDELETED(existing))
			continue
		var/turf/existing_turf = get_turf(existing)
		if(existing_turf && existing_turf.z == target_turf.z && get_dist(existing_turf, target_turf) < min_distance)
			return TRUE
	return FALSE

/proc/ataman_bandit_belongs_to(atom/movable/AM, mob/living/carbon/human/owner)
	if(!owner || !istype(AM, /mob/living/carbon/human/npc/ataman_bandit))
		return FALSE
	var/mob/living/carbon/human/npc/ataman_bandit/bandit = AM
	return bandit.ataman_owner_ref?.resolve() == owner

/proc/ataman_trap_spot_error(mob/living/user, turf/target_turf)
	var/area/spot_area = get_area(target_turf)
	if(istype(spot_area, /area/rogue/under))
		return "I cannot set this underground!"
	if(locate(/obj/structure/fluff/traveltile/dungeon) in range(ATAMAN_TRAP_TOMB_EXCLUSION, target_turf))
		return "too close to the tomb!"
	for(var/mob/living/bystander in range(ATAMAN_TRAP_PLAYER_EXCLUSION_RANGE, target_turf))
		if(bystander == user || !bystander.client)
			continue
		return "someone would see me do this!"
	var/crowd = 0
	for(var/mob/living/bystander in range(ATAMAN_TRAP_CROWD_RANGE, target_turf))
		if(bystander == user || bystander.stat == DEAD || ataman_bandit_belongs_to(bystander, user))
			continue
		crowd++
	if(crowd > ATAMAN_TRAP_MAX_CROWD)
		return "too many souls nearby!"
	return null

/proc/ataman_channel_undisturbed(mob/living/carbon/human/H, start_health)
	return !QDELETED(H) && H.health >= start_health && !H.pulledby

/proc/ataman_trap_channel(mob/living/carbon/human/H, turf/target_turf)
	var/datum/callback/checks = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ataman_channel_undisturbed), H, H.health)
	return do_after(H, ATAMAN_TRAP_SETUP_TIME, target = target_turf, extra_checks = checks)

/proc/ataman_find_bounty(mob/living/carbon/human/culprit, employer, category)
	for(var/datum/bounty/existing in GLOB.head_bounties)
		if(existing.target == culprit.real_name && existing.employer == employer && existing.ataman_reason_category == category)
			return existing
	return null

/proc/ataman_create_bounty(mob/living/carbon/human/culprit, amount, reason, employer, category, race, gender, descriptor_height, descriptor_body, descriptor_voice)
	add_bounty(culprit.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, FALSE, reason, employer)
	var/datum/bounty/created = GLOB.head_bounties[length(GLOB.head_bounties)]
	created.ataman_reason_category = category
	return created

/proc/ataman_get_loot_tier(total)
	if(total >= 5000)
		return 5
	if(total >= 4000)
		return 4
	if(total >= 2500)
		return 3
	if(total >= 1500)
		return 2
	if(total >= 500)
		return 1
	return 0

/proc/ataman_process_honest_trade(mob/living/carbon/human/H, appraised_value)
	var/damage_multiplier = ATAMAN_TREASURY_DAMAGE_MULTIPLIER * (1 + (0.1 * H.ataman_loot_tier))
	var/treasury_damage = round(appraised_value * damage_multiplier)
	SStreasury.burn(SStreasury.discretionary_fund, treasury_damage, "Honest Exchange")
	send_ooc_note("[treasury_damage] coins have been stolen from the duchy treasury!", job = list("Grand Duke", "Steward", "Clerk", "Sultan", "Vizier"))

	var/list/d_list = H.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")

	var/datum/bounty/bounty = ataman_find_bounty(H, ATAMAN_EXCIDIUM, ATAMAN_BOUNTY_CATEGORY_THEFT)
	if(bounty)
		bounty.amount += treasury_damage
	else
		bounty = ataman_create_bounty(H, treasury_damage, "", ATAMAN_EXCIDIUM, ATAMAN_BOUNTY_CATEGORY_THEFT, H.dna.species, H.gender, descriptor_height, descriptor_body, descriptor_voice)
	bounty.reason = "Theft from the [SSmapping.config.map_name] treasury - [bounty.amount] coins"

	H.ataman_loot_sold_total += appraised_value
	var/new_tier = ataman_get_loot_tier(H.ataman_loot_sold_total)
	if(new_tier > H.ataman_loot_tier)
		H.ataman_loot_tier = new_tier
		var/tier_bonus = new_tier * ATAMAN_TIER_BASE_BOUNTY
		bounty.amount += tier_bonus
		to_chat(H, span_danger("My notoriety reaches tier [new_tier] - the Excidium adds [tier_bonus] coins to the price on my head."))

	bounty.banner = null
	compose_bounty(bounty)

/proc/ataman_squad_size_for_tier(tier)
	switch(tier)
		if(3)
			return list(3, 5)
		if(4)
			return list(4, 6)
		if(5 to INFINITY)
			return list(5, 6)
	return list(3, 4)

/proc/ataman_apply_bandit_gear(mob/living/carbon/human/npc/ataman_bandit/bandit, tier)
	var/list/kit
	switch(tier)
		if(2)
			kit = list(
				/obj/item/clothing/suit/roguetown/armor/leather/heavy = SLOT_ARMOR,
				/obj/item/clothing/gloves/roguetown/plate/iron = SLOT_GLOVES,
				/obj/item/clothing/shoes/roguetown/boots/armor/iron = SLOT_SHOES,
				/obj/item/clothing/wrists/roguetown/bracers/iron = SLOT_WRISTS,
				/obj/item/clothing/neck/roguetown/chaincoif/iron = SLOT_NECK,
			)
		if(3, 4)
			kit = list(
				/obj/item/clothing/suit/roguetown/armor/plate/iron = SLOT_ARMOR,
				/obj/item/clothing/gloves/roguetown/plate/iron = SLOT_GLOVES,
				/obj/item/clothing/shoes/roguetown/boots/armor/iron = SLOT_SHOES,
				/obj/item/clothing/wrists/roguetown/bracers/iron = SLOT_WRISTS,
				/obj/item/clothing/neck/roguetown/chaincoif/iron = SLOT_NECK,
			)
		if(5 to INFINITY)
			kit = list(
				/obj/item/clothing/suit/roguetown/armor/plate = SLOT_ARMOR,
				/obj/item/clothing/gloves/roguetown/plate = SLOT_GLOVES,
				/obj/item/clothing/shoes/roguetown/boots/armor = SLOT_SHOES,
				/obj/item/clothing/wrists/roguetown/bracers = SLOT_WRISTS,
				/obj/item/clothing/neck/roguetown/chaincoif = SLOT_NECK,
			)
		else
			kit = list(
				/obj/item/clothing/suit/roguetown/armor/leather = SLOT_ARMOR,
				/obj/item/clothing/gloves/roguetown/leather = SLOT_GLOVES,
				/obj/item/clothing/shoes/roguetown/boots/leather/reinforced = SLOT_SHOES,
				/obj/item/clothing/wrists/roguetown/bracers/leather = SLOT_WRISTS,
				/obj/item/clothing/neck/roguetown/leather = SLOT_NECK,
			)
	for(var/piece in kit)
		bandit.equip_to_slot_or_del(new piece(), kit[piece], TRUE)

#define ATAMAN_DEATH_MARK_WINDOW 15
#define ATAMAN_DEATH_MARK_MAX_WITNESSES 6
#define ATAMAN_DEATH_MARK_BOUNTY 300

SUBSYSTEM_DEF(ataman_deathmark)
	name = "Ataman Death Mark"
	flags = SS_NO_FIRE

/datum/controller/subsystem/ataman_deathmark/Initialize()
	RegisterSignal(SSdcs, COMSIG_GLOB_MOB_CREATED, PROC_REF(on_mob_created))
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		register_human(H)
	return ..()

/datum/controller/subsystem/ataman_deathmark/proc/on_mob_created(datum/source, mob/new_mob)
	SIGNAL_HANDLER
	if(!ishuman(new_mob))
		return
	register_human(new_mob)

/datum/controller/subsystem/ataman_deathmark/proc/register_human(mob/living/carbon/human/H)
	if(!H || H.ataman_deathmark_bound)
		return
	H.ataman_deathmark_bound = TRUE
	RegisterSignal(H, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damaged))
	RegisterSignal(H, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/controller/subsystem/ataman_deathmark/proc/on_damaged(mob/living/carbon/human/victim, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	var/mob/living/attacker = victim.lastattacker_weakref?.resolve()
	if(!attacker || attacker == victim)
		return
	victim.recent_attackers += WEAKREF(attacker)
	var/excess = length(victim.recent_attackers) - ATAMAN_DEATH_MARK_WINDOW
	if(excess > 0)
		victim.recent_attackers.Cut(1, excess + 1)

/datum/controller/subsystem/ataman_deathmark/proc/on_death(mob/living/carbon/human/victim, gibbed)
	SIGNAL_HANDLER
	check_ataman_death_mark(victim)
	victim.recent_attackers = list()

/proc/ataman_resolve_source(mob/living/attacker)
	if(!istype(attacker))
		return null
	if(istype(attacker, /mob/living/carbon/human/npc/ataman_bandit))
		var/mob/living/carbon/human/npc/ataman_bandit/bandit = attacker
		return bandit.ataman_owner_ref?.resolve()
	return attacker

/proc/check_ataman_death_mark(mob/living/carbon/human/victim)
	if(!victim?.client || !length(victim.recent_attackers))
		return

	var/mob/living/carbon/human/culprit
	for(var/datum/weakref/ref as anything in victim.recent_attackers)
		var/mob/living/carbon/human/source = ataman_resolve_source(ref?.resolve())
		if(istype(source) && source.client && source.mind && source.advjob == "Атаман")
			culprit = source
			break

	if(!culprit?.client)
		return

	var/nearby_players = 0
	for(var/mob/living/witness in view(5, victim))
		if(!witness.client)
			continue
		nearby_players++
		if(nearby_players > ATAMAN_DEATH_MARK_MAX_WITNESSES)
			return

	var/list/d_list = culprit.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, culprit, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, culprit, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, culprit, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")

	var/datum/bounty/bounty = ataman_find_bounty(culprit, ATAMAN_EXCIDIUM, ATAMAN_BOUNTY_CATEGORY_MURDER)
	if(bounty)
		bounty.ataman_victim_names += victim.real_name
		bounty.amount += ATAMAN_DEATH_MARK_BOUNTY
		bounty.reason = "Murder: [jointext(bounty.ataman_victim_names, ", ")]"
		bounty.banner = null
		compose_bounty(bounty)
	else
		bounty = ataman_create_bounty(culprit, ATAMAN_DEATH_MARK_BOUNTY, "Murder: [victim.real_name]", ATAMAN_EXCIDIUM, ATAMAN_BOUNTY_CATEGORY_MURDER, culprit.dna.species, culprit.gender, descriptor_height, descriptor_body, descriptor_voice)
		bounty.ataman_victim_names = list(victim.real_name)

	to_chat(culprit, span_danger("За мою голову назначена награда. Кто-то узнал о том, что я убил [victim.real_name]!"))

#undef ATAMAN_DEATH_MARK_WINDOW
#undef ATAMAN_DEATH_MARK_MAX_WITNESSES
#undef ATAMAN_DEATH_MARK_BOUNTY

/proc/ataman_appraise_loot(atom/movable/container)
	var/total = 0
	for(var/obj/item/I in container.contents)
		if(length(I.contents))
			total += ataman_appraise_loot(I)
		var/price = I.get_real_price()
		if(price > ATAMAN_TRADE_MIN_ITEM_VALUE)
			total += price
	return total

/datum/action/cooldown/spell/ataman_exchange
	name = "Honest Exchange"
	desc = "Trade a bag of goods to a nearby fence. I receive 55% of their appraised value, while the duchy treasury takes the loss. Only items worth more than 25 mammons count, and the haul must total at least 200."
	click_to_activate = TRUE
	self_cast_possible = FALSE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 10 SECONDS
	cast_range = 1
	associated_skill = null
	associated_stat = null
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/proc/ataman_is_loot_sack(atom/thing)
	return istype(thing, /obj/item/storage/roguebag) || istype(thing, /obj/item/storage/backpack/rogue)

/datum/action/cooldown/spell/ataman_exchange/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!ataman_is_loot_sack(cast_on))
		owner.balloon_alert(owner, "that is not a bag of goods!")
		return FALSE
	if(!locate(/obj/structure/roguemachine/goldface/public/wretch_cat) in range(2, owner))
		owner.balloon_alert(owner, "there is no fence nearby!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/ataman_exchange/cast(atom/target)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/storage/sack = target
	if(!ataman_is_loot_sack(sack))
		return FALSE
	var/obj/structure/roguemachine/goldface/public/wretch_cat/fence = locate(/obj/structure/roguemachine/goldface/public/wretch_cat) in range(2, H)
	if(!fence)
		return FALSE

	var/appraised_value = round(ataman_appraise_loot(sack))
	if(appraised_value < ATAMAN_TRADE_MIN_VALUE)
		to_chat(H, span_warning("There is not enough in [sack] for a real exchange - [appraised_value] of the [ATAMAN_TRADE_MIN_VALUE] mammons a fence would bother with. Trinkets worth [ATAMAN_TRADE_MIN_ITEM_VALUE] mammons or less do not count."))
		return FALSE
	var/payout_value = round(appraised_value * ATAMAN_TRADE_PAYOUT_MULTIPLIER)

	sack.forceMove(fence)
	budget2change(payout_value, H)
	ataman_process_honest_trade(H, appraised_value)
	to_chat(H, span_notice("I hand [sack] to [fence] and receive [payout_value] mammons."))
	return TRUE
