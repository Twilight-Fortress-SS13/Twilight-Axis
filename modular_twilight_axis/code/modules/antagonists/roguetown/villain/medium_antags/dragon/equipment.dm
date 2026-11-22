/obj/item/clothing/suit/roguetown/armor/regenerating/skin/wyvern_armor
	slot_flags = null
	name = "wyvern scales"
	desc = "an impenetrable coat of greed."
	mob_overlay_icon = 'modular_twilight_axis/icons/mob/monster/player_dragon.dmi'
	icon = 'modular_twilight_axis/icons/mob/monster/player_dragon.dmi'
	icon_state = "empty"
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_WYVERN_STRONG
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 900
	item_flags = DROPDEL
	repair_time = 30 SECONDS

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/wyvern_armor/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "HIDE", "#WYVERNED")/// no one should ever see this unless they spawn in dragon hide via the game panel

/datum/antagonist/wyvern
	name = "Wyvern"
	roundend_category = "Dragons"
	antagpanel_category = "Dragons"
	job_rank = ROLE_WYVERN

/datum/antagonist/wyvern/on_gain()
	greet()
	owner.special_role = "Wyverns"
	return ..()

/datum/antagonist/wyvern/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null

/mob/living/carbon/human/proc/wyvern_can_feed_heal()
	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		to_chat(src, span_notice("My power is weakened, I cannot heal!"))
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/wyvern_feed(mob/living/carbon/human/target, healing_amount = 30)
	if(!target)
		return
	if(!wyvern_can_feed_heal())
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("I should not feed on rotten flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(src, span_warning("I should not feed on corrupted flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/gnoll))
			to_chat(src, span_warning("I should not feed on graggarite flesh."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/wyvern))
			to_chat(src, span_warning("I should not feed on my kin's flesh."))
			return

	to_chat(src, span_warning("I feed on succulent flesh. I feel reinvigorated."))
	return src.reagents.add_reagent(/datum/reagent/medicine/healthpot, healing_amount)

/obj/item/rogueweapon/werewolf_claw/wyvern
	name = "Wyvern Claw"
	wdefense = 5
	force = 40
	possible_item_intents = list(/datum/intent/simple/gnoll_cut/wyvern, /datum/intent/simple/werewolf/gnoll/wyvern, /datum/intent/mace/smash/werewolf/gnoll/wyvern, /datum/intent/mace/strike/gnoll/wyvern)

/datum/intent/simple/gnoll_cut/wyvern
	reach = 2

/datum/intent/simple/werewolf/gnoll/wyvern
	reach = 2

/datum/intent/mace/smash/werewolf/gnoll/wyvern
	reach = 2

/datum/intent/mace/strike/gnoll/wyvern
	reach = 2

/obj/item/rogueweapon/werewolf_claw/wyvern/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/wyvern/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT

/obj/effect/proc_holder/spell/self/claws/wyvern
	name = "Wyvern claws"
	claw_type = /obj/item/rogueweapon/werewolf_claw/wyvern

/proc/enforce_wyvern_slots()
	var/datum/job/wyvern_job = SSjob.GetJob("Wyvern")
	if(!wyvern_job)
		return
	if(wyvern_job.admin_slot_override)
		return
	var/slots
	var/admin_slot = !SSgamemode.allow_vote ? SSgamemode.admin_slots["Wyvern"] : null
	if(!isnull(admin_slot))
		slots = max(0, admin_slot)
	else
		slots = SSgamemode.current_storyteller?.wyvern_slot || 0
	wyvern_job.total_positions = max(wyvern_job.current_positions, slots)
	wyvern_job.spawn_positions = max(wyvern_job.current_positions, slots)
