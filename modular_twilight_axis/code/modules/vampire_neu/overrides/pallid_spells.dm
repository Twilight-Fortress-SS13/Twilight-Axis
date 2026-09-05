/// Returns TRUE if two z-levels belong to the same map (connected via multiz UP/DOWN chain)
/proc/are_z_levels_same_map(z1, z2)
	if(z1 == z2)
		return TRUE

	var/list/checked = list(z1)
	var/list/queue = list(z1)

	while(length(queue))
		var/current_z = queue[1]
		queue.Cut(1, 2)

		if(current_z < 1 || current_z > SSmapping.multiz_levels.len)
			continue
		var/list/links = SSmapping.multiz_levels[current_z]
		if(!links)
			continue

		if(links[Z_LEVEL_UP])
			var/z_up = current_z + 1
			if(z_up == z2)
				return TRUE
			if(!(z_up in checked))
				checked += z_up
				queue += z_up

		if(links[Z_LEVEL_DOWN])
			var/z_down = current_z - 1
			if(z_down == z2)
				return TRUE
			if(!(z_down in checked))
				checked += z_down
				queue += z_down

	return FALSE

/// VAMPIRE SPELL: Track all pallid victims (those who refused conversion and got TRAIT_PALLID from this vampire)
/obj/effect/proc_holder/spell/self/pallid_track
	name = "Резонанс Крови"
	desc = "Почувствовать направление к тем, кто несёт вашу проклятую метку."
	recharge_time = 30 SECONDS
	overlay_icon = 'icons/mob/actions/vampspells.dmi'
	action_icon = 'icons/mob/actions/vampspells.dmi'
	overlay_state = "yourbloodismine"
	action_icon_state = "yourbloodismine"
	invocation_type = "emote"
	invocation_emote_self = span_notice("Я закрываю глаза и тянусь к отмеченным...")
	human_req = TRUE
	clothes_req = FALSE

/obj/effect/proc_holder/spell/self/pallid_track/cast(mob/living/carbon/human/user)
	var/my_ref = REF(user)
	var/list/targets = list()

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H == user || H.stat == DEAD || QDELETED(H))
			continue
		if(HAS_TRAIT_FROM(H, TRAIT_PALLID, my_ref))
			targets[H.real_name] = H

	if(!length(targets))
		to_chat(user, span_warning("Я не чувствую отмеченных душ в этом мире."))
		return

	var/selection = input(user, "К чьей крови мне потянуться?", "Резонанс Крови") as null|anything in sort_list(targets)
	if(!selection)
		return

	var/mob/living/carbon/human/victim = targets[selection]
	if(!victim || QDELETED(victim) || victim.stat == DEAD)
		to_chat(user, span_warning("Метка угасла..."))
		return

	var/turf/user_turf = get_turf(user)
	var/turf/victim_turf = get_turf(victim)

	if(!are_z_levels_same_map(user_turf.z, victim_turf.z))
		to_chat(user, span_warning("Цель слишком далеко..."))
		return

	if(user_turf.z != victim_turf.z)
		to_chat(user, span_notice("Скверна [victim.real_name] пульсирует [user_turf.z > victim_turf.z ? "снизу" : "сверху"]."))
		return

	var/dist = get_dist(user, victim)
	var/dir_text = dir2text(get_dir(user, victim))

	if(dist <= 1)
		to_chat(user, span_boldnotice("[victim.real_name] прямо здесь!"))
	else if(dist < 15)
		to_chat(user, span_notice("Кровь [victim.real_name] зовёт на [dir_text]. Совсем близко."))
	else
		to_chat(user, span_notice("Слабый пульс от [victim.real_name] на [dir_text]."))

/// VICTIM SPELL: Sense the direction of the vampire who marked you (10 min cooldown)
/obj/effect/proc_holder/spell/self/pallid_sense
	name = "Проклятая Интуиция"
	desc = "Скверна в крови шепчет направление к тому, кто вас отметил."
	recharge_time = 3 MINUTES
	overlay_icon = 'icons/mob/actions/vampspells.dmi'
	action_icon = 'icons/mob/actions/vampspells.dmi'
	overlay_state = "yourbloodismine"
	action_icon_state = "yourbloodismine"
	invocation_type = "emote"
	invocation_emote_self = span_notice("Я чувствую, как проклятие шевелится внутри меня...")
	human_req = TRUE
	clothes_req = FALSE
	var/mob/living/carbon/human/sire = null

/obj/effect/proc_holder/spell/self/pallid_sense/Initialize(mapload, mob/living/carbon/human/linked_sire)
	. = ..()
	sire = linked_sire

/obj/effect/proc_holder/spell/self/pallid_sense/cast(mob/living/carbon/human/user)
	if(!sire || QDELETED(sire) || sire.stat == DEAD)
		to_chat(user, span_warning("Присутствие, отметившее меня, исчезло из этого мира..."))
		return

	var/turf/user_turf = get_turf(user)
	var/turf/sire_turf = get_turf(sire)

	if(!are_z_levels_same_map(user_turf.z, sire_turf.z))
		to_chat(user, span_warning("Цель слишком далеко..."))
		return

	var/dist = get_dist(user, sire)
	var/dir_text = dir2text(get_dir(user, sire))

	if(user_turf.z != sire_turf.z)
		to_chat(user, span_warning("Леденящий страх тянет меня [user_turf.z > sire_turf.z ? "вниз" : "вверх"]... Тварь СЛИШКОМ далеко."))
	else if(dist <= 1)
		to_chat(user, span_userdanger("Чудовище прямо здесь!"))
	else if(dist < 15)
		to_chat(user, span_warning("Леденящий страх тянет меня на [dir_text]. Тварь рядом."))
	else
		to_chat(user, span_notice("Слабая тревога тянет меня на [dir_text]."))
