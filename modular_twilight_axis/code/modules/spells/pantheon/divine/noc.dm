/datum/action/cooldown/spell/noc
	background_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'

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
// T1 - Step in the shadow. //
/////////////////////////////

/datum/action/cooldown/spell/noc/TAstep_in_the_shadow
	name = "Шаг во тьму"
	desc = "Находясь в тени, вы можете быстро телепортироваться в неосвещённое место. Ограничено дальностью в 6 шагов."
	sound = 'sound/magic/blink.ogg'
	background_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon = 'modular_twilight_axis/icons/mob/actions/nocmiracles.dmi'
	button_icon_state = "noc_gaze"
	cooldown_time = 40 SECONDS
	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = 0
	charge_sound = null
	hide_charge_effect = TRUE
	invocation_type = INVOCATION_NONE
	hold_drain = 1
	spell_color = NONE
	glow_intensity = NONE
	ignore_armor_penalty = TRUE
	attunement_school = null
	source_aspect = null
	weapon_cast_penalized = FALSE
	primary_resource_type = SPELLCOST_MIRACLE_MAJOR
	secondary_resource_type = SPELLCOST_TELEPORT
	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	point_cost = 0
	var/max_range = 6
	var/phase = /obj/effect/temp_visual/blink/shadowstep

/datum/action/cooldown/spell/noc/TAstep_in_the_shadow/cast(atom/cast_on)
	. = ..()
	var/turf/T = get_turf(cast_on)
	var/turf/start = get_turf(owner)
	if(T.get_lumcount() > 0.25 || start.get_lumcount() > 0.25)
		to_chat(owner, span_warning("There is too much light!"))
		return FALSE

	var/dest_err = arcyne_validate_blink_dest(T, owner)
	if(dest_err)
		to_chat(owner, span_warning(dest_err))
		return FALSE

	var/distance = get_dist(start, T)
	if(distance > max_range)
		to_chat(owner, span_warning("That location is too far away! I can only blink up to [max_range] tiles."))
		return FALSE

	var/path_err = arcyne_validate_blink_path(start, T)
	if(path_err)
		to_chat(owner, span_warning(path_err))
		return FALSE

	owner.visible_message(span_warning("<b>[owner]'s body begins to shimmer with arcane energy as [owner.p_they()] prepare[owner.p_s()] to blink!</b>"),
					span_notice("<b>I focus my arcane energy, preparing to blink across space!</b>"))

	new phase(start, owner.dir)
	new phase(T, owner.dir)

	var/mob/living/L = owner
	if(istype(L) && L.buckled)
		L.buckled.unbuckle_mob(L, TRUE)

	// Afterimage at departure point
	var/obj/effect/after_image/img = new(start, 0, 0, 0, 0, 0.5 SECONDS, 2 SECONDS, 0)
	img.name = owner.name
	img.appearance = owner.appearance
	img.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	img.alpha = 120
	animate(img, alpha = 0, time = 1.5 SECONDS, easing = LINEAR_EASING)
	QDEL_IN(img, 1.5 SECONDS)

	do_teleport(owner, T, channel = TELEPORT_CHANNEL_MAGIC)

	return TRUE

/obj/effect/temp_visual/blink/shadowstep
	icon_state = "curse"
	light_color = COLOR_PALE_PURPLE_GRAY

///////////////////////
// T1 - Inspiration. //
///////////////////////

/datum/action/cooldown/spell/noc/TAinspiration
	name = "Вдохновение"
	desc = "Прикоснитесь к цели. Следующий сон цели будет вдохновлён, даруя больше очков сна цели и немного себе. \
	Количество очков зависит от вашего уровня чудес."
	button_icon_state = "moondream"
	sound = 'sound/magic/owlhoot.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MIRACLE_MINOR

	invocation_type = INVOCATION_WHISPER
	invocations = list("Спокойной ночи.")

	charge_required = FALSE
	cooldown_time = 25 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/TAinspiration/cast(atom/cast_on)
	. = ..()
	if(isliving(cast_on))
		var/mob/living/carbon/human/target = cast_on
		var/mob/living/carbon/human/H = owner
		if(target.anti_magic_check(TRUE, TRUE))
			to_chat(owner, span_danger("Что-то мешает мне вдохновить их сны!"))
			return FALSE
		if(!target.mind)
			to_chat(owner, span_warning("Цель слишком глупа для моих чудес!"))
			return FALSE
		if(target.mind?.sleep_adv)
			owner.visible_message(span_blue("[owner] рисует светящийся голубой полумесяц на голове [target]"))
			to_chat(target, span_blue("Мой разум сияет множественными изображениями и идеями! Мои сны будут более насыщенными...!"))
			target.mind.sleep_adv.sleep_adv_points += H.get_skill_level(associated_skill)
			target.energy_add(50 * H.get_skill_level(associated_skill))
			H.energy_add(25 * H.get_skill_level(associated_skill))
			H.mind.sleep_adv.sleep_adv_points += floor(H.get_skill_level(associated_skill)/2)
		return TRUE
	return FALSE

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
	icon_state = "nite_owl"//Someone make a better sprite for this someday.
	damage = 30
	nodamage = FALSE
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
	invocation_type = INVOCATION_SHOUT
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
	<b>CONTROLLER</b>: Frost Bolt, Geas, Gravity, Wither \n \
	<b>SEER</b>: Attune Hawk, Attune Haste, Fortitude, Arcyne Forge, Mending, Mindlink"
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
		/datum/action/cooldown/spell/projectile/arcyne_lance,
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
		/datum/action/cooldown/spell/noc/TAinspiration::name			= /datum/action/cooldown/spell/noc/TAinspiration,
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
		/datum/action/cooldown/spell/noc/TAinspiration::name					= /datum/action/cooldown/spell/noc/TAinspiration,
		/obj/effect/proc_holder/spell/invoked/vendetta::name				= /obj/effect/proc_holder/spell/invoked/vendetta,
	)
