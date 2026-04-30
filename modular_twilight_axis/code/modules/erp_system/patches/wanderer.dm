// ============================================================
// TEMPTRESS
// Martial master inheritor with ERP/training hooks.
// ============================================================

#define TEMPTRESS_EMBRACE_TRAIT_SOURCE    "temptress_embrace"
#define TEMPTRESS_EMBRACE_PULSE_CD        (1 SECONDS)
#define TEMPTRESS_EMBRACE_GAIN_CD         (3 SECONDS)
#define TEMPTRESS_EMBRACE_RANGE           2

/proc/temptress_get_component(mob/living/user)
	if(!isliving(user))
		return null

	var/datum/component/combo_core/temptress/C = user.GetComponent(/datum/component/combo_core/temptress)
	if(!C)
		C = user.AddComponent(/datum/component/combo_core/temptress)
	return C

/proc/temptress_get_component_safe(mob/living/user)
	if(!isliving(user))
		return null

	return user.GetComponent(/datum/component/combo_core/temptress)

GLOBAL_LIST_INIT(temptress_erp_training_map, list(
	/datum/skill/labor/farming = list("action" = /datum/erp_action/other/hands/milking_breasts, "passive" = "temptress"),
	/datum/skill/labor/mining = list("action" = /datum/erp_action/other/mouth/rimming, "passive" = "temptress"),
	/datum/skill/labor/fishing = list("action" = /datum/erp_action/other/hands/finger_oral, "passive" = "temptress"),
	/datum/skill/labor/butchering = list("action" = /datum/erp_action/other/body/grinding, "passive" = "temptress"),
	/datum/skill/labor/lumberjacking = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "temptress"),

	/datum/skill/magic/holy = list("action" = /datum/erp_action/other/mouth/cunnilingus, "passive" = "temptress"),
	/datum/skill/magic/arcane = list("action" = /datum/erp_action/other/mouth/breast_feed, "passive" = "temptress"),

	/datum/skill/misc/climbing = list("action" = /datum/erp_action/other/body/rubbing, "passive" = "actor"),
	/datum/skill/misc/reading = list("action" = /datum/erp_action/other/vagina/force_face, "passive" = "actor"),
	/datum/skill/misc/stealing = list("action" = /datum/erp_action/other/vagina/face, "passive" = "actor"),
	/datum/skill/misc/sneaking = list("action" = /datum/erp_action/other/hands/force_crotch, "passive" = "actor"),
	/datum/skill/misc/lockpicking = list("action" = /datum/erp_action/other/hands/tease_vagina, "passive" = "temptress"),
	/datum/skill/misc/riding = list("action" = /datum/erp_action/other/anus/force_face, "passive" = "temptress"),
	/datum/skill/misc/medicine = list("action" = /datum/erp_action/other/mouth/finger_lick, "passive" = "actor"),
	/datum/skill/misc/tracking = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "temptress"),

	/datum/skill/craft/crafting = list("action" = /datum/erp_action/other/breasts/breast_feed, "passive" = "actor"),
	/datum/skill/craft/weaponsmithing = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "actor"),
	/datum/skill/craft/armorsmithing = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "actor"),
	/datum/skill/craft/blacksmithing = list("action" = /datum/erp_action/other/anus/butt, "passive" = "temptress"),
	/datum/skill/craft/smelting = list("action" = /datum/erp_action/other/penis/rubbing, "passive" = "actor"),
	/datum/skill/craft/carpentry = list("action" = /datum/erp_action/other/vagina/rubbing, "passive" = "actor"),
	/datum/skill/craft/masonry = list("action" = /datum/erp_action/other/anus/rubbing, "passive" = "actor"),
	/datum/skill/craft/traps = list("action" = /datum/erp_action/other/anus/face, "passive" = "actor"),
	/datum/skill/craft/engineering = list("action" = /datum/erp_action/other/hands/toy_oral, "passive" = "temptress"),
	/datum/skill/craft/cooking = list("action" = /datum/erp_action/other/mouth/kiss, "passive" = "temptress"),
	/datum/skill/craft/sewing = list("action" = /datum/erp_action/other/hands/rubbing, "passive" = "temptress"),
	/datum/skill/craft/tanning = list("action" = /datum/erp_action/other/hands/spanking, "passive" = "actor"),
	/datum/skill/craft/ceramics = list("action" = /datum/erp_action/other/hands/breasts_play, "passive" = "temptress"),
	/datum/skill/craft/alchemy = list("action" = /datum/erp_action/other/hands/milking_penis, "passive" = "temptress"),

	/datum/skill/combat/knives = list("action" = /datum/erp_action/other/penis/masturbation, "passive" = "actor"),
	/datum/skill/combat/swords = list("action" = /datum/erp_action/other/hands/toy_anal, "passive" = "temptress"),
	/datum/skill/combat/polearms = list("action" = /datum/erp_action/other/hands/toy_vaginal, "passive" = "temptress"),
	/datum/skill/combat/maces = list("action" = /datum/erp_action/other/legs/footjob, "passive" = "temptress"),
	/datum/skill/combat/axes = list("action" = /datum/erp_action/other/mouth/foot_lick, "passive" = "temptress"),
	/datum/skill/combat/whipsflails = list("action" = /datum/erp_action/other/hands/tease_testicles, "passive" = "temptress"),
	/datum/skill/combat/wrestling = list("action" = /datum/erp_action/other/hands/finger_anal, "passive" = "temptress"),
	/datum/skill/combat/unarmed = list("action" = /datum/erp_action/other/hands/finger_vaginal, "passive" = "temptress"),
	/datum/skill/combat/shields = list("action" = /datum/erp_action/other/breasts/teasing, "passive" = "actor"),
	/datum/skill/combat/staves = list("action" = /datum/erp_action/other/legs/teasing, "passive" = "actor")
))

GLOBAL_LIST_INIT(temptress_combat_skills, list(
	/datum/skill/combat/knives,
	/datum/skill/combat/swords,
	/datum/skill/combat/polearms,
	/datum/skill/combat/maces,
	/datum/skill/combat/axes,
	/datum/skill/combat/whipsflails,
	/datum/skill/combat/wrestling,
	/datum/skill/combat/unarmed,
	/datum/skill/combat/shields,
	/datum/skill/combat/staves
))

/proc/temptress_erp_get_training_entry(datum/erp_action/A, expected_passive)
	if(!A || !expected_passive)
		return null

	var/action_type = A.type

	for(var/skill_type as anything in GLOB.temptress_erp_training_map)
		var/list/entry = GLOB.temptress_erp_training_map[skill_type]
		if(!islist(entry))
			continue

		if(entry["action"] != action_type)
			continue

		if(entry["passive"] != expected_passive)
			continue

		return list("skill" = skill_type, "passive" = entry["passive"])

	return null

/datum/erp_scene_effects/proc/apply_training(list/active_links)
	if(!controller)
		return

	var/list/temptresses = list()

	var/datum/component/combo_core/temptress/TC = controller.owner?.physical?.GetComponent(/datum/component/combo_core/temptress)
	if(TC && TC.erotic_embrace_enabled && TC.owner)
		temptresses += TC.owner

	TC = controller.active_partner?.physical?.GetComponent(/datum/component/combo_core/temptress)
	if(TC && TC.erotic_embrace_enabled && TC.owner)
		if(!(TC.owner in temptresses))
			temptresses += TC.owner

	if(!length(temptresses))
		return

	for(var/mob/living/temptress_mob as anything in temptresses)
		if(!temptress_mob)
			continue

		for(var/datum/erp_sex_link/L in active_links)
			if(!L || QDELETED(L) || !L.is_valid())
				continue

			var/datum/erp_actor/active = L.actor_active
			var/datum/erp_actor/passive = L.actor_passive
			if(!active || !passive)
				continue

			var/mob/living/m_active = active.get_effect_mob()
			var/mob/living/m_passive = passive.get_effect_mob()
			if(!m_active || !m_passive)
				continue

			var/expected_passive = null
			var/mob/living/receiver = null

			if(m_active == temptress_mob)
				expected_passive = "actor"
				receiver = m_passive
			else if(m_passive == temptress_mob)
				expected_passive = "temptress"
				receiver = m_active
			else
				continue

			if(!receiver?.mind)
				continue

			var/list/entry = temptress_erp_get_training_entry(L.action, expected_passive)
			if(!entry)
				continue

			var/skill_type = entry["skill"]
			if(!skill_type)
				continue

			if(skill_type in GLOB.temptress_combat_skills)
				if(L.force < SEX_FORCE_HIGH)
					continue

			receiver.mind.add_sleep_experience(skill_type, 2, FALSE)

/datum/component/combo_core/temptress
	parent_type = /datum/component/combo_core/martial_master
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/erotic_embrace_enabled = FALSE
	var/temptress_awakened = FALSE

	var/last_embrace_pulse = 0
	var/last_embrace_gain = 0

/datum/component/combo_core/temptress/Initialize(_combo_window, _max_history)
	. = ..(_combo_window, _max_history)
	if(. == COMPONENT_INCOMPATIBLE)
		return .

	RegisterSignal(owner, COMSIG_PARENT_EXAMINE, PROC_REF(_sig_examined))
	return .

/datum/component/combo_core/temptress/Destroy(force)
	if(owner)
		UnregisterSignal(owner, COMSIG_PARENT_EXAMINE)
		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, TEMPTRESS_EMBRACE_TRAIT_SOURCE)

	return ..()

/datum/component/combo_core/temptress/process()
	. = ..()

	if(!owner || !erotic_embrace_enabled)
		return

	if(world.time < last_embrace_pulse + TEMPTRESS_EMBRACE_PULSE_CD)
		return

	last_embrace_pulse = world.time

	var/list/targets = list()

	for(var/mob/living/M in view(TEMPTRESS_EMBRACE_RANGE, owner))
		if(M == owner)
			continue
		if(M.stat == DEAD)
			continue
		targets += M

	if(!length(targets))
		return

	if(world.time >= last_embrace_gain + TEMPTRESS_EMBRACE_GAIN_CD)
		for(var/mob/living/M as anything in targets)
			AddArousalStack(1)
			SEND_SIGNAL(M, COMSIG_SEX_RECEIVE_ACTION, 2, 0, TRUE, 1, 1, null)

		last_embrace_gain = world.time
	else
		for(var/mob/living/M as anything in targets)
			SEND_SIGNAL(M, COMSIG_SEX_RECEIVE_ACTION, 1, 0, TRUE, 1, 1, null)

/datum/component/combo_core/temptress/GetComboDamageMultiplier()
	var/mult = 1
	mult += (arousal_stacks * 0.10)
	return max(1, mult)

/datum/component/combo_core/temptress/GrantSpells()
	if(!owner?.mind)
		return

	var/mob/living/L = owner
	RevokeSpells()

	var/list/paths = list(
		/obj/effect/proc_holder/spell/self/martial_master/switch_stance
	)

	if(!temptress_awakened)
		paths += /obj/effect/proc_holder/spell/self/temptress_awaken
	else
		paths += /obj/effect/proc_holder/spell/self/temptress/erotic_embrace
		paths += /obj/effect/proc_holder/spell/invoked/massage
		paths += /datum/action/cooldown/spell/mirror_transform

	for(var/path in paths)
		var/obj/effect/proc_holder/spell/S = new path
		L.mind.AddSpell(S)
		granted_spells += S

	spells_granted = TRUE

/datum/component/combo_core/temptress/proc/UnlockTemptressArts()
	if(temptress_awakened)
		return

	temptress_awakened = TRUE
	GrantSpells()
	MartialMasterWaveUp("#6b2240")
	_balloon("awakened")

/datum/component/combo_core/temptress/proc/ToggleEroticEmbrace()
	erotic_embrace_enabled = !erotic_embrace_enabled

	if(erotic_embrace_enabled)
		ADD_TRAIT(owner, TRAIT_DODGEEXPERT, TEMPTRESS_EMBRACE_TRAIT_SOURCE)
		MartialMasterWaveUp("#6b2240")
	else
		REMOVE_TRAIT(owner, TRAIT_DODGEEXPERT, TEMPTRESS_EMBRACE_TRAIT_SOURCE)
		MartialMasterParticleUp("#6b2240")

	_balloon_embrace()

/datum/component/combo_core/temptress/proc/_sig_examined(datum/source, mob/living/user)
	SIGNAL_HANDLER

	if(!erotic_embrace_enabled)
		return 0
	if(!isliving(user))
		return 0
	if(user == owner)
		return 0
	if(world.time < last_embrace_gain + TEMPTRESS_EMBRACE_GAIN_CD)
		return 0

	SEND_SIGNAL(user, COMSIG_SEX_RECEIVE_ACTION, 6, 0, TRUE, 2, 2, null)
	AddArousalStack(1)
	last_embrace_gain = world.time
	return 0

/datum/component/combo_core/temptress/proc/_balloon_embrace()
	if(erotic_embrace_enabled)
		_balloon("embrace: on")
	else
		_balloon("embrace: off")

// ------------------------------------------------------------
// spells
// ------------------------------------------------------------

/obj/effect/proc_holder/spell/self/temptress
	name = "Temptress Ability"
	desc = "Base temptress ability."
	clothes_req = FALSE
	charge_type = "recharge"
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 6 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1

	invocations = list()
	invocation_type = "none"
	hide_charge_effect = TRUE
	charging_slowdown = 0
	chargedloop = null
	overlay_state = null

	action_icon = 'modular_twilight_axis/icons/roguetown/misc/soundspells.dmi'

/obj/effect/proc_holder/spell/self/temptress/proc/Execute(mob/living/user, datum/component/combo_core/temptress/C)
	return

/obj/effect/proc_holder/spell/self/temptress_awaken
	name = "Temptress Awakening"
	desc = "Awaken the tempting flow within yourself."
	clothes_req = FALSE
	charge_type = "recharge"
	cost = 0
	xp_gain = FALSE

	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	recharge_time = 2 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1

	invocations = list()
	invocation_type = "none"
	hide_charge_effect = TRUE
	charging_slowdown = 0
	chargedloop = null
	overlay_state = "embrace"

	action_icon = 'modular_twilight_axis/icons/roguetown/misc/soundspells.dmi'

/obj/effect/proc_holder/spell/self/temptress_awaken/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.incapacitated())
		return

	var/datum/component/combo_core/temptress/C = temptress_get_component(L)
	if(!C)
		return

	if(C.temptress_awakened)
		L.balloon_alert(L, "Already awakened.")
		return

	C.UnlockTemptressArts()

	if(L.mind)
		L.mind.RemoveSpell(src)
	qdel(src)

/obj/effect/proc_holder/spell/self/temptress/erotic_embrace
	name = "Erotic Embrace"
	desc = "Toggle erotic embrace mode."
	overlay_state = "embrace"
	recharge_time = 2 SECONDS

/obj/effect/proc_holder/spell/self/temptress/erotic_embrace/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(user))
		return

	var/mob/living/L = user
	if(L.incapacitated())
		return

	var/datum/component/combo_core/temptress/C = temptress_get_component_safe(L)
	if(!C)
		return

	if(!C.temptress_awakened)
		return

	C.ToggleEroticEmbrace()

#undef TEMPTRESS_EMBRACE_TRAIT_SOURCE
#undef TEMPTRESS_EMBRACE_PULSE_CD
#undef TEMPTRESS_EMBRACE_GAIN_CD
#undef TEMPTRESS_EMBRACE_RANGE
