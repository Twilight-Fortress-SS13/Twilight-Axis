#define IMPLEMENT_REFUND_AMETHYST 0.45
#define IMPLEMENT_REFUND_TOPER 0.48
#define IMPLEMENT_REFUND_GEMERALD 0.53
#define IMPLEMENT_REFUND_SAFFIRA 0.56
#define IMPLEMENT_REFUND_BLORTZ 0.59
#define IMPLEMENT_REFUND_RONTZ 0.62
#define IMPLEMENT_REFUND_DORPEL 0.65
#define IMPLEMENT_REFUND_RIDDLE 0.70

#define IMPLEMENT_CAST_SPEED_AMETHYST 0.05
#define IMPLEMENT_CAST_SPEED_TOPER 0.07
#define IMPLEMENT_CAST_SPEED_GEMERALD 0.10
#define IMPLEMENT_CAST_SPEED_SAFFIRA 0.12
#define IMPLEMENT_CAST_SPEED_BLORTZ 0.14
#define IMPLEMENT_CAST_SPEED_RONTZ 0.16
#define IMPLEMENT_CAST_SPEED_DORPEL 0.18
#define IMPLEMENT_CAST_SPEED_RIDDLE 0.20

// Подстраховываемся хардкапом от эксплойтов, если кто-нибудь их изобретёт
#define IMPLEMENT_CAST_SPEED_MAX 0.25

/obj/item/rogueweapon
	// Время на каст умножается на (1 - implement_cast_speed)
	var/implement_cast_speed = 0
	var/gem_socketable = FALSE
	var/obj/item/socketed_gem
	var/starting_gem_type  // Для спавна посохов сразу с гемами
	var/implement_noun  // Для автоматического переименования при вызове update_gem_name

/mob/living/carbon/human/proc/get_held_cast_speed_implement()
	var/obj/item/rogueweapon/best
	for(var/obj/item/rogueweapon/held in held_items)
		if(held.implement_cast_speed > best?.implement_cast_speed)
			best = held
	return best

// Донатерские морфы сохраняют силу гема
/obj/item/rogueweapon/transfer_implement_state(obj/item/rogueweapon/morphed, mob/user)
	if(!implement_refund && !implement_cast_speed)
		return
	morphed.implement_refund = implement_refund
	morphed.implement_cast_speed = implement_cast_speed
	morphed.implement_tier = implement_tier

// Возвращает модификатор времени каста заклинаний.
/datum/action/cooldown/spell/proc/get_implement_charge_mult()
	if(!ishuman(owner))
		return 1

	var/mob/living/carbon/human/H = owner

	var/obj/item/rogueweapon/implement = H.get_held_cast_speed_implement()
	if(!implement)
		return 1

	return 1 - clamp(implement.implement_cast_speed, 0, IMPLEMENT_CAST_SPEED_MAX)

// Этот оверрайд нужен исключительно для косметического свечения и переименования томов
/datum/action/cooldown/spell/get_held_implement(mob/user)
	. = ..()
	if(. || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	return H.get_held_cast_speed_implement()

GLOBAL_LIST_INIT(implement_gem_stats, list(
	/obj/item/roguegem/amethyst = list("key" = "amethyst", "label" = "amythortz", "refund" = IMPLEMENT_REFUND_AMETHYST, "cast_speed" = IMPLEMENT_CAST_SPEED_AMETHYST, "glow" = 1),
	/obj/item/roguegem/yellow = list("key" = "topaz", "label" = "toper", "refund" = IMPLEMENT_REFUND_TOPER, "cast_speed" = IMPLEMENT_CAST_SPEED_TOPER, "glow" = 1),
	/obj/item/roguegem/green = list("key" = "emerald", "label" = "gemerald", "refund" = IMPLEMENT_REFUND_GEMERALD, "cast_speed" = IMPLEMENT_CAST_SPEED_GEMERALD, "glow" = 2),
	/obj/item/roguegem/violet = list("key" = "sapphire", "label" = "saffira", "refund" = IMPLEMENT_REFUND_SAFFIRA, "cast_speed" = IMPLEMENT_CAST_SPEED_SAFFIRA, "glow" = 2),
	/obj/item/roguegem/blue = list("key" = "quartz", "label" = "blortz", "refund" = IMPLEMENT_REFUND_BLORTZ, "cast_speed" = IMPLEMENT_CAST_SPEED_BLORTZ, "glow" = 2),
	/obj/item/roguegem/ruby = list("key" = "ruby", "label" = "rontz", "refund" = IMPLEMENT_REFUND_RONTZ, "cast_speed" = IMPLEMENT_CAST_SPEED_RONTZ, "glow" = 2),
	/obj/item/roguegem/diamond = list("key" = "diamond", "label" = "dorpel", "refund" = IMPLEMENT_REFUND_DORPEL, "cast_speed" = IMPLEMENT_CAST_SPEED_DORPEL, "glow" = 3),
	/obj/item/riddleofsteel = list("key" = "riddle", "label" = "riddlesteel", "refund" = IMPLEMENT_REFUND_RIDDLE, "cast_speed" = IMPLEMENT_CAST_SPEED_RIDDLE, "glow" = 3),
))

/proc/get_implement_gem_stats(obj/item/gem)
	if(!gem)
		return null
	for(var/gem_type in GLOB.implement_gem_stats)
		if(istype(gem, gem_type))
			return GLOB.implement_gem_stats[gem_type]
	return null

/obj/item/rogueweapon/Initialize(mapload)
	. = ..()
	if(!gem_socketable)
		return
	if(starting_gem_type)
		socketed_gem = new starting_gem_type(src)
	update_gem_state()

// Виртуальная функция, которую оверрайдят посохи/гримуары
/obj/item/rogueweapon/proc/apply_gem_stats(list/stats)
	return

/obj/item/rogueweapon/proc/update_gem_icon(list/stats)
	return

// Увы, мы не можем использовать оригинальный apply_quality() для сохранения префиксов
/obj/item/proc/get_quality_name_prefix()
	var/prefix
	switch(item_quality)
		if(ITEM_QUALITY_LOOTED)
			prefix = ITEM_QUALITY_PREFIX_LOOTED
		if(ITEM_QUALITY_RUINED)
			prefix = ITEM_QUALITY_PREFIX_RUINED
		if(ITEM_QUALITY_AWFUL)
			prefix = ITEM_QUALITY_PREFIX_AWFUL
		if(ITEM_QUALITY_CRUDE)
			prefix = ITEM_QUALITY_PREFIX_CRUDE
		if(ITEM_QUALITY_ROUGH)
			prefix = ITEM_QUALITY_PREFIX_ROUGH
		if(ITEM_QUALITY_FINE)
			prefix = ITEM_QUALITY_PREFIX_FINE
		if(ITEM_QUALITY_FLAWLESS)
			prefix = ITEM_QUALITY_PREFIX_FLAWLESS
		if(ITEM_QUALITY_MASTERWORK)
			prefix = ITEM_QUALITY_PREFIX_MASTERWORK
	return prefix ? "[prefix] " : ""

/obj/item/rogueweapon/proc/update_gem_name(list/stats)
	if(!implement_noun)
		return
	base_implement_name = "[get_quality_name_prefix()][stats ? stats["label"] : "unfitted"] [implement_noun]"
	name = base_implement_name

// Обновляет статы, спрайты и название при смене гема
/obj/item/rogueweapon/proc/update_gem_state()
	var/list/stats = get_implement_gem_stats(socketed_gem)
	implement_refund = 0
	implement_cast_speed = 0
	apply_gem_stats(stats)

	implement_tier = stats ? stats["glow"] : 0
	attuned_color = null
	COOLDOWN_RESET(src, attunement_cd)
	remove_filter(IMPLEMENT_GLOW_FILTER)

	update_gem_name(stats)
	update_gem_icon(stats)

	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_hands()
		M.update_inv_back()

/obj/item/rogueweapon/proc/fit_gem(obj/item/gem, mob/living/user)
	user.visible_message(
		span_notice("[user] starts setting [gem] into [src]..."),
		span_notice("I start setting [gem] into [src]...")
	)
	if(!do_after(user, 2 SECONDS, target = src))
		return
	if(socketed_gem)  // Если несколько игроков как-то додумаются одновременно совать камни в один посох
		to_chat(user, span_warning("There's already [socketed_gem] set into [src]!"))
		return
	if(!user.transferItemToLoc(gem, src))
		return
	socketed_gem = gem
	update_gem_state()
	playsound(src, gem.drop_sound || 'sound/items/gem.ogg', 50, TRUE)
	user.visible_message(
		span_notice("[user] sets [gem] into [src]."),
		span_notice("I set [gem] into [src].")
	)

/obj/item/rogueweapon/proc/pry_gem(mob/living/user)
	if(!socketed_gem)
		return
	user.visible_message(
		span_notice("[user] starts prying [socketed_gem] out of [src]..."),
		span_notice("I start prying [socketed_gem] out of [src]...")
	)
	if(!do_after(user, 2 SECONDS, target = src))
		return
	var/obj/item/old_gem = socketed_gem
	if(!old_gem || old_gem.loc != src)
		return
	old_gem.forceMove(drop_location())  // socketed_gem обнуляется сам в Exited()
	user.put_in_hands(old_gem)
	user.visible_message(
		span_notice("[user] pries [old_gem] out of [src]."),
		span_notice("I pry [old_gem] out of [src].")
	)

// Этот хук добавлен, чтобы помечать гем в посохе из Hoardmaster
// Это надёжнее, чем быдлокодить это в mark_as_worn, хоть и менее модульно
/obj/item/proc/on_hoardmaster_spawned()
	return

/obj/item/rogueweapon/on_hoardmaster_spawned()
	. = ..()
	if(!socketed_gem)
		return
	socketed_gem.flags_1 |= HOARDMASTER_SPAWNED_1
	socketed_gem.sellprice = 0

// Передаём гему качество "worn" при спавне в этом оверрайде
/obj/item/rogueweapon/mark_as_worn()
	. = ..()
	if(worn_out)
		socketed_gem?.mark_as_worn()

/obj/item/rogueweapon/unmark_as_worn()
	. = ..()
	if(!worn_out)
		socketed_gem?.unmark_as_worn()

// Передаём гему качество "scavenged" при спавне в этом оверрайде
/obj/item/rogueweapon/mark_as_looted()
	. = ..()
	if(looted)
		socketed_gem?.mark_as_looted()

/obj/item/rogueweapon/unmark_as_looted()
	. = ..()
	if(!looted)
		socketed_gem?.unmark_as_looted()

/obj/item/rogueweapon/attackby(obj/item/I, mob/living/user, params)
	if(gem_socketable)
		if(get_implement_gem_stats(I))
			if(socketed_gem)
				to_chat(user, span_warning("There's already [socketed_gem] set into [src]!"))
			else
				fit_gem(I, user)
			return TRUE
		if(istype(I, /obj/item/roguegem))
			to_chat(user, span_warning("[I] doesn't fit the setting of [src]."))
			return TRUE
		if(socketed_gem && istype(I, /obj/item/rogueweapon/huntingknife))
			pry_gem(user)
			return TRUE
	else if((implement_refund || implement_cast_speed) && get_implement_gem_stats(I))
		to_chat(user, span_warning("[src] won't take a gem!"))
		return TRUE
	return ..()

/obj/item/rogueweapon/Exited(atom/movable/gone, atom/newLoc)
	. = ..()
	if(gone == socketed_gem)
		socketed_gem = null
		update_gem_state()

/obj/item/rogueweapon/obj_destruction(damage_flag)
	socketed_gem?.forceMove(drop_location())
	return ..()

// Код навигатора не учитывает цену содержимого контейнеров, поэтому мы добавляем цену гема сами
/obj/item/rogueweapon/get_real_price()
	. = ..()
	if(socketed_gem)
		. += socketed_gem.get_real_price()

// А вот код appraise_price() учитывает содержимое контейнеров, поэтому придется исключить оттуда гемы из-за "фикса" выше
/obj/item/rogueweapon/appraise_price()
	if(!socketed_gem)
		return ..()
	. = get_real_price()
	for(var/obj/item/I in contents)
		if(I != socketed_gem)
			. += I.appraise_price()

/obj/item/rogueweapon/examine(mob/user)
	. = ..()
	if(implement_refund)
		. += span_notice("When held while casting, this implement leaves behind Residual Focus, returning [round(implement_refund * 100)]% of the spell's resource cost as energy over 20 seconds.")
	if(implement_cast_speed)
		. += span_notice("When held while casting, this implement shortens the time needed to gather a spell by [round(implement_cast_speed * 100)]%.")
	if(socketed_gem)
		. += span_info("[socketed_gem] is set into it. A knife could pry it loose.")
	else if(gem_socketable)
		. += span_info("Its setting is empty. A gem would fit it.")
