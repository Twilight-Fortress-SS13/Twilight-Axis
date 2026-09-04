#define SHAMANIC_TOTEM_AURA_RANGE 7

#define SHAMANIC_TOTEM_MAX_RECIPIENTS 4

#define SHAMANIC_TOTEM_MIN_BLOCKS 3

#define SHAMANIC_TOTEM_MAX_BLOCKS 6

#define SHAMANIC_TOTEM_MAX_SAME_BLOCKS 3

#define SHAMANIC_TOTEM_COMMIT_THRESHOLD 3

#define TRAIT_SOURCE_SHAMANIC_DENDOR "shamanic_totem_dendor_commit"
#define TRAIT_SOURCE_SHAMANIC_ABYSSOR "shamanic_totem_abyssor_commit"
#define TRAIT_SHAMANIC_ABYSSOR_SLOW "Shamanic Abyssor's Dragging Tide"

#define SHAMANIC_TOTEM_DENDOR_VINE_INTERVAL 30 SECONDS
#define SHAMANIC_TOTEM_DENDOR_VINE_BURST 2
#define SHAMANIC_TOTEM_DENDOR_VINE_CAP 12
#define SHAMANIC_TOTEM_DENDOR_KNEESTINGER_INTERVAL 3 MINUTES
#define SHAMANIC_TOTEM_DENDOR_KNEESTINGER_BURST 3
#define SHAMANIC_TOTEM_DENDOR_KNEESTINGER_CAP 9
#define SHAMANIC_TOTEM_DENDOR_WARMUP 1 MINUTES
#define SHAMANIC_TOTEM_COMMIT_DEBUFF_DURATION 10 SECONDS

#define TRAIT_SOURCE_SHAMANIC_ZIZO "shamanic_totem_zizo_commit"

#define SHAMANIC_TOTEM_STACK_MIN_LEVEL SKILL_LEVEL_JOURNEYMAN

#define SHAMANIC_TOTEM_MASTER_LEVEL SKILL_LEVEL_MASTER

#define SHAMANIC_TOTEM_LOW_MAX_BLOCKS 3

#define SHAMANIC_TOTEM_HEAL_PER_TICK 3

#define SHAMANIC_TOTEM_LINGER_TIME 15 SECONDS

#define SHAMANIC_TOTEM_WATER_TILE_THRESHOLD 12
#define SHAMANIC_TOTEM_WATER_HEAL_BRUTE 1.75
#define SHAMANIC_TOTEM_WATER_HEAL_FIRE 1.75
#define SHAMANIC_TOTEM_WATER_HEAL_OXY 1.25
#define SHAMANIC_TOTEM_WATER_HEAL_CLONE 1.75
#define SHAMANIC_TOTEM_WATER_HEAL_WOUNDS 3
#define SHAMANIC_TOTEM_WATER_STAMINA_REGEN 6

#define SHAMANIC_TOTEM_STAMINA_DRAIN 40
#define SHAMANIC_TOTEM_STAMINA_DRAIN_INTERVAL 20 SECONDS

#define SHAMANIC_TOTEM_BAOTHA_SWAMPWEED_INJECT 0.5

/mob/living/carbon/human
	var/obj/structure/shamanic_totem/owned_shamanic_totem

/obj/item/shamanic_totem_block
	name = "totem block"
	desc = "A carved block humming with totemic power. Set a few of them together on one spot and they awake as a working totem."
	icon = 'modular_twilight_axis/icons/obj/structures/totem.dmi'
	icon_state = "Graggar_totem"
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	var/god_name = "Grinning Moose"
	var/stat_key = STATKEY_STR
	var/block_value = 1
	var/patron_type
	var/stat_key2
	var/block_value2 = 0
	var/stat_key3
	var/block_value3 = 0
	var/curses_outsiders = TRUE
	var/curse_stat_key
	var/curse_stat_value = 0
	var/curse_stat_key2
	var/curse_stat_value2 = 0
	var/clear_on_commit = FALSE
	var/commit_buff
	var/commit_debuff
	var/greed_taxed = FALSE
	var/list/commit_blessing_folded
	var/list/commit_curse_folded

/obj/item/shamanic_totem_block/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Those who tend the totem are blessed by [god_name]'s favor.")
	if(curses_outsiders)
		if(!isnull(curse_stat_key) || !isnull(curse_stat_key2))
			. += span_info("Strangers who linger near it instead feel [god_name]'s malice weigh upon them.")
		else
			. += span_info("Strangers who linger near it instead feel its malice weigh upon them.")
	. += span_info("Hold it in your hand and use it to set it down. Set several of them together on one spot and they awake as a working totem.")
	if(commit_buff || commit_debuff)
		. += span_info("Devoting many to a single god may earn a deeper favor for those who tend it[commit_debuff ? ", and a crueler malice for its foes" : ""].")

/obj/item/shamanic_totem_block/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_GRONN)

/obj/item/shamanic_totem_block/attack_self(mob/user)
	..()
	if(!ishuman(user))
		to_chat(user, span_warning("I don't know how to place this properly."))
		return
	if(user.get_skill_level(/datum/skill/craft/spiritism) < SHAMANIC_TOTEM_STACK_MIN_LEVEL)
		to_chat(user, span_warning("I don't understand how to work with this properly."))
		return
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, span_warning("I need solid ground to place this on!"))
		return

	var/obj/structure/shamanic_totem/totem = locate(/obj/structure/shamanic_totem) in T
	if(!totem)
		for(var/obj/A in T)
			if(istype(A, /obj/structure))
				to_chat(user, span_warning("I need some free space to start a totem here!"))
				return
			if(A.density && !(A.flags_1 & ON_BORDER_1))
				to_chat(user, span_warning("There is already something here!"))
				return
		var/mob/living/carbon/human/H = user
		if(H.owned_shamanic_totem)
			to_chat(user, span_warning("I already have a totem planted somewhere. I should take it apart before starting another."))
			return
		user.visible_message(span_notice("[user] begins stacking \the [src] on the ground."))
		if(!do_after(user, 1 SECONDS, TRUE, src))
			return
		var/turf/T2 = get_turf(src)
		if(!isfloorturf(T2))
			return
		totem = locate(/obj/structure/shamanic_totem) in T2
		if(!totem)
			totem = new /obj/structure/shamanic_totem(T2)
			totem.set_owner(H)
		else if(user != totem.owner)
			to_chat(user, span_warning("Someone else started a totem here while I was stacking."))
			return
		totem.add_block(src.type)
		qdel(src)
		return

	if(user != totem.owner)
		to_chat(user, span_warning("That's someone else's totem. I can't add to it."))
		return
	var/totem_cap = totem.get_max_blocks()
	if(length(totem.totem_blocks) >= totem_cap)
		if(totem.owner.get_skill_level(/datum/skill/craft/spiritism) < SHAMANIC_TOTEM_MASTER_LEVEL)
			to_chat(user, span_warning("The totem already holds all the blocks it will take from me."))
		else
			to_chat(user, span_warning("The totem can't hold any more blocks."))
		return
	var/same_count = 0
	for(var/existing in totem.totem_blocks)
		if(existing == src.type)
			same_count++
	if(same_count >= SHAMANIC_TOTEM_MAX_SAME_BLOCKS)
		to_chat(user, span_warning("The totem already holds as many of these blocks as it can take."))
		return
	user.visible_message(span_notice("[user] stacks \the [src] into [totem]."))
	if(!do_after(user, 1 SECONDS, TRUE, src))
		return
	totem.add_block(src.type)
	qdel(src)

/obj/item/shamanic_totem_block/graggar
	name = "moose block"
	desc = "A carved block covered in red dye all over it, roughly resembling blood drops. There is a small antlers carved on top"
	icon_state = "Graggar_totem"
	god_name = "Grinning Moose"
	stat_key = STATKEY_STR
	patron_type = /datum/patron/inhumen/graggar
	curses_outsiders = FALSE
	commit_blessing_folded = list(STATKEY_CON = 2, STATKEY_WIL = 2)
	commit_buff = /datum/status_effect/buff/shamanic_totem_commit_graggar
	commit_debuff = null

/datum/status_effect/buff/shamanic_totem_commit_graggar
	id = "shamanic_totem_commit_graggar"
	status_type = STATUS_EFFECT_REFRESH
	duration = SHAMANIC_TOTEM_COMMIT_DEBUFF_DURATION
	alert_type = /atom/movable/screen/alert/status_effect/buff/shamanic_totem_commit_graggar
	examine_text = "SUBJECTPRONOUN is bolstered by the Grinning Moose's favor."

/datum/status_effect/buff/shamanic_totem_commit_graggar/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, TRAIT_GENERIC)

/datum/status_effect/buff/shamanic_totem_commit_graggar/on_remove()
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC)
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	return ..()

/obj/item/shamanic_totem_block/zizo
	name = "wolf block"
	desc = "A carved block covered in white dye, resembling a bone. There is a wolf head carved on top"
	icon_state = "Zizo_totem"
	god_name = "Plotting Wolf"
	stat_key = null
	patron_type = /datum/patron/inhumen/zizo
	curses_outsiders = TRUE
	curse_stat_key = STATKEY_INT
	curse_stat_value = -1
	curse_stat_key2 = STATKEY_WIL
	curse_stat_value2 = -1
	commit_curse_folded = list(STATKEY_CON = -2)
	commit_debuff = /datum/status_effect/buff/shamanic_totem_commit_zizo

/datum/status_effect/buff/shamanic_totem_commit_zizo
	id = "shamanic_totem_commit_zizo"
	status_type = STATUS_EFFECT_REFRESH
	duration = SHAMANIC_TOTEM_COMMIT_DEBUFF_DURATION
	alert_type = /atom/movable/screen/alert/status_effect/debuff/shamanic_totem_commit_zizo
	examine_text = "SUBJECTPRONOUN is shadowed by the Plotting Wolf's malice."

/datum/status_effect/buff/shamanic_totem_commit_zizo/on_apply()
	. = ..()


	if(HAS_TRAIT(owner, TRAIT_BAD_MOOD))
		owner.add_stress(/datum/stressevent/zizo_bad_mood)
	else
		ADD_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_SOURCE_SHAMANIC_ZIZO)

/datum/status_effect/buff/shamanic_totem_commit_zizo/on_remove()
	REMOVE_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_SOURCE_SHAMANIC_ZIZO)
	return ..()

/datum/stressevent/zizo_bad_mood
	stressadd = 3
	timer = 2 MINUTES
	desc = span_red("The Plotting Wolf's schemes gnaw at my mind.")

/obj/item/shamanic_totem_block/matthios
	name = "bear block"
	desc = "A carved block covered in yellow dye, resembling a pile of coins. There is a bear tooth carved on top."
	icon_state = "Matthios_totem"
	god_name = "Starving Bear"
	stat_key = STATKEY_SPD
	block_value = 1
	patron_type = /datum/patron/inhumen/matthios
	curses_outsiders = TRUE
	greed_taxed = TRUE
	commit_buff = null
	commit_debuff = null
	commit_blessing_folded = list(STATKEY_STR = 1, STATKEY_PER = 1, STATKEY_SPD = -1)
	commit_curse_folded = list(STATKEY_STR = -1, STATKEY_PER = -1)

/obj/item/shamanic_totem_block/baotha
	name = "leopard block"
	desc = "A carved block covered in purple dye, resembling a field of roses. There is a feline head carved on top"
	icon_state = "Baotha_totem"
	god_name = "Relishing Leopard"
	stat_key = STATKEY_INT
	block_value = 1
	stat_key2 = STATKEY_WIL
	block_value2 = 1
	stat_key3 = STATKEY_PER
	block_value3 = -1
	patron_type = /datum/patron/inhumen/baotha
	curses_outsiders = TRUE
	curse_stat_key = STATKEY_LCK
	curse_stat_value = -1
	clear_on_commit = TRUE
	commit_buff = /datum/status_effect/buff/moondust_purest
	commit_debuff = null

/datum/status_effect/buff/shamanic_totem_commit_dendor
	id = "shamanic_totem_commit_dendor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/shamanic_totem_commit_dendor

/datum/status_effect/buff/shamanic_totem_commit_dendor/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_WOODSMAN, TRAIT_SOURCE_SHAMANIC_DENDOR)
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, TRAIT_SOURCE_SHAMANIC_DENDOR)
	ADD_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_SOURCE_SHAMANIC_DENDOR)


	var/area/dendor_apply_area = get_area(owner)
	if(dendor_apply_area && dendor_apply_area:warden_area)
		owner.apply_status_effect(/datum/status_effect/buff/wardenbuff)

/datum/status_effect/buff/shamanic_totem_commit_dendor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_WOODSMAN, TRAIT_SOURCE_SHAMANIC_DENDOR)
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, TRAIT_SOURCE_SHAMANIC_DENDOR)
	REMOVE_TRAIT(owner, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_SOURCE_SHAMANIC_DENDOR)
	var/area/dendor_remove_area = get_area(owner)
	if(dendor_remove_area && dendor_remove_area:warden_area)
		owner.remove_status_effect(/datum/status_effect/buff/wardenbuff)
	. = ..()

/obj/item/shamanic_totem_block/dendor
	name = "volf block"
	desc = "A carved block overgrown with vines and thorns, with a clawed hand carved on top of it."
	icon_state = "Dendor_totem"
	god_name = "Volfskinned Man"
	stat_key = STATKEY_PER
	patron_type = /datum/patron/divine/dendor
	curses_outsiders = TRUE
	curse_stat_key = STATKEY_PER
	curse_stat_value = -1
	commit_buff = /datum/status_effect/buff/shamanic_totem_commit_dendor


/mob/living/var/shamic_stamina_mult = 1

/datum/status_effect/shamanic_totem/abyssor_blessing
	id = "shamanic_totem_abyssor_blessing"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	effectedstats = list()
	alert_type = /atom/movable/screen/alert/status_effect/buff/shamanic_totem_abyssor_blessing
	var/stamina_mult = 1

/datum/status_effect/shamanic_totem/abyssor_blessing/on_apply()
	. = ..()
	if(owner)
		owner.shamic_stamina_mult = stamina_mult

/datum/status_effect/shamanic_totem/abyssor_blessing/on_remove()
	if(owner)
		owner.shamic_stamina_mult = 1
	var/obj/structure/shamanic_totem/T = source_totem_ref?.resolve()
	if(T)
		LAZYREMOVE(T.abyssor_buff_claims, owner)
	. = ..()


/datum/status_effect/shamanic_totem/abyssor_curse
	id = "shamanic_totem_abyssor_curse"
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	effectedstats = list()
	alert_type = /atom/movable/screen/alert/status_effect/debuff/shamanic_totem_abyssor_curse
	var/slow_mult = 1

/datum/status_effect/shamanic_totem/abyssor_curse/nextmove_modifier()
	return slow_mult

/datum/status_effect/shamanic_totem/abyssor_curse/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SHAMANIC_ABYSSOR_SLOW, TRAIT_SOURCE_SHAMANIC_ABYSSOR)

/datum/status_effect/shamanic_totem/abyssor_curse/on_remove()
	REMOVE_TRAIT(owner, TRAIT_SHAMANIC_ABYSSOR_SLOW, TRAIT_SOURCE_SHAMANIC_ABYSSOR)
	var/obj/structure/shamanic_totem/T = source_totem_ref?.resolve()
	if(T)
		LAZYREMOVE(T.abyssor_curse_claims, owner)
	. = ..()

/atom/movable/screen/alert/status_effect/buff/shamanic_totem_abyssor_blessing
	name = "Kraken's Tide"
	desc = "The Spiraling Kraken's tide bears my exertions: my stamina drains less for each Kraken block covering me."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/debuff/shamanic_totem_abyssor_curse
	name = "Dragging Tide"
	desc = "The Spiraling Kraken's curse drags at my limbs: every strike lands slower, as if wading through surf."
	icon_state = "restrained"

/obj/item/shamanic_totem_block/abyssor
	name = "kraken block"
	desc = "A carved block with a seashell on it, briefly painted with blue dye."
	icon_state = "Abyssor_totem"
	god_name = "Spiraling Kraken"
	patron_type = /datum/patron/divine/abyssor
	stat_key = null
	stat_key2 = null
	stat_key3 = null
	curses_outsiders = TRUE

/obj/structure/shamanic_totem
	name = "shamanic totem"
	desc = "A pole of stacked carved blocks, humming faintly with totemic power. Something watches from within it."
	icon = 'modular_twilight_axis/icons/obj/structures/totem_blank.dmi'
	icon_state = "blank"
	layer = ABOVE_OBJ_LAYER
	plane = GAME_PLANE
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF
	max_integrity = 400

	var/mob/living/carbon/human/owner
	var/list/mob/living/carbon/human/recipients = list()
	var/list/mob/living/carbon/human/active_buffed = list()
	var/list/mob/living/carbon/human/active_cursed = list()
	var/list/mob/living/carbon/human/active_healed = list()
	var/list/commit_buff_claims = list()
	var/list/commit_debuff_claims = list()
	var/list/abyssor_buff_claims = list()
	var/list/abyssor_curse_claims = list()
	var/list/water_buff_claims = list()
	var/max_recipients = SHAMANIC_TOTEM_MAX_RECIPIENTS
	var/list/totem_blocks = list()
	var/max_blocks = SHAMANIC_TOTEM_MAX_BLOCKS
	var/next_stamina_drain = 0
	var/next_vine_spawn = 0
	var/next_kneestinger_spawn = 0
	var/next_growth_start = 0

/obj/structure/shamanic_totem/examine(mob/user)
	. = ..()
	if(length(totem_blocks))
		. += span_info("Blocks stacked: [length(totem_blocks)]/[get_max_blocks()].")
		var/list/counts = list()
		for(var/block_type in totem_blocks)
			counts[initial(block_type:name)] = (counts[initial(block_type:name)] || 0) + 1
		for(var/block_name in counts)
			. += span_info("[counts[block_name]]x [block_name]")
		if(length(totem_blocks) < SHAMANIC_TOTEM_MIN_BLOCKS)
			. += span_warning("Not enough blocks yet — stack at least [SHAMANIC_TOTEM_MIN_BLOCKS] to wake the totem.")
		else
			. += span_notice("The totem hums with spirit, offering its favor within [SHAMANIC_TOTEM_AURA_RANGE] tiles.")
			var/list/committed = list()
			for(var/block_type in totem_blocks)
				committed[block_type] = (committed[block_type] || 0) + 1
			for(var/block_type in committed)
				if(committed[block_type] >= SHAMANIC_TOTEM_COMMIT_THRESHOLD)
					. += span_notice("The totem radiates the committed favor of [initial(block_type:god_name)].")
	else
		. += span_info("A bare pole. Stack shamanic blocks on it.")

	. += span_info(SPAN_TOOLTIP_DANGEROUS_HTML(EXAMINEHIGHLIGHT_TOOLTIP_HERESYSEVERITY_ODD, "<font color = '[COLOR_HERESYSEVERITY_ODD]'>[EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ODD] It is <b>Odd</b>: [HERESYDESC_GRONN] [EXAMINEHIGHLIGHT_SYMBOL_HERESYSEVERITY_ODD]</font>"))

/obj/structure/shamanic_totem/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Set enough carved blocks together on one spot and they awake as a working totem. It grants buffs for everyone chosen in role unique tab, and debuffs everyone else.")
	. += span_info("Each block provide its own buffs, and if stacked 3 of the same type, they do additional effect.")
	. += span_info("Buffs and debuffs lingers for a small duration when leaving a totem range, but destroying or packing it up ends effects instantly.")
	. += span_info("Touch it for removing one block, alt+click for packing up whole totem. Only owner can do it, but everyone skilled in spiritism can move already packed totem.")

/obj/structure/shamanic_totem/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

	next_growth_start = world.time + SHAMANIC_TOTEM_DENDOR_WARMUP

/obj/structure/shamanic_totem/Destroy()
	for(var/mob/living/carbon/human/H in active_buffed)
		remove_blessing_from(H)
	for(var/mob/living/carbon/human/H in active_cursed)
		remove_curse_from(H)
	for(var/mob/living/carbon/human/H in active_healed)
		remove_heal_from(H)
	for(var/mob/living/carbon/human/H in (commit_buff_claims | commit_debuff_claims))
		remove_commit_bonuses(H)
	for(var/mob/living/carbon/human/H in (abyssor_buff_claims | abyssor_curse_claims))
		remove_abyssor_effects(H)
	for(var/mob/living/carbon/human/H in water_buff_claims)
		remove_water_effects(H)
	recipients.Cut()
	active_buffed.Cut()
	active_cursed.Cut()
	active_healed.Cut()
	if(length(totem_blocks) && isturf(loc))
		for(var/block_type in totem_blocks)
			spawn_shamanic_block(block_type, loc)
	totem_blocks.Cut()
	if(owner?.owned_shamanic_totem == src)
		owner.owned_shamanic_totem = null
	if(owner)
		remove_verb(owner, list(/mob/living/carbon/human/proc/shamanic_totem_manage_roster, /mob/living/carbon/human/proc/shamanic_totem_clear_roster, /mob/living/carbon/human/proc/shamanic_totem_disassemble))
	owner = null
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/shamanic_totem/proc/set_owner(mob/living/carbon/human/new_owner)
	owner = new_owner
	recipients = list(new_owner)
	new_owner.owned_shamanic_totem = src
	add_verb(new_owner, list(/mob/living/carbon/human/proc/shamanic_totem_manage_roster, /mob/living/carbon/human/proc/shamanic_totem_clear_roster, /mob/living/carbon/human/proc/shamanic_totem_disassemble))
	to_chat(new_owner, span_notice("I start a totem. I can choose who it shelters with a quiet word."))

/obj/structure/shamanic_totem/proc/add_recipient(mob/living/carbon/human/target)
	if(!target || (target in recipients))
		return FALSE
	if((recipients.len - 1) >= max_recipients)
		return FALSE
	recipients += target
	if(target in active_cursed)
		remove_curse_from(target)
	return TRUE

/obj/structure/shamanic_totem/proc/remove_recipient(mob/living/carbon/human/target)
	if(!target || target == owner)
		return FALSE
	if(!(target in recipients))
		return FALSE
	recipients -= target
	if(target in active_healed)
		remove_heal_from(target)
	if(target in active_buffed)
		remove_blessing_from(target)
	return TRUE

/obj/structure/shamanic_totem/proc/get_max_blocks()
	if(!owner)
		return 0
	var/level = owner.get_skill_level(/datum/skill/craft/spiritism)
	if(level >= SHAMANIC_TOTEM_MASTER_LEVEL)
		return SHAMANIC_TOTEM_MAX_BLOCKS
	if(level >= SHAMANIC_TOTEM_STACK_MIN_LEVEL)
		return SHAMANIC_TOTEM_LOW_MAX_BLOCKS
	return 0

/obj/structure/shamanic_totem/proc/add_block(block_type)
	if(!ispath(block_type, /obj/item/shamanic_totem_block))
		return FALSE
	if(length(totem_blocks) >= get_max_blocks())
		return FALSE
	var/same_count = 0
	for(var/existing in totem_blocks)
		if(existing == block_type)
			same_count++
	if(same_count >= SHAMANIC_TOTEM_MAX_SAME_BLOCKS)
		return FALSE
	totem_blocks += block_type
	update_appearance()
	refresh_all_effects()
	return TRUE

/obj/structure/shamanic_totem/proc/remove_block(mob/user)
	if(!length(totem_blocks))
		return FALSE


	var/idx = length(totem_blocks)
	var/block_type = totem_blocks[idx]
	totem_blocks.Cut(idx, idx + 1)
	spawn_shamanic_block(block_type, get_turf(src))
	if(user)
		to_chat(user, span_notice("I pull a [initial(block_type:name)] off [src]. The stack settles."))
	if(!length(totem_blocks))
		qdel(src)
		return TRUE
	update_appearance()
	refresh_all_effects()
	return TRUE

/obj/structure/shamanic_totem/proc/disassemble(mob/user)
	if(user != owner)
		return FALSE
	for(var/block_type in totem_blocks)
		spawn_shamanic_block(block_type, get_turf(src))
	totem_blocks.Cut()
	qdel(src)
	return TRUE

/obj/structure/shamanic_totem/proc/get_effects(only_cursing = FALSE, mob/living/carbon/human/target = null, list/covering = null, filter_patron = null)
	. = list()
	for(var/block_type in totem_blocks)
		if(!isnull(filter_patron) && initial(block_type:patron_type) != filter_patron)
			continue
		if(only_cursing && !initial(block_type:curses_outsiders))
			continue

		if(!isnull(target) && initial(block_type:clear_on_commit) && is_patron_committed(target, initial(block_type:patron_type), covering))
			continue
		var/stat_key = initial(block_type:stat_key)
		if(stat_key)
			.[stat_key] = (.[stat_key] || 0) + initial(block_type:block_value)
		var/secondary = initial(block_type:stat_key2)
		if(secondary)
			.[secondary] = (.[secondary] || 0) + initial(block_type:block_value2)
		var/tertiary = initial(block_type:stat_key3)
		if(tertiary)
			.[tertiary] = (.[tertiary] || 0) + initial(block_type:block_value3)

/obj/structure/shamanic_totem/proc/get_curse_effects(mob/living/carbon/human/target = null, list/covering = null, filter_patron = null)
	. = list()
	for(var/block_type in totem_blocks)
		if(!isnull(filter_patron) && initial(block_type:patron_type) != filter_patron)
			continue
		if(!initial(block_type:curses_outsiders))
			continue

		if(!isnull(target) && initial(block_type:clear_on_commit) && is_patron_committed(target, initial(block_type:patron_type), covering))
			continue
		if(!isnull(initial(block_type:curse_stat_key)) || !isnull(initial(block_type:curse_stat_key2)))
			if(!isnull(initial(block_type:curse_stat_key)))
				var/k = initial(block_type:curse_stat_key)
				.[k] = (.[k] || 0) + initial(block_type:curse_stat_value)
			if(!isnull(initial(block_type:curse_stat_key2)))
				var/k2 = initial(block_type:curse_stat_key2)
				.[k2] = (.[k2] || 0) + initial(block_type:curse_stat_value2)
			continue
		var/k = initial(block_type:stat_key)
		if(k)
			.[k] = (.[k] || 0) - initial(block_type:block_value)
		var/k2 = initial(block_type:stat_key2)
		if(k2)
			.[k2] = (.[k2] || 0) - initial(block_type:block_value2)
		var/k3 = initial(block_type:stat_key3)
		if(k3)
			.[k3] = (.[k3] || 0) - initial(block_type:block_value3)

/obj/structure/shamanic_totem/proc/get_healing_patrons()
	var/list/patrons = list()
	for(var/block_type in totem_blocks)
		var/p = initial(block_type:patron_type)
		if(p)
			patrons |= p
	return patrons

/obj/structure/shamanic_totem/proc/is_patron_committed(mob/living/carbon/human/target, patron_type, list/covering = null)
	if(isnull(patron_type))
		return FALSE
	if(isnull(covering))
		covering = get_covering_totems(target)
	var/count = 0
	for(var/obj/structure/shamanic_totem/T in covering)
		for(var/block_type in T.totem_blocks)
			if(initial(block_type:patron_type) == patron_type)
				count++
	return count >= SHAMANIC_TOTEM_COMMIT_THRESHOLD

/obj/structure/shamanic_totem/proc/compute_greed_tax(mob/living/carbon/human/target)
	var/mammonsonperson = get_mammons_in_atom(target)
	var/mammonsinbank = SStreasury.get_balance(target)
	var/total = mammonsinbank + mammonsonperson
	var/tax = FLOOR(total / 200, 1)
	if(HAS_TRAIT(target, TRAIT_NOBLE))
		tax += 1
	return tax


var/static/list/shamanic_commit_fold_cache = list()
/proc/get_shamanic_commit_fold(block_type, curse)
	var/cache_key = "[block_type]:[curse ? "curse" : "bless"]"
	if(!isnull(shamanic_commit_fold_cache[cache_key]))
		return shamanic_commit_fold_cache[cache_key]
	var/obj/item/shamanic_totem_block/B = new block_type
	var/list/fold_src = curse ? B.commit_curse_folded : B.commit_blessing_folded
	var/list/result = fold_src ? fold_src.Copy() : null
	qdel(B)
	shamanic_commit_fold_cache[cache_key] = result
	return result

/proc/get_covering_totems(mob/living/carbon/human/target)
	. = list()
	for(var/obj/structure/shamanic_totem/T in range(SHAMANIC_TOTEM_AURA_RANGE, target))
		if(QDELETED(T) || T.z != target.z)
			continue
		if(length(T.totem_blocks) < SHAMANIC_TOTEM_MIN_BLOCKS)
			continue
		if(get_dist(T, target) > SHAMANIC_TOTEM_AURA_RANGE)
			continue
		. += T

/obj/structure/shamanic_totem/proc/is_dendor_committed()
	var/count = 0
	for(var/block_type in totem_blocks)
		if(initial(block_type:patron_type) == /datum/patron/divine/dendor)
			count++
	return count >= SHAMANIC_TOTEM_COMMIT_THRESHOLD

/obj/structure/shamanic_totem/proc/count_dendor_fauna(type)
	var/c = 0
	for(var/atom/A in range(4, src))
		if(istype(A, type))
			c++
	return c

/obj/structure/shamanic_totem/proc/pick_dendor_spawn_turf(spawn_type)
	var/list/turfs = list()
	for(var/turf/T in range(3, src))
		if(T == loc)
			continue
		if(!isfloorturf(T))
			continue
		if(T.density)
			continue
		if(is_blocked_turf(T))
			continue
		if(spawn_type && locate(spawn_type) in T)
			continue
		turfs += T
	if(!turfs.len)
		return null
	return pick(turfs)

/proc/spawn_shamanic_block(block_type, atom/loc)
	var/obj/item/shamanic_totem_block/B = new block_type(loc)
	if(istype(B))
		B.pixel_x = rand(-4, 4)
		B.pixel_y = rand(0, 4)
	return B


/obj/structure/shamanic_totem/proc/get_combined_effects(mob/living/carbon/human/target, list/covering = null)
	if(isnull(covering))
		covering = get_covering_totems(target)
	var/list/combined = list()
	var/list/patron_counts = list()
	for(var/obj/structure/shamanic_totem/T in covering)
		for(var/block_type in T.totem_blocks)
			var/p = initial(block_type:patron_type)
			if(p)
				patron_counts[p] = (patron_counts[p] || 0) + 1
	for(var/patron in patron_counts)
		var/obj/structure/shamanic_totem/best
		var/best_blocks = -1
		var/best_dist = INFINITY
		for(var/obj/structure/shamanic_totem/T in covering)
			var/blocks = 0
			for(var/block_type in T.totem_blocks)
				if(initial(block_type:patron_type) == patron)
					blocks++
			if(!blocks)
				continue
			var/dist = get_dist(T, target)
			if(blocks > best_blocks || (blocks == best_blocks && dist < best_dist))
				best = T
				best_blocks = blocks
				best_dist = dist
		if(!best)
			continue
		var/list/eff = best.get_effects(FALSE, target, covering, patron)
		for(var/S in eff)
			combined[S] = (combined[S] || 0) + eff[S]
	var/list/folded_gods = list()
	for(var/obj/structure/shamanic_totem/T in covering)
		for(var/block_type in T.totem_blocks)
			var/patron = initial(block_type:patron_type)
			if(patron in folded_gods)
				continue
			if((patron_counts[patron] || 0) < SHAMANIC_TOTEM_COMMIT_THRESHOLD)
				continue
			var/list/fold = get_shamanic_commit_fold(block_type, FALSE)
			if(fold)
				for(var/S in fold)
					combined[S] = (combined[S] || 0) + fold[S]
				folded_gods[patron] = TRUE
	return combined


/obj/structure/shamanic_totem/proc/get_combined_curse_effects(mob/living/carbon/human/target, list/covering = null)
	if(isnull(covering))
		covering = get_covering_totems(target)
	var/list/combined = list()
	var/list/patron_counts = list()
	for(var/obj/structure/shamanic_totem/T in covering)
		for(var/block_type in T.totem_blocks)
			var/p = initial(block_type:patron_type)
			if(p)
				patron_counts[p] = (patron_counts[p] || 0) + 1
	for(var/patron in patron_counts)
		var/obj/structure/shamanic_totem/best
		var/best_blocks = -1
		var/best_dist = INFINITY
		for(var/obj/structure/shamanic_totem/T in covering)
			var/blocks = 0
			for(var/block_type in T.totem_blocks)
				if(initial(block_type:patron_type) == patron)
					blocks++
			if(!blocks)
				continue
			var/dist = get_dist(T, target)
			if(blocks > best_blocks || (blocks == best_blocks && dist < best_dist))
				best = T
				best_blocks = blocks
				best_dist = dist
		if(!best)
			continue
		var/list/curse = best.get_curse_effects(target, covering, patron)
		for(var/S in curse)
			combined[S] = (combined[S] || 0) + curse[S]
	var/list/folded_gods = list()
	for(var/obj/structure/shamanic_totem/T in covering)
		for(var/block_type in T.totem_blocks)
			var/patron = initial(block_type:patron_type)
			if(patron in folded_gods)
				continue
			if((patron_counts[patron] || 0) < SHAMANIC_TOTEM_COMMIT_THRESHOLD)
				continue
			var/list/fold = get_shamanic_commit_fold(block_type, TRUE)
			if(fold)
				for(var/S in fold)
					combined[S] = (combined[S] || 0) + fold[S]
				folded_gods[patron] = TRUE
	var/greed = 0
	for(var/obj/structure/shamanic_totem/T in covering)
		for(var/block_type in T.totem_blocks)
			if(!greed && initial(block_type:greed_taxed))
				greed = compute_greed_tax(target)
	if(greed)
		for(var/S in list(STATKEY_SPD, STATKEY_STR, STATKEY_PER))
			combined[S] = (combined[S] || 0) - greed
	return combined

/obj/structure/shamanic_totem/proc/get_combined_patrons(mob/living/carbon/human/target, list/covering = null)
	if(isnull(covering))
		covering = get_covering_totems(target)
	var/list/patrons = list()
	for(var/obj/structure/shamanic_totem/T in covering)
		patrons |= T.get_healing_patrons()
	return patrons

/obj/structure/shamanic_totem/proc/get_commit_bonuses(mob/living/carbon/human/target, list/covering = null)
	if(isnull(covering))
		covering = get_covering_totems(target)
	var/list/type_counts = list()
	for(var/obj/structure/shamanic_totem/T in covering)
		for(var/block_type in T.totem_blocks)
			var/cur = type_counts[block_type]
			type_counts[block_type] = isnull(cur) ? 1 : (cur + 1)
	var/list/buffs = list()
	var/list/buff_statuses = list()
	var/list/debuffs = list()
	for(var/block_type in type_counts)
		if(type_counts[block_type] < SHAMANIC_TOTEM_COMMIT_THRESHOLD)
			continue
		var/buff = initial(block_type:commit_buff)
		var/debuff = initial(block_type:commit_debuff)
		if(buff)
			if(ispath(buff, /datum/status_effect))
				buff_statuses |= buff
			else
				buffs |= buff
		if(debuff)
			debuffs |= debuff
	return list("buffs" = buffs, "buff_statuses" = buff_statuses, "debuffs" = debuffs)


/obj/structure/shamanic_totem/proc/apply_commit_bonuses(mob/living/carbon/human/H, recipient, list/covering = null)
	var/list/bonuses = get_commit_bonuses(H, covering)
	var/list/want_traits = recipient ? bonuses["buffs"] : list()
	var/list/want_statuses = recipient ? bonuses["buff_statuses"] : bonuses["debuffs"]

	for(var/trait_type in (commit_buff_claims[H] || list()))
		if(!(trait_type in want_traits))
			REMOVE_TRAIT(H, trait_type, src)
			LAZYREMOVE(commit_buff_claims[H], trait_type)
	for(var/trait_type in want_traits)
		if(!(trait_type in (commit_buff_claims[H] || list())))
			ADD_TRAIT(H, trait_type, src)
			LAZYADD(commit_buff_claims[H], trait_type)

	for(var/se_type in (commit_debuff_claims[H] || list()))
		if(!(se_type in want_statuses))
			H.remove_status_effect(se_type)
			LAZYREMOVE(commit_debuff_claims[H], se_type)
	for(var/se_type in want_statuses)
		var/datum/status_effect/E = H.has_status_effect(se_type)
		if(E)


			E.duration = -1
		else
			H.apply_status_effect(se_type)
		LAZYADD(commit_debuff_claims[H], se_type)

/obj/structure/shamanic_totem/proc/remove_commit_bonuses(mob/living/carbon/human/H)
	for(var/trait_type in (commit_buff_claims[H] || list()))
		REMOVE_TRAIT(H, trait_type, src)
		LAZYREMOVE(commit_buff_claims[H], trait_type)
	for(var/se_type in (commit_debuff_claims[H] || list()))
		H.remove_status_effect(se_type)
		LAZYREMOVE(commit_debuff_claims[H], se_type)


/obj/structure/shamanic_totem/proc/linger_commit_bonuses(mob/living/carbon/human/H)
	for(var/se_type in ((commit_buff_claims[H] || list()) | (commit_debuff_claims[H] || list())))
		var/datum/status_effect/E = H.has_status_effect(se_type)
		if(E && E.duration == -1)
			E.duration = world.time + SHAMANIC_TOTEM_LINGER_TIME

/obj/structure/shamanic_totem/proc/apply_heal_to(mob/living/carbon/human/target)
	if(!target || QDELETED(target) || target.stat == DEAD)
		return
	target.apply_status_effect(/datum/status_effect/buff/shamanic_totem_heal, src)
	active_healed |= target

/obj/structure/shamanic_totem/proc/remove_heal_from(mob/living/carbon/human/target)
	active_healed -= target
	if(target && !QDELETED(target))
		var/datum/status_effect/buff/shamanic_totem_heal/H_eff = target.has_status_effect(/datum/status_effect/buff/shamanic_totem_heal)
		if(H_eff && H_eff.heal_totem == src)
			target.remove_status_effect(/datum/status_effect/buff/shamanic_totem_heal)

/obj/structure/shamanic_totem/proc/refresh_all_effects()
	if(length(totem_blocks) < SHAMANIC_TOTEM_MIN_BLOCKS)
		for(var/mob/living/carbon/human/H in active_buffed)
			remove_blessing_from(H)
			if(!QDELETED(H))
				to_chat(H, span_warning("[src] falls silent as its blocks are taken away."))
		for(var/mob/living/carbon/human/H in active_cursed)
			remove_curse_from(H)
			if(!QDELETED(H))
				to_chat(H, span_notice("The malevolent weight lifts as [src] falls silent."))
		for(var/mob/living/carbon/human/H in active_healed)
			remove_heal_from(H)
		for(var/mob/living/carbon/human/H in water_buff_claims)
			remove_water_effects(H)
		for(var/mob/living/carbon/human/H in (commit_buff_claims | commit_debuff_claims))
			remove_commit_bonuses(H)
		for(var/mob/living/carbon/human/H in (abyssor_buff_claims | abyssor_curse_claims))
			remove_abyssor_effects(H)
		return

	var/list/mob/living/carbon/human/touched = (active_buffed | active_cursed | active_healed)
	for(var/mob/living/carbon/human/H in touched)
		if(QDELETED(H) || H.stat == DEAD)
			remove_blessing_from(H)
			remove_curse_from(H)
			remove_heal_from(H)
			remove_abyssor_effects(H)
			remove_water_effects(H)
			continue
		var/list/covering = get_covering_totems(H)
		if(!is_dominant_totem_for(H, covering))
			remove_blessing_from(H)
			remove_curse_from(H)
			remove_heal_from(H)
			remove_abyssor_effects(H)
			remove_water_effects(H)
			continue


		var/recipient_of_covering = FALSE
		for(var/obj/structure/shamanic_totem/T in covering)
			if(H in T.recipients)
				recipient_of_covering = TRUE
				break

		if(recipient_of_covering)
			var/datum/status_effect/shamanic_totem/curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/curse)
			if(C)
				H.remove_status_effect(/datum/status_effect/shamanic_totem/curse)
			remove_curse_from(H)
			var/list/ce = get_combined_effects(H, covering)
			var/datum/status_effect/shamanic_totem/blessing/B = H.has_status_effect(/datum/status_effect/shamanic_totem/blessing)
			if(B && B.source_totem_ref?.resolve() == src)
				B.refresh_effects(ce)
			else
				apply_blessing_to(H, ce)
			if(H.patron?.type in get_combined_patrons(H, covering))
				apply_heal_to(H)
			else
				remove_heal_from(H)
			apply_commit_bonuses(H, TRUE, covering)
		else
			var/list/cc = get_combined_curse_effects(H, covering)
			var/datum/status_effect/shamanic_totem/blessing/B = H.has_status_effect(/datum/status_effect/shamanic_totem/blessing)
			if(B)
				H.remove_status_effect(/datum/status_effect/shamanic_totem/blessing)
			remove_blessing_from(H)
			var/datum/status_effect/shamanic_totem/curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/curse)
			if(length(cc))
				if(C && C.source_totem_ref?.resolve() == src)
					C.refresh_effects(cc)
				else
					apply_curse_to(H, cc)
			else if(C)
				H.remove_status_effect(/datum/status_effect/shamanic_totem/curse)
			remove_curse_from(H)
			apply_commit_bonuses(H, FALSE, covering)
		update_abyssor_effects(H, recipient_of_covering, TRUE, covering)
		update_water_effects(H, recipient_of_covering, TRUE)

/obj/structure/shamanic_totem/proc/get_abyssor_block_count(mob/living/carbon/human/H, list/covering = null)
	if(isnull(covering))
		covering = get_covering_totems(H)
	var/count = 0
	for(var/obj/structure/shamanic_totem/T in covering)
		for(var/block_type in T.totem_blocks)
			if(block_type == /obj/item/shamanic_totem_block/abyssor)
				count++
	return count

/obj/structure/shamanic_totem/proc/update_abyssor_effects(mob/living/carbon/human/H, recipient, coord, list/covering = null)
	if(QDELETED(H) || H.stat == DEAD)
		remove_abyssor_effects(H)
		return
	if(!coord)
		linger_abyssor_effects(H)
		return
	var/abc = get_abyssor_block_count(H, covering)
	if(abc <= 0)
		remove_abyssor_effects(H)
		return
	apply_abyssor_effects(H, recipient, abc)

/obj/structure/shamanic_totem/proc/apply_abyssor_effects(mob/living/carbon/human/H, recipient, count)
	if(QDELETED(H) || H.stat == DEAD)
		return
	if(recipient)
		if(H in abyssor_curse_claims)
			remove_abyssor_curse_from(H)
		var/mult = clamp(1 - 0.05 * count, 0.05, 1)
		var/datum/status_effect/shamanic_totem/abyssor_blessing/B = H.has_status_effect(/datum/status_effect/shamanic_totem/abyssor_blessing)
		if(B && B.source_totem_ref?.resolve() == src)
			B.stamina_mult = mult
			if(H)
				H.shamic_stamina_mult = mult
			B.make_persistent()
		else
			B = H.apply_status_effect(/datum/status_effect/shamanic_totem/abyssor_blessing, src)
			B.stamina_mult = mult
			if(H)
				H.shamic_stamina_mult = mult
			LAZYADD(abyssor_buff_claims, H)
	else
		if(H in abyssor_buff_claims)
			remove_abyssor_blessing_from(H)
		var/mult = 1 + (count / 9)
		var/datum/status_effect/shamanic_totem/abyssor_curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/abyssor_curse)
		if(C && C.source_totem_ref?.resolve() == src)
			C.slow_mult = mult
			C.make_persistent()
		else
			C = H.apply_status_effect(/datum/status_effect/shamanic_totem/abyssor_curse, src)
			C.slow_mult = mult
			LAZYADD(abyssor_curse_claims, H)

/obj/structure/shamanic_totem/proc/remove_abyssor_blessing_from(mob/living/carbon/human/H)
	var/datum/status_effect/shamanic_totem/abyssor_blessing/B = H.has_status_effect(/datum/status_effect/shamanic_totem/abyssor_blessing)
	if(B && B.source_totem_ref?.resolve() == src)
		H.remove_status_effect(/datum/status_effect/shamanic_totem/abyssor_blessing)

/obj/structure/shamanic_totem/proc/remove_abyssor_curse_from(mob/living/carbon/human/H)
	var/datum/status_effect/shamanic_totem/abyssor_curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/abyssor_curse)
	if(C && C.source_totem_ref?.resolve() == src)
		H.remove_status_effect(/datum/status_effect/shamanic_totem/abyssor_curse)

/obj/structure/shamanic_totem/proc/remove_abyssor_effects(mob/living/carbon/human/H)
	remove_abyssor_blessing_from(H)
	remove_abyssor_curse_from(H)

/obj/structure/shamanic_totem/proc/linger_abyssor_effects(mob/living/carbon/human/H)
	var/datum/status_effect/shamanic_totem/abyssor_blessing/B = H.has_status_effect(/datum/status_effect/shamanic_totem/abyssor_blessing)
	if(B && B.source_totem_ref?.resolve() == src && B.duration == -1)
		B.duration = world.time + SHAMANIC_TOTEM_LINGER_TIME
	var/datum/status_effect/shamanic_totem/abyssor_curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/abyssor_curse)
	if(C && C.source_totem_ref?.resolve() == src && C.duration == -1)
		C.duration = world.time + SHAMANIC_TOTEM_LINGER_TIME

/obj/structure/shamanic_totem/proc/count_water_tiles()
	var/c = 0
	for(var/turf/open/water/W in range(SHAMANIC_TOTEM_AURA_RANGE, src))
		if(W.z == z)
			c++
	return c

/obj/structure/shamanic_totem/proc/update_water_effects(mob/living/carbon/human/H, recipient, coord)
	if(QDELETED(H) || H.stat == DEAD)
		remove_water_effects(H)
		return
	if(!coord)
		linger_water_effects(H)
		return
	if(!recipient)
		remove_water_effects(H)
		return
	if(count_water_tiles() < SHAMANIC_TOTEM_WATER_TILE_THRESHOLD)
		remove_water_effects(H)
		return
	apply_water_effects(H)

/obj/structure/shamanic_totem/proc/apply_water_effects(mob/living/carbon/human/H)
	if(QDELETED(H) || H.stat == DEAD)
		return
	var/datum/status_effect/buff/shamanic_totem_water/W = H.has_status_effect(/datum/status_effect/buff/shamanic_totem_water)
	if(W && W.water_totem == src)
		W.make_persistent()
	else
		H.apply_status_effect(/datum/status_effect/buff/shamanic_totem_water, src)
		LAZYADD(water_buff_claims, H)

/obj/structure/shamanic_totem/proc/remove_water_effects(mob/living/carbon/human/H)
	if(H in water_buff_claims)
		var/datum/status_effect/buff/shamanic_totem_water/W = H.has_status_effect(/datum/status_effect/buff/shamanic_totem_water)
		if(W && W.water_totem == src)
			H.remove_status_effect(/datum/status_effect/buff/shamanic_totem_water)
		LAZYREMOVE(water_buff_claims, H)

/obj/structure/shamanic_totem/proc/linger_water_effects(mob/living/carbon/human/H)
	var/datum/status_effect/buff/shamanic_totem_water/W = H.has_status_effect(/datum/status_effect/buff/shamanic_totem_water)
	if(W && W.water_totem == src && W.duration == -1)
		W.duration = world.time + SHAMANIC_TOTEM_LINGER_TIME

/obj/structure/shamanic_totem/proc/apply_blessing_to(mob/living/carbon/human/target, list/effects)
	if(QDELETED(target) || target.stat == DEAD)
		return
	target.apply_status_effect(/datum/status_effect/shamanic_totem/blessing, src, effects)
	active_buffed |= target

/obj/structure/shamanic_totem/proc/remove_blessing_from(mob/living/carbon/human/target)
	active_buffed -= target
	if(target && !QDELETED(target))
		var/datum/status_effect/shamanic_totem/blessing/B = target.has_status_effect(/datum/status_effect/shamanic_totem/blessing)
		if(B && B.source_totem_ref?.resolve() == src)
			target.remove_status_effect(/datum/status_effect/shamanic_totem/blessing)

/obj/structure/shamanic_totem/proc/apply_curse_to(mob/living/carbon/human/target, list/effects)
	if(QDELETED(target) || target.stat == DEAD)
		return
	target.apply_status_effect(/datum/status_effect/shamanic_totem/curse, src, effects)
	active_cursed |= target

/obj/structure/shamanic_totem/proc/remove_curse_from(mob/living/carbon/human/target)
	active_cursed -= target
	if(target && !QDELETED(target))
		var/datum/status_effect/shamanic_totem/curse/C = target.has_status_effect(/datum/status_effect/shamanic_totem/curse)
		if(C && C.source_totem_ref?.resolve() == src)
			target.remove_status_effect(/datum/status_effect/shamanic_totem/curse)

/obj/structure/shamanic_totem/proc/handle_effect_expired(mob/living/carbon/human/target)
	if(!target)
		return
	active_buffed -= target
	active_cursed -= target

/obj/structure/shamanic_totem/proc/update_appearance()
	cut_overlays()
	for(var/i = 1 to length(totem_blocks))
		var/block_type = totem_blocks[i]
		var/mutable_appearance/MA = mutable_appearance(initial(block_type:icon), initial(block_type:icon_state), layer = src.layer + (i * 0.01))
		MA.color = initial(block_type:color)
		MA.pixel_y = (i - 1) * 6
		add_overlay(MA)


/obj/structure/shamanic_totem/proc/is_dominant_totem_for(mob/living/carbon/human/target, list/covering = null)
	if(!target || QDELETED(target) || target.stat == DEAD)
		return FALSE
	if(length(totem_blocks) < SHAMANIC_TOTEM_MIN_BLOCKS)
		return FALSE
	if(isnull(covering))
		covering = get_covering_totems(target)
	var/obj/structure/shamanic_totem/best
	var/best_blocks = -1
	var/best_dist = INFINITY
	for(var/obj/structure/shamanic_totem/T in covering)
		var/blocks = length(T.totem_blocks)
		var/dist = get_dist(T, target)
		if(blocks > best_blocks || (blocks == best_blocks && dist < best_dist))
			best = T
			best_blocks = blocks
			best_dist = dist
	return (best == src)

/obj/structure/shamanic_totem/process(delta_time)
	if(QDELETED(src) || length(totem_blocks) < SHAMANIC_TOTEM_MIN_BLOCKS)
		return

	if(owner && !QDELETED(owner) && owner.stat != DEAD && world.time >= next_stamina_drain)
		var/drain = SHAMANIC_TOTEM_STAMINA_DRAIN + max(0, length(recipients) - 1) * (SHAMANIC_TOTEM_STAMINA_DRAIN / 2)
		if(drain > 0)
			owner.energy_add(-drain)
		next_stamina_drain = world.time + SHAMANIC_TOTEM_STAMINA_DRAIN_INTERVAL
		if(owner.energy <= 0)
			to_chat(owner, span_warning("My totem's thirst for my vitality leaves me spent — it will keep draining as long as it stands."))

	if(is_dendor_committed())
		if(world.time >= next_growth_start)
			if(world.time >= next_vine_spawn)
				next_vine_spawn = world.time + SHAMANIC_TOTEM_DENDOR_VINE_INTERVAL
				for(var/i in 1 to SHAMANIC_TOTEM_DENDOR_VINE_BURST)
					if(count_dendor_fauna(/obj/structure/vine) >= SHAMANIC_TOTEM_DENDOR_VINE_CAP)
						break
					var/turf/T = pick_dendor_spawn_turf(/obj/structure/vine)
					if(T)
						new /obj/structure/vine(T)
			if(world.time >= next_kneestinger_spawn)
				next_kneestinger_spawn = world.time + SHAMANIC_TOTEM_DENDOR_KNEESTINGER_INTERVAL
				for(var/i in 1 to SHAMANIC_TOTEM_DENDOR_KNEESTINGER_BURST)
					if(count_dendor_fauna(/obj/structure/glowshroom) >= SHAMANIC_TOTEM_DENDOR_KNEESTINGER_CAP)
						break
					var/turf/T = pick_dendor_spawn_turf(/obj/structure/glowshroom)
					if(T)
						new /obj/structure/glowshroom(T)

	var/list/mob/living/carbon/human/to_process = list()
	for(var/mob/living/carbon/human/H in range(SHAMANIC_TOTEM_AURA_RANGE, src))
		if(H.z == z && H.stat != DEAD)
			to_process |= H
	for(var/mob/living/carbon/human/H in (active_buffed | active_cursed | active_healed))
		if(!(H in to_process))
			to_process |= H

	for(var/mob/living/carbon/human/H in to_process)
		if(QDELETED(H) || H.stat == DEAD)
			remove_blessing_from(H)
			remove_curse_from(H)
			remove_heal_from(H)
			remove_commit_bonuses(H)
			remove_abyssor_effects(H)
			continue


		var/list/covering = get_covering_totems(H)
		var/coord = is_dominant_totem_for(H, covering)
		var/recipient_of_covering = FALSE

		if(coord)
			for(var/obj/structure/shamanic_totem/T in covering)
				if(H in T.recipients)
					recipient_of_covering = TRUE
					break
			if(recipient_of_covering)
				var/datum/status_effect/shamanic_totem/curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/curse)
				if(C)
					H.remove_status_effect(/datum/status_effect/shamanic_totem/curse)
				remove_curse_from(H)
				var/list/ce = get_combined_effects(H, covering)
				if(!(H in active_buffed))
					apply_blessing_to(H, ce)
					to_chat(H, span_notice("[src]'s spirits settle over me."))
				else
					var/datum/status_effect/shamanic_totem/blessing/B = H.has_status_effect(/datum/status_effect/shamanic_totem/blessing)
					if(B && B.source_totem_ref?.resolve() == src)
						B.refresh_effects(ce)
						if(B.make_persistent())
							to_chat(H, span_notice("I step back within [src]'s influence."))
				if(H.patron?.type in get_combined_patrons(H, covering))
					apply_heal_to(H)
				else
					remove_heal_from(H)
			else
				var/datum/status_effect/shamanic_totem/blessing/B = H.has_status_effect(/datum/status_effect/shamanic_totem/blessing)
				if(B)
					H.remove_status_effect(/datum/status_effect/shamanic_totem/blessing)
				remove_blessing_from(H)
				var/list/cc = get_combined_curse_effects(H, covering)
				if(length(cc))
					if(!(H in active_cursed))
						apply_curse_to(H, cc)
						to_chat(H, span_danger("A malevolent presence from [src] weighs down my body!"))
					else
						var/datum/status_effect/shamanic_totem/curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/curse)
						if(C && C.source_totem_ref?.resolve() == src)
							C.refresh_effects(cc)
							if(C.make_persistent())
								to_chat(H, span_danger("I step back within [src]'s reach. Its curse tightens again."))
				else
					var/datum/status_effect/shamanic_totem/curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/curse)
					if(C)
						H.remove_status_effect(/datum/status_effect/shamanic_totem/curse)
					remove_curse_from(H)
				remove_heal_from(H)
				apply_commit_bonuses(H, FALSE, covering)
				if(is_patron_committed(H, /datum/patron/inhumen/baotha, covering) && H.reagents)
					H.reagents.add_reagent(/datum/reagent/drug/swampweed, SHAMANIC_TOTEM_BAOTHA_SWAMPWEED_INJECT)
			if(recipient_of_covering)
				apply_commit_bonuses(H, TRUE, covering)
		else
			var/datum/status_effect/shamanic_totem/blessing/B = H.has_status_effect(/datum/status_effect/shamanic_totem/blessing)
			if(B && B.source_totem_ref?.resolve() == src)
				if(B.start_linger())
					to_chat(H, span_warning("I've moved too far from [src], or a stronger totem overshadows it. Its blessing clings to me for a moment longer."))
			else
				remove_blessing_from(H)
			var/datum/status_effect/shamanic_totem/curse/C = H.has_status_effect(/datum/status_effect/shamanic_totem/curse)
			if(C && C.source_totem_ref?.resolve() == src)
				if(C.start_linger())
					to_chat(H, span_warning("I leave [src]'s reach, but its curse clings to me for a moment longer."))
			else
				remove_curse_from(H)
			remove_heal_from(H)
			linger_commit_bonuses(H)
		update_abyssor_effects(H, recipient_of_covering, coord, covering)
		update_water_effects(H, recipient_of_covering, coord)

/obj/structure/shamanic_totem/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/shamanic_totem_block))
		if(user != owner)
			to_chat(user, span_warning("This isn't my totem to add to."))
			return
		if(user.get_skill_level(/datum/skill/craft/spiritism) < SHAMANIC_TOTEM_STACK_MIN_LEVEL)
			to_chat(user, span_warning("I don't understand how to work with this properly."))
			return
		var/cap = get_max_blocks()
		if(length(totem_blocks) >= cap)
			if(owner.get_skill_level(/datum/skill/craft/spiritism) < SHAMANIC_TOTEM_MASTER_LEVEL)
				to_chat(user, span_warning("The totem already holds all the blocks it will take from me."))
			else
				to_chat(user, span_warning("The totem can't hold any more blocks."))
			return
		var/same_count = 0
		for(var/existing in totem_blocks)
			if(existing == I.type)
				same_count++
		if(same_count >= SHAMANIC_TOTEM_MAX_SAME_BLOCKS)
			to_chat(user, span_warning("The totem already holds as many [I.name] blocks as it can take."))
			return
		var/block_type = I.type
		var/block_name = I.name
		qdel(I)
		add_block(block_type)
		user.visible_message(span_notice("[user] stacks a [block_name] into [src]."))
		return
	return ..()

/obj/structure/shamanic_totem/attack_hand(mob/user)
	if(!isliving(user))
		return ..()
	if(user != owner)
		to_chat(user, span_warning("This isn't my totem to take apart."))
		return
	if(!length(totem_blocks))
		to_chat(user, span_warning("There's nothing left to remove."))
		return
	user.visible_message(span_notice("[user] begins pulling a block off [src]."))
	if(!do_after(user, 1 SECONDS, TRUE, src))
		return
	remove_block(user)


/obj/structure/shamanic_totem/Click(location, control, params)
	var/list/modifiers = islist(params) ? params : params2list(params)
	if(usr == owner && modifiers["alt"] && modifiers["left"] && !modifiers["right"])
		reclaim_whole(usr)
		return
	return ..()

/obj/structure/shamanic_totem/proc/reclaim_whole(mob/user)
	if(user != owner)
		return
	if(!user.Adjacent(src))
		to_chat(user, span_warning("I need to get closer to [src]."))
		return
	if(length(totem_blocks) < SHAMANIC_TOTEM_MAX_BLOCKS)
		to_chat(user, span_warning("I need all [SHAMANIC_TOTEM_MAX_BLOCKS] blocks stacked before I can pack the totem up whole."))
		return
	user.visible_message(span_notice("[user] begins uprooting [src] whole."))
	if(!do_after(user, 2 SECONDS, TRUE, src))
		return
	if(QDELETED(src) || user != owner)
		return
	var/obj/item/shamanic_totem/new_item = new /obj/item/shamanic_totem(get_turf(src))
	new_item.owner = owner
	new_item.recipients = recipients - owner
	new_item.totem_blocks = totem_blocks.Copy()
	new_item.max_recipients = max_recipients
	totem_blocks.Cut()
	qdel(src)

#define SHAMANIC_TOTEM_UNWORTHY_DAMAGE 15

#define SHAMANIC_TOTEM_UNWORTHY_STUN (4 SECONDS)

/obj/item/shamanic_totem
	name = "Packed totem"
	desc = "A large, unwieldy wooden structure covered with stiched up sacks. You can see small painted parts between rugged cloth."
	icon = 'modular_twilight_axis/icons/obj/structures/totem.dmi'
	icon_state = "Totem2"
	experimental_onback = TRUE
	lefthand_file = 'modular_twilight_axis/icons/obj/structures/totem_hand.dmi'
	righthand_file = 'modular_twilight_axis/icons/obj/structures/totem_hand.dmi'
	item_state = "Totem1"
	mob_overlay_icon = 'modular_twilight_axis/icons/obj/structures/totem_hand.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	w_class = WEIGHT_CLASS_HUGE
	twohands_required = TRUE
	slot_flags = ITEM_SLOT_BACK
	force = 12
	force_wielded = 32
	wdefense = 3
	gripped_intents = list(/datum/intent/mace/smash/wood)
	resistance_flags = FIRE_PROOF
	var/mob/living/carbon/human/owner
	var/list/mob/living/carbon/human/recipients = list()
	var/list/totem_blocks = list()
	var/max_recipients = SHAMANIC_TOTEM_MAX_RECIPIENTS

/obj/item/shamanic_totem/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, HERESYDESC_GRONN)

/obj/item/shamanic_totem/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Activate it in your hand to plant it back into the ground, with every stacked block intact.")
	. += span_info("It can be strapped to your back to carry, but actually wielding it — to plant it or swing it — takes both hands.")
	. += span_info("Only the totem's owner can plant or reclaim it. Anyone without training in Spiritism who picks it up will be hurt for their trouble.")

/obj/item/shamanic_totem/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped_by_unworthy))

/obj/item/shamanic_totem/generateonmob(tag, prop, behind, mirrored)
	if(!length(totem_blocks))
		var/saved_icon = icon
		var/saved_state = icon_state
		icon = 'modular_twilight_axis/icons/obj/structures/totem_hand.dmi'
		icon_state = "Totem1"
		var/result = ..()
		icon = saved_icon
		icon_state = saved_state
		return result

	var/list/used_prop = prop
	var/used_mask = 'icons/roguetown/helpers/inhand_64.dmi'
	var/icon/returned = icon(used_mask, "blank")
	var/icon/totem_icon = icon('modular_twilight_axis/icons/obj/structures/totem_hand.dmi', "Totem1")

	if(!totem_icon)
		return

	var/icon/blended = icon(totem_icon)
	blended.Scale(64, 64)


	var/list/dir_params = list(
		list("dir" = NORTH, "above" = "northabove", "mask" = "north", "pfx" = "n", "mflip" = WEST),
		list("dir" = SOUTH, "above" = "southabove", "mask" = "south", "pfx" = "s", "mflip" = EAST),
		list("dir" = EAST,  "above" = null,          "mask" = "east",  "pfx" = null, "mflip" = EAST),
		list("dir" = WEST,  "above" = null,          "mask" = "west",  "pfx" = null, "mflip" = EAST),
	)

	for(var/list/dp in dir_params)
		var/dir = dp["dir"]
		var/pfx = dp["pfx"]
		var/mflip = dp["mflip"]


		if(isnull(pfx))
			switch(dir)
				if(EAST)
					pfx = mirrored ? "w" : "e"
				if(WEST)
					pfx = mirrored ? "e" : "w"


		var/above_key = dp["above"]
		if(isnull(above_key))
			switch(dir)
				if(EAST)
					above_key = mirrored ? "westabove" : "eastabove"
				if(WEST)
					above_key = mirrored ? "eastabove" : "westabove"

		var/render_this_dir = FALSE
		if(!behind)
			if(used_prop[above_key] == 1)
				render_this_dir = TRUE
		else
			if(used_prop[above_key] == 0)
				render_this_dir = TRUE

		if(!render_this_dir)
			continue

		var/px = 0
		var/py = 0
		var/icon/holder = icon(blended)
		var/icon/masky = icon(icon = used_mask, icon_state = dp["mask"])
		holder.Blend(masky, ICON_MULTIPLY)

		if(!isnull(used_prop["[pfx]flip"]))
			holder.Flip(used_prop["[pfx]flip"])
		if(!isnull(used_prop["[pfx]turn"]))
			holder.Turn(used_prop["[pfx]turn"])

		if(!isnull(used_prop["[pfx]x"]))
			px += used_prop["[pfx]x"]
			if(mirrored)
				px = -px

		if(!isnull(used_prop["[pfx]y"]))
			py += used_prop["[pfx]y"]

		var/ax = 0
		if(!isnull(used_prop["shrink"]))
			holder.Scale(64 * used_prop["shrink"], 64 * used_prop["shrink"])
			ax = 32 - (holder.Width() / 2)

		px += ax
		py += ax

		if(mirrored)
			holder.Flip(mflip)

		returned.Blend(holder, ICON_OVERLAY, x = px, y = py)

	return returned

/obj/item/shamanic_totem/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8, "sx" = 0, "sy" = 0, "nx" = 0, "ny" = 0, "wx" = 0, "wy" = 0, "ex" = 0, "ey" = 0, "nturn" = 15, "sturn" = 15, "wturn" = 15, "eturn" = 15, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 1)
			if("wielded")
				return list("shrink" = 0.8, "sx" = 0, "sy" = 0, "nx" = 0, "ny" = 0, "wx" = 0, "wy" = 0, "ex" = 0, "ey" = 0, "nturn" = 15, "sturn" = 15, "wturn" = 15, "eturn" = 15, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 1)
			if("onback")
				return list("shrink" = 0.8, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 45, "sturn" = 45, "wturn" = 45, "eturn" = -45, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)


/obj/item/shamanic_totem/proc/on_equipped_by_unworthy()
	SIGNAL_HANDLER
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/user = loc
	if(user.get_skill_level(/datum/skill/craft/spiritism) > SKILL_LEVEL_NONE)
		return
	to_chat(user, span_danger("The spirits bound in [src] reject my unworthy hands!"))
	addtimer(CALLBACK(src, PROC_REF(apply_unworthy_punishment), user), 0)

/obj/item/shamanic_totem/proc/apply_unworthy_punishment(mob/living/carbon/human/user)
	if(QDELETED(user))
		return
	user.adjustBruteLoss(SHAMANIC_TOTEM_UNWORTHY_DAMAGE)
	user.Stun(SHAMANIC_TOTEM_UNWORTHY_STUN)


/obj/item/shamanic_totem/attack_self(mob/user)
	..()
	if(!ishuman(user))
		to_chat(user, span_warning("I don't know how to plant this properly."))
		return
	if(owner && user != owner)
		to_chat(user, span_warning("This totem belongs to someone else. I can't plant it."))
		return
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, span_warning("I need solid ground to plant this on!"))
		return
	for(var/obj/A in T)
		if(istype(A, /obj/structure))
			to_chat(user, span_warning("I need some free space to plant [src] here!"))
			return
		if(A.density && !(A.flags_1 & ON_BORDER_1))
			to_chat(user, span_warning("There is already something here!"))
			return
	user.visible_message(span_notice("[user] begins planting [src] into the ground."))
	if(!do_after(user, 2 SECONDS, TRUE, src))
		return
	var/turf/T2 = get_turf(src)
	if(!isfloorturf(T2))
		return
	var/mob/living/carbon/human/H = owner ? owner : user
	if(H.owned_shamanic_totem)
		to_chat(user, span_warning("The totem's owner already has another totem planted. They should take it apart first."))
		return
	var/obj/structure/shamanic_totem/totem = new /obj/structure/shamanic_totem(T2)
	totem.set_owner(H)
	totem.totem_blocks = totem_blocks.Copy()
	totem.max_blocks = totem.get_max_blocks()
	totem.max_recipients = max_recipients
	for(var/mob/living/carbon/human/R in recipients)
		totem.add_recipient(R)
	totem.update_appearance()
	totem.refresh_all_effects()
	qdel(src)

/obj/item/shamanic_totem/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	if(slot == SLOT_BACK || slot == SLOT_BACK_R || slot == SLOT_BACK_L || slot == ITEM_SLOT_BACK || slot == ITEM_SLOT_BACK_R || slot == ITEM_SLOT_BACK_L)

		if(!M)
			return FALSE
		if(HAS_TRAIT(M, TRAIT_CHUNKYFINGERS) && (!equipper || equipper == M) && type != /obj/item/grabbing/bite)
			to_chat(M, span_warning("...What?"))
			return FALSE
		var/equip_slot = SLOT_BACK
		if(slot == SLOT_BACK_R || slot == ITEM_SLOT_BACK_R)
			equip_slot = SLOT_BACK_R
		else if(slot == SLOT_BACK_L || slot == ITEM_SLOT_BACK_L)
			equip_slot = SLOT_BACK_L
		return M.can_equip(src, equip_slot, disable_warning, bypass_equip_delay_self)
	return ..()

/mob/living/carbon/human/proc/shamanic_totem_manage_roster()
	set name = "Totem: Manage Roster"
	set category = "RoleUnique.ShamanicTotem"

	if(!owned_shamanic_totem)
		to_chat(src, span_warning("I don't have a totem planted."))
		return FALSE

	var/obj/structure/shamanic_totem/totem = owned_shamanic_totem

	var/list/candidates = list()
	for(var/mob/living/carbon/human/nearby in view(SHAMANIC_TOTEM_AURA_RANGE, src))
		if(nearby == src)
			continue
		candidates += nearby

	if(!length(candidates))
		to_chat(src, span_warning("There's no one nearby to add or remove."))
		return FALSE

	var/mob/living/carbon/human/target = tgui_input_list(src, "Toggle who benefits from my totem's blessing:", "Totem Roster", candidates)
	if(!target || !(target in candidates))
		return FALSE

	if(target in totem.recipients)
		totem.remove_recipient(target)
		to_chat(src, span_notice("I turn the totem's favor from [target.real_name]."))
		to_chat(target, span_warning("[src] turns the totem's favor from me."))
	else
		if(!totem.add_recipient(target))
			to_chat(src, span_warning("The totem already shelters as many as it can."))
			return FALSE
		to_chat(src, span_notice("I extend the totem's favor to [target.real_name]."))
		to_chat(target, span_notice("[src] extends the totem's favor to me."))

	return TRUE

/mob/living/carbon/human/proc/shamanic_totem_clear_roster()
	set name = "Totem: Clear Roster"
	set category = "RoleUnique.ShamanicTotem"

	if(!owned_shamanic_totem)
		to_chat(src, span_warning("I don't have a totem planted."))
		return FALSE

	var/obj/structure/shamanic_totem/totem = owned_shamanic_totem
	for(var/mob/living/carbon/human/H in totem.recipients - src)
		totem.remove_recipient(H)
		to_chat(H, span_warning("[src] withdraws the totem's favor from me. I'm no longer sheltered by it."))

	to_chat(src, span_notice("I withdraw the totem's favor from all but myself."))
	return TRUE

/mob/living/carbon/human/proc/shamanic_totem_disassemble()
	set name = "Totem: Disassemble"
	set category = "RoleUnique.ShamanicTotem"

	if(!owned_shamanic_totem)
		to_chat(src, span_warning("I don't have a totem planted."))
		return FALSE

	var/obj/structure/shamanic_totem/totem = owned_shamanic_totem
	to_chat(src, span_info("I reach out and unmake my totem wherever it stands."))
	if(!do_after(src, 2 SECONDS, FALSE, src))
		return FALSE
	if(QDELETED(totem) || totem.owner != src)
		return FALSE

	totem.disassemble(src)
	return TRUE

/datum/status_effect/shamanic_totem
	duration = -1
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/datum/weakref/source_totem_ref
	var/linger_time = SHAMANIC_TOTEM_LINGER_TIME

/datum/status_effect/shamanic_totem/on_creation(mob/living/new_owner, obj/structure/shamanic_totem/totem, list/effects)
	source_totem_ref = WEAKREF(totem)
	if(effects)
		effectedstats = effects
	. = ..()

/datum/status_effect/shamanic_totem/on_apply()


	return ..()

/datum/status_effect/shamanic_totem/on_remove()


	. = ..()
	var/obj/structure/shamanic_totem/totem = source_totem_ref?.resolve()
	if(totem && !QDELETED(totem))
		totem.handle_effect_expired(owner)


/datum/status_effect/shamanic_totem/proc/make_persistent()
	if(duration == -1)
		return FALSE
	duration = -1
	return TRUE


/datum/status_effect/shamanic_totem/proc/start_linger()
	if(duration != -1)
		return FALSE
	duration = world.time + linger_time
	return TRUE


/datum/status_effect/shamanic_totem/proc/refresh_effects(list/new_effects)
	if(!owner || QDELETED(owner))
		return FALSE
	for(var/S in effectedstats)
		owner.change_stat(S, -effectedstats[S])
	effectedstats = list()
	if(new_effects)
		for(var/S in new_effects)
			var/amt = new_effects[S]
			if(!amt)
				continue
			var/newval = owner.get_stat(S) + amt
			if(newval < 1)
				amt = 1 - owner.get_stat(S)
			else if(newval > 20)
				amt = 20 - owner.get_stat(S)
			if(!amt)
				continue
			effectedstats[S] = amt
			owner.change_stat(S, amt)
	return TRUE


/datum/status_effect/shamanic_totem/tick(delta_time)
	var/obj/structure/shamanic_totem/totem = source_totem_ref?.resolve()
	if(!totem || QDELETED(totem))
		qdel(src)

/atom/movable/screen/alert/status_effect/buff/shamanic_totem_blessing
	name = "Totem's Blessing"
	desc = "The spirits of the totem watch over me."
	icon_state = "buff"

/datum/status_effect/shamanic_totem/blessing
	id = "shamanic_totem_blessing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/shamanic_totem_blessing

/atom/movable/screen/alert/status_effect/debuff/shamanic_totem_curse
	name = "Totem's Curse"
	desc = "A malevolent presence weighs down my body, leaving me drained and weary."
	icon_state = "restrained"

/atom/movable/screen/alert/status_effect/buff/shamanic_totem_commit_graggar
	name = "Grinning Moose's Favor"
	desc = "The Grinning Moose's favor fills me: my body brims past its limits, and pain no longer stays my hand."
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/debuff/shamanic_totem_commit_zizo
	name = "Plotting Wolf's Malice"
	desc = "The Plotting Wolf's malice dogs me: a foul, scheming dread settles in and my body grows frail."
	icon_state = "restrained"

/atom/movable/screen/alert/status_effect/buff/shamanic_totem_commit_dendor
	name = "Volfskinned Man's Favor"
	desc = "The Volfskinned Man's favor makes the wild my home, sharpening my senses and saving from nature's wrath."
	icon_state = "buff"

/datum/status_effect/shamanic_totem/curse
	id = "shamanic_totem_curse"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/shamanic_totem_curse

#define SHAMANIC_TOTEM_HEAL_FILTER "shamanic_totem_heal_glow"

/datum/status_effect/buff/shamanic_totem_heal
	id = "shamanic_totem_heal"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 10 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	examine_text = "SUBJECTPRONOUN is bathed in a soothing totemic light!"
	var/healing_on_tick = SHAMANIC_TOTEM_HEAL_PER_TICK
	var/outline_colour = "#87cefa"

	var/obj/structure/shamanic_totem/heal_totem

/datum/status_effect/buff/shamanic_totem_heal/on_creation(mob/living/new_owner, obj/structure/shamanic_totem/source_totem, new_healing_on_tick)
	heal_totem = source_totem
	if(!isnull(new_healing_on_tick))
		healing_on_tick = new_healing_on_tick
	return ..()

/datum/status_effect/buff/shamanic_totem_heal/on_apply()
	var/filter = owner.get_filter(SHAMANIC_TOTEM_HEAL_FILTER)
	if(!filter)
		owner.add_filter(SHAMANIC_TOTEM_HEAL_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/shamanic_totem_heal/on_remove()
	. = ..()
	owner.remove_filter(SHAMANIC_TOTEM_HEAL_FILTER)

/datum/status_effect/buff/shamanic_totem_heal/tick()
	if(HAS_TRAIT(owner, TRAIT_NOHEAL) || HAS_TRAIT(owner, TRAIT_IRONMAN))
		return
	if(HAS_TRAIT(owner, TRAIT_HALFHEAL))
		healing_on_tick /= 2
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#87cefa"
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume + healing_on_tick, BLOOD_VOLUME_NORMAL)
	var/list/wCount = owner.get_wounds()
	if(length(wCount))
		owner.heal_wounds(healing_on_tick)
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick)

#undef SHAMANIC_TOTEM_HEAL_FILTER

#define SHAMANIC_TOTEM_WATER_FILTER "shamanic_totem_water_glow"

/atom/movable/screen/alert/status_effect/buff/shamanic_totem_water
	name = "Tidal Blessing"
	desc = "The totem's tide refreshes my body, slowly mending wounds."
	icon_state = "buff"

/datum/status_effect/buff/shamanic_totem_water
	id = "shamanic_totem_water"
	alert_type = /atom/movable/screen/alert/status_effect/buff/shamanic_totem_water
	duration = -1
	status_type = STATUS_EFFECT_UNIQUE
	examine_text = "SUBJECTPRONOUN is cradled by the totem's living tide!"
	var/healing_on_tick = SHAMANIC_TOTEM_WATER_HEAL_WOUNDS
	var/stamina_regen = SHAMANIC_TOTEM_WATER_STAMINA_REGEN
	var/outline_colour = "#3fb8c8"
	var/obj/structure/shamanic_totem/water_totem

/datum/status_effect/buff/shamanic_totem_water/on_creation(mob/living/new_owner, obj/structure/shamanic_totem/source_totem)
	water_totem = source_totem
	return ..()

/datum/status_effect/buff/shamanic_totem_water/on_apply()
	var/filter = owner.get_filter(SHAMANIC_TOTEM_WATER_FILTER)
	if(!filter)
		owner.add_filter(SHAMANIC_TOTEM_WATER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/shamanic_totem_water/on_remove()
	. = ..()
	owner.remove_filter(SHAMANIC_TOTEM_WATER_FILTER)

/datum/status_effect/buff/shamanic_totem_water/proc/make_persistent()
	if(duration == -1)
		return FALSE
	duration = -1
	return TRUE

/datum/status_effect/buff/shamanic_totem_water/proc/start_linger()
	if(duration != -1)
		return FALSE
	duration = world.time + SHAMANIC_TOTEM_LINGER_TIME
	return TRUE

/datum/status_effect/buff/shamanic_totem_water/tick()

	if(!water_totem || QDELETED(water_totem))
		qdel(src)
		return
	if(HAS_TRAIT(owner, TRAIT_NOHEAL) || HAS_TRAIT(owner, TRAIT_IRONMAN))
		return


	if(HAS_TRAIT(owner, TRAIT_HALFHEAL))
		healing_on_tick /= 2
		stamina_regen /= 2
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = outline_colour
	if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
		owner.blood_volume = min(owner.blood_volume + healing_on_tick, BLOOD_VOLUME_NORMAL)
	var/list/wCount = owner.get_wounds()
	if(length(wCount))
		owner.heal_wounds(healing_on_tick)
		owner.update_damage_overlays()

	owner.adjustBruteLoss(-SHAMANIC_TOTEM_WATER_HEAL_BRUTE * REAGENTS_EFFECT_MULTIPLIER, 0)
	owner.adjustFireLoss(-SHAMANIC_TOTEM_WATER_HEAL_FIRE * REAGENTS_EFFECT_MULTIPLIER, 0)
	owner.adjustOxyLoss(-SHAMANIC_TOTEM_WATER_HEAL_OXY * REAGENTS_EFFECT_MULTIPLIER, 0)
	owner.adjustCloneLoss(-SHAMANIC_TOTEM_WATER_HEAL_CLONE * REAGENTS_EFFECT_MULTIPLIER)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5 * REAGENTS_EFFECT_MULTIPLIER)

	owner.stamina_add(-stamina_regen)

#undef SHAMANIC_TOTEM_WATER_FILTER


#define TRAIT_SPIRIT_CHOSEN "Spirit Chosen"

/datum/skill/craft/spiritism
	name = "Spiritism"
	desc = "Communion with totemic spirits. Governs the crafting of shamanic totem blocks. Only the well-versed may bind many blocks together; the deepest communion awakens the fullest totem."
	expert_name = "Shaman"
	max_untraited_level = SKILL_LEVEL_NONE


	learnable_in_sleep = FALSE
	trait_uncap = list(TRAIT_SPIRIT_CHOSEN = SKILL_LEVEL_LEGENDARY)

/var/list/shamanic_totem_block_recipe_types = list(
	/datum/crafting_recipe/shamanic_totem/graggar,
	/datum/crafting_recipe/shamanic_totem/zizo,
	/datum/crafting_recipe/shamanic_totem/matthios,
	/datum/crafting_recipe/shamanic_totem/baotha,
	/datum/crafting_recipe/shamanic_totem/dendor,
	/datum/crafting_recipe/shamanic_totem/abyssor,
)


/datum/skill/craft/spiritism/skill_level_effect(level, datum/skill_holder/holder)
	var/mob/living/L = holder?.current
	var/datum/mind/M = L?.mind
	if(!M)
		return
	for(var/recipe_type in shamanic_totem_block_recipe_types)
		if(level > SKILL_LEVEL_NONE)
			M.teach_crafting_recipe(recipe_type)
		else
			M.forget_crafting_recipe(recipe_type)


/datum/crafting_recipe/shamanic_totem/graggar
	name = "moose block"
	result = /obj/item/shamanic_totem_block/graggar


	reqs = list(/obj/item/grown/log/tree/small = 1)


	tools = list(/obj/item/rogueweapon/huntingknife)
	category = "Totems"
	craftdiff = 2
	time = 4 SECONDS
	skillcraft = /datum/skill/craft/spiritism
	always_availible = FALSE

/datum/crafting_recipe/shamanic_totem/graggar/build_display_cache()
	. = ..()
	cached_category = "Totems"

/datum/crafting_recipe/shamanic_totem/zizo
	name = "wolf block"
	result = /obj/item/shamanic_totem_block/zizo
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	category = "Totems"
	craftdiff = 2
	time = 4 SECONDS
	skillcraft = /datum/skill/craft/spiritism
	always_availible = FALSE

/datum/crafting_recipe/shamanic_totem/zizo/build_display_cache()
	. = ..()
	cached_category = "Totems"

/datum/crafting_recipe/shamanic_totem/matthios
	name = "bear block"
	result = /obj/item/shamanic_totem_block/matthios
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	category = "Totems"
	craftdiff = 2
	time = 4 SECONDS
	skillcraft = /datum/skill/craft/spiritism
	always_availible = FALSE

/datum/crafting_recipe/shamanic_totem/matthios/build_display_cache()
	. = ..()
	cached_category = "Totems"

/datum/crafting_recipe/shamanic_totem/baotha
	name = "leopard block"
	result = /obj/item/shamanic_totem_block/baotha
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	category = "Totems"
	craftdiff = 2
	time = 4 SECONDS
	skillcraft = /datum/skill/craft/spiritism
	always_availible = FALSE

/datum/crafting_recipe/shamanic_totem/baotha/build_display_cache()
	. = ..()
	cached_category = "Totems"

/datum/crafting_recipe/shamanic_totem/dendor
	name = "volf block"
	result = /obj/item/shamanic_totem_block/dendor
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	category = "Totems"
	craftdiff = 2
	time = 4 SECONDS
	skillcraft = /datum/skill/craft/spiritism
	always_availible = FALSE

/datum/crafting_recipe/shamanic_totem/dendor/build_display_cache()
	. = ..()
	cached_category = "Totems"

/datum/crafting_recipe/shamanic_totem/abyssor
	name = "kraken block"
	result = /obj/item/shamanic_totem_block/abyssor
	reqs = list(/obj/item/grown/log/tree/small = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	category = "Totems"
	craftdiff = 2
	time = 4 SECONDS
	skillcraft = /datum/skill/craft/spiritism
	always_availible = FALSE

/datum/crafting_recipe/shamanic_totem/abyssor/build_display_cache()
	. = ..()
	cached_category = "Totems"


