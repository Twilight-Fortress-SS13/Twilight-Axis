GLOBAL_LIST_INIT(ritualslist, build_zizo_rituals())
GLOBAL_LIST_INIT(ritual_counters, list())

/proc/build_zizo_rituals()
	. = list()
	for(var/datum/ritual/ritual as anything in subtypesof(/datum/ritual))
		if(is_abstract(ritual))
			continue
		.[initial(ritual.name)] = ritual

// RITUAL DATUMS
/datum/ritual
	abstract_type = /datum/ritual
	var/name = "DVRK AND EVIL RITVAL"
	var/desk = "" // Описание ритуала, что будет в книжке. Добавляя новый ритуал опишите его, пожалуйста.
	var/center_requirement
	// This is absolutely fucking terrible. I tried to do it with lists but it just didn't work and
	//kept runtiming. Something something, can't access list inside a datum.
	//I couldn't find a more efficient solution to do this, I'm sorry. -7
	var/n_req
	var/e_req
	var/s_req
	var/w_req

	// Насильно присваивает в книгу что нужно положить на руну. 
	// Полезно если ритуал требует, например, аасимара на севере, а культиста по центру. Можно адекватно это вписать.
	// Картинок при этом не будет. В теории, могу улучшить метод, чтоб можно было еще и особые картинки пихать, если потребуется.
	var/north_book
	var/east_book
	var/south_book
	var/west_book
	var/center_book

	/// If zizo followers can't perform this
	var/is_cultist_ritual = FALSE
	var/cultist_number = 0 // Минимальное количество культистов в игре для выполнения ритуала.
	var/ritual_limit = 0 // Сколько раз можно исполнить ритуал. Если 0, то бесконечное число раз.
	var/number_cultist_for_add_limit = 0 // Сколько необходимо культистов для того, чтобы добавить к лимиту ритуала еще единицу сверху. Если 0, то лимит нельзя повысить.

/datum/ritual/proc/invoke(mob/living/user, turf/center)
	return

// Счетчик количества ритуалов
/proc/get_ritual_count(ritual_name)
	if(!GLOB.ritual_counters[ritual_name])
		GLOB.ritual_counters[ritual_name] = 0
	return GLOB.ritual_counters[ritual_name]

/proc/increment_ritual_count(ritual_name)
	if(!GLOB.ritual_counters[ritual_name])
		GLOB.ritual_counters[ritual_name] = 0
	GLOB.ritual_counters[ritual_name]++

// Динамичные лимиты
/proc/get_dynamic_ritual_limit(datum/ritual/ritual, current_cultists)
	var/base_limit = ritual.ritual_limit
	var/cultists_per_additional_limit = ritual.number_cultist_for_add_limit
	
	if(cultists_per_additional_limit <= 0)
		return base_limit
	
	var/additional_limit = 0
	if(current_cultists > ritual.cultist_number)
		var/extra_cultists = current_cultists - ritual.cultist_number
		additional_limit = round(extra_cultists / cultists_per_additional_limit)
	
	return base_limit + additional_limit

/obj/effect/decal/cleanable/sigil/proc/show_ritual_tgui(mob/living/user)
	if(!user.client)
		return
	
	var/list/available_rituals = list()
	var/list/ritual_categories = list()
	
	switch(sigil_type)
		if("Transmutation")
			ritual_categories = subtypesof(/datum/ritual/transmutation)
		if("Fleshcrafting")
			ritual_categories = subtypesof(/datum/ritual/fleshcrafting)
		if("Servantry")
			ritual_categories = subtypesof(/datum/ritual/servantry)
	
	if(!length(ritual_categories))
		return
	
	var/current_cultists = length(SSmapping.retainer.cultists)
	
	for(var/datum/ritual/ritual_type as anything in ritual_categories)
		if(is_abstract(ritual_type))
			continue
		
		var/ritual_name = initial(ritual_type.name)
		var/is_cultist_only = initial(ritual_type.is_cultist_ritual)
		
		if(is_cultist_only && !(is_zizocultist(user.mind) || is_zizolackey(user.mind)))
			continue
		
		available_rituals[ritual_name] = ritual_type
	
	if(!length(available_rituals))
		to_chat(user, span_warning("No rituals for this rune."))
		return
	
	var/chosen_ritual_name = tgui_input_list(user, "Choose Ritual:", "Rituals [sigil_type]", available_rituals)
	if(!chosen_ritual_name || !user.Adjacent(src))
		return
	
	var/ritual_type = available_rituals[chosen_ritual_name]
	var/datum/ritual/pickritual = GLOB.ritualslist[chosen_ritual_name]
	
	if(!pickritual)
		pickritual = new ritual_type()
		GLOB.ritualslist[chosen_ritual_name] = pickritual
	
	// Специальная проверка для ритуала ASCEND
	var/required_cultists = pickritual.cultist_number
	if(istype(pickritual, /datum/ritual/fleshcrafting/ascend))
		var/player_count = length(GLOB.joined_player_list)
		required_cultists = max(1, round(player_count / 6))
		
		if(current_cultists < required_cultists)
			to_chat(user, span_danger("This ritual requires at least [required_cultists] cultists, but there are only [current_cultists]. You need [required_cultists - current_cultists] more cultists."))
			return
	// Обычная проверка для других ритуалов
	else if(required_cultists > 0)
		if(current_cultists < required_cultists)
			to_chat(user, span_danger("This ritual requires at least [required_cultists] cultists, but there are only [current_cultists]. You need [required_cultists - current_cultists] more cultists."))
			return
	
	var/dynamic_limit = get_dynamic_ritual_limit(pickritual, current_cultists)
	
	if(dynamic_limit > 0)
		var/current_count = get_ritual_count(chosen_ritual_name)
		if(current_count >= dynamic_limit)
			if(pickritual.number_cultist_for_add_limit > 0)
				var/needed_cultists_for_more = pickritual.number_cultist_for_add_limit
				var/current_extra_cultists = max(0, current_cultists - required_cultists)
				var/needed_for_next = needed_cultists_for_more - (current_extra_cultists % needed_cultists_for_more)
				
				to_chat(user, span_danger("This ritual can only be performed [dynamic_limit] times, and it has already been performed [current_count] times. You need [needed_for_next] more cultists to perform it again."))
			else
				to_chat(user, span_danger("This ritual can only be performed [dynamic_limit] times, and it has already been performed [current_count] times."))
			return
	
	var/cardinal_success = FALSE
	var/center_success = FALSE
	var/dews = 0

	if(pickritual.e_req)
		for(var/atom/A in get_step(src, EAST))
			if(istype(A, pickritual.e_req))
				dews++
				break
			else
				continue
	else
		dews++

	if(pickritual.s_req)
		for(var/atom/A in get_step(src, SOUTH))
			if(istype(A, pickritual.s_req))
				dews++
				break
			else
				continue
	else
		dews++

	if(pickritual.w_req)
		for(var/atom/A in get_step(src, WEST))
			if(istype(A, pickritual.w_req))
				dews++
				break
			else
				continue
	else
		dews++

	if(pickritual.n_req)
		for(var/atom/A in get_step(src, NORTH))
			if(istype(A, pickritual.n_req))
				dews++
				break
			else
				continue
	else
		dews++

	if(dews >= 4)
		cardinal_success = TRUE

	for(var/atom/A in loc.contents)
		if(!istype(A, pickritual.center_requirement))
			continue
		else
			center_success = TRUE
			break

	var/badritualpunishment = FALSE
	if(cardinal_success != TRUE)
		if(badritualpunishment)
			return
		to_chat(user, span_danger("That's not how you do it, fool."))
		user.electrocute_act(10, src)
		return

	if(center_success != TRUE)
		if(badritualpunishment)
			return
		to_chat(user, span_danger("That's not how you do it, fool."))
		user.electrocute_act(10, src)
		return

	consume_ingredients(pickritual)
	user.playsound_local(user, 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/tesa.ogg', 25)
	user.whisper("O'vena tesa...")

	increment_ritual_count(chosen_ritual_name)
	
	var/datum/ritual/ritual_instance = new ritual_type()
	ritual_instance.invoke(user, loc)

// SERVANTRY
/datum/ritual/servantry
	abstract_type = /datum/ritual/servantry

/datum/ritual/servantry/convert
	name = "Обращение лакея"
	desk = "Обращает жертву в нового лакея!"
	center_book = "Жертва"
	center_requirement = /mob/living/carbon/human
	is_cultist_ritual = TRUE

/datum/ritual/servantry/convert/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target == user)
		return
	if(is_zizocultist(target.mind) || is_zizolackey(target.mind))
		to_chat(user, span_danger("Он уже мой лакей!"))
		return
	if(target.mind.assigned_role == "Gnoll")
		to_chat(user, span_danger("Это граггарское отродье, оно не заслуживает быть моим лакеем..."))
	if(HAS_TRAIT(target, TRAIT_SILVER_WEAK))
		to_chat(user, span_danger("Мне нужны лишь живые..."))
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/skeleton))
		to_chat(user, span_danger("Мертвые слуги уже принадлежат Зизо, их не нужно обращать."))
		return
	if(istype(target.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver) || istype(target.wear_wrists, /obj/item/clothing/neck/roguetown/psicross/silver))
		to_chat(user, span_danger("Он носит серебрянный крест! Он мешает мне обратить его..."))
		return

	var/datum/antagonist/zizocultist/PR = user.mind.has_antag_datum(/datum/antagonist/zizocultist)
	if(!PR)
		return

	to_chat(user, "[target.real_name] было предложено стать лакеем...")
	to_chat(target, span_notice("Вам предлагается путь культа Возвышения. Выбирайте мудро."))

	var/list/options = list(
		"Yield",
		"Resist"
	)

	var/chosen = tgui_input_list(target, "Do you yield to the darkness?", "You are shown the path of Zizo.", options)

	if(!chosen)
		convert_resist(target)
		return

	if(chosen == "Yield")
		convert_yield(target, PR)
	else if(chosen == "Resist")
		convert_resist(target)


/datum/ritual/servantry/convert/proc/convert_yield(mob/living/carbon/human/target, datum/antagonist/zizocultist/PR)
	target.Immobilize(3 SECONDS)
	to_chat(target, span_notice("Правда! Она.. ОНА ОТРКЫЛАСЬ МНЕ! Они совсем не плохие... Я... Должен помогать им!"))
	PR.add_cultist(target.mind)
	target.praise()
	target.playsound_local(target, 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/tesa.ogg', 25)
	target.whisper("O'vena tesa...")
	log_game("[key_name(target)] was converted to Zizoid Lackey by [key_name(PR.owner.current)]")
	message_admins("[key_name(target)] was converted to Zizoid Lackey by [key_name(PR.owner.current)]")

/datum/ritual/servantry/convert/proc/convert_resist(mob/living/carbon/human/target)
	target.Immobilize(3 SECONDS)
	target.visible_message(span_danger("[target] трясется, отказываясь помогать нам!"))
	to_chat(target, span_reallybigredtext("СМЕРТНЫЙ! Я ТРЕБУЮ, ЧТОБЫ ТЫ СТАЛ МОИМ ЛАКЕЕМ ДЛЯ НАШЕГО БУДУЩЕГО!"))
	if(target.electrocute_act(10))
		target.emote("painscream")
	log_game("[key_name(target)] was resist to convert by cultist")

/datum/ritual/servantry/zizofication
	name = "Ритуал Просветления"
	desk = "Ритуал для простых последователей зизо, что не являются культистами. Позволяет обратить кого-либо в веру Зизо."
	center_requirement = /mob/living/carbon/human
	center_book = "Жертва"

/datum/ritual/servantry/zizofication/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents

	if(!target)
		return
	
	var/list/options = list(
		"Yield",
		"Resist"
	)
	if(target.mind && target.mind.has_antag_datum(/datum/antagonist/skeleton))
		to_chat(user, span_danger("В пустых глазницах уже сияет воля Зизо. Просветление им не нужно."))
		return
	
	var/chosen = tgui_input_list(target, "Do you yield to the darkness?", "You are shown the path of Zizo.", options)

	if(!chosen)
		convert_resist(target)
		return

	if(chosen == "Yield")
		convert_yield(target)
	else if(chosen == "Resist")
		convert_resist(target)

/datum/ritual/servantry/zizofication/proc/convert_yield(mob/living/carbon/human/target)
	target.Immobilize(3 SECONDS)
	target.set_patron(/datum/patron/inhumen/zizo)
	to_chat(target, span_notice("Зизо... Она... Она теперь укажет мне верный путь..."))
	target.praise()
	target.playsound_local(target, 'modular_twilight_axis/code/modules/roguetown/rogueantagonists/zizo_cult/sounds/tesa.ogg', 25)
	target.whisper("O'vena tesa...")
	log_game("[key_name(target)] was converted to Zizoid by zizoid!")
	message_admins("[key_name(target)] was converted to Zizoid by zizoid!]")

/datum/ritual/servantry/zizofication/proc/convert_resist(mob/living/carbon/human/target)
	target.Immobilize(3 SECONDS)
	target.visible_message(span_danger("[target] трясется, отказываясь от Зизо!"))
	to_chat(target, span_reallybigredtext("Прими Её путь! СЕЙЧАС ЖЕ!"))
	if(target.electrocute_act(10))
		target.emote("painscream")
	log_game("[key_name(target)] was resist to convert by zizoid")

/datum/ritual/servantry/skeletaljaunt
	name = "Скелетонизация"
	desk = "Превращает жертву в сильного и особого скелета Зизо! А ежели души в теле нет - его тело займет иная душа. Не принимает культистов."
	ritual_limit = 2
	number_cultist_for_add_limit = 2
	center_book = "Жертва"
	center_requirement = /mob/living/carbon/human

	n_req = /obj/item/natural/bone
	s_req = /obj/item/natural/bone
	w_req = /obj/item/natural/bone
	e_req = /obj/item/natural/bone

	is_cultist_ritual = TRUE

/datum/ritual/servantry/skeletaljaunt/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	
	if(target == user)
		return
	
	if(target.mind && is_zizocultist(target.mind))
		to_chat(target, span_danger("I will not let my followers become mindless brutes."))
		return
	
	if(!target.ckey || !target.mind)
		var/list/candidates = pollGhostCandidates("Do you want to play as skeleton?", ROLE_LICH_SKELETON, null, null, 10 SECONDS, POLL_IGNORE_LICH_SKELETON)
		if(!LAZYLEN(candidates))
			to_chat(user, span_warning("The depths are hollow."))
			return

		var/mob/dead/mob = pick(candidates)
		if(!istype(mob))
			return

		if(istype(mob, /mob/dead/new_player))
			var/mob/dead/new_player/new_player = mob
			new_player.close_spawn_windows()

		target.key = mob.key

	if(target.skills)
		target.skills.known_skills = list()
		target.skills.skill_experience = list()
		target.status_traits = list()

	while(target.mind.spell_list.len)
		var/obj/effect/proc_holder/spell/S = target.mind.spell_list[1]
		target.mind.spell_list -= S
		qdel(S)

	while(target.mob_spell_list.len)
		var/obj/effect/proc_holder/spell/S2 = target.mob_spell_list[1]
		target.mob_spell_list -= S2
		qdel(S2)

	target.unequip_everything()
	var/datum/job/summon_job = SSjob.GetJobType(/datum/job/roguetown/skeleton/zizoid)
	target.mind?.set_assigned_role(summon_job)
	summon_job.after_spawn(target, target.client)

	var/datum/advclass/cult/skeleton/zizoid/raider/class = new
	class.equipme(target)
	qdel(class)

	target.choose_name_popup("SKELETON")
	ADD_TRAIT(target, TRAIT_CABAL, TRAIT_GENERIC)

	to_chat(target, span_userdanger("I am returned to serve. I will obey, so that I may return to rest."))
	to_chat(target, span_userdanger("My master is [user]."))

/datum/ritual/servantry/thecall
	name = "Похищение"
	desk = "Дает возможность похитить кого-либо прямо на руну, но только не тех, кто является церковником или под защитой Астраты."
	ritual_limit = 2
	number_cultist_for_add_limit = 2
	center_requirement = /obj/item/bedsheet
	is_cultist_ritual = TRUE

	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg
	n_req = /obj/item/alch/matricaria
	s_req = /obj/item/reagent_containers/food/snacks/grown/manabloom 

/datum/ritual/servantry/thecall/invoke(mob/living/user, turf/center)

	var/input = input(user, "Who we need to kidnap?", "TELEPORT")
	if(!input)
		return
	for(var/mob/living/carbon/human/human in GLOB.human_list)
		if(human.real_name == input)
			if(!user.mind?.do_i_know(name = human.real_name))
				to_chat(user, span_warning("I didn't saw his face."))
				return
			if(!human)
				return

			if(human == SSticker.rulermob)
				return

			if(human.mind?.assigned_role in GLOB.church_positions)
				to_chat(human, span_warning("I sense an unholy presence loom near my soul."))
				to_chat(user, span_danger("They are protected..."))
				return
			
			if(human.mind?.assigned_role in GLOB.noble_positions)
				to_chat(human, span_warning("I sense an unholy presence loom near my soul."))
				to_chat(user, span_danger("They are protected..."))
				return
			
			if(human.mind?.assigned_role in GLOB.retinue_positions)
				to_chat(human, span_warning("I sense an unholy presence loom near my soul."))
				to_chat(user, span_danger("They are protected..."))
				return
			
			if(human.mind?.assigned_role in GLOB.regency_positions)
				to_chat(human, span_warning("I sense an unholy presence loom near my soul."))
				to_chat(user, span_danger("They are protected..."))
				return
			
			if(human.mind?.assigned_role in GLOB.courtier_positions)
				to_chat(human, span_warning("I sense an unholy presence loom near my soul."))
				to_chat(user, span_danger("They are protected..."))
				return

			if(istype(human.wear_neck, /obj/item/clothing/neck/roguetown/psicross/silver) || istype(human.wear_wrists, /obj/item/clothing/neck/roguetown/psicross/silver))
				to_chat(user, span_danger("They are wearing silver, it resists the dark magick!"))
				return

			if(!HAS_TRAIT(human, TRAIT_NOSLEEP))
				to_chat(human, span_userdanger("I'm so sleepy..."))
				human.SetSleeping(5 SECONDS)
			else
				to_chat(human, span_userdanger("My eyes close on their own!"))
				human.set_eyes_closed(TRUE)

			addtimer(CALLBACK(src, PROC_REF(kidnap), human, center), 3 SECONDS)

/datum/ritual/servantry/thecall/proc/kidnap(mob/living/victim, turf/to_go)
	if(QDELETED(victim))
		return
	if(to_go.is_blocked_turf(TRUE))
		return
	victim.SetSleeping(0)
	to_chat(victim, span_warning("This isn't my bed... Where am I?!"))
	victim.playsound_local(victim, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg'), 100)
	if (!istype(victim, /mob/living/carbon/human/dummy))
		victim.forceMove(to_go)

/datum/ritual/servantry/falseappearance
	name = "Ложный облик"
	desk = "Меняет внешность на случайную. Не дает вернуть её назад."
	center_book = "Культист"
	center_requirement = /mob/living/carbon/human

	n_req = /obj/item/bodypart/head
	s_req = /obj/item/rogueweapon/huntingknife/stoneknife
	e_req = /obj/item/rogueweapon/huntingknife/stoneknife
	w_req = /obj/item/rogueweapon/huntingknife/stoneknife

/datum/ritual/servantry/falseappearance/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.mob_biotypes & MOB_UNDEAD)
		to_chat(user, span_warning("The fruits of her work prevent me from changing my appearance..."))
		return
	target.randomize_human_appearance(include_donator = FALSE)
	target.regenerate_clothes()
	target.update_body()

/datum/ritual/servantry/heartache
	name = "Страдание"
	desk = "Призывает проклятое сердце, кое может помочь в захвате жертв. Не поможет в бою."
	center_requirement = /obj/item/organ/heart

	n_req = /obj/item/natural/worms/leech
	s_req = /obj/item/alch/sinew
	w_req = /obj/item/alch/viscera
	e_req = /obj/item/alch/taraxacum

/datum/ritual/servantry/heartache/invoke(mob/user, turf/center)
	new /obj/item/corruptedheart(center)
	to_chat(user, span_notice("A corrupted heart. When used on a non-enlightened mortal their heart shall ache and they will be immobilized and too stunned to speak. Perfect for getting new soon-to-be enlightened. Now, just don't use it at the combat ready."))

/obj/item/corruptedheart
	name = "corrupted heart"
	desc = "It sparkles with forbidden magic energy. It makes all the heart aches go away."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "heart-on"
	w_class =  WEIGHT_CLASS_SMALL

/obj/item/corruptedheart/attack(mob/living/target, mob/living/user, params)
	if(!istype(user.patron, /datum/patron/inhumen/zizo))
		return
	if(istype(target.patron, /datum/patron/inhumen/zizo))
		target.blood_volume = BLOOD_VOLUME_MAXIMUM
		to_chat(target, span_notice("My elixir of life is stagnant once again."))
		qdel(src)
		return
	if(!do_after(user, 2 SECONDS, target))
		return
	if(target.cmode)
		user.electrocute_act(30)
	target.Stun(10 SECONDS)
	if(iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.silent += 30
	qdel(src)

/*/datum/ritual/servantry/darksunmark //Надо будет переделать мб, или хуй забить
	name = "Dark Sun's Mark"
	desk = "Помечает выбранное существо как цель культа. Также ассассины получают о нем информацию.."
	center_requirement = /obj/item/rogueweapon/huntingknife/idagger // Requires a combat dagger. Can be iron, steel or silver.

/datum/ritual/servantry/darksunmark/invoke(mob/living/user, turf/center)
	var/obj/item/rogueweapon/huntingknife/idagger/D = locate() in center.contents
	if(!D)
		to_chat(user, span_warning("A dagger is required as a sacrifice."))
		return

	var/mob/living/carbon/human/target = tgui_input_list(user, "CHOOSE TARGET", "TELEPORT", GLOB.human_list)

	if(!target)
		return

	if(!user.mind?.do_i_know(name = target.real_name))
		to_chat(user, span_warning("I didn't saw his face."))
		return
	
	var/assassin_found = FALSE
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HAS_TRAIT(HL, TRAIT_ASSASSIN))
			assassin_found = TRUE
			var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/dagger = locate() in HL.get_all_gear()
			if(dagger)
				to_chat(HL, "profane dagger whispers, <span class='danger'>\"The terrible Zizo has called for our aid. Hunt and strike down our common foe, [target.real_name]!\"</span>")
	if(!target || !assassin_found)
		to_chat(user, span_warning("There has been no answer to your call to the Dark Sun. It seems his servants are far from here..."))
		return
	ADD_TRAIT(target, TRAIT_ZIZOID_HUNTED, TRAIT_GENERIC) // Gives the victim a trait to track that they are wanted dead.
	log_hunted("[key_name(target)] playing as [target] had the hunted flaw by Zizoid curse.")
	to_chat(target, span_danger("My hair stands on end. Has someone just said my name? I should watch my back."))
	to_chat(user, span_warning("Your target has been marked, your profane call answered by the Dark Sun. [target.real_name] will surely perish!"))
	qdel(D)
	target.playsound_local(target, 'sound/magic/marked.ogg', 100) */

// TRANSMUTATION
/datum/ritual/transmutation
	abstract_type = /datum/ritual/transmutation

/datum/ritual/transmutation/allseeingeye
	name = "Всевидящее око"
	desk = "Призывает всевидящее око."
	center_requirement = /obj/item/organ/eyes

/datum/ritual/transmutation/allseeingeye/invoke(mob/living/user, turf/center)
	. = ..()
	new /obj/item/scrying/eye(center)
	to_chat(user, span_notice("The All-seeing Eye. To see beyond sight."))

/datum/ritual/transmutation/book
	name = "Призыв ритуальной книги"
	desk = "Заменяет обычную книгу на книгу, которая поможет новым культистам с ритуалами."
	center_requirement = /obj/item/book/rogue

/datum/ritual/transmutation/book/invoke(mob/living/user, turf/center)
	. = ..()

	new /obj/item/recipe_book/zizo(center)

	to_chat(user, span_notice("Now you know how to make another ritual..."))

/datum/ritual/transmutation/cross
	name = "Призыв амулета Зизо"
	desk = "Призывает особый крест Зизо, который и защитит, и одарит Её милостинью."
	center_requirement = /obj/item/clothing/neck/roguetown/psicross

	n_req = /obj/item/natural/bone
	s_req = /obj/item/natural/bone
	w_req = /obj/item/natural/bone
	e_req = /obj/item/natural/bone

/datum/ritual/transmutation/cross/invoke(mob/living/user, turf/center)
	. = ..()
	new /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult(center)
	to_chat(user, span_notice("The psycross is transmuted into an amulet of Zizo."))

/datum/ritual/transmutation/repaircross
	name = "Восполнить амулет"
	desk = "Восполняет амулет зизо, возвращая его защиту."
	center_requirement = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult

	w_req = /obj/item/natural/bone
	e_req = /obj/item/natural/bone

/datum/ritual/transmutation/repaircross/invoke(mob/living/user, turf/center)
	. = ..()
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	playsound(get_turf(center), pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

	new /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy/cult(center)
	to_chat(user, span_notice("Крест вновь может защитить вас.."))

/datum/ritual/transmutation/criminalstool
	name = "Призыв мыла Зизо"
	desk = "Призывает мыло Зизо."
	center_requirement = /obj/item/natural/cloth

/datum/ritual/transmutation/criminalstool/invoke(mob/living/user, turf/center)
	new /obj/item/soap/cult(center)
	to_chat(user, span_notice("The Criminal's Tool. Could be useful for hiding tracks or getting rid of sigils."))

/obj/item/soap/cult
	name = "accursed soap"
	desc = "It is pulsating."
	color = LIGHT_COLOR_BLOOD_MAGIC
	uses = 1000

/*/datum/ritual/transmutation/propaganda
	name = "Propaganda"
	desk = "А это будем менять потом"
	center_requirement = /obj/item/natural/worms/leech
	n_req = /obj/item/paper
	s_req = /obj/item/natural/feather

/datum/ritual/transmutation/propaganda/invoke(mob/living/user, turf/center)
	new /obj/item/natural/worms/leech/propaganda(center)
	to_chat(user, span_notice("A leech to make their minds wrangled. They'll be in bad spirits.")) */

/datum/ritual/transmutation/invademind
	name = "Сообщение"
	desk = "Отправляет сообщение существу."
	center_requirement = /obj/item/paper

/datum/ritual/transmutation/invademind/invoke(mob/living/user, turf/center)
	var/text = tgui_input_text(user, "ENTER MESSAGE", "MESSAGE")

	if(!text)
		return

	var/input = input(user, "To whom do we send this message?", "ZIZO")
	if(!input)
		return
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == input)
			to_chat(HL, "<i>You hear a voice in your head... <b>[text]</i></b>")

/datum/ritual/transmutation/summonoutfit
	name = "Призыв снаряжения культа"
	desk = "Призывает снаряжение культа. Легкая броня и цепь."
	center_requirement = /obj/item/natural/cloth

	n_req = /obj/item/ingot/iron

/datum/ritual/transmutation/summonoutfit/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/clothing/head/roguetown/helmet/skullcap/cult(center)

	new /obj/item/clothing/cloak/half/shadowcloak/cult(center)

	new /obj/item/clothing/suit/roguetown/armor/brigandine/light/cult(center)

	new /obj/item/rope/chain(center)

	playsound(get_turf(center), pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/transmutation/summonneant
	name = "Призыв Косы"
	desk = "Призывает Особую косу Зизо."
	center_requirement = /obj/item/reagent_containers/lux

	w_req = /obj/item/ingot/steel
	e_req = /obj/item/ingot/steel

	is_cultist_ritual = TRUE

/datum/ritual/transmutation/summonneant/invoke(mob/living/user, turf/center)

	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/rogueweapon/zizo/neant(center)

	playsound(get_turf(center), pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/transmutation/summonarmor
	name = "Призыв доспехов Зизо"
	desk = "Призывает доспехи Зизо."
	cultist_number = 3
	number_cultist_for_add_limit = 1
	ritual_limit = 1
	center_book = "Культист"
	
	center_requirement = /mob/living/carbon/human
	n_req = /obj/item/ingot/steel
	s_req = /obj/item/ingot/steel

	is_cultist_ritual = TRUE

/datum/ritual/transmutation/summonarmor/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat == DEAD)
		target.gib(FALSE, FALSE, FALSE)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/clothing/suit/roguetown/armor/plate/full/zizo(center)

	new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zizo(center)

	new /obj/item/clothing/under/roguetown/platelegs/zizo(center)

	new /obj/item/clothing/shoes/roguetown/boots/armor/zizo(center)

	new /obj/item/clothing/wrists/roguetown/bracers/zizo(center)

	new /obj/item/clothing/gloves/roguetown/plate/zizo(center)

	new /obj/item/clothing/head/roguetown/helmet/heavy/zizo(center)

	new /obj/item/clothing/neck/roguetown/bevor/zizo(center)

	playsound(get_turf(center), pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)
	ADD_TRAIT(target,TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)

/datum/ritual/transmutation/summonweapon
	name = "Призыв Оружия"
	desk = "Призывает набор оружия, включая меч Зизо."
	center_requirement = /obj/item/rogueweapon/sword

	n_req = /obj/item/natural/bundle/bone
	e_req = /obj/item/natural/bundle/bone
	s_req = /obj/item/natural/bundle/bone
	w_req = /obj/item/natural/bundle/bone

/datum/ritual/transmutation/summonweapon/invoke(mob/living/user, turf/center)
	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()

	new /obj/item/rogueweapon/sword/long/zizo(center)

	playsound(get_turf(center), pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

// FLESH CRAFTING
/datum/ritual/fleshcrafting
	abstract_type = /datum/ritual/fleshcrafting

/datum/ritual/fleshcrafting/bunnylegs
	name = "Сильные ноги"
	desk = "Даёт возможность прыгать довольно-таки высоко.."
	cultist_number = 2
	number_cultist_for_add_limit = 1
	ritual_limit = 1
	center_book = "Культист"
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/bodypart/l_leg
	e_req = /obj/item/bodypart/r_leg
	n_req = /obj/item/alch/horn
	s_req = /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius

	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/bunnylegs/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_ZJUMP, TRAIT_GENERIC)
	to_chat(target, span_notice("I feel like my legs have become stronger."))

/datum/ritual/fleshcrafting/fleshmend
	name = "Плотолечение"
	desk = "Одаривает цель полным исцелением."
	center_book = "Пострадавший"
	center_requirement = /mob/living/carbon/human
	n_req =  /obj/item/alch/viscera
	s_req = /obj/item/alch/calendula

/datum/ritual/fleshcrafting/fleshmend/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	target.playsound_local(target, 'sound/misc/vampirespell.ogg', 100, FALSE, pressure_affected = FALSE)
	target.fully_heal()
	target.revive()
	target.regenerate_limbs()
	target.apply_status_effect(/datum/status_effect/debuff/fleshmend_exhaustion)
	target.heal_wounds()
	target.apply_status_effect(/datum/status_effect/debuff/fleshmend_exhaustion)
	to_chat(target, span_notice("ZIZO EMPOWERS ME!"))

/datum/ritual/fleshcrafting/darkeyes
	name = "Глаза ночи"
	desk = "Заменяет глаза на особые, которые крайне хорошо видят в темноте, но имеют одно НО.."
	center_requirement = /mob/living/carbon/human

	w_req = /obj/item/alch/viscera
	e_req = /obj/item/natural/bundle/bone
	n_req = /obj/item/organ/eyes

/datum/ritual/fleshcrafting/darkeyes/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(target, TRAIT_ZIZOEYES, TRAIT_GENERIC)
	to_chat(target, span_notice("Я больше не боюсь темноты. Но теперь мне стоит скрывать мои глаза.."))

/datum/ritual/fleshcrafting/undead
	name = "Реликвия некроманта"
	desk = "Принеся дары Ей, можно будет получить особый кристалл."
	ritual_limit = 2
	number_cultist_for_add_limit = 2
	center_requirement = /obj/item/natural/glass_shard

	w_req = /obj/item/organ/brain
	e_req = /obj/item/organ/brain
	n_req = /obj/item/alch/bone
	s_req = /obj/item/natural/bundle/bone

	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/undead/invoke(mob/living/user, turf/center)

	var/datum/effect_system/spark_spread/S = new(center)
	S.set_up(1, 1, center)
	S.start()
	new /obj/item/necro_relics/necro_crystal(center)
	playsound(get_turf(center), pick('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg'), 100, FALSE)

/datum/ritual/fleshcrafting/arcane
	name = "Поглощение Арканы"
	desk = "Принеся в жертву мага, одаривает культиста очками на изучение заклинаний и повышает его навык владения арканой. Нужно изначально быть магом..."
	cultist_number = 2
	number_cultist_for_add_limit = 3
	ritual_limit = 1
	center_book = "Культист"
	north_book = "Маг"
	center_requirement = /mob/living/carbon/human

	n_req = /mob/living/carbon/human

	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/arcane/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/cultist = locate() in center.contents
	var/mob/living/carbon/human/mage = locate() in get_step(center, NORTH)
	if(mage.has_status_effect(/datum/status_effect/debuff/arcynestolen))
		to_chat(cultist, span_notice("This mage is already was arcane drained..."))
		return
	mage.apply_status_effect(/datum/status_effect/debuff/arcynestolen)
	mage.Stun(30)
	mage.Knockdown(30)
	cultist.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	cultist.mind.adjust_spellpoints(16)
	to_chat(cultist, span_notice("Stolen Arcane prowess floods my mind, ZIZO empowers me."))

///datum/ritual/fleshcrafting/curse
//	name = "Hollow Curse"
//	desk = "Поменяем потом его или удалим"
//	center_requirement = /mob/living/carbon/human

//	w_req = /obj/item/alch/sinew
//	e_req = /obj/item/alch/sinew
//	n_req = /obj/item/natural/fur/wolf
//	s_req = /obj/item/natural/fur/wolf

///datum/ritual/fleshcrafting/curse/invoke(mob/living/user, turf/center)
//	var/mob/living/carbon/human/target = locate() in center.contents
//	if(!target)
//		return
//	if(!target.mind)
//		to_chat(target, span_warning("A mindless servant is useless to me!"))
//		return
//	if(target.mob_biotypes & MOB_UNDEAD)
//		to_chat(target, span_warning("The curse doesn't take hold!"))
//		return
//	if(target.mind.has_antag_datum(/datum/antagonist/werewolf))
//		to_chat(target, span_warning("The curse doesn't take hold!"))
//		return
//	to_chat(target, span_warning("My very being, body, soul, and mind is contorted and twisted violently into a ball of flesh and fur, until I am reshaped anew as an abomination!"))
//	addtimer(CALLBACK(src, PROC_REF(get_hollowed), target, center), 5 SECONDS)

///datum/ritual/fleshcrafting/curse/proc/get_hollowed(mob/living/victim, turf/place)
//	if(QDELETED(victim))
//		return
//	if(place != get_turf(victim))
//		return
//	if(!victim.mind)
//		return
//	var/mob/living/wll = new /mob/living/carbon/human/species/demihuman(place)
//	victim.mind.transfer_to(wll)
//	victim.gib()

/datum/ritual/fleshcrafting/nopain
	name = "Безболезненный бой"
	desk = "Вы перестанете чувствовать боль... Но какой ценой?"
	center_requirement = /mob/living/carbon/human
	center_book = "Культист"

	w_req = /obj/item/organ/heart
	e_req = /obj/item/organ/brain
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	s_req = /obj/item/alch/horn

/datum/ritual/fleshcrafting/nopain/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
	to_chat(target, span_notice("I no longer feel pain, but it has come at a terrible cost."))
	target.change_stat(STATKEY_STR, -2)
	target.change_stat(STATKEY_CON, -1)
	target.change_stat(STATKEY_WIL, -2)

/datum/ritual/fleshcrafting/immortality
	name = "Несовершенное бессмертие"
	desk = "Принеся в жертву аасимара, вы получите множество сил, но и заплатите определенную цену."
	center_book = "Культист"
	north_book = "Живой аасимар"
	center_requirement = /mob/living/carbon/human

	n_req = /mob/living/carbon/human
	
/datum/ritual/fleshcrafting/immortality/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	var/mob/living/carbon/human/victim = locate() in get_step(center, NORTH)
	if(!(is_species(victim, /datum/species/aasimar)))
		return
	if(victim.has_status_effect(/datum/status_effect/debuff/ritualdefiled/cult))
		to_chat(target, span_notice("This aasimar is already used in ritual..."))
		return
	victim.apply_status_effect(/datum/status_effect/debuff/ritualdefiled/cult)
	victim.Stun(30)
	victim.Knockdown(30)
	ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_HARDDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NODEATH, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_WOUNDREGEN, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_SPELLCOCKBLOCK, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_NOSLEEP, TRAIT_GENERIC)
	to_chat(target, span_notice("ZIZO EMPOWERS ME!! SOMETHING HAS GONE WRONG, THE RITUAL FAILED BUT WHAT IT LEFT ME WITH IS STILL POWER!!"))
	target.change_stat(STATKEY_STR, -3)
	target.change_stat(STATKEY_SPD, -3)
	target.change_stat(STATKEY_WIL, -3)
	target.Knockdown(5 SECONDS)
	target.emote("agony", forced = TRUE)
	target.mind.AddSpell(new /obj/effect/proc_holder/spell/self/zizo_regenerate)

/datum/ritual/fleshcrafting/fleshform
	name = "Форма Плоти"
	desk = "Превращает жертву в глупую живую плоть."
	cultist_number = 4
	center_requirement = /mob/living/carbon/human
	center_book = "Жертва"

	w_req = /obj/item/organ/heart
	e_req = /obj/item/organ/heart
	n_req = /obj/item/reagent_containers/food/snacks/rogue/meat
	s_req = /obj/item/reagent_containers/food/snacks/rogue/meat
	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/fleshform/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(is_zizocultist(target.mind))
		to_chat(target, span_danger("I'm not letting my strongest follower become a mindless brute."))
		return
	if(!target.mind)
		to_chat(target, span_warning("A mindless beast will not serve our cause."))
		return
	to_chat(target, span_warning("SOON I WILL BECOME A HIGHER FORM!"))
	addtimer(CALLBACK(src, PROC_REF(flesh_convert), target, center), 5 SECONDS)

/datum/ritual/fleshcrafting/fleshform/proc/flesh_convert(mob/living/victim, turf/place)
	if(QDELETED(victim))
		return
	if(place != get_turf(victim))
		return
	if(!victim.mind)
		return
	var/mob/living/trl = new /mob/living/simple_animal/hostile/retaliate/blood(place)
	victim.mind.transfer_to(trl)
	victim.gib()

/datum/ritual/fleshcrafting/gutted
	name = "Потрошение"
	desk = "Потрошит труп, вынимая все органы и отрубая все конечности."
	center_requirement = /mob/living/carbon/human // One to be gutted.human
	center_book = "Мертвое тело"

/datum/ritual/fleshcrafting/gutted/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat != DEAD)
		return
	target.take_overall_damage(500)
	center.visible_message(span_danger("[target] is lifted up into the air and multiple scratches, incisions and deep cuts start etching themselves into their skin as all of their internal organs spill on the floor below!"))
	var/atom/drop_location = target.drop_location()
	for(var/obj/item/organ/organ as anything in target.internal_organs)
		organ.Remove(target)
		organ.forceMove(drop_location)
	var/obj/item/bodypart/chest/cavity = target.get_bodypart(BODY_ZONE_CHEST)
	if(cavity.cavity_item)
		cavity.cavity_item.forceMove(drop_location)
		cavity.cavity_item = null
	for(var/obj/item/bodypart/part as anything in target.bodyparts)
		part.drop_limb()

/* /datum/ritual/fleshcrafting/badomen
	name = "Bad Omen"
	center_requirement = /mob/living/carbon/human
	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/badomen/invoke(mob/living/user, turf/center)
	var/mob/living/carbon/human/target = locate() in center.contents
	if(!target)
		return
	if(target.stat == DEAD)
		target.gib(FALSE, FALSE, FALSE)
		addomen(OMEN_ROUNDSTART) */

/datum/ritual/fleshcrafting/ascend
	name = "!ВОЗВЫШЕНИЕ!"
	desk = "ЗАКОНЧИ ЭТО. ДАВАЙ!! РАДИ ЗИЗО!!!"
	center_requirement = /mob/living/carbon/human // cult leader
	n_req = /mob/living/carbon/human // the ruler
	center_book = "Лидер"
	north_book = "Цель возвышения"

	is_cultist_ritual = TRUE

/datum/ritual/fleshcrafting/ascend/invoke(mob/living/user, turf/center)
	// Динамический расчет требуемых культистов. Формулу можно поменять как угодно. Пока затычка на 1/6
	var/player_count = length(GLOB.joined_player_list)
	var/required_cultists = max(1, round(player_count / 6))
	// Меняя формулу и требование меняйте это все и в /mob/living/carbon/human/proc/ascension_check() чтобы оно совпадало и не псиопило культистов
	var/current_cultists = length(SSmapping.retainer.cultists)
	
	if(current_cultists < required_cultists)
		to_chat(user, span_danger("This ritual requires at least [required_cultists] cultists, but there are only [current_cultists]. You need [required_cultists - current_cultists] more cultists."))
		return
	
	var/mob/living/carbon/human/cultist = locate() in center.contents
	if(!cultist || cultist != user)
		return
	if(!is_zizocultist(cultist.mind))
		return
	
	// Поиск жертвы по приоритету
	var/mob/living/carbon/human/sacrifice_target = null
	var/target_role = null
	var/obj/item/clothing/head/roguetown/crown/crown_target = null
	
	// Приоритет 1: Герцог (SSticker.rulermob)
	if(SSticker.rulermob && istype(SSticker.rulermob, /mob/living/carbon/human))
		var/mob/living/carbon/human/ruler = SSticker.rulermob
		if(ruler.stat != DEAD)
			sacrifice_target = ruler
			target_role = "Ruler"
	
	// Приоритет 2: Епископ
	if(!sacrifice_target)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat == DEAD)
				continue
			var/role_title
			if(H.mind && H.mind.assigned_role)
				if(istext(H.mind.assigned_role))
					role_title = H.mind.assigned_role
				else if(istype(H.mind.assigned_role))
					role_title = H.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Bishop")
				sacrifice_target = H
				target_role = "Bishop"
				break
	
	// Приоритет 3: Десница
	if(!sacrifice_target)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat == DEAD)
				continue
			var/role_title
			if(H.mind && H.mind.assigned_role)
				if(istext(H.mind.assigned_role))
					role_title = H.mind.assigned_role
				else if(istype(H.mind.assigned_role))
					role_title = H.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Hand")
				sacrifice_target = H
				target_role = "Hand"
				break
	
	// Приоритет 4: Принц или Принцесса
	if(!sacrifice_target)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat == DEAD)
				continue
			var/role_title
			if(H.mind && H.mind.assigned_role)
				if(istext(H.mind.assigned_role))
					role_title = H.mind.assigned_role
				else if(istype(H.mind.assigned_role))
					role_title = H.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Prince" || role_title == "Princess")
				sacrifice_target = H
				target_role = role_title
				break
	
	// Приоритет 5: Маршал
	if(!sacrifice_target)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat == DEAD)
				continue
			var/role_title
			if(H.mind && H.mind.assigned_role)
				if(istext(H.mind.assigned_role))
					role_title = H.mind.assigned_role
				else if(istype(H.mind.assigned_role))
					role_title = H.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Marshal")
				sacrifice_target = H
				target_role = "Marshal"
				break
	
	// Приоритет 6: Придворный маг
	if(!sacrifice_target)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat == DEAD)
				continue
			var/role_title
			if(H.mind && H.mind.assigned_role)
				if(istext(H.mind.assigned_role))
					role_title = H.mind.assigned_role
				else if(istype(H.mind.assigned_role))
					role_title = H.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Court Magician")
				sacrifice_target = H
				target_role = "Court Magician"
				break
	
	// Приоритет 7: Рыцарь-капитан
	if(!sacrifice_target)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat == DEAD)
				continue
			var/role_title
			if(H.mind && H.mind.assigned_role)
				if(istext(H.mind.assigned_role))
					role_title = H.mind.assigned_role
				else if(istype(H.mind.assigned_role))
					role_title = H.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Knight Captain")
				sacrifice_target = H
				target_role = "Knight Captain"
				break
	
	// Приоритет 8: Казначей
	if(!sacrifice_target)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.stat == DEAD)
				continue
			var/role_title
			if(H.mind && H.mind.assigned_role)
				if(istext(H.mind.assigned_role))
					role_title = H.mind.assigned_role
				else if(istype(H.mind.assigned_role))
					role_title = H.mind.assigned_role.title
				else
					role_title = null
			else
				role_title = null
			if(role_title == "Steward")
				sacrifice_target = H
				target_role = "Steward"
				break
	
	// Приоритет 9: Корона
	if(!sacrifice_target)
		for(var/obj/item/clothing/head/roguetown/crown/C in get_step(center, NORTH))
			crown_target = C
			target_role = "Crown"
			break
	
	if(!sacrifice_target && !crown_target)
		to_chat(user, span_danger("No suitable sacrifice found. Check ascension requirements."))
		return
	
	if(sacrifice_target)
		var/mob/living/carbon/human/RULER = locate() in get_step(center, NORTH)
		if(RULER != sacrifice_target)
			to_chat(user, span_danger("[sacrifice_target.real_name] ([target_role]) must stand on the northern cell of the sigil."))
			return
		
		if(sacrifice_target.stat == DEAD)
			to_chat(user, span_danger("[sacrifice_target.real_name] ([target_role]) must be alive for this ritual."))
			return
		
		sacrifice_target.gib()
		to_chat(user, span_notice("You have sacrificed [sacrifice_target.real_name], the [target_role]!"))
	else if(crown_target)
		qdel(crown_target)
		to_chat(user, span_notice("You have sacrificed the Crown!"))
	
	SSmapping.retainer.cult_ascended = TRUE
	addomen(OMEN_ASCEND)
	to_chat(cultist, span_userdanger("I HAVE DONE IT! I HAVE REACHED A HIGHER FORM! ZIZO SMILES UPON ME WITH MALICE IN HER EYES TOWARD THE ONES WHO LACK KNOWLEDGE AND UNDERSTANDING!"))
	var/mob/living/trl = new /mob/living/simple_animal/hostile/retaliate/blood/ascended(center)
	cultist.mind?.transfer_to(trl)
	cultist.gib()
	priority_announce("The sky blackens, a dark day for Psydonia.", "Ascension", 'sound/misc/zizo.ogg')
	for(var/mob/living/carbon/human/V in GLOB.human_list)
		if(V.mind in SSmapping.retainer.cultists)
			V.add_stress(/datum/stressevent/lovezizo)
		else
			V.add_stress(/datum/stressevent/hatezizo)
	SSvote.started_time = world.time - CONFIG_GET(number/vote_delay) - 10
	SSvote.initiate_vote("endround", "AHAHAHAHAHAHAHAHAHHA")
