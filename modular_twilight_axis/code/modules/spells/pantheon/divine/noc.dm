/datum/action/cooldown/spell/noc
	background_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	associated_skill = /datum/skill/magic/holy

//Зеркально взору Астраты.
/obj/effect/proc_holder/spell/self/TAnoc_gaze
	name = "Взор Нок"
	desc = "Убирает ограничения вашего взгляда и ума, позволяя видеть всё сокрытое."
	action_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	overlay_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	overlay_state = "nocshroud"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/astrata_choir.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocations = "Нок, покажи мне сокрытое."
	invocation_type = INVOCATION_WHISPER
	recharge_time = 90 SECONDS
	devotion_cost = 30
	miracle = TRUE

/obj/effect/proc_holder/spell/self/TAnoc_gaze/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	var/skill_level = H.get_skill_level(associated_skill)
	H.apply_status_effect(/datum/status_effect/buff/TAnoc_gaze, skill_level)
	H.apply_status_effect(/datum/status_effect/buff/darkvision)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/TAnoc_gaze
	name = "Взор Нок"
	desc = "С её глазами, я найду и увижу всё сокрытое."
	icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	icon_state = "nocshroud"

/datum/status_effect/buff/TAnoc_gaze
	id = "nocgaze"
	alert_type = /atom/movable/screen/alert/status_effect/buff/TAnoc_gaze
	duration = 20 SECONDS
	var/skill_level = 0
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/TAnoc_gaze/on_creation(mob/living/new_owner, slevel)
	// Only store skill level here
	skill_level = slevel
	.=..()

/datum/status_effect/buff/TAnoc_gaze/on_apply()
	var/per_bonus = 1
	duration = 20 SECONDS

	if(skill_level > SKILL_LEVEL_NOVICE)
		per_bonus++

	if(!GLOB.tod == "day")
		per_bonus++
		duration *= 2

	duration *= skill_level

	if(per_bonus)
		effectedstats = list(STATKEY_PER = per_bonus)

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = TRUE
		H.hide_cone()
		H.update_cone_show()

	to_chat(owner, span_info("Нок даровала мне свои чувства! Я могу увидеть всё!"))

	return ..()

/datum/status_effect/buff/TAnoc_gaze/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = FALSE
		H.hide_cone()
		H.update_cone_show()

/////////////////////////
// T1 - Enlightenment. //
/////////////////////////

/datum/action/cooldown/spell/noc/TAenlightenment
	name = "Озарение"
	desc = "Создайте низшую форму танца лунного света, временно повышающую интеллект вашей цели. \
	Навык чудес влияет на силу эффекта, а также эффект становится намного сильнее вне дня."
	button_icon_state = "moon_light"
	sound = 'sound/magic/clang.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_STAT_BUFF
	secondary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Даруй мне свое наставление.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	charge_then_click = TRUE
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAenlightenment/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/skill_level = H.get_skill_level(associated_skill)
	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget] briefly shines green.")
		to_chat(H, span_notice("With another person as a conduit, my spell's duration is extended."))
		spelltarget.apply_status_effect(/datum/status_effect/buff/TAwise_moon, skill_level)
	else
		H.visible_message("[H] mutters an incantation and they briefly shine green.")
		spelltarget.apply_status_effect(/datum/status_effect/buff/TAwise_moon, skill_level)
	return TRUE

/datum/status_effect/buff/TAwise_moon
	id = "wise_moon"
	alert_type = /atom/movable/screen/alert/status_effect/buff/wise_moon
	duration = 2 MINUTES

/datum/status_effect/buff/TAwise_moon/on_creation(mob/living/new_owner, assocskill)
	var/int_bonus = 0
	if(assocskill)
		int_bonus = 2
		if(assocskill >= 4)
			int_bonus = 3
	if(!GLOB.tod == "day")
		if(assocskill <= 2)
			int_bonus = 3
		else
			int_bonus = assocskill
		duration *= 1.5
	else if(GLOB.tod == "day")
		int_bonus--
	if(int_bonus > 0)
		effectedstats = list(STATKEY_INT = int_bonus)
	. = ..()

/datum/status_effect/buff/TAwise_moon/on_apply()
	. = ..()
	owner.energy_add((100 * (owner.get_skill_level(/datum/skill/magic/holy))) * 2)

/////////////////////////
// T1 - Nitesight. //////
/////////////////////////

/datum/action/cooldown/spell/noc/TAnitevision
	name = "Ночное зрение"
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "darkvision"
	desc = "Дарует вам и людям вокруг ночное зрение."
	fluff_desc = "Когда первые люди появились, они не были наделены даром видеть ночью. В темноте они становились добычей чудовищ и животных. Нок, в своей бесконечной мудрости, наделила человечество даром ночного видения. И вскоре, маги смогли повторить её зрение с помощью арканы."
	sound = 'sound/magic/haste.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_STAT_BUFF

	secondary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Нок направляет мой взор.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 MINUTES

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAnitevision/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.visible_message("[H] mutters an incantation and a dim pulse of light radiates out from them.")
	for(var/mob/living/L in range(2, H))
		L.apply_status_effect(/datum/status_effect/buff/nitevision/noc)

	return TRUE

/datum/status_effect/buff/nitevision/noc
	id = "noc_nitevision"
	effectedstats = list(STATKEY_PER = 1)
	duration = 10 MINUTES

//////////////////////////////
// T1 - Hiden Rune. //
/////////////////////////////

/datum/action/cooldown/spell/noc/TAhidden_rune
	name = "Скрытая Руна"
	desc = "Вы создаете на полу скрытую руну. При наступлении на руну существом, что не являются членом вашей группы, создается морозное поле радиусом 3x3, которое охлаждает всех, кто в него войдёт."
	sound = 'sound/spellbooks/crystal.ogg'
	background_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon_state = "antimagenoc"

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
	button_icon_state = "silencenoc"
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

// Альтернатива Ритуоса - но вместо крутых трейтов дает больше магии.
/datum/action/cooldown/spell/noc/TAspellpack
	name = "Арканные знания"
	desc = "Дарует вам частицу знаний Арканы, позволяя использовать её без зубрения в книжках!"
	button_icon_state = "spellpack"
	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAspellpack/cast(atom/cast_on)
	. = ..()
	owner.adjust_skillrank(/datum/skill/magic/arcane, 4, TRUE)
	if(owner.mind)
		if(!LAZYLEN(owner.mind.mage_aspect_config))
			owner.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 3, "utilities" = 9))
		else
			owner.mind.mage_aspect_config["utilities"] += 3
			owner.mind.mage_aspect_config["minor"] += 3
			owner.mind.check_learnspell()
		ADD_TRAIT(owner, TRAIT_WARLOCK, "[type]")
		grant_poke_spell(owner)

	owner.visible_message(
		span_boldwarning("Арканные руны покрывают кожу [owner], излучая приятный, синий свет, прежде чем потухнуть."),
		span_notice("Нок даровала частицу своего знания! Знания наполнили мой разум!")
	)
	owner.mind?.RemoveSpell(src.type)
	return TRUE

// That's one in fact is not Noc changes, but it’s related to that.

/datum/action/cooldown/spell/undivided/undivided_spellpack
	miracle_generalist_bundle = list(
		/datum/action/cooldown/spell/darkvision/undivided::name		=/datum/action/cooldown/spell/darkvision/undivided,
		/datum/action/cooldown/spell/noc/invisibility::name			=/datum/action/cooldown/spell/noc/invisibility,
		/datum/action/cooldown/spell/noc/enlightenment::name		=/datum/action/cooldown/spell/noc/enlightenment,
		/obj/effect/proc_holder/spell/invoked/diagnose::name		=/obj/effect/proc_holder/spell/invoked/diagnose,
		/obj/effect/proc_holder/spell/invoked/bless_food::name		=/obj/effect/proc_holder/spell/invoked/bless_food,
		/datum/action/cooldown/spell/arcyne_forge/miracle::name		=/datum/action/cooldown/spell/arcyne_forge/miracle,
	)
	miracle_acolyte_bundle = list(
		/datum/action/cooldown/spell/miracle/fortify::name			=/datum/action/cooldown/spell/miracle/fortify,
		/obj/effect/proc_holder/spell/invoked/abyssheal::name		=/obj/effect/proc_holder/spell/invoked/abyssheal,
		/obj/effect/proc_holder/spell/invoked/eora_blessing::name	=/obj/effect/proc_holder/spell/invoked/eora_blessing,
		/obj/effect/proc_holder/spell/targeted/blesscrop::name		=/obj/effect/proc_holder/spell/targeted/blesscrop,
		/datum/action/cooldown/spell/noc/TAblindness::name			=/datum/action/cooldown/spell/noc/TAblindness,
	)
	miracle_templar_bundle = list(
		/datum/action/cooldown/spell/noc/TAhidden_rune::name		=/datum/action/cooldown/spell/noc/TAhidden_rune,
		/datum/action/cooldown/spell/projectile/sacred_flame::name	=/datum/action/cooldown/spell/projectile/sacred_flame,
		/datum/action/cooldown/spell/ravox/withstand::name			=/datum/action/cooldown/spell/ravox/withstand,
		/obj/effect/proc_holder/spell/invoked/vendetta::name		=/obj/effect/proc_holder/spell/invoked/vendetta,
		/datum/action/cooldown/spell/malum/hammerfall::name			=/datum/action/cooldown/spell/malum/hammerfall,
	)
