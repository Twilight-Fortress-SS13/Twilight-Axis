/datum/action/cooldown/spell/noc
	background_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	associated_skill = /datum/skill/magic/holy

/////////////////////////
// T0 - Nitesight. //////
/////////////////////////

/datum/action/cooldown/spell/noc/nitevision
	name = "Ночное зрение"
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "darkvision"
	desc = "Дарует вам и людям вокруг ночное зрение."
	invocation_type = "Нок направляет мой взор."

//////////////////////////////
// T1 - Hiden Rune. //
/////////////////////////////

/datum/action/cooldown/spell/noc/TAhidden_rune
	name = "Скрытая Руна"
	desc = "Вы создаете на полу скрытую руну. При наступлении на руну существом, что не являются членом вашей группы, создается морозное поле радиусом 3x3, которое охлаждает всех, кто в него войдёт."
	sound = 'sound/spellbooks/crystal.ogg'
	background_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon_state = "noc_gaze"

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = FALSE

	primary_resource_cost = 50

	secondary_resource_cost = 10

	invocation_type = INVOCATION_NONE
	invocations = null

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAhidden_rune/cast(atom/cast_on)
	. = ..()
	if(isopenturf(cast_on))
		var/mob/living/carbon/human/O = owner
		var/turf/place_to_spawn = cast_on
		var/obj/structure/trap/moon/moon_trap = new /obj/structure/trap/moon(place_to_spawn)
		moon_trap.summoner = O
		var/datum/fellowship/F = O.current_fellowship
		if(F)
			for(var/mob/living/carbon/human/fellowshipers as anything in F.get_members())
				moon_trap.immune_minds += fellowshipers.mind
		else
			moon_trap.immune_minds += O.mind
	else
		return FALSE

/obj/structure/trap/moon
	icon = 'icons/effects/effects.dmi'
	icon_state = "spellwarning"
	layer = BELOW_MOB_LAYER
	max_integrity = 100
	charges = 1
	trap_damage = 50
	disarm_by_sight = FALSE
	var/mob/living/summoner

/obj/structure/trap/moon/trap_effect(mob/living/L)
	. = ..()
	new /obj/effect/frozen_mist/moon(L.loc, summoner)

/obj/effect/frozen_mist/moon
	effect_radius = 1
	ticks_remaining = 5

/////////////////////////
// T2 - Nite Owl. //
////////////////////////

/datum/action/cooldown/spell/projectile/nite_owl
	name = "Ночная сова"
	desc = "Направьте на врага ночную сову, которая попытается замедлить его и затушить весь свет."
	background_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon_state = "noc_sight"
	glow_intensity = NONE
	attunement_school = null

	projectile_type = /obj/projectile/magic/nite_owl
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Да поможет мне друг Луны.")
	invocation_type = INVOCATION_WHISPER

	ignore_armor_penalty = TRUE
	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	cooldown_time = 45 SECONDS

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/noc, /obj/item/clothing/neck/roguetown/psicross/silver/noc, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/obj/projectile/magic/nite_owl
	name = "nite owl"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "nite_owl"
	damage = 30
	nodamage = FALSE
	damage_type = BRUTE
	range = 8
	hitsound = 'sound/magic/owlhoot.ogg'
	guard_deflectable = TRUE
	expose_caster_on_deflect = TRUE

/obj/projectile/magic/nite_owl/on_hit(target, blocked = FALSE)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check(TRUE, TRUE))
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(blocked >= 100)
			return ..()
		if(M.has_status_effect(/datum/status_effect/debuff/TAnite_owl))
			qdel(src)
			return BULLET_ACT_BLOCK
		M.apply_status_effect(/datum/status_effect/debuff/TAnite_owl)
		playsound(get_turf(target), hitsound, 60, TRUE)
	return ..()

/datum/status_effect/debuff/TAnite_owl
	id = "nite_owl"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/TAnite_owl
	effectedstats = list(STATKEY_SPD = -3)
	duration = 15 SECONDS

/datum/status_effect/debuff/TAnite_owl/on_apply()
	if(!owner.mind)
		owner.Immobilize(5 SECONDS)

	for(var/obj/O in range(1, owner))
		if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
			continue
		if(istype(O, /obj/item/flashlight/flare/light))
			qdel(O)
		O.extinguish()

	for(var/mob/M in range(1, owner))
		for(var/obj/O in M.contents)
			if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
				continue
			if(istype(O, /obj/item/flashlight/flare/light))
				qdel(O)
			O.extinguish()

	if(owner.has_status_effect(/datum/status_effect/light_buff))
		owner.remove_status_effect(/datum/status_effect/light_buff)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/TAnite_owl
	name = "Ночная сова"
	desc = "Вы ощущаете её арканное присутствие рядом, но не можете понять, где она..."

/////////////////////
// T2 - Blindness. //
/////////////////////

/datum/action/cooldown/spell/noc/TAblindness
	name = "Ослепление"
	desc = "Направьте тьму в глаза жертвы, ослепляя её. \n(-3 ВНИМАТЕЛЬНОСТИ, КОРОТКОЕ ОСЛЕПЛЕНИЕ)"
	button_icon_state = "blindness"
	sound = 'sound/magic/churn.ogg'
	glow_intensity = GLOW_INTENSITY_LOW
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_MIRACLE
	invocation_type = INVOCATION_WHISPER
	invocations = list("Темнейшая ночь, ослепи!")
	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1.5 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAblindness/cast(atom/cast_on)
	. = ..()
	var/mob/living/spelltarget = cast_on

	if(isliving(cast_on))
		if(spelltarget.anti_magic_check(TRUE, TRUE))
			to_chat(owner, span_danger("Their magic protection has interrupted my cast!"))
			return FALSE
		if(spell_guard_check(cast_on, TRUE))
			cast_on.visible_message(span_warning("[cast_on] shields their eyes from the darkness!"))
			return TRUE
		var/assocskill = owner.get_skill_level(associated_skill)
		cast_on.visible_message(span_warning("[owner] points at [cast_on]'s eyes!"), span_userdanger("[owner] points at my eyes! Shadowy fingers are digging into my vision-- I can't SEE!"))
		spelltarget.apply_status_effect(/datum/status_effect/debuff/TAblindness, assocskill)
		spelltarget.flash_act()
		if(!spelltarget.mind)
			spelltarget.Immobilize(5 SECONDS)
		return TRUE
	else
		return FALSE

/atom/movable/screen/alert/status_effect/debuff/TAblindness
	name = "Слепота"
	desc = "Я ничего не вижу! (-3 ВНИМАТЕЛЬНОСТИ, СЛЕПОТА)"

/datum/status_effect/debuff/TAblindness
	id = "blindness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/TAblindness
	effectedstats = list(STATKEY_PER = -3)

/datum/status_effect/debuff/TAblindness/on_creation(mob/living/new_owner, assocskill)
	// Guaranteed at least five seconds. Technically not needed but Just In CaseTM.
	if(assocskill)
		duration = clamp(assocskill*5, 5, 30) * 1 SECONDS
	else
		duration = 5 SECONDS // Just in case someone somehow gets this W/O holy skill.
	. = ..()

/datum/status_effect/debuff/TAblindness/on_apply()
	. = ..()
	owner.adjust_blindness(3)

/datum/status_effect/debuff/TAblindness/on_remove()
	. = ..()
	to_chat(owner, span_warning("My vision returns...!"))


////////////////////////
// T2 - Invisibility. //
////////////////////////

/datum/action/cooldown/spell/noc/invisibility
	name = "Невидимость"
	desc = "Сделайте себя (или другого человека) невидимым на короткое время. Заклинания, атаки или получение урона снимают невидимость."
	hide_charge_effect = TRUE

////////////////////////
// T3 - Silence. 	  //
////////////////////////

/datum/action/cooldown/spell/noc/TAsilence
	name = "Тишина"
	desc = "Закройте жертве рот - жертва не произнесёт ни слова, будь это чтение заклинания или оскорбление. \
		Длительность зависит от уровня чудес."
	button_icon_state = "silence"
	self_cast_possible = FALSE
	cooldown_time = 60 SECONDS
	charge_time = 1 SECONDS
	cast_range = 7
	sound = 'sound/magic/zizo_snuff.ogg'
	invocations = list("Молчание луны!")
	invocation_type = INVOCATION_WHISPER
	devotion_cost = SPELLCOST_MIRACLE_MAJOR

/datum/action/cooldown/spell/noc/TAsilence/cast(atom/cast_on)
	. = ..()
	if(isliving(cast_on))
		var/mob/living/carbon/target = cast_on
		var/mob/living/carbon/caster = owner
		if(target.anti_magic_check(TRUE, TRUE))
			to_chat(caster, span_warning("The spell fizzles, it won't work on them!"))
			return FALSE
		if(spell_guard_check(target, TRUE))
			cast_on.visible_message(span_warning("[cast_on] shields against the void!"))
			return TRUE
		var/assocskill = caster.get_skill_level(associated_skill)
		target.apply_status_effect(/datum/status_effect/debuff/TAmute, assocskill)
		return TRUE
	else
		return FALSE

/datum/status_effect/debuff/TAmute
	id = "mute"
	duration = 5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/debuff/TAmute

/datum/status_effect/debuff/TAmute/on_creation(mob/living/new_owner, assocskill)
	if(assocskill)
		duration = clamp(assocskill*5, 5, 30) * 1 SECONDS
	else
		duration = 5 SECONDS
	. = ..()

/datum/status_effect/debuff/TAmute/on_apply()
	. = ..()
	to_chat(owner, span_warning("The wind in my voice goes still. I can't speak!"))
	ADD_TRAIT(owner, TRAIT_MUTE, MAGIC_TRAIT)

/datum/status_effect/debuff/TAmute/on_remove()
	. = ..()
	to_chat(owner, span_warning("My voice returns to me!"))
	REMOVE_TRAIT(owner, TRAIT_MUTE, MAGIC_TRAIT)

/atom/movable/screen/alert/status_effect/debuff/TAmute
	name = "Немота"
	desc = "Мой рот не издает и звука, я не могу говорить!"

///////////////////////////
// T3 - Arcyne Affinity. //
///////////////////////////

/datum/action/cooldown/spell/noc/TAspellpack
	name = "Arcyne Affinity"
	desc = "Allows you to learn a spellpack. \n \
	<b>MAGISTER</b>: Arc Bolt, Spit Fire, Arcyne Lance \n \
	<b>CONTROLLER</b>: Geas, Gravity, Wither \n \
	<b>SEER</b>: Attune Hawk, Attune Haste, Fortitude, Arcyne Forge, Mending, Lesser Knock"
	button_icon_state = "spellpack"
	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// var we use to flag we are currently choosing a bundle.
	var/choosing_bundle = FALSE
	var/chosen_bundle
	// Magister - attacks
	var/list/magister_bundle = list(
		/datum/action/cooldown/spell/projectile/arc_bolt,
		/datum/action/cooldown/spell/projectile/spitfire,
		/datum/action/cooldown/spell/projectile/frost_bolt,
	)
	// Controller - debuffs
	var/list/controller_bundle = list(
		/datum/action/cooldown/spell/geas,
		/datum/action/cooldown/spell/gravity,
		/datum/action/cooldown/spell/wither,
	// Seer - support and help
	)
	var/list/seer_bundle = list(
		/datum/action/cooldown/spell/augment_buff/attune_hawk,
		/datum/action/cooldown/spell/augment_buff/attune_haste,
		/datum/action/cooldown/spell/augment_buff/fortitude,
		/datum/action/cooldown/spell/arcyne_forge,
		/datum/action/cooldown/spell/mending,
		/datum/action/cooldown/spell/lesser_knock,
	)

/datum/action/cooldown/spell/noc/TAspellpack/cast(atom/cast_on)
	. = ..()

	if(choosing_bundle)
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choosing_bundle = TRUE
		choice = alert(owner, "What type of spells has Noc blessed you with?", "CHOOSE PATH", "Magister", "Controller", "Seer")
		chosen_bundle = choice
		choosing_bundle = FALSE

	switch(choice)
		if("Magister")
			add_spells(owner, magister_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Controller")
			add_spells(owner, controller_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Seer")
			add_spells(owner, seer_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/noc/TAspellpack/proc/add_spells(mob/owner, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(owner?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(owner, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/datum/new_spell = new picked_spell
				owner?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/datum/new_spell = new spell_type
			owner?.mind.AddSpell(new_spell)
	if(!length(spells))
		owner.mind?.RemoveSpell(src.type)


//////////////////////
// T3 - Moonlight. //
//////////////////////

/datum/action/cooldown/spell/noc/TAmoonlight
	name = "Лунный свет"
	desc = "Луна поглощает весь свет и замедляет окружающих в определенном радиусе, эффект зависит от уровня чудес. \
		Низшие существа вокруг вас потеряют возможность двигаться."
	button_icon_state = "moon_light"
	sound = 'sound/magic/churn.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 8
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_SHOUT
	invocations = list("Для меня всегда найдётся тень!", "Попробуй найди меня!")

	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAmoonlight/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/caster = owner
	var/checkrange = (1 + caster.get_skill_level(/datum/skill/magic/holy))
	for(var/mob/living/M in range(checkrange, caster))
		if(M == caster)
			continue
		if(M.anti_magic_check(TRUE, TRUE))
			continue
		M.apply_status_effect(/datum/status_effect/debuff/TAnoc_darkness)
	for(var/obj/O in range(checkrange, caster))
		if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
			continue
		if(istype(O, /obj/item/flashlight/flare/light))
			qdel(O)
		O.extinguish()
	return TRUE

/datum/status_effect/debuff/TAnoc_darkness
	id = "noc_darkness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/TAnoc_darkness
	effectedstats = list(STATKEY_SPD = -2)
	duration = 15 SECONDS

/datum/status_effect/debuff/TAnoc_darkness/on_apply()
	if(!owner.mind)
		owner.Immobilize(3 SECONDS)

	for(var/obj/O in range(1, owner))
		if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
			continue
		if(istype(O, /obj/item/flashlight/flare/light))
			qdel(O)
		O.extinguish()

	for(var/mob/M in range(1, owner))
		for(var/obj/O in M.contents)
			if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
				continue
			if(istype(O, /obj/item/flashlight/flare/light))
				qdel(O)
			O.extinguish()
	return ..()

/atom/movable/screen/alert/status_effect/debuff/TAnoc_darkness
	name = "Nite Darkness"
	desc = "You feel a weight on your soul, as if something is pulling you down..."

// That's one in fact is not Noc changes, but it’s related to that.

/datum/action/cooldown/spell/undivided/undivided_spellpack
	miracle_generalist_bundle = list(
		/datum/action/cooldown/spell/darkvision/undivided::name		= /datum/action/cooldown/spell/darkvision/undivided,
		/datum/action/cooldown/spell/noc/invisibility::name			= /datum/action/cooldown/spell/noc/invisibility,
		/obj/effect/proc_holder/spell/targeted/blesscrop::name		= /obj/effect/proc_holder/spell/targeted/blesscrop,
		/obj/effect/proc_holder/spell/invoked/eora_blessing::name	= /obj/effect/proc_holder/spell/invoked/eora_blessing,
		/datum/action/cooldown/spell/arcyne_forge/miracle::name		= /datum/action/cooldown/spell/arcyne_forge/miracle,
	)
	miracle_acolyte_bundle = list(
		/obj/effect/proc_holder/spell/invoked/diagnose::name			= /obj/effect/proc_holder/spell/invoked/diagnose,
		/datum/action/cooldown/spell/noc/TAblindness::name				= /datum/action/cooldown/spell/noc/TAblindness,
		/obj/effect/proc_holder/spell/invoked/bless_food::name			= /obj/effect/proc_holder/spell/invoked/bless_food,
		/obj/effect/proc_holder/spell/invoked/avert::name				= /obj/effect/proc_holder/spell/invoked/avert,
		/obj/effect/proc_holder/spell/invoked/attach_bodypart::name		= /obj/effect/proc_holder/spell/invoked/attach_bodypart,
	)
	miracle_templar_bundle = list(
		/obj/effect/proc_holder/spell/invoked/abyssor_undertow::name		= /obj/effect/proc_holder/spell/invoked/abyssor_undertow,
		/datum/action/cooldown/spell/ravox/withstand::name					= /datum/action/cooldown/spell/ravox/withstand,
		/datum/action/cooldown/spell/mending/malum::name					= /datum/action/cooldown/spell/mending/malum,
		/datum/action/cooldown/spell/noc/TAhidden_rune::name					= /datum/action/cooldown/spell/noc/TAhidden_rune,
		/obj/effect/proc_holder/spell/invoked/vendetta::name				= /obj/effect/proc_holder/spell/invoked/vendetta,
	)
