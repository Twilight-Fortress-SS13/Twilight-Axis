/obj/item/philosophers_stone
	name = "Great Philosopher's Stone"
	desc = "A pulsating, blood-red gem. It feels warm, almost like it has a pulse of its own."
	icon = 'modular_twilight_axis/code/modules/roguetown/roguecrafting/alchemy/master_alchemy/alch.dmi'
	icon_state = "soulstone"
	
	var/charges = 0
	var/max_charges = 200
	var/mob/living/carbon/human/bound_soul = null 

/obj/item/philosophers_stone/Destroy()
	if(bound_soul && !QDELETED(bound_soul))
		REMOVE_TRAIT(bound_soul, TRAIT_PHILOSOPHER_BOUND, src)
	return ..()

/obj/item/philosophers_stone/attack_self(mob/living/carbon/human/user)
	if(!istype(user)) return
	
	if(bound_soul)
		to_chat(user, span_warning(bound_soul == user ? "Ваши души уже переплетены." : "Этот камень уже поглотил чужую жизнь."))
		return

	if(HAS_TRAIT(user, TRAIT_PHILOSOPHER_BOUND))
		to_chat(user, span_warning("Ваша душа уже переплетена с другим артефактом!"))
		return

	user.visible_message(span_danger("[user] прижимает камень к груди!"), \
						span_notice("Вы чувствуете, как вся ваша жизненная суть втягивается в бездонную пустоту камня..."))
	
	if(do_after(user, 50, target = src))
		if(HAS_TRAIT(user, TRAIT_PHILOSOPHER_BOUND) || bound_soul) return

		bound_soul = user
		charges = max_charges
		
		ADD_TRAIT(user, TRAIT_DNR, src)
		ADD_TRAIT(user, TRAIT_PHILOSOPHER_BOUND, src)

		playsound(src, 'sound/magic/lightning.ogg', 100, TRUE)
		to_chat(user, span_userdanger("КОНТРАКТ ПОДПИСАН. Камень наполнился вашей жизнью. Каждое использование теперь приближает ваш конец..."))
		update_icon()

/obj/item/philosophers_stone/proc/consume_soul()
	if(!bound_soul || QDELETED(bound_soul)) return
	
	var/mob/living/carbon/human/victim = bound_soul
	victim.visible_message(span_userdanger("Тело [victim] мгновенно бледнеет!"))
	
	to_chat(victim, span_userdanger("ВЫ ИСЧЕРПАЛИ СЕБЯ. КАМЕНЬ ПОГЛОТИЛ ПОСЛЕДНЮЮ КАПЛЮ ВАШЕЙ СУТИ!"))

	playsound(src, 'sound/magic/lightning.ogg', 100, TRUE)
	
	victim.death()

	qdel(src)

/obj/item/philosophers_stone/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/reagent_containers/lux))
		
		if(user != bound_soul)
			to_chat(user, span_warning("Камень отвергает подношение. Вы не его хозяин."))
			return TRUE

		if(charges >= max_charges)
			to_chat(user, span_warning("Камень уже переполнен душами."))
			return TRUE

		user.visible_message(span_danger("[user] скармливает [I.name] Философскому Камню!"), \
							span_notice("Камень жадно поглощает чужую эссенцию жизни..."))
		
		charges = min(charges + 50, max_charges)
		
		playsound(src, 'sound/magic/bloodheal.ogg', 50, TRUE) 
		
		qdel(I)
		update_icon()
		return TRUE
		
	return ..()

/obj/item/philosophers_stone/examine(mob/user)
	. = ..()
	
	if(user == bound_soul)
		. += span_notice("Связь с вашей душой позволяет вам ощущать энергию: <b>[charges]/[max_charges]</b> зарядов.")
	
	if(bound_soul)
		. += span_info("Вы чувствуете, что он привязан к душе [bound_soul.name].")
	else
		. += span_info("Этот артефакт еще не нашел своего хозяина.")

/obj/item/philosophers_stone/attack(mob/living/carbon/target, mob/living/carbon/human/user)
	if(user != bound_soul)
		return ..()

	if(target.stat != DEAD)
		to_chat(user, span_warning("Камень не реагирует на живых. Его сила пробуждается только перед лицом смерти."))
		return TRUE

	if(charges < 50)
		to_chat(user, span_warning("В камне недостаточно энергии (нужно 50 за.)."))
		return TRUE

	if(!target.mind)
		to_chat(user, span_warning("В этом теле больше нет искры разума..."))
		return TRUE

	var/mob/dead/observer/ghost = null
	var/has_soul = FALSE
	
	if(target.client)
		has_soul = TRUE
		to_chat(target, span_ghostalert("<b>АЛОЕ СИЯНИЕ ЗОВЕТ ВАС!</b> Кто-то использует могущественную алхимию на вашем теле!"))
		playsound(target, 'sound/magic/ahh1.ogg', 100, FALSE)
		
	else
		ghost = target.mind.get_ghost(even_if_they_cant_reenter = TRUE, ghosts_with_clients = TRUE)
		if(ghost)
			has_soul = TRUE
			to_chat(ghost, span_ghostalert("<b>АЛОЕ СИЯНИЕ ЗОВЕТ ВАС!</b> Кто-то использует могущественную алхимию на вашем теле!"))
			playsound(ghost, 'sound/magic/ahh1.ogg', 100, FALSE)

	if(!has_soul)
		to_chat(user, span_warning("Вы не чувствуете связи с душой [target]. Возможно, он покинул этот мир навсегда..."))
		return TRUE

	if(!target.check_revive(user))
		to_chat(user, span_warning("Эта душа уже недосягаема для смертной магии."))
		return TRUE

	user.visible_message(span_danger("[user] прикладывает Философский Камень к груди [target]!"), \
						span_notice("Вы направляете энергию Камня, призывая душу [target] вернуться..."))

	INVOKE_ASYNC(src, PROC_REF(do_resurrect), user, target, ghost)
	return TRUE



/obj/item/philosophers_stone/proc/do_resurrect(mob/living/carbon/human/user, mob/living/carbon/target, mob/dead/observer/ghost)

	var/mob/prompt_target = ghost ? ghost : target
	var/response = alert(prompt_target, "Алая энергия зовет вас. Вы готовы вернуться в мир живых?", "Великое Делание", "Я должен проснуться", "Оставьте меня во тьме")
	
	if(QDELETED(src) || QDELETED(target) || QDELETED(user)) return

	if(response != "Я должен проснуться")
		to_chat(user, span_warning("Душа [target] отказывается возвращаться."))
		return

	charges -= 50

	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	if(underworld_spirit)
		var/mob/dead/observer/uw_ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		uw_ghost.mind.transfer_to(target, TRUE)
	
	target.grab_ghost(force = TRUE)
	
	target.adjustOxyLoss(-target.getOxyLoss())
	target.revive(full_heal = TRUE) 
	target.blood_volume = BLOOD_VOLUME_NORMAL
	
	for(var/datum/wound/W in target.get_wounds())
		qdel(W)

	target.emote("gasp")
	target.Jitter(30)
	
	target.visible_message(span_danger("Алое сияние окутывает тело [target], и он резко делает вдох!"), \
						span_userdanger("Алхимическое пламя восстановило вашу плоть! ВЫ ЖИВЫ!"))
	
	do_sparks(4, TRUE, target)
	playsound(target, 'sound/magic/revive.ogg', 100, TRUE)

	if(target.mind)
		target.mind.remove_antag_datum(/datum/antagonist/zombie)
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)
	target.apply_status_effect(/datum/status_effect/debuff/revived) 

	if(charges <= 0)
		to_chat(user, span_danger("Равноценный обмен завершен... Жизнь за жизнь!"))
		consume_soul() 
	else
		to_chat(user, span_danger("Вы отдали огромную часть энергии Камня. Чувствуется сильная слабость."))
		user.flash_fullscreen("redflash", 2)

	update_icon()
