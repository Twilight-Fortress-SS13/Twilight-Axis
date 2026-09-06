#define BLOODLOCK_AWAKEN_TIME 90 SECONDS
#define BLOODLOCK_LOSS_TIME 120 SECONDS
#define BLOODLOCK_VITAE_PER_DRINK 90
#define BLOODLOCK_PHRASE_TIME 1200 SECONDS

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock
	name = "bloodlock rifle"
	desc = "Оружие скованное тёмными эльфами, глубоко во тьме Подземий. Выглядит...Живым?"
	icon = 'modular_twilight_axis/firearms/icons/bloodlock.dmi'
	icon_state = "bloodlock"
	icon_state_ready = "bloodlock_r"
	default_icon_state = "bloodlock"
	item_state = "bloodlock"
	associated_skill = /datum/skill/combat/staves
	possible_item_intents = list(/datum/intent/mace/strike/wood)
	gripped_intents = list(/datum/intent/shoot/twilight_runelock, /datum/intent/arc/twilight_runelock, INTENT_GENERIC)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/twilight_bloodlock
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	experimental_onback = TRUE
	bigboy = TRUE
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	spread = 10
	var/vitae_cost = 200
	recoil = 3
	force = 10
	force_wielded = 15
	cocked = FALSE
	var/mob/living/carbon/human/bloodlock_owner
	var/bloodlock_awakened = FALSE
	var/bloodlock_awaken_timer
	var/bloodlock_phrase_timer
	var/mob/living/carbon/human/bloodlock_phrase_user
	var/bloodlock_loss_timer
	var/previous_maxbloodpool = 0
	var/last_slot
	cartridge_wording = "bullet"
	load_sound = 'modular_twilight_axis/firearms/sound/musketload.ogg'
	fire_sound = 'modular_twilight_axis/firearms/sound/musketfire2.ogg'
	fire_sound_variations = list(
		'modular_twilight_axis/firearms/sound/musketfire2.ogg' = 99.99,
		'modular_twilight_axis/firearms/sound/musketfire11.ogg' = 0.01, //little secret
	)
	vary_fire_sound = TRUE
	fire_sound_volume = 200
	anvilrepair = null
	smeltresult = /obj/item/ingot/steel
	/// Chance for the weapon to misfire
	misfire_chance = 0
	/// Reload time, in SECONDS
	reload_time = 15
	damfactor = 1.1
	critfactor = 1
	npcdamfactor = 4

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "GUN")
	addtimer(CALLBACK(src, PROC_REF(bloodlock_random_phrase)), BLOODLOCK_PHRASE_TIME)

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_WEAPON)

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/attack_self(mob/living/user)
	if(twohands_required)
		return
	if(altgripped || wielded) //Trying to unwield it
		ungrip(user)
		return
	if(!cocked)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(HAS_TRAIT(H, TRAIT_ARCYNE) && HAS_TRAIT(H, TRAIT_VAMPBITE))
				if(H.bloodpool < vitae_cost)
					to_chat(H, span_warning("Ружье требует больше крови!"))
					if(prob(5))
						to_chat(H, "<span style='color:#5E2129'>The Bloodlock</span> slurs, " + span_cult(pick("<i>\"Мне не хватает твоей крови, найди беднягу!\"</i>", "<i>\"Мне нужно больше крови\"</i>", "<i>\"Ну же, забери у любого крови, для меня!\"</i>", "<i>\"Мне нечем запитаться...\"</i>")))
					return
				to_chat(H, span_warning("Ружье начинает вибрировать и запитываться..."))
				if(prob(5))
					to_chat(H, "<span style='color:#5E2129'>The Bloodlock</span> slurs, " + span_cult(pick("<i>\"Да, да, ДА! Какое же блаженство...\"</i>","<i>\"Этот прилив сил...Пристрели шавку!\"</i>","<i>\"Они поплатятся за то, что поднимут на тебя клинок!\"</i>")))
				playsound(src,'modular_twilight_axis/firearms/sound/bloodreload.ogg', 150, FALSE)
				var/adj_reload_time = reload_time
				if(H.mind)
					var/skill = H.get_skill_level(/datum/skill/combat/twilight_firearms)
					if(skill)
						adj_reload_time = reload_time / skill
				if(move_after(H, adj_reload_time SECONDS, target = H))
					H.adjust_bloodpool(-vitae_cost)
					H.update_action_buttons()
					playsound(H, 'modular_twilight_axis/firearms/sound/musketcock.ogg', 100, FALSE)
					cocked = TRUE
			else
				to_chat(H, "<span class='warning'>Я совершенно не понимаю, как этим пользоваться!</span>")
		else
			to_chat(user, "<span class='warning'>Я совершенно не понимаю, как этим пользоваться!</span>")
	else
		if(alt_grips)
			altgrip(user)
		if(gripped_intents)
			wield(user)
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/get_special_examine_hint(mob/living/carbon/human/user)
	if(!HAS_TRAIT(user, TRAIT_ARCYNE))
		return

	return span_info("Это оружие оснащено арканным замком — для стрельбы достаточно взвести курок, но зарядить его можно лишь своей кровью и знаниями.")

/obj/item/ammo_box/magazine/internal/shot/twilight_bloodlock
	ammo_type = /obj/item/ammo_casing/caseless/rogue/twilight_lead
	caliber = "lead_sphere"
	max_ammo = 1
	start_empty = TRUE

/datum/intent/shoot/twilight_bloodlock
	chargedrain = 0

/datum/intent/shoot/twilight_bloodlock/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 75
		newtime = newtime - (mastermob.get_skill_level(/datum/skill/combat/twilight_firearms) * 15)
		//per block
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/arc/twilight_bloodlock
	chargetime = 1
	chargedrain = 0

/datum/intent/arc/twilight_bloodlock/get_chargetime()
	if(mastermob && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 70
		newtime = newtime - (mastermob.get_skill_level(/datum/skill/combat/twilight_firearms) * 15)
		//per block
		newtime = newtime + 20
		newtime = newtime - ((mastermob.STAPER)*1.5)
		if(newtime > 0)
			return newtime
		else
			return 1
	return chargetime

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/is_blood_raider(mob/living/carbon/human/H)
	if(!H?.mind)
		return FALSE
	if(HAS_TRAIT_FROM(H, TRAIT_VAMPBITE, "bloodraider"))
		return TRUE
	return FALSE

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/can_awaken(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(HAS_TRAIT(H, TRAIT_ARCYNE))
		return TRUE
	return FALSE

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(slot != ITEM_SLOT_HANDS)
		last_slot = slot
		return

	if(last_slot == ITEM_SLOT_BACK)
		last_slot = null
		if(H == bloodlock_owner && bloodlock_awakened)
			reset_loss_timer()

		return

	last_slot = null

	if(is_blood_raider(H))
		if(prob(10))
			to_chat(H, "<span style='color:#5E2129'>The Bloodlock</span> slurs, " + span_cult(pick("<i>\"Здравствуй...", "<i>\"Приветствую!", "<i>\"Я скучал...", "<i>\"Направь меня, дай выстрелить!")))
		return

	if(bloodlock_awakened)
		if(H == bloodlock_owner)
			reset_loss_timer()
			if(prob(10))
				to_chat(H, "<span style='color:#5E2129'>The Bloodlock</span> slurs, " + span_cult(pick("<i>\"Здравствуй...", "<i>\"Приветствую!", "<i>\"Я скучал...", "<i>\"Направь меня, дай выстрелить!")))
		return

	if(!can_awaken(H))
		to_chat(H, span_warning(pick("Оружие молчит", "Похоже, вам показалось", "Вы ничего не чувствуете, держа оружие в руках")))
		return

	if(bloodlock_awaken_timer)
		return

	bloodlock_owner = H

	to_chat(H, span_info(pick("Вы чувствуете дискомфорт. Оружие будто пытается с вами связаться...", "Оружие едва заметно пульсирует под вашими пальцами.", "Что-то внутри оружия откликается на ваше присутствие.", "На мгновение кажется, будто оружие смотрит прямо на вас.", "Чужая воля касается вашего разума.", "Вы ощущаете слабый зов, исходящий от оружия.")))

	bloodlock_awaken_timer = addtimer(CALLBACK(src, PROC_REF(finish_bloodlock_awaken)), BLOODLOCK_AWAKEN_TIME, TIMER_STOPPABLE)
	reset_loss_timer()

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/finish_bloodlock_awaken()
	bloodlock_awaken_timer = null
	if(!bloodlock_owner)
		return
	if(QDELETED(bloodlock_owner))
		bloodlock_owner = null
		return
	if(src.loc != bloodlock_owner)
		to_chat(bloodlock_owner, span_warning("Оружие утихает, связь прервана"))
		bloodlock_owner = null
		return
	bloodlock_awakened = TRUE
	awaken_bloodlock(bloodlock_owner)

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/awaken_bloodlock(mob/living/carbon/human/H)
	if(!H)
		return

	ADD_TRAIT(H, TRAIT_NOSLEEP, "bloodlock")
	ADD_TRAIT(H, TRAIT_NOHUNGER, "bloodlock")
	ADD_TRAIT(H, TRAIT_NASTY_EATER, "bloodlock")
	ADD_TRAIT(H, TRAIT_VAMPBITE, "bloodlock")

	previous_maxbloodpool = H.maxbloodpool
	var/previous_bloodpool = H.bloodpool
	H.maxbloodpool = max(H.maxbloodpool, 1700)
	H.hud_used?.shutdown_bloodpool()
	H.hud_used?.initialize_bloodpool()
	H.hud_used?.bloodpool.set_fill_color("#510000")
	if(previous_maxbloodpool > 0)
		H.set_bloodpool(min(previous_bloodpool, H.maxbloodpool))
	else
		H.set_bloodpool(H.maxbloodpool)

	RegisterSignal(H, COMSIG_LIVING_DRINKED_LIMB_BLOOD, PROC_REF(on_drink_blood))

	reset_loss_timer()

	to_chat(H, "<span style='color:#5E2129'>The Bloodlock</span> slurs, " + span_cult(pick("<i>\"Приветствую нового владельца...\"<i>", "<i>\"Ощущаешь меня?\"<i>", "<i>\"Почувствуй же мой дар!\"<i>", "<i>\"Моё имя С'анг, запомни его\"<i>", "<i>\"Прошлый владелец был противен мне, но ты...!\"<i>")))

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/bloodlock_random_phrase()
	if(ishuman(src.loc))
		var/mob/living/carbon/human/H = src.loc

		to_chat(H, span_warning("Он что-то пытается вам рассказать..."))
		if(prob(40))
			to_chat(H,"<span style='color:#5E2129'>The Bloodlock</span> whispers, " + span_cult(pick("<i>\"Еще когда меня держали в каком-то закаулке Мензоберразана, в лавку пришла группа Антаракса. Помню лишь…Тьму\"</i>","<i>\"Ходили слухи, что те - кто заточил меня и создал одну из первых оболочек - заключили какую-то сделку с тварями Инферно.. А что думаешь ты?\"</i>","<i>\"Кажется запах железа застал тебя врасплох. А ты точно подходишь мне?! \"</i>","<i>\"Дом Бэнр -  властители Мензоберранзана. Младшая дочь заняла трон, назначив старших сестру и брата советниками.. Ах... Маги тесно связаны с призывами демонов.. Как думаешь, тот огромный паук был его рук дела? \"</i>","<i>\"Ох, вспоминаю прекрасные моменты в доме Грейвс. Как же часто меня тогда заводили, как же часто мы стреляли. Нет-нет, ты не подумай ничего плохого! Но ты и впрямь не дотягиваешь!\"</i>","<i>\"Вон, посмотри на того урода, может выстрелим?\"</i>","<i>\"Нихрена не вижу…Может поднимешь ствол?\"</i>","<i>\"Я думал ты намного хуже, когда подбирал меня впервые. Приятно ошибаться \"</i>","<i>\"Вон, посмотри на того урода, может выстрелим?\"</i>","<i>\"Когда мы уже сделаем что-то?!\"</i>","<i>\"Таким красавцем я стал не так уж и давно, может…Пару йиллов назад, раньше меня так и водили по сосудам\"</i>","<i>\"Они назвали меня С’анг. Был еще один, или даже близнецы, но их имен я совсем не помню\"</i>","<i>\"Пум-пурум-пурум-пум…\"</i>","<i>\"А какой сейчас Йилл? Наверно уже наступил 1000, да?\"</i>","<i>\"А...А?! Мьерда, ты тут...\"</i>")))

	addtimer(CALLBACK(src, PROC_REF(bloodlock_random_phrase)), BLOODLOCK_PHRASE_TIME)

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/dropped(mob/user, silent)
	. = ..()

	if(bloodlock_awaken_timer && bloodlock_owner == user)
		deltimer(bloodlock_awaken_timer)
		bloodlock_awaken_timer = null
		to_chat(user, span_warning("Оружие затихает. Пробуждение прервано."))
		bloodlock_owner = null
		return

	if(bloodlock_awakened && bloodlock_owner == user)
		reset_loss_timer()

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/reset_loss_timer()
	if(bloodlock_loss_timer)
		deltimer(bloodlock_loss_timer)
	bloodlock_loss_timer = addtimer(CALLBACK(src, PROC_REF(check_owner_loss)), BLOODLOCK_LOSS_TIME, TIMER_STOPPABLE)

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/check_owner_loss()
	bloodlock_loss_timer = null
	if(!bloodlock_owner)
		return
	if(src.loc == bloodlock_owner)
		reset_loss_timer()
		return
	remove_bloodlock_power()

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/remove_bloodlock_power()
	if(!bloodlock_owner)
		return

	var/mob/living/carbon/human/H = bloodlock_owner

	REMOVE_TRAIT(H, TRAIT_NOSLEEP, "bloodlock")
	REMOVE_TRAIT(H, TRAIT_NOHUNGER, "bloodlock")
	REMOVE_TRAIT(H, TRAIT_NASTY_EATER, "bloodlock")
	REMOVE_TRAIT(H, TRAIT_VAMPBITE, "bloodlock")

	UnregisterSignal(H, COMSIG_LIVING_DRINKED_LIMB_BLOOD)

	var/current_bloodpool = H.bloodpool
	H.maxbloodpool = previous_maxbloodpool
	H.hud_used?.shutdown_bloodpool()
	if(H.maxbloodpool > 0)
		H.hud_used?.initialize_bloodpool()
		H.hud_used?.bloodpool.set_fill_color("#510000")
		H.set_bloodpool(min(current_bloodpool, H.maxbloodpool))
	else
		H.set_bloodpool(0)
	previous_maxbloodpool = 0
	bloodlock_awakened = FALSE
	bloodlock_owner = null

	to_chat(H, "<span style='color:#5E2129'>The Bloodlock</span> slurs, " + span_cult(pick("<i>\"Как ты посмел меня бросить?!\"</i>", "<i>\"Прошлый владелец всё же был лучше\"</i>", "<i>\"Н'вах!\"</i>", "<i>\"Прогресс явно не для такого остолопа, как ты!\"</i>")))

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/Destroy()
	if(bloodlock_awaken_timer)
		deltimer(bloodlock_awaken_timer)
		bloodlock_awaken_timer = null
	if(bloodlock_loss_timer)
		deltimer(bloodlock_loss_timer)
		bloodlock_loss_timer = null
	if(bloodlock_awakened && bloodlock_owner && !QDELETED(bloodlock_owner))
		remove_bloodlock_power()
	else
		bloodlock_owner = null
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/on_drink_blood(mob/living/drinker, mob/living/target)
	SIGNAL_HANDLER
	if(drinker != bloodlock_owner)
		return
	drinker.adjust_bloodpool(BLOODLOCK_VITAE_PER_DRINK)

/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/get_examine_string(mob/living/user)
	. = ..()

	if(name != "bloodlock rifle")
		return

	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/own_bloodlock

	for(var/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/B in H)
		if(B.loc != H)
			continue

		if(B.bloodlock_owner == H && B.bloodlock_awakened)
			own_bloodlock = B
			break

		if(B.is_blood_raider(H))
			own_bloodlock = B
			break

	if(!own_bloodlock)
		return

	if(own_bloodlock == src)
		return

	own_bloodlock.bloodlock_second_examine(H)


/obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/twilight_bloodlock/proc/bloodlock_second_examine(mob/living/carbon/human/H)
	if(!H)
		return

	if(bloodlock_owner != H && !is_blood_raider(H))
		return

	to_chat(H, span_warning("Ружье начинает тревожно вибрировать при виде близнеца."))
	if(prob(50))
		to_chat(H, "<span style='color:#5E2129'>The Bloodlock</span> whispers, " + span_cult(pick("<i>\"Какого Зизо?! Фальшивка!\"</i>","<i>\"Нон..нон...НОН!УБЕЙ ВЛАДЕЛЬЦА ЭТОЙ ФАЛЬШИВКИ И УНИЧТОЖЬ ЕЁ!\"</i>","<i>\"Пристрели владельца и сломай фальшивку, пока они нас не заметили!\"</i>","<i>\"УБЕЙ, УБЕЙ, УБЕЙ!!!\"</i>","<i>\"Уничтожь самозванцев!\"</i>","<i>\"Ха... Нам стоит покончить с фальшивкой, пока она это первая не сделала!\"</i>")))

#undef BLOODLOCK_AWAKEN_TIME
#undef BLOODLOCK_LOSS_TIME
#undef BLOODLOCK_VITAE_PER_DRINK
#undef BLOODLOCK_PHRASE_TIME
