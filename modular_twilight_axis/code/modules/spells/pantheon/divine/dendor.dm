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

/obj/effect/proc_holder/spell/targeted/create_seed
	name = "Чудо создания семян"
	range = -1
	overlay_state = "blesscrop"
	releasedrain = 30
	recharge_time = 15 MINUTES
	req_items = /obj/item/clothing/neck/roguetown/psicross/dendor
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/druidic
	miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/targeted/create_seed/proc/get_seeds_dict()
	var/list/allowed_seeds = list()

	allowed_seeds["Болотная трава"] = /obj/item/seeds/swampweed
	allowed_seeds["Табак"] = /obj/item/seeds/pipeweed
	allowed_seeds["Капуста"] = /obj/item/seeds/cabbage
	allowed_seeds["Картофель"] = /obj/item/seeds/potato
	allowed_seeds["Лук"] = /obj/item/seeds/onion
	allowed_seeds["Овес"] = /obj/item/seeds/wheat/oat
	allowed_seeds["Пшеница"] = /obj/item/seeds/wheat
	allowed_seeds["Чай"] = /obj/item/seeds/tea
	allowed_seeds["Яблоня"] = /obj/item/seeds/apple
	allowed_seeds["Ягодный куст (ядовитый)"] = /obj/item/seeds/berryrogue/poison
	allowed_seeds["Ягодный куст"] = /obj/item/seeds/berryrogue

	return allowed_seeds

/obj/effect/proc_holder/spell/targeted/create_seed/cast(list/targets, mob/user = usr)
	. = ..()

	var/list/seeds_dict = get_seeds_dict()

	var/selected_option = input(
		user,
		"Семена какого растения вы хотите сотворить?",
		"Создание семян"
	) as null | anything in seeds_dict

	if(!selected_option)
		revert_cast()
		return FALSE

	var/obj/item/seeds/seed_to_create = seeds_dict[selected_option]
	user.put_in_hands(new seed_to_create(get_turf(user)))
	return TRUE

/datum/action/cooldown/spell/wood_emergence
	name = "Wood Emergence"
	desc = "Command old tree to erupt from the earth, dealing heavy damage to anyone standing on the target and repelling everyone nearby back 1 pace.\
	Deals 2x damage to structures. Can be self-cast - the caster is unharmed by their own eruption."
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

	primary_resource_type  = SPELL_COST_DEVOTION
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
	if(!T)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(T.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(T in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	if(T.density)
		to_chat(H, span_warning("There's no room to raise stone there!"))
		return FALSE

	for(var/obj/structure/S in T.contents)
		if(S.density)
			to_chat(H, span_warning("Something is already there!"))
			return FALSE

	if(!is_type_in_list(T, turf_whitelist))
		to_chat(owner, span_warning("This turf is not natural; nothing can grow on it! (It's blocked sire.)"))
		return FALSE

	new /obj/effect/temp_visual/trap/emergence(T)
	playsound(T, 'sound/foley/footsteps/armor/woodarmor (1).ogg', 60, TRUE)

	addtimer(CALLBACK(src, PROC_REF(do_emergence), T, H), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/wood_emergence/proc/do_emergence(turf/T, mob/living/carbon/human/caster)
	if(QDELETED(caster) || caster.stat == DEAD)
		return

	playsound(T, 'sound/foley/footsteps/armor/woodarmor (2).ogg', 100, TRUE, 4)

	// Direct hit - full damage to anyone standing on the target tile
	for(var/mob/living/victim in T.contents)
		if(victim == caster || victim.stat == DEAD)
			continue
		if(victim.anti_magic_check())
			victim.visible_message(span_warning("The erupting stone crumbles around [victim]!"))
			playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(victim, TRUE))
			victim.visible_message(span_warning("[victim] braces against the eruption!"))
			continue
		var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
		arcyne_strike(caster, victim, null, direct_damage, target_zone, BCLASS_BLUNT, \
			spell_name = "Emergence", damage_type = BRUTE, skip_animation = TRUE)
		to_chat(victim, span_userdanger("Stone erupts beneath me!"))
		new /obj/effect/temp_visual/spell_impact(get_turf(victim), spell_color, spell_impact_intensity)
		var/push_dir = get_dir(T, victim) || get_dir(caster, victim) || pick(GLOB.cardinals)
		victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)

	// AOE repulse - low damage to everyone adjacent
	for(var/turf/affected in get_hear(1, T))
		if(affected == T)
			continue
		new /obj/effect/temp_visual/kinetic_blast(affected)
		for(var/mob/living/victim in affected)
			if(victim == caster || victim.stat == DEAD)
				continue
			if(victim.anti_magic_check())
				continue
			if(spell_guard_check(victim, TRUE))
				continue
			var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
			arcyne_strike(caster, victim, null, aoe_damage, target_zone, BCLASS_BLUNT, \
				spell_name = "Emergence", damage_type = BRUTE, skip_animation = TRUE)
			var/push_dir = get_dir(T, victim)
			if(!push_dir)
				push_dir = get_dir(caster, victim) || pick(GLOB.cardinals)
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)

	// Structural damage - 2x to structures in the entire AOE
	for(var/turf/struct_turf in get_hear(1, T))
		for(var/obj/structure/S in struct_turf)
			S.take_damage(direct_damage, BRUTE, "blunt", object_damage_multiplier = 2)

	// Spawn the pillar - lasts until the spell is off cooldown
	new /obj/effect/temp_visual/kinetic_blast(T)
	var/list/structure = list(/obj/structure/flora/roguetree/burnt,
							  /obj/structure/flora/roguetree,
							  /obj/structure/flora/roguetree/evil)

	var/tree_type = pick(structure)

	new tree_type (T)

/datum/action/cooldown/spell/create_maneater
	name = "Create Maneater"
	desc = "Creates a maneater. His size depends on the caster skill."
	button_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	button_icon_state = "create_maneater"
	sound = 'sound/ambience/noises/mystical (4).ogg'

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 3

	primary_resource_type  = SPELL_COST_DEVOTION
	primary_resource_cost = 20
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Live, grow, devour!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 2 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/druidic

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_NO_MOVE | SPELL_REQUIRES_SAME_Z

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

/datum/action/cooldown/spell/create_maneater/cast(atom/cast_on)
	. = ..()
	var/turf/target = get_turf(cast_on)
	var/skill = owner.get_skill_level(/datum/skill/magic/holy)
	var/skill_second = owner.get_skill_level(associated_skill)

	if(!target || !target.Enter(owner) || !is_type_in_list(target, turf_whitelist))
		to_chat(owner, span_warning("This turf is not natural; nothing can grow on it! (It's blocked sire.)"))
		return FALSE

	for(var/obj/structure/S in target.contents)
		if(istype(S, /obj/structure/flora/roguegrass/maneater/real))
			to_chat(owner, span_warning("Something is already there!"))
			return FALSE

	if(skill > 3 || skill_second > 1) //druid apprenties or miracle expert
		new /obj/structure/flora/roguegrass/maneater/real(target)
	else
		new /obj/structure/flora/roguegrass/maneater/real/juvenile(target)

	return TRUE

////////////////////////////////////////////////////////////////////////////////
/obj/effect/proc_holder/spell/invoked/transform_tree/miracle                  //
	action_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/dendormiracles.dmi'
	overlay_state = "wood_emergence"                                          //
	icon_state = "wood_emergence"		                                      //
	recharge_time = 60 SECONDS                                                //
	associated_skill = /datum/skill/magic/druidic                             //
	miracle = TRUE                                                            //
	devotion_cost = 100                                                       //
	req_items = /obj/item/clothing/neck/roguetown/psicross/dendor             //
////////////////////////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/invoked/transform_tree/miracle/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return

	var/atom/target_atom = targets[1]
	var/obj/structure/flora/target

	if(istype(target_atom, /obj/structure/flora/tree) && !istype(target_atom, /obj/structure/flora/roguetree/wise) && !istype(target_atom, /obj/structure/flora/roguetree/stump))
		target = target_atom
	else if(istype(target_atom, /obj/structure/flora/newtree))
		target = target_atom
	else if(target_atom.loc && (get_dist(user, target_atom.loc) <= 1))
		for(var/obj/structure/flora/tree/T in target_atom.loc)
			if(!istype(T, /obj/structure/flora/roguetree/wise) && !istype(T, /obj/structure/flora/roguetree/stump))
				target = T
				break
		if(!target)
			for(var/obj/structure/flora/newtree/NT in target_atom.loc)
				if(!NT.burnt)
					target = NT
					break

	if(!target)
		to_chat(H, span_warning("You must target a normal, living tree adjacent to you!"))
		return

	H.visible_message(span_notice("[H] begins chanting to transform the tree."), \
					span_notice("You begin the transformation ritual..."))

	if(!do_after(H, 10 SECONDS, target = target))
		to_chat(H, span_warning("The ritual was interrupted!"))
		return

	var/turf/T = get_turf(target)
	var/obj/structure/flora/roguetree/wise/new_wise_tree = new(T)
	new_wise_tree.activated = TRUE
	new_wise_tree.set_light(2, 2, 2, l_color = "#66FF99")

	if(istype(target, /obj/structure/flora/newtree))
		for(var/turf/adjacent in range(1, T))
			for(var/obj/structure/flora/newbranch/B in adjacent)
				qdel(B)
			for(var/obj/structure/flora/newleaf/L in adjacent)
				qdel(L)
		var/turf/above = get_step_multiz(T, UP)
		if(istype(above, /turf/open/transparent/openspace))
			for(var/obj/structure/flora/newtree/upper_tree in above)
				qdel(upper_tree)

	qdel(target)

	SEND_SIGNAL(user, COMSIG_TREE_TRANSFORMED)
	to_chat(H, span_notice("You transform the tree into a wise tree."))
	playsound(T, 'sound/ambience/noises/mystical (4).ogg', 50, TRUE)

/obj/effect/temp_visual/trap/emergence
	color = GLOW_COLOR_EARTHEN
	light_color = GLOW_COLOR_EARTHEN
	duration = TELEGRAPH_SKILLSHOT
