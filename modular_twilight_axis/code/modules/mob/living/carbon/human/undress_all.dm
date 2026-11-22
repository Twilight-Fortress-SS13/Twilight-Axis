// Модульная фича: IC-verb "Undress All" - снять с себя всё надетое и уронить под себя.
// Не изменяет оригинальные файлы. Подключается одной строкой #include в roguetown.dme.

#define UNDRESS_ALL_MIN_DELAY (5) // децисекунды: нижняя граница задержки на предмет (0.5 сек)

/mob/living/carbon/human
	/// TRUE, пока идёт процесс раздевания (защита от повторного запуска)
	var/tmp/undress_all_active = FALSE

/// Проверка, может ли персонаж сейчас раздеваться. Возвращает FALSE и пишет причину, если нет.
/mob/living/carbon/human/proc/can_undress_all(silent = FALSE)
	if(QDELETED(src))
		return FALSE
	if(stat != CONSCIOUS)
		if(!silent)
			to_chat(src, span_warning("I can't undress right now."))
		return FALSE
	if(IsUnconscious() || IsStun() || IsParalyzed() || IsKnockdown())
		if(!silent)
			to_chat(src, span_warning("I can't undress while stunned or incapacitated!"))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_CHUNKYFINGERS)) // как в ручном снятии: "Zombie fingers don't take things off"
		if(!silent)
			to_chat(src, span_warning("My fingers can't take things off!"))
		return FALSE
	if(handcuffed || restrained() || HAS_TRAIT(src, TRAIT_RESTRAINED) || HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		if(!silent)
			to_chat(src, span_warning("My hands are bound, I can't undress!"))
		return FALSE
	return TRUE

/// Время снятия предмета с себя в децисекундах - ровно как при ручном снятии
/// (modular/code/game/objects/items/items.dm: /obj/item/MouseDrop и allow_attack_hand_drop):
/// unequip_delay_self - STASPD, но не меньше UNDRESS_ALL_MIN_DELAY.
/mob/living/carbon/human/proc/get_undress_all_delay(obj/item/I)
	if(!I.unequip_delay_self)
		return UNDRESS_ALL_MIN_DELAY
	return max(UNDRESS_ALL_MIN_DELAY, I.unequip_delay_self - STASPD)

/// Список предметов, которые теоретически можно снять прямо сейчас (внешние слои идут первыми).
/mob/living/carbon/human/proc/get_undress_all_items()
	var/list/result = list()
	var/list/candidates = list(
		cloak,
		wear_armor,
		wear_shirt,
		wear_pants,
		gloves,
		shoes,
		wear_wrists,
		wear_ring,
		head,
		wear_mask,
		wear_neck,
		glasses,
		ears,
		backr,
		backl,
		back,
		beltr,
		beltl,
		belt,
		s_store,
		l_store,
		r_store,
		mouth,
	)
	for(var/obj/item/I in candidates)
		if(I == handcuffed || I == legcuffed)
			continue
		if(I.item_flags & ABSTRACT)
			continue
		if(I.loc != src)
			continue
		if(HAS_TRAIT(I, TRAIT_NODROP))
			continue
		if(!I.allow_self_unequip) // "I need help taking this off!"
			continue
		if(!canUnEquip(I))
			continue
		result |= I
	return result

/mob/living/carbon/human/verb/undress_all()
	set name = "Undress All"
	set category = "IC"
	set desc = "Take off everything I'm wearing and drop it on the floor beneath me. Moving interrupts it."
	set hidden = FALSE

	if(undress_all_active)
		to_chat(src, span_warning("I'm already undressing."))
		return
	if(!can_undress_all())
		return
	if(!length(get_undress_all_items()))
		to_chat(src, span_warning("I have nothing I can take off."))
		return

	undress_all_active = TRUE
	visible_message(span_notice("[src] starts undressing."), span_notice("I start undressing. (Moving will stop me.)"))

	var/removed = 0
	var/interrupted = FALSE
	while(TRUE)
		if(QDELETED(src))
			return
		if(!can_undress_all(silent = TRUE))
			interrupted = TRUE
			break
		var/list/items = get_undress_all_items()
		if(!length(items))
			break
		var/obj/item/I = items[1]
		var/delay = get_undress_all_delay(I)
		if(delay >= 10)
			visible_message(span_smallnotice("[src] starts taking off [I]..."), span_smallnotice("I start taking off [I]..."))
		// Всегда do_after (не move_after, как у предметов с edelay_type): движение должно прерывать раздевание.
		if(!do_after(src, delay, needhand = FALSE, target = null, progress = FALSE))
			interrupted = TRUE
			break
		// Состояние могло измениться за время ожидания.
		if(!can_undress_all(silent = TRUE) || QDELETED(I) || I.loc != src || !canUnEquip(I))
			interrupted = TRUE
			break
		if(dropItemToGround(I, force = FALSE, silent = FALSE))
			removed++
		else
			// Не снялось - не зацикливаемся
			interrupted = TRUE
			break

	undress_all_active = FALSE
	if(QDELETED(src))
		return
	if(interrupted)
		to_chat(src, span_warning("I stop undressing."))
	if(removed)
		visible_message(span_notice("[src] finishes undressing."), span_notice("I take off [removed] item\s."))

#undef UNDRESS_ALL_MIN_DELAY
