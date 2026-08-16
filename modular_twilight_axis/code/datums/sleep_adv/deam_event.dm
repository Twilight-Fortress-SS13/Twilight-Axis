#ifndef subtypesof
#define subtypesof(typepath) (typesof(typepath) - typepath)
#endif

GLOBAL_LIST_INIT(dream_events, init_dream_events())

/proc/init_dream_events()
	var/list/L = list()
	for(var/path in subtypesof(/datum/dream_event))
		if(path == /datum/dream_event/positive || path == /datum/dream_event/negative)
			continue
		L[path] = new path()
	return L

/datum/dream_event
	var/name = "Базовое событие"
	var/is_positive = TRUE

/datum/dream_event/proc/can_trigger(mob/living/carbon/human/H)
	return TRUE

/datum/dream_event/proc/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	return

/datum/dream_event/proc/on_wake(mob/living/carbon/human/H, datum/sleep_adv/SA)
	return


//          ПОЛОЖИТЕЛЬНЫЕ СОБЫТИЯ

/datum/dream_event/positive/cure_addiction
	name = "Отрезвление разума"
	is_positive = TRUE

/datum/dream_event/positive/cure_addiction/can_trigger(mob/living/carbon/human/H)
	for(var/datum/charflaw/addiction/A in H.charflaws)
		return TRUE
	return FALSE

/datum/dream_event/positive/cure_addiction/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	var/list/active_vices = list()
	for(var/datum/charflaw/addiction/A in H.charflaws)
		active_vices += A

	if(length(active_vices))
		var/datum/charflaw/addiction/chosen_vice = pick(active_vices)
		to_chat(H, span_nicegreen("Я вижу яркую вспышку чистого разума. Моя тяга к пороку <b>[chosen_vice.name]</b> безвозвратно угасает!"))
		H.charflaws.Remove(chosen_vice)
		qdel(chosen_vice)

/datum/dream_event/positive/tooth_fairy
	name = "Визит Зубной Феи"
	is_positive = TRUE

/datum/dream_event/positive/tooth_fairy/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	to_chat(H, span_nicegreen("Мне снится звон золотых монет и крошечные, мерцающие в темноте крылышки..."))

/datum/dream_event/positive/tooth_fairy/on_wake(mob/living/carbon/human/H, datum/sleep_adv/SA)
	var/turf/T = get_turf(H)
	if(T)
		var/obj/item/roguecoin/silver/pile/G = new(T)
		if(G)
			G.name = "Подарок Зубной Феи"
			G.desc = "Волшебная стопка монеток, странно зубы все на месте..."
			to_chat(H, span_nicegreen("Я открываю глаза и обнаруживаю под своей подушкой подарок! Неужели Зубная фея действительно существует?.."))

/datum/dream_event/positive/loot_cheap
	name = "Простая находка"
	is_positive = TRUE

/datum/dream_event/positive/loot_cheap/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	to_chat(H, span_nicegreen("Мне снится блеск старой бронзы и простых, но милых сердцу украшений..."))

/datum/dream_event/positive/loot_cheap/on_wake(mob/living/carbon/human/H, datum/sleep_adv/SA)
	var/turf/T = get_turf(H)
	if(T)
		var/spawner_path = pick(list(
			/obj/effect/spawner/lootdrop/cheap_clutter_spawner,
			/obj/effect/spawner/lootdrop/cheap_candle_spawner,
			/obj/effect/spawner/lootdrop/cheap_tableware_spawner,
			/obj/effect/spawner/lootdrop/cheap_jewelry_spawner
		))

		new spawner_path(T)
		to_chat(H, span_nicegreen("Я открываю глаза и замечаю, что на краю моей постели лежит какая-то вещица... Кажется, я захватил ее из сна."))

/datum/dream_event/positive/loot_valuable
	name = "Благородный дар"
	is_positive = TRUE

/datum/dream_event/positive/loot_valuable/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	to_chat(H, span_nicegreen("Мне снится сияние Нок она любит меня..."))

/datum/dream_event/positive/loot_valuable/on_wake(mob/living/carbon/human/H, datum/sleep_adv/SA)
	var/turf/T = get_turf(H)
	if(T)
		var/spawner_path = pick(list(
			/obj/effect/spawner/lootdrop/valuable_clutter_spawner,
			/obj/effect/spawner/lootdrop/valuable_candle_spawner,
			/obj/effect/spawner/lootdrop/valuable_tableware_spawner,
			/obj/effect/spawner/lootdrop/valuable_jewelry_spawner
		))

		new spawner_path(T)

		to_chat(H, span_nicegreen("Я открываю глаза и вижу, что рядом лежит прекрасный дар сновидений... Какая чудесная находка!"))
		playsound(T, 'sound/magic/ahh2.ogg', 80, FALSE)


//          ОТРИЦАТЕЛЬНЫЕ СОБЫТИЯ

// /datum/dream_event/negative/wake_pig
// 	name = "Трюфельная свинья под боком"
// 	is_positive = FALSE

// /datum/dream_event/negative/wake_pig/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
// 	to_chat(H, span_warning("Сквозь туман дремоты я слышу настойчивое хрюканье и сопение..."))

// /datum/dream_event/negative/wake_pig/on_wake(mob/living/carbon/human/H, datum/sleep_adv/SA)
// 	var/turf/T = get_turf(H)
// 	if(T)
// 		var/mob/living/simple_animal/hostile/retaliate/rogue/trufflepig/P = new(T)
// 		if(P)
// 			P.name = "Сонная свинья"
// 			to_chat(H, span_warning("Я открываю глаза и обнаруживаю, что делю постель с... трюфельной свиньей?! Хрю!"))
// 			playsound(T, pick('modular/Creechers/sound/pig1.ogg', 'modular/Creechers/sound/pig2.ogg'), 100, TRUE, -1)

/datum/dream_event/negative/vice_alcoholic
	name = "Тяга к бутылке"
	is_positive = FALSE

/datum/dream_event/negative/vice_alcoholic/can_trigger(mob/living/carbon/human/H)
	return !H.has_flaw(/datum/charflaw/addiction/alcoholic)

/datum/dream_event/negative/vice_alcoholic/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	var/datum/charflaw/added_flaw = new /datum/charflaw/addiction/alcoholic()
	H.charflaws.Add(added_flaw)
	added_flaw.on_mob_creation(H)
	to_chat(H, span_boldred("Сухость во рту преследует меня во сне. Я просыпаюсь с непреодолимым желанием сделать глоток алкоголя..."))

/datum/dream_event/negative/vice_smoker
	name = "Тяга к табаку"
	is_positive = FALSE

/datum/dream_event/negative/vice_smoker/can_trigger(mob/living/carbon/human/H)
	return !H.has_flaw(/datum/charflaw/addiction/smoker)

/datum/dream_event/negative/vice_smoker/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	var/datum/charflaw/added_flaw = new /datum/charflaw/addiction/smoker()
	H.charflaws.Add(added_flaw)
	added_flaw.on_mob_creation(H)
	to_chat(H, span_boldred("Мои легкие во сне наполняются серым удушливым дымом. Я жажду хорошей затяжки..."))

/datum/dream_event/negative/vice_sadist
	name = "Тяга к чужой боли"
	is_positive = FALSE

/datum/dream_event/negative/vice_sadist/can_trigger(mob/living/carbon/human/H)
	return !H.has_flaw(/datum/charflaw/addiction/sadist)

/datum/dream_event/negative/vice_sadist/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	var/datum/charflaw/added_flaw = new /datum/charflaw/addiction/sadist()
	H.charflaws.Add(added_flaw)
	added_flaw.on_mob_creation(H)
	to_chat(H, span_boldred("Мне снятся предсмертные хрипы и муки моих врагов... Я чувствую, что только страдания других вернут мне покой."))

/datum/dream_event/negative/ghost_visage
	name = "Ночной гость"
	is_positive = FALSE

/datum/dream_event/negative/ghost_visage/on_dream(mob/living/carbon/human/H, datum/sleep_adv/SA)
	to_chat(H, span_boldred("Я чувствую, как сквозь сон чьи-то холодные невидимые пальцы тянутся к моему лицу..."))

/datum/dream_event/negative/ghost_visage/on_wake(mob/living/carbon/human/H, datum/sleep_adv/SA)
	var/turf/T = get_turf(H)
	if(T)
		to_chat(H, span_boldred("Я резко просыпаюсь от леденящего душу шепота у самого уха... Бледный призрачный силуэт зависает надо мной в воздухе и медленно растворяется в темноте!"))
		H.Dizzy(30)
		H.blur_eyes(6)
		H.add_stress(/datum/stressevent/terrible_dreams)

		playsound(T, 'sound/effects/ghost.ogg', 80, FALSE)
