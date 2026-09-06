/datum/intent/simple/vurdalak_claw_base
	name = "claw"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("claws", "mauls", "tears")
	animname = "chop"
	hitsound = "genslash"
	penfactor = PEN_NONE
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"

/datum/intent/simple/vurdalak_claw_ascended
	name = "rending claw"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("eviscerates", "shreds", "rends")
	animname = "chop"
	hitsound = "genslash"
	penfactor = PEN_MEDIUM
	candodge = TRUE
	canparry = TRUE
	item_d_type = "slash"

/obj/item/rogueweapon/werewolf_claw/vurdalak
	name = "Vurdalak Claw"
	desc = "Острые, покрытые болотной гнилью когти вурдалака."
	wdefense = 3
	force = 22
	possible_item_intents = list(/datum/intent/simple/vurdalak_claw_base, /datum/intent/mace/smash/werewolf)

/obj/item/rogueweapon/werewolf_claw/vurdalak/right
	icon_state = "claw_r"

/obj/item/rogueweapon/werewolf_claw/vurdalak/left
	icon_state = "claw_l"

/obj/item/rogueweapon/werewolf_claw/vurdalak/ascended
	name = "Great Vurdalak Claw"
	desc = "Огромные когти вурдалака."
	wdefense = 4
	force = 30
	possible_item_intents = list(/datum/intent/simple/vurdalak_claw_ascended, /datum/intent/mace/smash/werewolf)

/obj/item/rogueweapon/werewolf_claw/vurdalak/ascended/right
	icon_state = "claw_r"

/obj/item/rogueweapon/werewolf_claw/vurdalak/ascended/left
	icon_state = "claw_l"


/obj/effect/dummy/vurdalak_burrow
	name = "underground burrow"
	desc = "Ничего примечательного."
	density = FALSE
	anchored = TRUE
	invisibility = INVISIBILITY_MAXIMUM
	mouse_opacity = 0
	var/mob/living/carbon/human/owner_mob

/obj/effect/dummy/vurdalak_burrow/Initialize(mapload, mob/living/carbon/human/user)
	. = ..()
	owner_mob = user

/obj/effect/dummy/vurdalak_burrow/proc/RelayMove(mob/living/user, direction)
	if(user == owner_mob)
		to_chat(user, span_warning("Вы сидите в засаде под землей!"))

/obj/effect/dummy/vurdalak_burrow/Destroy()
	if(owner_mob && owner_mob.loc == src)
		owner_mob.forceMove(get_turf(src))
		owner_mob.status_flags &= ~GODMODE
	owner_mob = null
	return ..()


/datum/action/cooldown/spell/vurdalak_claws
	name = "Vurdalak Claws"
	desc = "Выпустить или убрать смертоносные когти."
	button_icon_state = "claws"
	cooldown_time = 2 SECONDS
	charge_required = FALSE
	sound = null
	click_to_activate = FALSE
	self_cast_possible = TRUE
	has_visual_effects = FALSE
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	spell_requirements = NONE
	primary_resource_type = SPELL_COST_NONE
	var/list/extended_claw_record = list(FALSE, FALSE)
	var/claw_type = /obj/item/rogueweapon/werewolf_claw/vurdalak

/datum/action/cooldown/spell/vurdalak_claws/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!istype(user))
		return FALSE

	var/list/current_hands = list(FALSE, FALSE)
	current_hands[LEFT_HANDS] = user.get_item_for_held_index(LEFT_HANDS)
	current_hands[RIGHT_HANDS] = user.get_item_for_held_index(RIGHT_HANDS)
	var/extending_claws = FALSE

	if(!(current_hands[LEFT_HANDS] || !user.has_hand_for_held_index(LEFT_HANDS)) || !(current_hands[RIGHT_HANDS] || !user.has_hand_for_held_index(RIGHT_HANDS)))
		extending_claws = TRUE

	for(var/hand_index = 1, hand_index < 3, hand_index++)
		var/current_item = current_hands[hand_index]
		if(extending_claws)
			if(current_hands[hand_index])
				continue
			if(!user.has_hand_for_held_index(hand_index))
				continue
			var/new_claw
			if(hand_index == LEFT_HANDS)
				var/left_claw_path = text2path("[claw_type]/left")
				new_claw = new left_claw_path(user)
				user.put_in_l_hand(new_claw)
				extended_claw_record[LEFT_HANDS] = new_claw
			else
				var/right_claw_path = text2path("[claw_type]/right")
				new_claw = new right_claw_path(user)
				user.put_in_r_hand(new_claw)
				extended_claw_record[RIGHT_HANDS] = new_claw
			RegisterSignal(new_claw, COMSIG_QDELETING, PROC_REF(clear_claw_entry))
			continue

		if(istype(current_item, claw_type))
			user.temporarilyRemoveItemFromInventory(I = current_item, force = TRUE)
			qdel(current_item)
		extended_claw_record[hand_index] = FALSE
	return TRUE

/datum/action/cooldown/spell/vurdalak_claws/proc/clear_claw_entry(datum/source)
	SIGNAL_HANDLER
	var/claw_index = extended_claw_record.Find(source)
	if(claw_index)
		extended_claw_record[claw_index] = FALSE


/datum/action/cooldown/spell/vurdalak_seek_brain
	name = "Seek Brain"
	desc = "Почувствовать присутствие и теплое дыхание живых людей."
	button_icon = 'icons/mob/actions/vurdalak_abilities.dmi'
	button_icon_state = "seek_brain"
	cooldown_time = 30 SECONDS
	charge_required = FALSE
	sound = null
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	spell_requirements = NONE
	has_visual_effects = FALSE
	primary_resource_type = SPELL_COST_NONE

/datum/action/cooldown/spell/vurdalak_seek_brain/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	var/mob/living/nearest_player = null
	var/best_dist = 9999

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H == user || H.stat == DEAD || !H.client || !H.mind)
			continue
		var/dist = get_dist(user, H)
		if(dist < best_dist)
			best_dist = dist
			nearest_player = H

	if(!nearest_player)
		to_chat(user, span_warning("Вы не чувствуете тепла... Поблизости нет живых людей."))
		return TRUE

	var/dir_text = dir2text(get_dir(user, nearest_player))
	var/dist_text = ""
	if(best_dist <= 5)
		dist_text = "совсем близко"
	else if(best_dist <= 15)
		dist_text = "неподалеку"
	else if(best_dist <= 30)
		dist_text = "на среднем расстоянии"
	else
		dist_text = "очень далеко"

	to_chat(user, span_notice("Вы чувствуете биение сердца к [dir_text], [dist_text]..."))
	user.playsound_local(get_turf(user), 'sound/vo/mobs/vurdalak/vurdalak_breath1.ogg', 50, TRUE)
	return TRUE


/datum/action/cooldown/spell/vurdalak_ambush
	name = "Ambush"
	desc = "Зарыться в мягкую почву на месте, оставив яму."
	button_icon = 'icons/mob/actions/vurdalak_abilities.dmi'
	button_icon_state = "ambush"
	cooldown_time = 45 SECONDS
	charge_required = FALSE
	sound = null
	self_cast_possible = TRUE
	cast_range = 0
	has_visual_effects = FALSE
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	spell_requirements = NONE
	primary_resource_type = SPELL_COST_NONE
	var/is_burrowed = FALSE
	var/forced_unburrow = FALSE
	var/turf/origin_turf
	var/obj/effect/dummy/vurdalak_burrow/burrow_dummy
	var/obj/structure/vurdalak_ambush_mound/ambush_mound

	var/static/list/allowed_ambush_turfs = typecacheof(list(
		/turf/open/floor/rogue/dirt,
		/turf/open/floor/rogue/dirt/road,
		/turf/open/floor/rogue/grasspurple,
		/turf/open/floor/rogue/grass,
		/turf/open/floor/rogue/grassgrey,
		/turf/open/floor/rogue/grassyel,
		/turf/open/floor/rogue/grassred,
		/turf/open/floor/rogue/grasscold,
		/turf/open/floor/rogue/AzureSand,
		/turf/open/floor/rogue/snow,
		/turf/open/floor/rogue/snowrough
	))

/datum/action/cooldown/spell/vurdalak_ambush/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return .

	if(!is_burrowed)
		var/mob/living/carbon/human/user = owner
		var/turf/T = get_turf(user)
		if(!is_type_in_typecache(T, allowed_ambush_turfs))
			if(user)
				to_chat(user, span_warning("Вы можете зарываться только в мягкую почву, грязь, траву или снег!"))
			return . | SPELL_CANCEL_CAST

		return . | SPELL_NO_IMMEDIATE_COOLDOWN
	else
		var/turf/target_turf = get_turf(cast_on)
		if(origin_turf && target_turf && get_dist(target_turf, origin_turf) > 1)
			if(owner)
				to_chat(owner, span_warning("Слишком далеко!"))
			return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/vurdalak_ambush/cast(atom/cast_on)
	var/mob/living/carbon/human/user = owner
	if(!istype(user))
		return FALSE

	if(!is_burrowed)
		to_chat(user, span_notice("Вы начинаете с яростью разрывать землю под собой..."))
		user.visible_message(span_warning("[user] начинает лихорадочно зарываться в землю!"))

		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("Закапывание прервано!"))
			return FALSE

		origin_turf = get_turf(user)
		if(!origin_turf)
			return FALSE

		. = ..()
		is_burrowed = TRUE

		self_cast_possible = FALSE
		cast_range = 1
		name = "Emerge"
		desc = "Повторный клик чтобы выскочить из ямы."
		build_all_button_icons()

		new /obj/structure/closet/dirthole(origin_turf)
		ambush_mound = new /obj/structure/vurdalak_ambush_mound(origin_turf, user, src)
		playsound(origin_turf, 'sound/items/dig_shovel.ogg', 100, TRUE)

		user.visible_message(
			span_warning("[user] уходит глубоко под землю, оставляя за собой разрытую яму!"),
			span_boldnotice("Вы закопались под землю!")
		)

		burrow_dummy = new /obj/effect/dummy/vurdalak_burrow(origin_turf, user)
		user.forceMove(burrow_dummy)
		user.status_flags |= GODMODE

		set_click_ability(user)
		return TRUE

	else
		var/turf/destination = get_turf(cast_on)
		if(!destination)
			return FALSE

		. = ..()
		is_burrowed = FALSE

		self_cast_possible = TRUE
		cast_range = 0
		name = "Ambush"
		desc = initial(desc)
		build_all_button_icons()

		user.forceMove(destination)
		user.status_flags &= ~GODMODE
		QDEL_NULL(burrow_dummy)
		QDEL_NULL(ambush_mound)

		new /obj/structure/closet/dirthole(destination)

		playsound(destination, 'sound/foley/breaksound.ogg', 100, TRUE)


		if(!forced_unburrow)
			playsound(destination, 'sound/vo/mobs/vurdalak/vurdalak_ambush.ogg', 100, FALSE)
			user.visible_message(
				span_userdanger("[user] с диким ревом вырывается из-под земли, разрывая почву!"),
				span_boldnotice("Вы выпрыгиваете из-под земли, ошеломляя всех вокруг!")
			)

			for(var/mob/living/L in range(3, destination))
				if(L == user || L.stat == DEAD)
					continue
				to_chat(L, span_userdanger("Внезапный прорыв вурдалака из-под земли сбивает вас с ног и повергает в шок!"))
				L.emote("gasp")
				L.apply_status_effect(/datum/status_effect/debuff/exposed, 4 SECONDS)
				L.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)
				L.Knockdown(30)


		else
			user.visible_message(
				span_warning("[user] вываливается на поверхность из разрушенной ямы!"),
				span_warning("Ваше укрытие разрушено! Вас насильно выбросило на поверхность!")
			)

		origin_turf = null
		return TRUE

/datum/action/cooldown/spell/vurdalak_ambush/proc/forced_emerge(mob/living/carbon/human/user)
	if(!is_burrowed)
		return
	var/turf/dest = burrow_dummy ? get_turf(burrow_dummy) : get_turf(user)
	forced_unburrow = TRUE
	cast(dest)
	forced_unburrow = FALSE

/datum/action/cooldown/spell/vurdalak_devour
	name = "Devour Lux"
	desc = "Вытянуть частичку души из трупа."
	button_icon = 'icons/mob/actions/vurdalak_abilities.dmi'
	button_icon_state = "devour_lux"
	cooldown_time = 1 MINUTES
	charge_required = FALSE
	sound = null
	self_cast_possible = FALSE
	cast_range = 1
	has_visual_effects = FALSE
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	spell_requirements = NONE
	primary_resource_type = SPELL_COST_NONE

/datum/action/cooldown/spell/vurdalak_devour/cast(atom/cast_on)
	var/mob/living/carbon/human/user = owner
	var/mob/living/carbon/human/target = cast_on

	if(isturf(cast_on))
		target = locate(/mob/living/carbon/human) in cast_on

	if(!isliving(target) || target == user || target.stat != DEAD)
		to_chat(user, span_warning("Вы можете грызть только мертвые тела!"))
		return FALSE

	if(!target.mind)
		to_chat(user, span_warning("Люкс слишком мал в этом теле!"))
		return FALSE

	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/skeleton))
		to_chat(user, span_warning("Это скелет, в нем не может быть частички души!"))
		return FALSE

	if(target.has_status_effect(/datum/status_effect/debuff/devitalised) || target.has_status_effect(/datum/status_effect/debuff/ritualdefiled/cult))
		to_chat(user, span_warning("Люкс этого трупа уже выпит!"))
		return FALSE

	. = ..()
	INVOKE_ASYNC(src, PROC_REF(extract_lux_sequence), user, target)
	return TRUE

/datum/action/cooldown/spell/vurdalak_devour/proc/extract_lux_sequence(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!istype(user) || !istype(target))
		return

	to_chat(user, span_notice("Вы вонзаете когти в грудь трупа [target] и начинаете с жадностью пожирать вытекающий сгусток Люкса..."))
	user.visible_message(span_danger("[user] вонзает когти в грудь трупа [target] и начинает пожирать часть Люкса!"))

	var/sound_timer = addtimer(CALLBACK(src, PROC_REF(play_devour_sound_loop), user, target), 2 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)

	var/success = do_after(user, 60 SECONDS, target = target)
	deltimer(sound_timer)

	if(!success)
		to_chat(user, span_warning("Пожирание Люкса прервано!"))
		return

	if(QDELETED(target) || !user.Adjacent(target))
		return

	target.Stun(30)
	target.Knockdown(30)

	target.apply_status_effect(/datum/status_effect/debuff/devitalised)

	playsound(user, 'sound/surgery/organ2.ogg', 100, TRUE)

	user.STASTR += 1
	user.STACON += 1
	user.STASPD += 1
	user.STAWIL += 1
	user.STAPER += 1
	user.STAINT += 1
	user.STALUC += 1

	user.vurdalak_corpses_devoured += 1
	user.meat_lux_charge = TRUE

	to_chat(user, span_boldnotice("Вы успешно выпили Люкс трупа!"))

	user.check_vurdalak_ascension()

/datum/action/cooldown/spell/vurdalak_devour/proc/play_devour_sound_loop(mob/living/user, mob/living/target)
	if(QDELETED(user) || QDELETED(target) || user.stat != CONSCIOUS)
		return
	playsound(user, pick('sound/surgery/organ1.ogg', 'sound/surgery/organ2.ogg'), 70, TRUE)


/datum/action/cooldown/spell/vurdalak_gnaw
	name = "Gnaw Corpse"
	desc = "Погрызть труп существа, чтобы получить ускоренную регенерацию."
	button_icon = 'icons/mob/actions/vurdalak_abilities.dmi'
	button_icon_state = "gnaw_corpse"
	cooldown_time = 120 SECONDS
	charge_required = FALSE
	sound = null
	self_cast_possible = FALSE
	cast_range = 1
	has_visual_effects = FALSE
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	spell_requirements = NONE
	primary_resource_type = SPELL_COST_NONE

/datum/action/cooldown/spell/vurdalak_gnaw/cast(atom/cast_on)
	var/mob/living/target = cast_on
	var/mob/living/carbon/human/user = owner

	if(!isliving(target) || target == user || target.stat != DEAD)
		to_chat(user, span_warning("Вы можете грызть только мертвые тела!"))
		return FALSE

	. = ..()
	INVOKE_ASYNC(src, PROC_REF(gnaw_sequence), user, target)
	return TRUE

/datum/action/cooldown/spell/vurdalak_gnaw/proc/gnaw_sequence(mob/living/carbon/human/user, mob/living/target)
	if(!istype(user) || !isliving(target))
		return

	to_chat(user, span_notice("Вы впиваетесь зубами в труп [target] и с чавканьем обгладываете его кости..."))
	user.visible_message(span_danger("[user] жадно грызет мертвые останки [target]!"))

	if(!do_after(user, 4 SECONDS, target = target))
		to_chat(user, span_warning("Вы отвлеклись от грызни!"))
		return

	playsound(user, 'sound/surgery/organ1.ogg', 80, TRUE)

	user.heal_bodypart_damage(40, 40)
	user.apply_status_effect(/datum/status_effect/buff/healing, 20)

	if(user.skin_armor)
		user.skin_armor.obj_integrity = min(user.skin_armor.max_integrity, user.skin_armor.obj_integrity + 60)
		user.update_inv_armor_special()

	user.apply_status_effect(/datum/status_effect/buff/vurdalak_flesh_regen)
	to_chat(user, span_boldnotice("Вы насытились сырой плотью! Раны и шкура восстановлены, а регенерация ускорена."))

/datum/status_effect/buff/vurdalak_flesh_regen/tick(delta_time)
	var/heal_amount = 3
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.vurdalak_ascended)
			heal_amount = 6
		H.heal_bodypart_damage(heal_amount, heal_amount)


/datum/status_effect/buff/vurdalak_flesh_regen
	id = "vurdalak_flesh_regen"
	duration = 60 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/vurdalak_flesh_regen

/datum/status_effect/buff/vurdalak_flesh_regen/tick(delta_time)
	var/heal_amount = -1.5
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(H.vurdalak_ascended)
			heal_amount = -3.0
	owner.adjustBruteLoss(heal_amount)
	owner.adjustFireLoss(heal_amount)

/atom/movable/screen/alert/status_effect/buff/vurdalak_flesh_regen
	name = "Flesh Regeneration"
	desc = "Ваши раны быстро затягиваются от поглощенной сырой плоти."
	icon_state = "buff"


/datum/action/cooldown/spell/vurdalak_roar
	name = "Berserker Roar"
	desc = "Издать исступленный рев."
	button_icon = 'icons/mob/actions/vurdalak_abilities.dmi'
	button_icon_state = "rage"
	cooldown_time = 6 MINUTES
	charge_required = FALSE
	sound = null
	has_visual_effects = FALSE
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	spell_requirements = NONE
	primary_resource_type = SPELL_COST_NONE

/datum/action/cooldown/spell/vurdalak_roar/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!istype(user))
		return FALSE

	playsound(user, 'sound/vo/mobs/vurdalak/vurdalak_rage.ogg', 100, FALSE)
	user.visible_message(span_userdanger("[user] издает оглушительный рев ярости, наводящий ужас на окрестности!"))

	user.setStaminaLoss(0)
	user.apply_status_effect(/datum/status_effect/buff/adrenaline_rush)
	user.SetKnockdown(0)
	user.SetStun(0)
	user.SetUnconscious(0)
	user.SetImmobilized(0)
	user.SetParalyzed(0)
	user.resting = FALSE
	user.update_mobility()

	return TRUE


/datum/action/cooldown/spell/vurdalak_raise_kin
	name = "Animate Corpse"
	desc = "Направить проклятый Люкс в открытую яму, прикопать ее и вырастить нового вурдалака."
	button_icon = 'icons/mob/actions/vurdalak_abilities.dmi'
	button_icon_state = "reanimate"
	cooldown_time = 20 MINUTES
	charge_required = FALSE
	sound = null
	self_cast_possible = FALSE
	cast_range = 1
	has_visual_effects = FALSE
	spell_flags = SPELL_IGNORE_SPELLBLOCK
	spell_requirements = NONE
	primary_resource_type = SPELL_COST_NONE

/datum/action/cooldown/spell/vurdalak_raise_kin/cast(atom/cast_on)
	var/obj/structure/closet/dirthole/D = cast_on
	var/mob/living/carbon/human/user = owner

	if(!istype(D) || (!D.opened && D.stage == 4))
		to_chat(user, span_warning("Вам нужна открытая яма или разлом!"))
		return FALSE

	if(!user.meat_lux_charge)
		to_chat(user, span_warning("У вас нет заряда Люкса!"))
		return FALSE

	. = ..()

	user.meat_lux_charge = FALSE

	var/turf/T = get_turf(D)
	qdel(D)
	var/obj/structure/vurdalak_ambush_mound/M = new /obj/structure/vurdalak_ambush_mound(T, user, null)
	M.vurdalak_animated = TRUE
	M.vurdalak_slot_ready = FALSE
	GLOB.vurdalak_animated_graves |= M

	playsound(T, 'sound/items/empty_shovel.ogg', 100, TRUE)

	to_chat(user, span_boldnotice("Вы заливаете Люкс в яму и заравниваете её рыхлым холмиком земли."))
	user.visible_message(span_danger("[user] заливает черную болотную жижу в яму и заравнивает ее рыхлой землей!"))

	M.timer_id_vurdalak = addtimer(CALLBACK(M, TYPE_PROC_REF(/obj/structure/vurdalak_ambush_mound, activate_vurdalak_slot)), 90 SECONDS, TIMER_STOPPABLE)
	return TRUE
