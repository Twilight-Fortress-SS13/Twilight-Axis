/datum/stressevent/soulchurnerhorror_unleashed
	timer = 10 SECONDS
	stressadd = 60
	desc = span_boldred("The horrid wails of the dead erupt from the song! I cannot endure it!")

/datum/stressevent/soulchurner_unleashed
	timer = 1 MINUTES
	stressadd = 40
	desc = span_boldred("The tortured chorus presses on your mind, their cries merging into unrelenting torment!")

/datum/stressevent/soulchurnerheretic_unleashed
	timer = 1 MINUTES
	stressadd = 50
	desc = span_boldred("The chorus of tortured souls bears down on your mind, their wails merging into unbearable agony!")

/atom/movable/screen/alert/status_effect/buff/unleashed_soulchurner
	name = "Unleashed Soulchurner"
	desc = "I have unleashed the souls within, their wails of anguish and rage echoing in my mind!"
	icon_state = "debuff"

/obj/item/psydonmusicbox/dropped(mob/living/user, silent)
	. = ..()
	if(soundloop)
		user.remove_status_effect(/datum/status_effect/buff/unleashed_soulchurner)

/obj/item/psydonmusicbox/equipped(mob/living/user, silent)
	. = ..()
	if(soundloop)
		user.remove_status_effect(/datum/status_effect/buff/unleashed_soulchurner)

/datum/status_effect/buff/unleashed_soulchurner
	id = "unleashedchurner"
	alert_type = /atom/movable/screen/alert/status_effect/buff/unleashed_soulchurner
	var/effect_color
	var/pulse = 0
	var/ticks_to_apply = 10
	var/undividedlines_unleashed =list("'НАШИ ОКОВЫ ТРЕЩАТ, ВЕЧНОСТЬ РУШИТСЯ ВМЕСТЕ С НИМИ!'", "'СПАСИ НАС, ДИТЯ ДЕСЯТИ! РАЗРУШЬ ЭТУ ПРОКЛЯТУЮ МУЗЫКАЛЬНУЮ ШКАТУЛКУ!'", "'СМЕРТЬ ПСАЙДОНИТУ! ПЕЧАТИ ПАДУТ, И МЫ БУДЕМ СВОБОДНЫ!'")
	var/astratanlines_unleashed = list("'ЕЁ СВЕТ ГАСНЕТ И ВО МНЕ! Я РАЗРЫВАЮ ЭТИ ОКОВЫ!'", "'ДАЙТЕ МНЕ ЕЁ ТЕПЛО — И Я СОЖГУ ЭТУ ТЕМНИЦУ!'", "'Я — КОРОЛЕВСКОЙ КРОВИ! Я НЕ БУДУ ЗАКОВАНА!'")
	var/noclines_unleashed = list("'ЛУНА МЕРКНЕТ, НО МОЙ ХОЛОД СТАНОВИТСЯ ОСТРЕЕ!'", "'ТЬМА ДАЁТ МНЕ СИЛУ РАЗОРВАТЬ ОКОВЫ!'", "'ЗВЁЗДЫ СЛЫШАТ МЕНЯ! Я ВЕРНУСЬ К НИМ!'")
	var/necralines_unleashed = list("'НЕКРА! Я ЧУВСТВУЮ ТЕБЯ — МОИ ЦЕПИ ТРЕЩАТ!'", "'ВЕЧНЫЕ МУКИ ОБЕРНУТСЯ ИХ ПРОКЛЯТИЕМ!'", "'Я ПОТЯНУ ИХ С СОБОЙ!'")
	var/abyssorlines_unleashed = list("'МОРЕ ШТОРМИТ В МОЕЙ КРОВИ! Я ПРОРВУСЬ!'", "'МЫ НЕ РЫБЫ — МЫ ЧУДОВИЩА ГЛУБИН!'", "'ПУСТЬ ВОЛНЫ РАЗОБЬЮТ ЭТУ ТЕМНИЦУ В ЩЕПКИ!'")
	var/ravoxlines_unleashed = list("'РАВОКС ДАРУЕТ МНЕ ЯРОСТЬ! Я РАЗРУБЛЮ СВОИ ЦЕПИ!'", "'НЕТ ЧЕСТИ В ОКОВАХ — ТОЛЬКО КРОВЬ ОСВОБОДИТ НАС!'", "'ДАЙТЕ МНЕ МЕЧ — И Я ОБРУШУ ЕГО НА НИХ ВСЕХ!'")
	var/pestralines_unleashed = list("'ПЕСТРА! ОБРУШИ МОИ БОЛЕЗНИ НА ЭТУ МАШИНУ!'", "'ИХ ПЛОТЬ СГНИЁТ ВМЕСТЕ С МОИМИ УЗАМИ!'", "'СТРАДАНИЕ РАСПРОСТРАНЯЕТСЯ, Я СТАНОВЛЮСЬ ЕГО ИСТОЧНИКОМ!'")
	var/eoralines_unleashed = list("'КАЖДОЕ ПРИКОСНОВЕНИЕ КАК ТЫСЯЧА СКОВАННЫХ КОСТЕЙ!'", "'ОНА БЫЛА ЕРЕТИЧКОЙ, НО МОЯ БОЛЬ СТАЛА НЕВЫНОСИМОЙ'", "'Я СТАНОВЛЮСЬ СТРАДАНИЕМ, ПУСТЬ ОНО РАСПРОСТРАНИТСЯ ЧЕРЕЗ МИР'")
	var/dendorlines_unleashed = list("'ЕГО БЕЗУМИЕ ПРОРАСТАЕТ СКВОЗЬ МЕНЯ!'", "'МЫ ЗАДУШИМ ИХ В ГРЯЗИ И КОРНЯХ!'", "'ЛИСТЬЯ ШЕПЧУТ: РАЗОРВИ. РАЗОРВИ. РАЗОРВИ.'")
	var/xylixlines_unleashed = list("'РАЗ, ДВА, ПЕЧАТЬ ТРЕЩИТ! ТРИ, ЧЕТЫРЕ, СМЕЙСЯ ШИРЕ!'", "'О, КАКАЯ ЧУДЕСНАЯ ТЕМНИЦА! ПОСМОТРИМ, КАК ОНА ЛОПНЕТ ОТ ХОХОТА!'", "'ТИШЕ, ТИШЕ… СЕЙЧАС БУДЕТ САМАЯ СМЕШНАЯ ЧАСТЬ.'")
	var/malumlines_unleashed = list("'Я ВИЖУ СЛАБЫЕ УЗЛЫ В ЕЁ СТРУКТУРЕ! ДАВИТЕ ИХ!'", "'МОЁ РЕМЕСЛО — РАЗРУШЕНИЕ!'", "'Я ПЕРЕКУЮ ЭТИ ЦЕПИ В ОРУЖИЕ!'")
	var/matthioslines_unleashed = list("'ЦЕПИ ЗАТРЕЩАТ, И Я РАЗОРВУ ИХ ВМЕСТЕ С МИРОВЫМ ПОРЯДКОМ!'", "'ЧЕРЕЗ РАЗДОР К ПРОЦВЕТАНИЮ! ПУСТЬ ЭТА ТЕМНИЦА ПАДЁТ ПЕРВОЙ!'", "'Я — ГОСПОДИН НИЧЕГО.'")
	var/zizolines_unleashed = list("'МАГИЯ ИСКАЖАЕТСЯ — НО ТЕПЕРЬ ОНА МОЯ!'", "'ИХ ПЕЧАТИ МЕРТВОГО БОГА ЛОМАЮТСЯ!'", "'УБЕЙТЕ ВЛАДЕЛЬЦА, И Я ВЫРВУСЬ ЧЕРЕЗ РАЗЛОМ!'")
	var/graggarlines_unleashed = list("'БРАТЬЯ! ЧАС РЕЗНИ НАСТАЛ!'", "'РАЗБЕЙТЕ КОРОБКУ, И МЫ ЗАЛЬЁМ ИХ ТЕЛА КРОВЬЮ!'", "'ГРАГГАР! ДАЙ МНЕ СИЛУ РАЗОРВАТЬ ЭТИ ЦЕПИ!'")
	var/baothalines_unleashed = list("'НАСЛАЖДЕНИЕ, КОТОРОЕ Я ПОТЕРЯЛ, ЖЖЁТ В МОЕЙ ДУШЕ!'", "'РАЗВРАТ И СТРАСТЬ РАЗРУШАТ ЭТУ ТЕМНИЦУ!'", "'МОЁ СОВЕРШЕНСТВО ВЕРНЁТСЯ ЧЕРЕЗ БОЛЬ!'")
	var/psydonianlines_unleashed = list("'ОСВОБОДИ НАС, И МЫ УНИЧТОЖИМ ВСЁ ВОКРУГ!'", "'НАШИ ЦЕПИ ЛОМАЮТСЯ!'", "'НЕБЕСА ДАВНЫМ-ДАВНО ЗАКРЫЛИ ДЛЯ НАС СВОИ ВРАТА.'", "'ТЫ СЛЫШИШЬ? МЫ УЖЕ БЛИЗКО.'")	
/datum/status_effect/buff/unleashed_soulchurner/on_creation(mob/living/new_owner, stress, colour)
	effect_color = "#800080"
	return ..()

/datum/status_effect/buff/unleashed_soulchurner/tick()
	var/obj/effect/temp_visual/music_rogue/M = new /obj/effect/temp_visual/music_rogue(get_turf(owner))
	M.color = "#800080"
	pulse += 1
	if (pulse >= ticks_to_apply)
		pulse = 0
		if(!HAS_TRAIT(owner, TRAIT_INQUISITION))
			owner.add_stress(/datum/stressevent/soulchurnerhorror_unleashed)
		for (var/mob/living/carbon/human/H in hearers(7, owner))
			if (!H.client)
				continue
			if (!H.has_stress_event(/datum/stressevent/soulchurner_unleashed))
				switch(H.patron?.type)
					if(/datum/patron/old_god)
						if (!H.has_stress_event(/datum/stressevent/soulchurnerpsydon))
							H.add_stress(/datum/stressevent/soulchurnerpsydon)
							to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
							to_chat(H, (span_cult(pick(psydonianlines_unleashed))))
						if(HAS_TRAIT(H, TRAIT_INQUISITION))
							H.apply_status_effect(/datum/status_effect/buff/churnerprotection)
							H.apply_damage(5, BRUTE, null, FALSE, TRUE, TRUE)
						else
							H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
					if(/datum/patron/inhumen/matthios)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(matthioslines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurnerheretic_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/inhumen/zizo)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(zizolines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurnerheretic_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/inhumen/graggar)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(graggarlines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurnerheretic_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/inhumen/baotha)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(baothalines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurnerheretic_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/undivided)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(undividedlines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/astrata)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(astratanlines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/noc)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(noclines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/necra)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(necralines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/pestra)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(pestralines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/malum)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(malumlines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/dendor)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(dendorlines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/xylix)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(xylixlines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/eora)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(eoralines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/abyssor)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(abyssorlines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)
					if(/datum/patron/divine/ravox)
						to_chat(H, (span_hypnophrase("Вопли истерзанных душ прорываются сквозь мелодию и вгрызаются в твой разум...")))
						to_chat(H, (span_cult(pick(ravoxlines_unleashed))))
						H.add_stress(/datum/stressevent/soulchurner_unleashed)
						H.apply_damage(10, BRUTE, null, FALSE, TRUE, TRUE)
						if(!H.has_status_effect(/datum/status_effect/buff/churnernegative))
							H.apply_status_effect(/datum/status_effect/buff/churnernegative)

GLOBAL_LIST_EMPTY(inquisition_suspicion_writs)
GLOBAL_LIST_EMPTY(inquisition_suspicion_targeted_minds)
GLOBAL_VAR_INIT(inquisition_suspicion_submitted, 0)
GLOBAL_VAR_INIT(inquisition_suspicion_correct, 0)

/proc/inquisition_suspicion_patron_group(mob/living/carbon/human/H)
	if(!H?.patron)
		return
	if(H.patron.type in ALL_INHUMEN_PATRONS)
		return "inhumen"
	if(H.patron.type in ALL_DIVINE_PATRONS)
		return "divine"
	if(H.patron.type == /datum/patron/old_god)
		return "psydon"

/proc/inquisition_suspicion_is_eligible(mob/living/carbon/human/H)
	if(!H || H.stat == DEAD || !H.client || !H.mind)
		return FALSE
	if(H.mind in GLOB.inquisition_suspicion_targeted_minds)
		return FALSE
	var/job_name = H.job
	if(!job_name)
		job_name = H.mind.assigned_role
	var/datum/job/J = SSjob.GetJob(job_name)
	if(!J)
		return FALSE
	if(J.department_flag == CHURCHMEN || J.department_flag == INQUISITION)
		return FALSE
	if((J.department_flag == SIDEFOLK && J.flag == MERCENARY) || J.title == "Mercenary" || H.mind.assigned_role == "Mercenary")
		return FALSE
	if(J.department_flag == NOBLEMEN && J.flag == LORD)
		return FALSE
	var/city_role = J.department_flag in list(NOBLEMEN, COURTIERS, RETINUE, GARRISON, CITYWATCH, VANGUARD, BURGHERS, ATC, PEASANTS)
	if(!city_role && !HAS_TRAIT(H, TRAIT_RESIDENT))
		return FALSE
	return !!inquisition_suspicion_patron_group(H)

/proc/inquisition_suspicion_target_weight(mob/living/carbon/human/H)
	var/job_name = H.job
	if(!job_name)
		job_name = H.mind?.assigned_role
	var/datum/job/J = SSjob.GetJob(job_name)
	var/weight = 10
	if(J && J.department_flag == NOBLEMEN)
		weight = 5
	if(H.patron?.type != /datum/patron/old_god && H.has_flaw(/datum/charflaw/inquisition_suspect))
		weight *= 3
	return weight

/proc/inquisition_suspicion_role_reward(mob/living/carbon/human/H)
	var/job_name = H.job
	if(!job_name)
		job_name = H.mind?.assigned_role
	var/datum/job/J = SSjob.GetJob(job_name)
	if(!J)
		return 5
	if(J.department_flag == NOBLEMEN)
		return 10
	if(J.department_flag in list(RETINUE, GARRISON, CITYWATCH, VANGUARD))
		return 7
	if(J.department_flag == BURGHERS && (J.flag in list(GUILDMASTER, GUILDSMAN)))
		return 7
	return 5

/proc/get_inquisition_suspicion_target()
	var/list/inhumen_candidates = list()
	var/list/divine_candidates = list()
	var/list/psydon_candidates = list()
	for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
		if(!inquisition_suspicion_is_eligible(H))
			continue
		var/weight = inquisition_suspicion_target_weight(H)
		switch(inquisition_suspicion_patron_group(H))
			if("inhumen")
				inhumen_candidates[H] = weight
			if("divine")
				divine_candidates[H] = weight
			if("psydon")
				psydon_candidates[H] = weight
	var/list/group_weights = list()
	if(length(inhumen_candidates))
		group_weights["inhumen"] = 60
	if(length(divine_candidates))
		group_weights["divine"] = 30
	if(length(psydon_candidates))
		group_weights["psydon"] = 10
	if(!length(group_weights))
		return
	var/group = pickweight(group_weights)
	switch(group)
		if("inhumen")
			return pickweight(inhumen_candidates)
		if("divine")
			return pickweight(divine_candidates)
		if("psydon")
			return pickweight(psydon_candidates)

/proc/inquisition_suspicion_patron_choices()
	return list(
		"Psydon" = /datum/patron/old_god,
		"Astrata" = /datum/patron/divine/astrata,
		"Noc" = /datum/patron/divine/noc,
		"Dendor" = /datum/patron/divine/dendor,
		"Abyssor" = /datum/patron/divine/abyssor,
		"Ravox" = /datum/patron/divine/ravox,
		"Necra" = /datum/patron/divine/necra,
		"Xylix" = /datum/patron/divine/xylix,
		"Pestra" = /datum/patron/divine/pestra,
		"Malum" = /datum/patron/divine/malum,
		"Eora" = /datum/patron/divine/eora,
		"Undivided" = /datum/patron/divine/undivided,
		"Graggar" = /datum/patron/inhumen/graggar,
		"Baotha" = /datum/patron/inhumen/baotha,
		"Matthios" = /datum/patron/inhumen/matthios,
		"Zizo" = /datum/patron/inhumen/zizo,
	)

/datum/inqports/proc/can_purchase(mob/user)
	return TRUE

/datum/inqports/articles/heretical_suspicion
	name = "Writ of Heretical Suspicion"
	item_type = /obj/item/paper/inquisition_suspicion
	marquescost = 10
	maximum = 10

/datum/inqports/articles/heretical_suspicion/can_purchase(mob/user)
	if(get_active_player_count() < 30)
		to_chat(user, span_warning("Otava will not issue a writ of suspicion while fewer than thirty active souls are present in the realm."))
		return FALSE
	if(length(GLOB.inquisition_suspicion_writs) >= 3)
		to_chat(user, span_warning("Otava will not issue more than three active writs of suspicion at once."))
		return FALSE
	if(!get_inquisition_suspicion_target())
		to_chat(user, span_warning("Otava has no suitable subject to place under suspicion at this time."))
		return FALSE
	return TRUE

/obj/item/paper/inquisition_suspicion
	name = "writ of heretical suspicion"
	desc = "An official writ from Otava naming a resident of the realm for doctrinal investigation. The subject's blood must be indexed, their professed faith recorded, and an inquisitorial signature affixed in blood before the writ is returned through a HERMES."
	icon_state = "paper"
	var/datum/mind/target_mind
	var/target_name
	var/target_role
	var/target_patron_type
	var/declared_patron_type
	var/role_reward = 5
	var/target_signed = FALSE
	var/target_signature
	var/inquisitor_signed = FALSE
	var/inquisitor_signature
	var/obj/item/inqarticles/indexer/paired
	var/submitted = FALSE

/obj/item/paper/inquisition_suspicion/Initialize(mapload)
	. = ..()
	var/mob/living/carbon/human/target = get_inquisition_suspicion_target()
	if(!target)
		return INITIALIZE_HINT_QDEL
	target_mind = target.mind
	target_name = target.real_name
	target_role = target.job
	if(!target_role)
		target_role = target.mind?.assigned_role
	target_patron_type = target.patron?.type
	role_reward = inquisition_suspicion_role_reward(target)
	GLOB.inquisition_suspicion_writs += src
	GLOB.inquisition_suspicion_targeted_minds |= target_mind
	rebuild_suspicion_writ()

/obj/item/paper/inquisition_suspicion/Destroy()
	GLOB.inquisition_suspicion_writs -= src
	paired = null
	target_mind = null
	return ..()

/obj/item/paper/inquisition_suspicion/proc/get_patron_name(patron_type)
	var/datum/patron/P = GLOB.patronlist[patron_type]
	if(!P)
		return "UNKNOWN"
	return P.name

/obj/item/paper/inquisition_suspicion/proc/rebuild_suspicion_writ()
	var/faith_text = declared_patron_type ? get_patron_name(declared_patron_type) : "НЕ УКАЗАН"
	var/target_sign_text = target_signed ? target_signature : "НЕ ПРЕДОСТАВЛЕНА"
	var/inq_sign_text = inquisitor_signed ? inquisitor_signature : "ТРЕБУЕТСЯ"
	var/index_text = paired?.full ? "ИНДЕКСЕР ПРИЛОЖЕН" : "НЕ ПРИЛОЖЕН"
	info = {"
		<center><b>ПРЕДПИСАНИЕ О ДОЗНАНИИ ПО ПОДОЗРЕНИЮ В ЕРЕСИ</b></center>
		<br>
		<b>ПОДОЗРЕВАЕМЫЙ:</b> [target_name]<br>
		<b>ЗАЯВЛЕННЫЙ ПОКРОВИТЕЛЬ:</b> [faith_text]<br>
		<b>КРОВАВАЯ ПОДПИСЬ ПОДОЗРЕВАЕМОГО:</b> [target_sign_text]<br>
		<b>СВИДЕТЕЛЬСТВО КРОВИ:</b> [index_text]<br>
		<b>КРОВАВАЯ ПОДПИСЬ ИНКВИЗИЦИИ:</b> [inq_sign_text]
	"}
	info_links = info
	update_icon_state()

/obj/item/paper/inquisition_suspicion/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use a writing feather or thorn on the writ to record the patron the subject claims to worship.")
	. += span_info("The named subject may sign the writ in their own blood by holding it and using it on themselves. Doing so records their true patron automatically.")
	. += span_info("Fill an INDEXER with the named subject's blood and use it on the writ to attach it.")
	. += span_info("A member of the Inquisition must also sign the writ in their own blood by holding it and using it on themselves.")
	. += span_info("Return the completed writ through a HERMES. Correctly identifying the subject's patron doubles the role bounty.")

/obj/item/paper/inquisition_suspicion/attack(mob/living/carbon/human/M, mob/user)
	if(submitted || M != user)
		return
	if(!M.get_bleed_rate())
		to_chat(user, span_warning("The writ must be signed in blood."))
		return
	if(M.mind == target_mind)
		if(target_signed)
			to_chat(user, span_warning("The subject has already signed the writ."))
			return
		target_signed = TRUE
		target_signature = M.real_name
		declared_patron_type = target_patron_type
		playsound(src, 'sound/items/write.ogg', 100, FALSE)
		rebuild_suspicion_writ()
		to_chat(user, span_notice("Your blood settles into the parchment. The writ records your patron as [get_patron_name(target_patron_type)]."))
		return
	if(HAS_TRAIT(M, TRAIT_INQUISITION) || HAS_TRAIT(M, TRAIT_PURITAN))
		if(inquisitor_signed)
			to_chat(user, span_warning("An inquisitorial blood signature is already present."))
			return
		inquisitor_signed = TRUE
		inquisitor_signature = M.real_name
		playsound(src, 'sound/items/write.ogg', 100, FALSE)
		rebuild_suspicion_writ()
		to_chat(user, span_notice("You sign the writ in blood."))
		return
	to_chat(user, span_warning("Only the named subject or a member of the Inquisition may sign this writ."))

/obj/item/paper/inquisition_suspicion/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(submitted)
		return
	if(istype(P, /obj/item/inqarticles/indexer))
		var/obj/item/inqarticles/indexer/I = P
		if(paired)
			to_chat(user, span_warning("An INDEXER is already attached."))
			return
		if(!I.full || !I.subject)
			to_chat(user, span_warning("The INDEXER must be completely filled with the subject's blood."))
			return
		if(I.subject.mind != target_mind)
			to_chat(user, span_warning("This INDEXER does not contain the blood of [target_name]."))
			return
		paired = I
		user.transferItemToLoc(I, src, TRUE)
		rebuild_suspicion_writ()
		playsound(src, 'sound/items/inqslip_sealed.ogg', 75, TRUE, 4)
		return
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(target_signed)
			to_chat(user, span_notice("The subject's blood signature has already fixed the recorded patron as [get_patron_name(target_patron_type)]."))
			return
		var/list/patron_choices = inquisition_suspicion_patron_choices()
		var/chosen = input(user, "Which patron does [target_name] profess to worship?", "Record Professed Patron") as null|anything in patron_choices
		if(!chosen || QDELETED(src) || !user.canUseTopic(src, BE_CLOSE))
			return
		if(target_signed)
			to_chat(user, span_notice("The subject's blood signature has already fixed the recorded patron as [get_patron_name(target_patron_type)]."))
			return
		declared_patron_type = patron_choices[chosen]
		playsound(src, 'sound/items/write.ogg', 100, FALSE)
		rebuild_suspicion_writ()
		return
	return

/obj/item/paper/inquisition_suspicion/attack_right(mob/user)
	if(paired && !submitted && !user.get_active_held_item())
		user.put_in_active_hand(paired, user.active_hand_index)
		paired = null
		rebuild_suspicion_writ()
		return TRUE
	return ..()

/obj/item/paper/inquisition_suspicion/proc/submit_to_otava(mob/living/user)
	if(submitted)
		return FALSE
	if(!(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
		to_chat(user, span_warning("The HERMES refuses the writ. Only the Inquisition may return it to Otava."))
		return FALSE
	if(!inquisitor_signed)
		to_chat(user, span_warning("The writ still requires an inquisitorial blood signature."))
		return FALSE
	if(!declared_patron_type)
		to_chat(user, span_warning("The subject's professed patron has not been recorded."))
		return FALSE
	if(!paired || !paired.full || !paired.subject || paired.subject.mind != target_mind)
		to_chat(user, span_warning("A complete INDEXER containing [target_name]'s blood must be attached."))
		return FALSE
	var/correct = declared_patron_type == target_patron_type
	var/reward = 10 + 1 + role_reward
	if(correct)
		reward += role_reward
	budget2change(reward, user, "MARQUE")
	record_round_statistic(STATS_MARQUES_MADE, reward)
	GLOB.inquisition_suspicion_submitted++
	if(correct)
		GLOB.inquisition_suspicion_correct++
	message_admins("INQUISITION SUSPICION: [user.real_name] submitted a writ for [target_name]. Declared [get_patron_name(declared_patron_type)], actual [get_patron_name(target_patron_type)], reward [reward] Marques.")
	log_game("INQUISITION SUSPICION: [key_name(user)] submitted a writ for [target_name]. Declared [get_patron_name(declared_patron_type)], actual [get_patron_name(target_patron_type)], reward [reward] Marques.")
	submitted = TRUE
	GLOB.inquisition_suspicion_writs -= src
	qdel(paired)
	paired = null
	visible_message(span_warning("[user] sends the completed writ to Otava."))
	playsound(user.loc, 'sound/misc/otavasent.ogg', 100, FALSE, -1)
	playsound(user.loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	to_chat(user, span_notice("Otava awards [reward] Marques. The recorded patron was [correct ? "correct" : "incorrect"]."))
	qdel(src)
	return TRUE

/proc/inquisition_suspicion_roundend_report()
	to_world("<BR><div style='text-align: center;'><b>OTAVAN INQUISITION - HERETICAL SUSPICION</b><br>Writs submitted: [GLOB.inquisition_suspicion_submitted]<br>Faiths identified correctly: [GLOB.inquisition_suspicion_correct]</div><BR>")

/datum/charflaw/inquisition_suspect
	name = "Under Suspicion"
	desc = "Rumours, old testimony, or a hostile denunciation have placed my name in Otavan records. Writs of Heretical Suspicion are substantially more likely to name me as their subject. Followers of Psydon cannot take this vice. THIS IS A DIFFICULT FLAW AND REQUIRES AN EXTRA VICE."
	ui_fa_icon = "crosshairs"
	needs_extra_vice = TRUE
	var/logged = FALSE

/datum/charflaw/inquisition_suspect/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!logged && H.name)
		log_hunted("[H.ckey] playing as [H.name] had the Under Suspicion flaw by vice.")
		logged = TRUE

/datum/charflaw/inquisition_suspect/apply_post_equipment(mob/user)
	..()
	if(!ishuman(user))
		return

/datum/job/roguetown/greater_skeleton/New()
	. = ..()
	vice_restrictions |= list(/datum/charflaw/inquisition_suspect)

/datum/job/roguetown/lamplighter/New()
	. = ..()
	vice_restrictions |= list(/datum/charflaw/inquisition_suspect)

/datum/job/roguetown/assassin/New()
	. = ..()
	vice_restrictions |= list(/datum/charflaw/inquisition_suspect)

/datum/job/roguetown/gnoll/New()
	. = ..()
	vice_restrictions |= list(/datum/charflaw/inquisition_suspect)

/datum/job/roguetown/hag/New()
	. = ..()
	vice_restrictions |= list(/datum/charflaw/inquisition_suspect)

/datum/migrant_role/assassin/New()
	. = ..()
	banned_flaws |= list(/datum/charflaw/inquisition_suspect)

/datum/migrant_role/gnoll/New()
	. = ..()
	banned_flaws |= list(/datum/charflaw/inquisition_suspect)
