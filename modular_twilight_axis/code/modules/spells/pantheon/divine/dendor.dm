/datum/action/cooldown/spell/conjure_arcyne_ward/druid
	name = "Conjure vine armor"
	button_icon_state = "tamebeast"
	spell_color = GLOW_COLOR_EARTHEN
	invocations = list("Threefather! Give me your protect!")
	dismiss_invocation = ""
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/druid

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/druid
	name = "vine armor"
	desc = "An holy vine's armor."
	ward_color = GLOW_COLOR_EARTHEN

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/druid/setup_ward(mob/living/carbon/human/user)
	. = ..()
	user.apply_status_effect(/datum/status_effect/buff/vinearmour)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/druid/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/vinearmour)

	return ..()

/datum/status_effect/buff/vinearmour
	id = "vinearmour"
	alert_type = /atom/movable/screen/alert/status_effect/buff/vinearmour
	duration = -1
	examine_text = "<font color='green'>SUBJECTPRONOUN is covered in vines!</font>"
	var/outline_colour = "#042013"
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = -1, STATKEY_SPD = -1)

/atom/movable/screen/alert/status_effect/buff/vinearmour
	name = "Vinearmour"
	desc = "The vines hirt you, but protects!"

/datum/intent/simple/beast_claws/slash
	name = "Рассекающий удар"
	desc = "Звериные когти помогают рвать свою добычу, заставляя её истекать кровью."
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = "genslash"
	miss_sound = "bluntwoosh"
	item_d_type = "slash"
	penfactor = PEN_LIGHT
	icon_state = "inchop"
// - - -

/obj/item/rogueweapon/beast_claws
	name = "Beast claws"
	gender = PLURAL
	max_blade_int = INFINITY
	max_integrity = INFINITY
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	sharpness = IS_SHARP_ACCURATE
	item_flags = DROPDEL
	possible_item_intents = list(/datum/intent/simple/beast_claws/slash)
	can_parry = TRUE
	wdefense = 7
	// Временная замена до момента появления спрайтера. Увы.
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "claw_r"
	force = 20

/obj/item/rogueweapon/beast_claws/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// - - -

/obj/effect/proc_holder/spell/self/beast_claws
	name = "Когти зверя"
	desc = "Вытянутые когти подобные острым лезвиям, способным как резать так и колоть. \
	Старшие друиды рассказывают легенду, согласно которым Дендор использовал свои зверские когти, \
	когда повздорил с Равоксом, богом войны. \
	Их битва длилась три дэя, во время которых в леса было страшно даже заглядывать. \
	Однако, на четвертый дэй все стихло, боги помирились."
	overlay_state = "dendor"
	req_items = /obj/item/clothing/neck/roguetown/psicross/dendor
	antimagic_allowed = TRUE
	miracle = TRUE

/obj/effect/proc_holder/spell/self/beast_claws/cast(mob/living/user = usr)
	. = ..()

	var/is_ability_activated = FALSE

	var/obj/item/active_hand_item = user.get_active_held_item()

	// Предовтращение манипуляций с когтями оборотня.
	if(istype(active_hand_item, /obj/item/rogueweapon/werewolf_claw))
		revert_cast()
		return FALSE

	if(istype(active_hand_item, /obj/item/rogueweapon/beast_claws))
		is_ability_activated = TRUE

	user.dropItemToGround(active_hand_item, TRUE)

	if(is_ability_activated)
		qdel(active_hand_item)
		return TRUE

	user.put_in_hands(new /obj/item/rogueweapon/beast_claws(user), TRUE, FALSE, TRUE)

// -- Debuff

/atom/movable/screen/alert/status_effect/debuff/beast_rage
	name = "Уставший зверь"
	desc = "Мой внутренний зверь устал, как и я."
	icon_state = "debuff"

/datum/status_effect/debuff/beast_rage_weakness
	id = "beast_rage_weakness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/beast_rage
	effectedstats = list(
		"speed" = -2,
		"strength" = -2,
		"willpower" = -2,
	)
	duration = 1 MINUTES

// -- Buff

/atom/movable/screen/alert/status_effect/buff/beast_rage
	name = "Буйствующий зверь"
	desc = "Мой внутренний зверь буйствует! Силы переполняют меня, но мой разум гаснет!"
	icon_state = "buff"

/datum/status_effect/buff/beast_rage
	id = "beast_rage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/beast_rage
	effectedstats = list(
		"speed" = 2,
		"strength" = 2,
		"willpower" = 2,
		"intelligence" = -5,
	)
	duration = 1 MINUTES

/datum/status_effect/buff/beast_rage/on_remove()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/debuff/beast_rage_weakness)
	owner.clear_fullscreen("beast_mode")

// -- Spell

/obj/effect/proc_holder/spell/self/beast_rage
	name = "Буйство зверя"
	desc = ""
	overlay_state = "dendor"
	recharge_time = 3 MINUTES
	req_items = /obj/item/clothing/neck/roguetown/psicross/dendor
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/druidic
	invocations = list("Вот она! Ярость дикого сердца!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 125

/obj/effect/proc_holder/spell/self/beast_rage/cast(mob/living/user = usr)
	. = ..()
	user.apply_status_effect(/datum/status_effect/buff/beast_rage)
	user.overlay_fullscreen("beast_mode", /atom/movable/screen/fullscreen/color_vision/red)
	user.Dizzy(10)

/mob/living/carbon/human/proc/ta_copy_wildshape_devotion_from(mob/living/carbon/human/source)
	if(!source?.devotion || !devotion)
		return
	devotion.max_devotion = source.devotion.max_devotion
	devotion.devotion = source.devotion.devotion
	devotion.max_progression = source.devotion.max_progression
	devotion.progression = source.devotion.progression
	devotion.level = source.devotion.level
	devotion.last_level = source.devotion.last_level
	devotion.passive_devotion_gain = source.devotion.passive_devotion_gain
	devotion.passive_progression_gain = source.devotion.passive_progression_gain
	devotion.prayer_effectiveness = source.devotion.prayer_effectiveness
	devotion.able_to_progress = source.devotion.able_to_progress
	devotion.granted_spells = source.devotion.granted_spells?.Copy()
	devotion.update_devotion(0, 0, silent = TRUE)

/obj/effect/proc_holder/spell/invoked/sanctify_tree
	name = "Sanctify Tree"
	desc = "Channel Dendor's most sacred blessing to consecrate a living tree into a sanctified tree of the Treefather."
	action_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	overlay_state = "sanctify_tree"
	invocation_type = "shout"
	range = 1
	recharge_time = 60 SECONDS
	associated_skill = /datum/skill/magic/holy
	sound = 'sound/ambience/noises/mystical (4).ogg'
	invocations = list("Treefather, consecrate this living tree into your eternal embrace!")
	miracle = TRUE
	devotion_cost = 250

/obj/effect/proc_holder/spell/invoked/sanctify_tree/cast(list/targets, mob/living/user)
	. = ..()

	var/mob/living/carbon/human/H = user
	if(!istype(H) || !length(targets))
		return FALSE

	var/atom/target_atom = targets[1]
	var/turf/target_turf = get_turf(target_atom)
	if(!target_turf || get_dist(H, target_turf) > 1)
		to_chat(H, span_warning("I must target a living tree directly adjacent to me."))
		return FALSE

	var/obj/structure/flora/newtree/newtree_target
	var/obj/structure/flora/roguetree/wise/wise_target
	var/obj/structure/flora/tree/legacy_target

	if(istype(target_atom, /obj/structure/flora/newtree))
		var/obj/structure/flora/newtree/direct_newtree = target_atom
		if(!direct_newtree.burnt)
			newtree_target = direct_newtree

	if(!newtree_target && istype(target_atom, /obj/structure/flora/roguetree/wise))
		var/obj/structure/flora/roguetree/wise/direct_wise = target_atom
		if(!istype(direct_wise, /obj/structure/flora/roguetree/wise/sanctified))
			wise_target = direct_wise

	if(!newtree_target && !wise_target && istype(target_atom, /obj/structure/flora/tree))
		var/obj/structure/flora/tree/direct_tree = target_atom
		if(!istype(direct_tree, /obj/structure/flora/roguetree/stump))
			legacy_target = direct_tree

	if(!newtree_target && !wise_target && !legacy_target)
		for(var/obj/structure/flora/newtree/tree in target_turf)
			if(tree.burnt)
				continue
			newtree_target = tree
			break

	if(!newtree_target && !wise_target && !legacy_target)
		for(var/obj/structure/flora/roguetree/wise/tree in target_turf)
			if(istype(tree, /obj/structure/flora/roguetree/wise/sanctified))
				continue
			wise_target = tree
			break

	if(!newtree_target && !wise_target && !legacy_target)
		for(var/obj/structure/flora/tree/tree in target_turf)
			if(istype(tree, /obj/structure/flora/roguetree/stump))
				continue
			legacy_target = tree
			break

	if(!newtree_target && !wise_target && !legacy_target)
		to_chat(H, span_warning("I must target a living tree directly adjacent to me. Burnt and already-sanctified trees cannot be consecrated."))
		return FALSE

	var/obj/structure/flora/consecrate_target
	if(newtree_target)
		consecrate_target = newtree_target
	else if(wise_target)
		consecrate_target = wise_target
	else
		consecrate_target = legacy_target

	if(!wise_target)
		for(var/obj/structure/flora/roguetree/wise/sanctified/tree in range(10, consecrate_target))
			if(istype(tree, /obj/structure/flora/roguetree/wise/sanctified/wise))
				continue
			to_chat(H, span_warning("A sanctified tree already stands nearby. The Treefather will not allow another grove anchor so close."))
			return FALSE

	H.visible_message(
		span_notice("[H] presses both hands to the bark of [consecrate_target] and begins a long, reverent invocation."),
		span_notice("I press my hands to the bark and channel the Treefather's blessing into the tree...")
	)

	if(!do_after(H, 10 SECONDS, target = consecrate_target))
		to_chat(H, span_warning("The consecration ritual was interrupted."))
		return FALSE

	if(QDELETED(consecrate_target))
		to_chat(H, span_warning("The tree is no longer a valid target for sanctification."))
		return FALSE

	var/turf/T = get_turf(consecrate_target)
	if(!T)
		return FALSE

	if(newtree_target)
		if(newtree_target.burnt)
			to_chat(H, span_warning("The tree is no longer a valid target for sanctification."))
			return FALSE
		for(var/turf/adjacent in range(1, T))
			for(var/obj/structure/flora/newbranch/branch in adjacent)
				qdel(branch)
			for(var/obj/structure/flora/newleaf/leaf in adjacent)
				qdel(leaf)
		var/turf/above = get_step_multiz(T, UP)
		if(istype(above, /turf/open/transparent/openspace))
			for(var/obj/structure/flora/newtree/upper_tree in above)
				qdel(upper_tree)

	if(wise_target)
		qdel(wise_target)
		var/obj/structure/flora/roguetree/wise/sanctified/wise/new_tree = new(T)
		playsound(T, 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
		H.visible_message(
			span_green("[H]'s hands blaze with golden light as [new_tree] is consecrated by Dendor."),
			span_notice("I feel the Treefather's power flow through me as the ancient tree is sanctified.")
		)
	else
		qdel(consecrate_target)
		var/obj/structure/flora/roguetree/wise/sanctified/new_tree = new(T)
		playsound(T, 'sound/ambience/noises/mystical (4).ogg', 70, TRUE)
		H.visible_message(
			span_green("[H]'s hands blaze with golden light as [new_tree] is consecrated and transfigured into a sanctified tree of Dendor."),
			span_notice("I feel the Treefather's power flow through me as [new_tree] is sanctified.")
		)

	SEND_SIGNAL(H, COMSIG_TREE_TRANSFORMED)
	if(H.mind)
		H.mind.add_sleep_experience(/datum/skill/magic/druidic, 50)
	return TRUE

/datum/action/cooldown/spell/wood_emergence
	name = "Wood Emergence"
	desc = "Command an old tree to erupt from natural ground, crushing the center and repelling creatures nearby. The summoned tree fades shortly afterward."
	button_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	button_icon_state = "wood_emergence"
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	sound = 'sound/ambience/noises/mystical (4).ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_GEOMANCY
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 50
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_MAJOR_AOE
	invocations = list("The Treefather commands thee, stand here!")
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS
	associated_skill = /datum/skill/magic/druidic
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	displayed_damage = 40
	var/telegraph_delay = TELEGRAPH_SKILLSHOT
	var/direct_damage = 40
	var/aoe_damage = 15
	var/push_dist = 1
	var/static/list/turf_whitelist = list(
		/turf/open/floor/rogue/dirt,
		/turf/open/floor/rogue/dirt/road,
		/turf/open/floor/rogue/dirt/ambush,
		/turf/open/floor/rogue/grass,
		/turf/open/floor/rogue/grassyel,
		/turf/open/floor/rogue/grassred,
		/turf/open/floor/rogue/grasscold,
		/turf/open/floor/rogue/snow,
		/turf/open/floor/rogue/snowrough,
		/turf/open/floor/rogue/snowpatchy,
		/turf/open/floor/rogue/AzureSand,
		/turf/open/floor/rogue/sand
	)

/datum/action/cooldown/spell/wood_emergence/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/T = get_turf(cast_on)
	if(!T || T.density)
		return FALSE
	for(var/obj/structure/S in T.contents)
		if(S.density)
			to_chat(H, span_warning("Something is already there!"))
			return FALSE
	if(!is_type_in_list(T, turf_whitelist))
		to_chat(H, span_warning("Only natural ground can answer the Treefather's call."))
		return FALSE
	new /obj/effect/temp_visual/trap/emergence(T)
	playsound(T, 'sound/foley/footsteps/armor/woodarmor (1).ogg', 60, TRUE)
	addtimer(CALLBACK(src, PROC_REF(do_emergence), T, H), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/wood_emergence/proc/do_emergence(turf/T, mob/living/carbon/human/caster)
	if(QDELETED(caster) || caster.stat == DEAD || !T)
		return
	playsound(T, 'sound/foley/footsteps/armor/woodarmor (2).ogg', 100, TRUE, 4)
	for(var/mob/living/victim in T.contents)
		if(victim == caster || victim.stat == DEAD)
			continue
		if(victim.anti_magic_check() || spell_guard_check(victim, TRUE))
			continue
		var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
		arcyne_strike(caster, victim, null, direct_damage, target_zone, BCLASS_BLUNT, spell_name = "Wood Emergence", damage_type = BRUTE, skip_animation = TRUE)
		var/push_dir = get_dir(T, victim) || get_dir(caster, victim) || pick(GLOB.cardinals)
		victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)
	for(var/turf/affected in get_hear(1, T))
		if(affected == T)
			continue
		new /obj/effect/temp_visual/kinetic_blast(affected)
		for(var/mob/living/victim in affected)
			if(victim == caster || victim.stat == DEAD || victim.anti_magic_check() || spell_guard_check(victim, TRUE))
				continue
			var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
			arcyne_strike(caster, victim, null, aoe_damage, target_zone, BCLASS_BLUNT, spell_name = "Wood Emergence", damage_type = BRUTE, skip_animation = TRUE)
			var/push_dir = get_dir(T, victim) || get_dir(caster, victim) || pick(GLOB.cardinals)
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)
	for(var/turf/struct_turf in get_hear(1, T))
		for(var/obj/structure/S in struct_turf)
			S.take_damage(direct_damage, BRUTE, "blunt", object_damage_multiplier = 2)
	new /obj/effect/temp_visual/kinetic_blast(T)
	var/tree_type = pick(/obj/structure/flora/roguetree, /obj/structure/flora/roguetree/evil, /obj/structure/flora/roguetree/burnt)
	var/obj/structure/flora/roguetree/tree = new tree_type(T)
	addtimer(CALLBACK(src, PROC_REF(remove_emergent_tree), tree), 30 SECONDS)

/datum/action/cooldown/spell/wood_emergence/proc/remove_emergent_tree(obj/structure/flora/roguetree/tree)
	if(!QDELETED(tree))
		qdel(tree)

/obj/effect/temp_visual/trap/emergence
	color = GLOW_COLOR_EARTHEN
	light_color = GLOW_COLOR_EARTHEN
	duration = TELEGRAPH_SKILLSHOT

//////////////////////
// T0 - Bless Crops //
//////////////////////

/obj/effect/proc_holder/spell/targeted/blesscrop
	name = "Bless Crops"
	desc = "Bless a targeted soil plot or tree. Druidic Trickery increases stored charges. Revives dead plants, gives them nutrition and water if low & boosts their growth. Blessed seed powder can expend all charges to bless up to five nearby planted soils at once."
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "blesscrop"
	range = 5
	selection_type = "range"
	releasedrain = 15
	charge_type = "charges"
	recharge_time = 1
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	max_targets = 1
	cast_without_targets = FALSE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/druidic
	invocations = list("The Treefather commands thee, be fruitful!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 20
	var/max_bless_charges = 1
	var/charge_regen_elapsed = 0
	var/empty_refill_elapsed = 0
	var/empty_refill_active = FALSE
	var/active_sound = null
	var/charges_initialized = FALSE

/obj/effect/proc_holder/spell/targeted/blesscrop/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	action.name = name
	action.build_all_button_icons()

/obj/effect/proc_holder/spell/targeted/blesscrop/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		if(active_sound)
			user.playsound_local(user, active_sound, 100, vary = FALSE)
		active = TRUE
		add_ranged_ability(user, null, TRUE)
	update_icon()

/obj/effect/proc_holder/spell/targeted/blesscrop/deactivate(mob/living/user)
	active = FALSE
	remove_ranged_ability(null)
	update_icon()

/obj/effect/proc_holder/spell/targeted/blesscrop/InterceptClickOn(mob/living/caller, params, atom/target)
	. = ..()
	if(.)
		return TRUE
	if(istype(target, /mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser))
		if(!can_cast(caller))
			deactivate(caller)
			return TRUE
		var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad = target
		if(dryad.frenzy_timer)
			to_chat(caller, span_warning("The dryad's frenzy blessing has not yet subsided!"))
			return TRUE
		if(!charge_check(caller))
			return TRUE
		var/obj/item/act_item = caller.get_active_held_item()
		var/obj/item/inact_item = caller.get_inactive_held_item()
		var/bloomstone_boost = istype(act_item, /obj/item/alch/bloomstone) || istype(inact_item, /obj/item/alch/bloomstone)
		if(bloomstone_boost)
			var/obj/item/alch/bloomstone/bs = istype(act_item, /obj/item/alch/bloomstone) ? act_item : inact_item
			qdel(bs) // Consumes one charge (Destroy() decrements; stone survives until charges reach 0).
		dryad.apply_blessed_frenzy(bloomstone_boost)
		playsound(caller, sound, 100, TRUE)
		charge_counter--
		after_cast(list(target), caller)
		deactivate(caller)
		return TRUE
	if(ismob(target))
		to_chat(caller, span_warning("Bless Crops must be aimed at a tree, long log, or soil plot."))
		return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		return TRUE
	if(perform(list(target), TRUE, user = ranged_ability_user))
		return TRUE
	return TRUE

/obj/effect/proc_holder/spell/targeted/blesscrop/Initialize(mapload)
	. = ..()
	charge_counter = 1
	max_bless_charges = 1

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/get_max_bless_charges(mob/user)
	if(!user)
		return max(1, max_bless_charges)
	return max(1, 1 + user.get_skill_level(associated_skill))

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/sync_bless_charges(mob/user)
	var/old_max = max_bless_charges
	max_bless_charges = get_max_bless_charges(user)
	if(!charges_initialized && user)
		charges_initialized = TRUE
		charge_counter = max_bless_charges
	else if(!empty_refill_active)
		if(max_bless_charges > old_max)
			charge_counter = min(charge_counter + (max_bless_charges - old_max), max_bless_charges)
		else
			charge_counter = clamp(charge_counter, 0, max_bless_charges)

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/start_empty_refill()
	if(empty_refill_active)
		return
	empty_refill_active = TRUE
	empty_refill_elapsed = 0
	charge_regen_elapsed = 0
	charge_counter = 0
	START_PROCESSING(SSfastprocess, src)
	if(action)
		action.build_all_button_icons()

/obj/effect/proc_holder/spell/targeted/blesscrop/proc/spend_all_bless_charges()
	charge_counter = 0
	start_empty_refill()

/obj/effect/proc_holder/spell/targeted/blesscrop/charge_check(mob/user, silent = FALSE)
	if(!silent || charges_initialized)
		sync_bless_charges(user)
	if(empty_refill_active || charge_counter <= 0)
		if(!empty_refill_active)
			start_empty_refill()
		if(!silent)
			to_chat(user, span_warning("[name] is exhausted and must recover before it can be used again."))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/targeted/blesscrop/start_recharge()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/process()
	if(empty_refill_active)
		empty_refill_elapsed += 2
		if(empty_refill_elapsed >= 30 SECONDS)
			empty_refill_active = FALSE
			empty_refill_elapsed = 0
			charge_regen_elapsed = 0
			charge_counter = max_bless_charges
			if(action)
				action.build_all_button_icons()
			STOP_PROCESSING(SSfastprocess, src)
		return
	if(charge_counter < max_bless_charges)
		charge_regen_elapsed += 2
		while(charge_regen_elapsed >= 10 SECONDS && charge_counter < max_bless_charges)
			charge_regen_elapsed -= 10 SECONDS
			charge_counter++
		if(action)
			action.build_all_button_icons()
		if(charge_counter >= max_bless_charges)
			charge_counter = max_bless_charges
			STOP_PROCESSING(SSfastprocess, src)
		return
	STOP_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/after_cast(list/targets, mob/user = usr)
	. = ..()
	sync_bless_charges(user)
	if(active)
		add_ranged_ability(user, null, TRUE)
	if(charge_counter <= 0)
		start_empty_refill()
	else
		empty_refill_active = FALSE
		empty_refill_elapsed = 0
		charge_regen_elapsed = 0
		START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/revert_cast(mob/user = usr)
	. = ..()
	sync_bless_charges(user)
	if(active)
		add_ranged_ability(user, null, TRUE)
	empty_refill_active = FALSE
	empty_refill_elapsed = 0
	if(charge_counter < max_bless_charges)
		START_PROCESSING(SSfastprocess, src)

/obj/effect/proc_holder/spell/targeted/blesscrop/cast(list/targets,mob/user = usr)
	. = ..()
	var/atom/target_atom = targets?.len ? targets[1] : null
	var/turf/target_turf = get_turf(target_atom)
	sync_bless_charges(user)
	if(!target_turf)
		target_turf = get_turf(user)
	var/list/target_long_logs = list()
	for(var/obj/item/grown/log/tree/log in target_turf)
		if(log.type == /obj/item/grown/log/tree)
			target_long_logs += log
	var/obj/item/alch/blessedseedpowder/blessed_seed_powder = user.get_active_held_item()
	if(!istype(blessed_seed_powder))
		blessed_seed_powder = user.get_inactive_held_item()
	if(!istype(blessed_seed_powder))
		blessed_seed_powder = null
	var/obj/item/alch/bloomstone/held_bloomstone = null
	if(!blessed_seed_powder)
		var/obj/item/act_item = user.get_active_held_item()
		var/obj/item/inact_item = user.get_inactive_held_item()
		if(istype(act_item, /obj/item/alch/bloomstone))
			held_bloomstone = act_item
		else if(istype(inact_item, /obj/item/alch/bloomstone))
			held_bloomstone = inact_item
	var/obj/item/seed_source = blessed_seed_powder
	if(!seed_source)
		seed_source = held_bloomstone
	var/obj/item/reagent_containers/water_container = null
	for(var/obj/item/held in list(user.get_active_held_item(), user.get_inactive_held_item()))
		if(held?.reagents && (istype(held, /obj/item/reagent_containers/glass/bucket) || istype(held, /obj/item/reagent_containers/glass/mortar)))
			if(held.reagents.get_reagent_amount(/datum/reagent/water/blessed) >= 2)
				water_container = held
				break

	if(target_long_logs.len || istype(target_atom, /obj/item/grown/log/tree))
		if(istype(target_atom, /obj/item/grown/log/tree) && target_atom.type != /obj/item/grown/log/tree)
			to_chat(user, span_warning("Only long logs can be blessed by this rite."))
			return FALSE
		if(!target_long_logs.len)
			to_chat(user, span_warning("There are no large logs at that location to sanctify."))
			return FALSE
		if(!seed_source)
			to_chat(user, span_warning("I need blessed seed powder or a harvest bloomstone in-hand to sanctify logs."))
			return FALSE
		if(!water_container)
			to_chat(user, span_warning("I need a stone mortar or bucket with blessed water in-hand to sanctify logs."))
			return FALSE
		var/blessed_amt = water_container.reagents.get_reagent_amount(/datum/reagent/water/blessed)
		if(blessed_amt < 1)
			to_chat(user, span_warning("My container has no blessed water to fuel the blessing."))
			return FALSE
		var/blessed_logs = 0
		for(var/obj/item/grown/log/tree/log in target_long_logs)
			if(!log.bless_log())
				continue
			blessed_logs++
			if(blessed_logs >= 6)
				break
		if(blessed_logs <= 0)
			to_chat(user, span_warning("There are no unblessed long logs here to sanctify."))
			return FALSE
		water_container.reagents.remove_reagent(/datum/reagent/water/blessed, blessed_amt)
		qdel(seed_source)
		visible_message(span_green("[usr] sanctifies the long logs with Dendor's favor!"))
		return TRUE

	var/obj/structure/soil/target_soil = null
	if(istype(target_atom, /obj/structure/soil))
		target_soil = target_atom
	else
		target_soil = locate(/obj/structure/soil) in target_turf
	if(target_soil)
		if(target_soil.blessed_time > 0 && !seed_source)
			to_chat(user, span_warning("That soil is already blessed. It can be blessed again in [DisplayTimeText(target_soil.blessed_time)]."))
			revert_cast(user)
			return FALSE
		if(seed_source)
			var/amount_blessed = 0
			for(var/obj/structure/soil/soil in range(4, user))
				if(!soil.plant)
					continue
				soil.bless_soil()
				amount_blessed++
				if(amount_blessed >= 5)
					break
			if(amount_blessed <= 0)
				to_chat(user, span_warning("There are no nearby planted soil plots for the powder to bless."))
				return FALSE
			qdel(seed_source)
			spend_all_bless_charges()
			visible_message(span_green("[usr] scatters blessed seed powder and Dendor's favor refreshes nearby crops!"))
			return TRUE
		target_soil.bless_soil()
		visible_message(span_green("[usr] blesses [target_soil] with Dendor's favor!"))
		return TRUE

	var/obj/structure/flora/roguetree/target_tree = null
	if(istype(target_atom, /obj/structure/flora/roguetree))
		target_tree = target_atom
	else
		target_tree = locate(/obj/structure/flora/roguetree) in target_turf
	if(target_tree)
		if(seed_source && get_dist(user, target_tree) > 1)
			to_chat(user, span_warning("I must be right next to the tree to convert it with Dendor's blessing."))
			return FALSE
		if(seed_source && target_tree.reinvigorate_tree(user))
			if(seed_source == user.get_active_held_item() || seed_source == user.get_inactive_held_item())
				qdel(seed_source)
			visible_message(span_green("[usr] invokes Dendor's favor upon [target_tree]."))
			return TRUE
		if(target_tree.bless_tree(user))
			visible_message(span_green("[usr] invokes Dendor's favor upon [target_tree]."))
			return TRUE
	if(istype(target_atom, /obj/structure/flora/newtree))
		var/obj/structure/flora/newtree/tree = target_atom
		if(tree.bless_tree(user))
			visible_message(span_green("[usr] invokes Dendor's favor upon [tree]."))
			return TRUE

	to_chat(user, span_warning("That target cannot receive this blessing."))
	return FALSE

/obj/effect/proc_holder/spell/targeted/blesscrop/secular
	miracle = FALSE
	devotion_cost = 0
	req_items = list()
	releasedrain = 40
	recharge_time = 1
	associated_skill = /datum/skill/labor/farming
	invocations = list("Cow pie n' raw sod, makes th' rye! Drink it down an' kiss the sky!", "Compost rich n' dark as sin, makes the harvest rollin' in!", "Manure fresh from stable floor, makes the crops grow more an' more!")

/mob/living/carbon/human/var/tmp/dendor_dryad_aggressive_mode = FALSE

/mob/living/carbon/human/proc/toggle_dendor_dryad_aggression()
	set name = "Toggle Dryad Aggression"
	set category = "RoleUnique.Cleric"
	if(!HAS_TRAIT(src, "DENDOR_SOULBOUND"))
		to_chat(src, span_warning("I have no soulbound dryad to command."))
		return FALSE
	dendor_dryad_aggressive_mode = !dendor_dryad_aggressive_mode
	var/updated = 0
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D in GLOB.mob_list)
		if(D.owner_mob != src || QDELETED(D) || D.stat == DEAD)
			continue
		D.apply_dendor_dryad_aggression(dendor_dryad_aggressive_mode)
		updated++
	to_chat(src, span_notice("Dryad aggression: [dendor_dryad_aggressive_mode ? "Aggressive - attack strangers" : "Defensive - protect the summoner and obey orders"].[updated ? " Updated [updated] summoned dryad." : ""]"))
	return TRUE

/obj/effect/proc_holder/spell/invoked/root_affinity
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	overlay_state = "vine"

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad
	name = "Summon Lesser Dryad"
	desc = "Call forth a lesser dryad from the grove to serve as your guardian. Cast again to send it back."
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "summondryad"
	releasedrain = 60
	recharge_time = 60 SECONDS
	chargetime = 1 SECONDS
	max_targets = 0
	cast_without_targets = TRUE
	associated_skill = /datum/skill/magic/holy
	invocations = list("Treefather, lend me your guardian.")
	invocation_type = "whisper"
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/conjured_dryad = null
	var/manual_unsummon = FALSE
	var/death_cooldown_until = 0

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/Destroy()
	if(conjured_dryad && !QDELETED(conjured_dryad))
		UnregisterSignal(conjured_dryad, COMSIG_QDELETING)
		qdel(conjured_dryad)
	conjured_dryad = null
	return ..()

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/cast(list/targets, mob/user = usr)
	invocations = (conjured_dryad && !QDELETED(conjured_dryad)) \
		? list("My protector, I send thee back to the grove!") \
		: list("Treefather, lend me your guardian.")
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = user
	if(world.time < death_cooldown_until)
		to_chat(H, span_warning("The bond to my soul-bound tree is unstable. I must wait [DisplayTimeText(death_cooldown_until - world.time)] before summoning another dryad."))
		revert_cast()
		return FALSE

	if(conjured_dryad && !QDELETED(conjured_dryad))
		manual_unsummon = TRUE
		conjured_dryad.visible_message(span_boldwarning("[conjured_dryad] dissolves back into the grove."))
		qdel(conjured_dryad)
		manual_unsummon = FALSE
		conjured_dryad = null
		to_chat(H, span_notice("My dryad returns to the grove."))
		return TRUE

	var/turf/spawn_turf = null
	for(var/D in GLOB.alldirs)
		var/turf/adj = get_step(get_turf(H), D)
		if(adj && !isclosedturf(adj))
			spawn_turf = adj
			break
	if(!spawn_turf)
		to_chat(H, span_warning("There is no room to summon the dryad here."))
		revert_cast()
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = new(spawn_turf, H)
	conjured_dryad = D
	D.summoner_spell = src
	D.follow_target = H
	if(H.dendor_dryad_aggressive_mode)
		D.apply_dendor_dryad_aggression(TRUE)
	RegisterSignal(D, COMSIG_QDELETING, PROC_REF(on_dryad_deleted))
	to_chat(H, span_green("A lesser dryad emerges from the roots, answering my call."))
	D.visible_message(span_notice("[D] takes form beside [H]."))
	return TRUE

/obj/effect/proc_holder/spell/targeted/summon_lesser_dryad/proc/on_dryad_deleted(datum/source)
	if(!manual_unsummon)
		death_cooldown_until = max(death_cooldown_until, world.time + 2 MINUTES)
	conjured_dryad = null
	UnregisterSignal(source, COMSIG_QDELETING)

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special
	name = "Dryad Surge"
	desc = "Activate, then middle-click a turf or creature to command your lesser dryad to surge there with thorns and vines."
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	overlay_state = "summondryad"
	releasedrain = 50
	recharge_time = 1 MINUTES
	chargetime = 0 SECONDS
	max_targets = 1
	cast_without_targets = FALSE
	associated_skill = /datum/skill/magic/holy
	invocations = list("Tangle my enemies and sting their feet. Grove, arise!")
	invocation_type = "shout"
	range = 10

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	action.name = name
	action.build_all_button_icons()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		active = TRUE
		add_ranged_ability(user, null, TRUE)
	update_icon()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/deactivate(mob/living/user)
	active = FALSE
	remove_ranged_ability(null)
	update_icon()

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/InterceptClickOn(mob/living/caller, params, atom/target)
	if(!isturf(target))
		. = ..()
		if(.)
			return TRUE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		deactivate(caller)
		return TRUE
	perform(list(get_turf(target) || target), TRUE, user = ranged_ability_user)
	deactivate(caller)
	return TRUE

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/cast(list/targets, mob/user = usr)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return FALSE
	var/atom/target = targets?.len ? targets[1] : null
	if(!target)
		return FALSE
	var/mob/living/carbon/human/H = user

	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = null
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad in view(14, H))
		if(dryad.conjurer_ckey == H.ckey)
			D = dryad
			break
	if(!D)
		to_chat(H, span_warning("My dryad is not nearby."))
		return FALSE

	var/turf/target_turf = get_turf(target)
	if(!target_turf || isclosedturf(target_turf))
		to_chat(H, span_warning("The dryad cannot reach that location."))
		return FALSE

	if(D.ai_controller)
		D.ai_controller.CancelActions()
		D.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		D.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
	D.clear_enemies()
	D.target = null
	D.LoseTarget()
	D.aggressive = D.dendor_dryad_aggressive_mode
	D.Goto(target_turf, D.move_to_delay, 1)
	addtimer(CALLBACK(src, PROC_REF(try_execute_surge), D, target_turf, H, 12), 0.5 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/targeted/lesser_dryad_special/proc/try_execute_surge(mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D, turf/target_turf, mob/living/carbon/human/user, attempts_left)
	if(QDELETED(D) || QDELETED(user) || !target_turf)
		return
	if(get_dist(D, target_turf) > 1)
		if(attempts_left <= 0)
			to_chat(user, span_warning("My dryad cannot reach the commanded target."))
			return
		D.Goto(target_turf, D.move_to_delay, 1)
		addtimer(CALLBACK(src, PROC_REF(try_execute_surge), D, target_turf, user, attempts_left - 1), 0.5 SECONDS)
		return
	if(!D.dryad_surge(target_turf))
		to_chat(user, span_warning("My dryad's power has not yet recovered."))

/mob/living/proc/try_handle_middle_targeted_spell(atom/target)
	return FALSE

/mob/living/carbon/human/try_handle_middle_targeted_spell(atom/target)
	return FALSE

/datum/action/cooldown/spell/minion_order/lesser_dryad
	name = "Order Dryad"
	desc = "Command your lesser dryad. Cast and click yourself to follow, a tile to guard there, or an enemy to attack."
	button_icon = 'icons/mob/actions/dendormiracles.dmi'
	button_icon_state = "orderdryad"
	associated_skill = /datum/skill/magic/druidic
	zizo_spell = FALSE
	faction_ordering = FALSE

/datum/action/cooldown/spell/minion_order/lesser_dryad/process_minions(order_type, turf/target_location, mob/living/target, faction_tag)
	var/mob/living/carbon/human/caster = owner
	if(!caster?.mind)
		return
	var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/D = null
	for(var/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad/lesser/dryad in oview(order_range, caster))
		if(faction_tag in dryad.faction)
			D = dryad
			break
	if(!D)
		to_chat(caster, span_warning("No dryad is nearby to command."))
		return
	switch(order_type)
		if("goto")
			D.follow_target = null
			D.clear_enemies()
			D.target = null
			D.LoseTarget()
			D.guard_turf = target_location
			walk(D, 0)
			D.aggressive = D.dendor_dryad_aggressive_mode
			if("neutral" in D.faction)
				D.faction -= "neutral"
			to_chat(caster, span_notice("[D.name] moves to guard that position."))
		if("follow")
			D.clear_enemies()
			D.target = null
			D.LoseTarget()
			D.lastattacker_weakref = null
			D.ignore_owner_defense_until = world.time + 2 SECONDS
			D.follow_target = caster
			D.guard_turf = null
			D.aggressive = D.dendor_dryad_aggressive_mode
			D.toggle_ai(AI_IDLE)
			walk_towards(D, caster, D.move_to_delay)
			if(!D.dendor_dryad_aggressive_mode && !("neutral" in D.faction))
				D.faction += "neutral"
			to_chat(caster, span_notice("[D.name] will follow me."))
		if("attack")
			D.follow_target = null
			D.guard_turf = null
			walk(D, 0)
			D.enemies = list(target)
			D.target = target
			D.aggressive = D.dendor_dryad_aggressive_mode
			if("neutral" in D.faction)
				D.faction -= "neutral"
			D.toggle_ai(AI_ON)
			D.Goto(get_turf(target), D.move_to_delay, 0)
			to_chat(caster, span_notice("[D.name] charges at [target.name]!"))
		if("toggle_stance")
			if("neutral" in D.faction)
				D.follow_target = null
				D.guard_turf = get_turf(D)
				D.faction -= "neutral"
				to_chat(caster, span_notice("[D.name] holds its ground."))
			else
				D.follow_target = caster
				D.guard_turf = null
				D.clear_enemies()
				D.target = null
				D.LoseTarget()
				D.lastattacker_weakref = null
				D.ignore_owner_defense_until = world.time + 2 SECONDS
				D.toggle_ai(AI_IDLE)
				if(!D.dendor_dryad_aggressive_mode)
					D.faction += "neutral"
				walk_towards(D, caster, D.move_to_delay)
				to_chat(caster, span_notice("[D.name] will follow me."))
		if("aggressive")
			D.follow_target = null
			D.clear_enemies()
			D.target = null
			D.LoseTarget()
			D.guard_turf = get_turf(target)
			walk(D, 0)
			D.aggressive = D.dendor_dryad_aggressive_mode
			if("neutral" in D.faction)
				D.faction -= "neutral"
			to_chat(caster, span_notice("[D.name] moves toward [target.name]."))

	if(D.dendor_dryad_aggressive_mode && ("neutral" in D.faction))
		D.faction -= "neutral"
		D.notify_faction_change()

/obj/effect/proc_holder/spell/self/conjure_floral_seed
	name = "Conjure Floral Seed"
	desc = "Conjure a flower or bush seed into your hand using Dendor's power. Seeds dissolve if dropped. Flower seeds can be changed in-hand to subtypes. 30 second cooldown."
	action_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'icons/mob/actions/dendormiracles.dmi'
	overlay_state = "blesscrop"
	chargetime = 0 SECONDS
	recharge_time = 20 SECONDS
	associated_skill = /datum/skill/magic/druidic
	invocations = list("From the deep soil, a fragile life springs! Treefather, grant me your seed.")
	invocation_type = "whisper"

/obj/effect/proc_holder/spell/self/conjure_floral_seed/cast(mob/user = usr)
	. = ..()
	if(!istype(user, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = user
	var/list/options = list("Flower seeds", "Bush seed")
	var/choice = input(H, "Which seed do you conjure?", "Conjure Floral Seed") as null|anything in options
	if(isnull(choice) || QDELETED(H))
		return
	var/obj/item/seed
	if(choice == "Bush seed")
		seed = new /obj/item/seeds/bush/conjured(get_turf(H))
	else
		seed = new /obj/item/seeds/flower/conjured(get_turf(H))
	if(!H.put_in_hands(seed))
		to_chat(H, span_warning("My hands are full — the conjured seed falls to my feet and dissolves!"))
		qdel(seed)
		return
	to_chat(H, span_notice("A [seed.name] materialises in my hand, thrumming with the Treefather's life."))

/obj/effect/proc_holder/spell/invoked/resurrect/dendor/cast(list/targets, mob/living/user)
	if(!length(targets) || !isanimal(targets[1]))
		return ..()
	var/mob/living/simple_animal/target = targets[1]
	if(target.stat != DEAD)
		to_chat(user, span_warning("[target] is not dead."))
		revert_cast()
		return FALSE
	var/validation_result = validate_items(target)
	if(validation_result != "")
		to_chat(user, span_warning("[validation_result] on the floor next to or on top of [target]"))
		revert_cast()
		return FALSE
	var/found_structure = FALSE
	for(var/atom/A in oview(structure_range, target))
		if(istype(A, required_structure))
			found_structure = TRUE
			break
		if(istype(A, /turf))
			var/turf/T = A
			for(var/obj/O in T.contents)
				if(istype(O, required_structure))
					found_structure = TRUE
					break
		if(found_structure)
			break
	if(!found_structure)
		var/atom/temp_structure = required_structure
		to_chat(user, span_warning("I need a [initial(temp_structure.name)] near [target]."))
		revert_cast()
		return FALSE
	if(!target.revive(full_heal = TRUE))
		to_chat(user, span_warning("Nothing happens."))
		revert_cast()
		return FALSE
	target.visible_message(span_notice("[target] is roused by the wild magic!"))
	consume_items(target)
	return TRUE
