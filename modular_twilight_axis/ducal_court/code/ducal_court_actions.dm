/datum/ducal_court/proc/court_action_blocker(mob/living/carbon/human/user, action)
	if(!istype(user))
		return "Управлять двором может лишь живой подданный."
	if(!get_throat())
		return "Древняя магия молчит."

	var/has_crown = user_has_crown(user)
	var/has_authority = user_has_ducal_authority(user)
	var/can_announce = SScommunications.can_announce(user)
	var/obj/structure/roguethrone/throne = GLOB.king_throne
	var/datum/usurpation_rite/rite = throne?.active_rite

	switch(action)
		if("summon_crown")
			return null
		if("summon_key")
			if(!has_crown)
				return "Требуется корона."
			return null
		if("make_announcement")
			if(!has_crown)
				return "Требуется корона."
			if(world.time < GLOB.last_crown_announcement_time + 2 MINUTES)
				return "Время для нового объявления ещё не пришло."
			if(!can_announce)
				return "Древняя магия ещё восстанавливает силу."
			return null
		if("revise_charter", "restore_charter", "set_taxes", "change_colors")
			if(!has_crown)
				return "Требуется корона."
			if(!has_authority)
				return "Только правитель или регент."
			return null
		if("issue_decree", "set_laws", "make_law", "purge_laws", "purge_decrees")
			if(!has_crown)
				return "Требуется корона."
			if(!has_authority)
				return "Только правитель или регент."
			if(!can_announce)
				return "Древняя магия ещё восстанавливает силу."
			return null
		if("declare_outlaw")
			if(!has_crown)
				return "Требуется корона."
			if(!has_authority)
				return "Только правитель или регент."
			if(!user_has_lord_job(user))
				return "Объявить вне закона может лишь правящий сан."
			if(!can_announce)
				return "Древняя магия ещё восстанавливает силу."
			return null
		if("ascend")
			if(!throne)
				return "Трона, на который можно притязать, нет."
			if(rite)
				return "Ритуал наследования уже идёт."
			if(!SSticker.had_ruler)
				return "Некого свергать — правителя не было."
			if(SSticker.rulermob == user)
				return "Трон уже ваш."
			if(SSgamemode.roundvoteend)
				return "Судьба земель уже решена."
			if(!has_available_usurpation_rite(user))
				return "Вам не доступен ни один ритуал наследования."
			return null
		if("assent")
			if(!rite)
				return "Нет притязания, требующего согласия."
			if(rite.stage != RITE_STAGE_GATHERING)
				return "Согласие принимается лишь во время сбора голосов."
			if(!user_near_throne(user))
				return "Чтобы выразить согласие, встаньте у трона."
			return null
		if("abdicate")
			if(!rite)
				return "Нет притязания, в пользу которого можно отречься."
			if(rite.stage >= RITE_STAGE_CONTESTING)
				return "Ритуал уже оспаривается."
			if(!has_authority)
				return "Отречься может лишь правитель или регент."
			if(!user_near_throne(user))
				return "Чтобы отречься, встаньте у трона."
			return null
		if("stop_ascent")
			if(!rite)
				return "Нет восхождения, которое можно остановить."
			if(rite.stage != RITE_STAGE_CONTESTING)
				return "Остановить восхождение можно лишь на этапе оспаривания."
			if(rite.contester)
				return "Кто-то уже оспаривает ритуал с трона."
			if(!throne || !(user in throne.buckled_mobs))
				return "Сядьте на трон, чтобы остановить наследование."
			return null
		if("become_regent")
			if(!has_crown)
				return "Требуется корона."
			if(SSticker.rulermob == user)
				return "Трон уже ваш."
			var/mob/living/current_lord = SSticker.rulermob
			if(current_lord && !QDELETED(current_lord) && current_lord.stat != DEAD)
				return "Истинный правитель ещё пребывает в этих землях."
			if(!HAS_TRAIT(user, TRAIT_NOBLE))
				return "Требуется благородная кровь."
			if(!(user.job in GLOB.regency_positions))
				return "Ваш сан не может нести корону как регент."
			if(SSticker.regentday == GLOB.dayspassed)
				return "Регент уже был провозглашён сегодня."
			if(SSticker.regentmob == user)
				return "Вы уже регент."
			return null
	return "Неизвестное действие двора."

/datum/ducal_court/proc/reject_court_action(mob/living/carbon/human/user, action)
	var/reason = court_action_blocker(user, action)
	if(!reason)
		return FALSE
	to_chat(user, span_warning(reason))
	playsound(GLOB.king_throne || user, 'sound/misc/machineno.ogg', 100, FALSE, -1)
	return TRUE

/datum/ducal_court/proc/get_court_text_param(list/params, key = "text", max_len = MAX_MESSAGE_LEN)
	var/text = params[key]
	if(!istext(text))
		return null
	text = trim(text)
	if(!length(text))
		return null
	return copytext(text, 1, max_len + 1)

/datum/ducal_court/proc/get_court_prompt_text(mob/living/carbon/human/user, message, title)
	var/text = tgui_input_text(user, message, title, max_length = MAX_MESSAGE_LEN, multiline = TRUE, bigmodal = TRUE)
	if(!text)
		return null
	text = trim(text)
	if(!length(text))
		return null
	return copytext(text, 1, MAX_MESSAGE_LEN + 1)

/datum/ducal_court/proc/try_summon_crown(mob/living/carbon/human/user)
	var/obj/structure/roguemachine/titan/T = get_throat()
	if(!T)
		return FALSE
	var/notlord = !user_has_ducal_authority(user)
	var/obj/item/clothing/head/roguetown/crown/serpcrown/I = SSroguemachine.crown

	if(!I)
		T.summon_crown()
		return TRUE

	var/mob/M = get_containing_mob(I)

	if(!M)
		var/area/crown_area = get_area(I)
		if(crown_area && istype(crown_area, /area/rogue/indoors/town/vault) && notlord)
			T.say("The crown is within the vault.")
			playsound(T, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return FALSE
		T.summon_crown()
		return TRUE

	if(ishuman(M))
		var/mob/living/carbon/human/HC = M

		if(HC.stat == DEAD)
			HC.dropItemToGround(I, TRUE)
			T.summon_crown()
			return TRUE

		if(SSticker.rulermob == HC || SSticker.regentmob == HC)
			if(I in HC.held_items)
				T.say("Master [HC.real_name] holds the crown!")
			else if(HC.head == I)
				T.say("Master [HC.real_name] wears the crown!")
			else
				T.say("Master [HC.real_name] has the crown stowed away!")
			playsound(T, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return FALSE

		if(HC.head == I)
			T.say("[HC.real_name] wears the crown!")
			playsound(T, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return FALSE

	T.summon_crown()
	return TRUE

/datum/ducal_court/proc/announce_key_summoned()
	var/obj/structure/roguemachine/titan/T = get_throat()
	if(!T)
		return
	T.say("The key is summoned!")
	playsound(T, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	playsound(T, 'sound/misc/hiss.ogg', 100, FALSE, -1)

/datum/ducal_court/proc/create_lord_key()
	var/obj/structure/roguemachine/titan/T = get_throat()
	if(!T)
		return
	new /obj/item/roguekey/lord(T.loc)
	announce_key_summoned()

/datum/ducal_court/proc/try_summon_key(mob/living/carbon/human/user)
	var/obj/structure/roguemachine/titan/T = get_throat()
	if(!T)
		return FALSE
	if(!user_has_crown(user))
		T.say("You need the crown.")
		playsound(T, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return FALSE
	var/obj/item/roguekey/lord/I = SSroguemachine.key
	if(!I)
		create_lord_key()
		return TRUE
	if(!ismob(I.loc))
		I.anti_stall()
		create_lord_key()
		return TRUE
	if(ishuman(I.loc))
		var/mob/living/carbon/human/HC = I.loc
		if(HC.stat != DEAD)
			T.say("[HC.real_name] holds the key!")
			playsound(T, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			return FALSE
		HC.dropItemToGround(I, TRUE)
	I.forceMove(T.loc)
	announce_key_summoned()
	return TRUE

/datum/ducal_court/proc/open_tax_menu(mob/living/carbon/human/user)
	var/datum/taxsetter/taxsetter = new("The Generous Lord Decrees")
	taxsetter.ui_interact(user)

/datum/ducal_court/proc/open_law_menu(mob/living/carbon/human/user)
	var/datum/laws_menu/lawmenu = new
	lawmenu.ui_interact(user)

/datum/ducal_court/proc/open_decree_menu(mob/living/carbon/human/user)
	var/datum/decree_setter/panel = new
	panel.ui_interact(user)

/datum/ducal_court/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	if(!ishuman(ui.user))
		return FALSE
	var/mob/living/carbon/human/user = ui.user
	if(!user_seated_on_throne(user))
		to_chat(user, span_warning("Вы более не восседаете на троне."))
		ui.close()
		return TRUE
	return handle_court_action(user, action, params)

/datum/ducal_court/proc/handle_court_action(mob/living/carbon/human/user, action, list/params)
	var/obj/structure/roguemachine/titan/T = get_throat()
	switch(action)
		if("make_announcement")
			if(reject_court_action(user, "make_announcement"))
				return TRUE
			var/text = get_court_prompt_text(user, "Что будет объявлено землям?", "Объявление")
			if(text && !reject_court_action(user, "make_announcement"))
				T?.make_announcement(user, text)
			return TRUE
		if("publish_announcement")
			if(reject_court_action(user, "make_announcement"))
				return TRUE
			var/text = get_court_text_param(params)
			if(text)
				T?.make_announcement(user, text)
			return TRUE
		if("issue_decree")
			if(reject_court_action(user, "issue_decree"))
				return TRUE
			var/text = get_court_prompt_text(user, "Какой указ будет издан?", "Указ")
			if(text && !reject_court_action(user, "issue_decree"))
				T?.make_decree(user, text)
			return TRUE
		if("publish_decree")
			if(reject_court_action(user, "issue_decree"))
				return TRUE
			var/text = get_court_text_param(params)
			if(text)
				T?.make_decree(user, text)
			return TRUE
		if("make_law")
			if(reject_court_action(user, "make_law"))
				return TRUE
			var/text = get_court_prompt_text(user, "Какой закон будет принят?", "Новый закон")
			if(text && !reject_court_action(user, "make_law"))
				make_law(text)
			return TRUE
		if("publish_law")
			if(reject_court_action(user, "make_law"))
				return TRUE
			var/text = get_court_text_param(params, "text", 500)
			if(text)
				make_law(text)
			return TRUE
		if("remove_law")
			if(reject_court_action(user, "make_law"))
				return TRUE
			var/law_number = params["law_number"]
			if(istext(law_number))
				law_number = text2num(law_number)
			else if(!isnum(law_number))
				law_number = null
			if(!isnum(law_number))
				to_chat(user, span_warning("Закона с таким номером нет."))
				return TRUE
			law_number = round(law_number)
			if(!islist(GLOB.laws_of_the_land) || law_number < 1 || law_number > length(GLOB.laws_of_the_land))
				to_chat(user, span_warning("Закона с таким номером нет."))
				return TRUE
			remove_law(law_number)
			return TRUE
		if("revise_charter", "restore_charter")
			if(reject_court_action(user, action))
				return TRUE
			open_decree_menu(user)
			return TRUE
		if("set_laws")
			if(reject_court_action(user, "set_laws"))
				return TRUE
			open_law_menu(user)
			return TRUE
		if("set_taxes")
			if(reject_court_action(user, "set_taxes"))
				return TRUE
			open_tax_menu(user)
			return TRUE
		if("declare_outlaw")
			if(reject_court_action(user, "declare_outlaw"))
				return TRUE
			var/text = get_court_prompt_text(user, "Кого объявить вне закона или помиловать? Укажите точное имя.", "Вне закона")
			if(text && !reject_court_action(user, "declare_outlaw"))
				T?.declare_outlaw(user, text)
			return TRUE
		if("change_colors")
			if(reject_court_action(user, "change_colors"))
				return TRUE
			user.lord_color_choice()
			return TRUE
		if("summon_crown")
			try_summon_crown(user)
			return TRUE
		if("summon_key")
			if(reject_court_action(user, "summon_key"))
				return TRUE
			try_summon_key(user)
			return TRUE
		if("purge_laws")
			if(reject_court_action(user, "purge_laws"))
				return TRUE
			var/confirm = tgui_alert(user, "Отменить все законы этих земель?", "Отмена законов", list("Отменить", "Назад"))
			if(confirm == "Отменить" && !reject_court_action(user, "purge_laws"))
				purge_laws()
			return TRUE
		if("purge_decrees")
			if(reject_court_action(user, "purge_decrees"))
				return TRUE
			var/confirm = tgui_alert(user, "Отменить все указы этих земель?", "Отмена указов", list("Отменить", "Назад"))
			if(confirm == "Отменить" && !reject_court_action(user, "purge_decrees"))
				purge_decrees()
			return TRUE
		if("ascend")
			if(reject_court_action(user, "ascend"))
				return TRUE
			T?.start_ascension(user)
			return TRUE
		if("assent")
			if(reject_court_action(user, "assent"))
				return TRUE
			var/obj/structure/roguethrone/assent_throne = GLOB.king_throne
			var/datum/usurpation_rite/assent_rite = assent_throne ? assent_throne.active_rite : null
			if(assent_rite)
				assent_rite.try_assent(user)
			return TRUE
		if("abdicate")
			if(reject_court_action(user, "abdicate"))
				return TRUE
			var/obj/structure/roguethrone/abdicate_throne = GLOB.king_throne
			var/datum/usurpation_rite/abdicate_rite = abdicate_throne ? abdicate_throne.active_rite : null
			if(abdicate_rite)
				abdicate_rite.try_abdication(user)
			return TRUE
		if("stop_ascent")
			if(reject_court_action(user, "stop_ascent"))
				return TRUE
			var/obj/structure/roguethrone/stop_throne = GLOB.king_throne
			var/datum/usurpation_rite/stop_rite = stop_throne ? stop_throne.active_rite : null
			if(stop_rite)
				stop_rite.start_counter_claim(user)
			return TRUE
		if("become_regent")
			if(reject_court_action(user, "become_regent"))
				return TRUE
			become_regent(user)
			return TRUE
	return FALSE
