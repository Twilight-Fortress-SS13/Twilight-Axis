/obj/effect/proc_holder/spell/self/noctite_fortify
	name = "Arcane Armor"
	desc = "Неся свет Нок в себе, он вас защищает. Вы становитесь крепче под лунным светом, но Астрата мешает вам, поэтому под её светом вы не можете использовать это."
	recharge_time = 10 MINUTES
	action_icon_state = "summons"
	action_icon = 'icons/mob/actions/roguespells.dmi'
	invocation_type = "none"

/obj/effect/proc_holder/spell/self/noctite_fortify/cast_check(skipcharge, mob/user = usr)
	if(GLOB.tod == "day")
		to_chat(usr, "Я не могу сделать это днем.")
		return 
	return ..()

/obj/effect/proc_holder/spell/self/noctite_fortify/cast(list/targets,mob/living/carbon/human/user = usr)
	user.apply_status_effect(/datum/status_effect/noctite_fortify)

/particles/noctite_fortify
	icon = 'icons/effects/particles/generic.dmi'
	icon_state = list("dot" = 8,"curl" = 1)
	width = 64
	height = 96
	color = 0
	color_change = 0.05
	count = 400
	spawning = 50
	gradient = list("#375f8d", "#bac6ff", "#a29bb9", "#3b455a")
	lifespan = 1.5 SECONDS
	fade = 1 SECONDS
	fadein = 0.1 SECONDS
	grow = -0.1
	velocity = generator("box", list(-3, -0.7), list(3,3), NORMAL_RAND)
	position = generator("sphere", 8, 8, LINEAR_RAND)
	scale = generator("vector", list(2, 2), list(4,4), NORMAL_RAND)
	drift = list(0)


/atom/movable/screen/alert/status_effect/buff/noctite_fortify
	name = "Укрепление света Нок"
	desc = "Нок благославила вас, дав вам защиту"
	icon_state = "status"

/datum/status_effect/noctite_fortify
	id = "noctite_fortify"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/noctite_fortify

/datum/status_effect/noctite_fortify/on_apply()
	effectedstats = list("constitution" = 3, "willpower" = 3)
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, NOCTITE_SPELLBLADE_TRAIT)
	ADD_TRAIT(owner, TRAIT_GRABIMMUNE, NOCTITE_SPELLBLADE_TRAIT)
	owner.particles = new /particles/noctite_fortify()
	. = ..()

/datum/status_effect/noctite_fortify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, NOCTITE_SPELLBLADE_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_GRABIMMUNE, NOCTITE_SPELLBLADE_TRAIT)
	qdel(owner.particles)
	owner.particles = null
	. = ..()

/obj/effect/proc_holder/spell/targeted/spellblade_select_weapon
	name = "Chose moonlight weapon"
	desc = "Вы на мгновение погружаетесь в мир снов, чтобы выбрать в нем подходящее для вас оружие."
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	recharge_time = 0.5 SECONDS
	chargedloop = /datum/looping_sound/invokegen
	action_icon = 'modular_twilight_axis/church_classes/icons/ui.dmi'
	action_icon_state = "select_weapon"
	overlay_state = "select_weapon"
	overlay_icon = 'modular_twilight_axis/church_classes/icons/ui.dmi'
	invocation_type = "none"
	spell_tier = 2 
	cost = 1
	var/obj/item/rogueweapon/selected_weapon = /obj/item/rogueweapon/sword/sabre/moonlight_sabre
	var/obj/effect/proc_holder/spell/invoked/spellblade_summon_weapon/summon_weapon

/obj/effect/proc_holder/spell/invoked/spellblade_summon_weapon
	name = "Summon moonlight weapon"
	desc = "Свет Нок прознает реальность приобретая твердую нестабильную форму образуя в нем выбранное оружие. Астрата противится этому, поэтому лучше сотворять под светом Нок."
	clothes_req = FALSE
	recharge_time = 2 SECONDS
	chargedloop = /datum/looping_sound/invokegen
	action_icon_state = "summon"
	overlay_state = "moonlight_saber"
	overlay_icon = 'modular_twilight_axis/church_classes/icons/prismatic_weapons64.dmi'
	invocations = list("Нок, одари меня оружием", "Свет Нок, сотвори мне оружие")
	invocation_type = "shout"
	spell_tier = 2 
	cost = 10 
	var/obj/effect/proc_holder/spell/targeted/spellblade_select_weapon/weapon_select

/obj/effect/proc_holder/spell/invoked/spellblade_summon_weapon/cast(list/targets, mob/user)
	. = ..()
	var/obj/effect/noctite_select_weapon/select_weapon_anim  = new /obj/effect/noctite_select_weapon(get_turf(user))
	select_weapon_anim.icon_state = weapon_select.selected_weapon.icon_state
	playsound(get_turf(user), 'modular_twilight_axis/church_classes/sound/summon_sfx.ogg', 100, FALSE)
	var/obj/item/rogueweapon/spawned_weapon = new weapon_select.selected_weapon

	if(hasvar(spawned_weapon, "owner"))
		spawned_weapon.vars["owner"] = user

	sleep(0.75 SECONDS)
	if(user.put_in_hands(spawned_weapon, del_on_fail = TRUE))
		if(GLOB.tod == "day")
			to_chat(usr, span_warningbig("Я сотворил оружие и Нок одарила меня знаниями к нему. Свет Астраты противится этому, поэтому оружие и мои навыки слабее"))
			user.adjust_skillrank(weapon_select.selected_weapon.associated_skill, SKILL_LEVEL_APPRENTICE, TRUE)
			spawned_weapon.force /= 2
		else 
			to_chat(usr, span_warning("Я сотворил оружие и Нок одарила меня знаниями к нему."))
			user.adjust_skillrank(weapon_select.selected_weapon.associated_skill, SKILL_LEVEL_EXPERT, TRUE)
		spawned_weapon.set_light(4, 2, 1.5, l_color ="#78a3c9")
		QDEL_IN_CLIENT_TIME(spawned_weapon, 3 MINUTES)
	else 
		to_chat(usr, span_warningbig("Что-то мешает мне применить это."))

/obj/effect/proc_holder/spell/targeted/spellblade_select_weapon/cast(list/targets, mob/user)
	. = ..()
	var/list/weapons_of_choice = list(
		"Moonlight Sabre",
		"Moonlight Rapier",
		"Moonlight Spear",
		"Moonlight Hammer",
		"Moonlight Shield",
	)
	var/chosed_weapon = tgui_input_list(user, "Немногое из того что хранится в мире снов.", "ВЫБОР ОРУЖИЯ", weapons_of_choice)
	if(chosed_weapon)
		switch(chosed_weapon)
			if("Moonlight Sabre")
				selected_weapon = /obj/item/rogueweapon/sword/sabre/moonlight_sabre

			if("Moonlight Rapier")
				selected_weapon = /obj/item/rogueweapon/sword/rapier/moonlight_rapier

			if("Moonlight Spear")
				selected_weapon = /obj/item/rogueweapon/spear/partizan/moonlight_spear

			if("Moonlight Hammer")
				selected_weapon = /obj/item/rogueweapon/mace/maul/grand/moonlight_hammer

			if("Moonlight Shield")
				selected_weapon = /obj/item/rogueweapon/shield/bronze/great/moonlight_shield
			
		summon_weapon.overlay_icon = selected_weapon.icon
		summon_weapon.overlay_state = selected_weapon.icon_state
		return TRUE

	return FALSE
