/datum/antagonist/thievesguild
	name = "Гильдия воров"
	job_rank = ROLE_THIEVESGUILD
	roundend_category = "Гильдия воров"
	antagpanel_category = "Roguetown"
	show_name_in_check_antagonists = TRUE
	rogue_enabled = TRUE
	can_coexist_with_others = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	storyteller_min_players = 0
	storyteller_slot_default_cap = 5
	storyteller_slot_scaling = 1
	confess_lines = list(
		"Я служу Гильдии воров!",
		"Никто не заметит моей руки в своём кошеле!",
		"Мой дом там, где лежит чужое золото!",
		"Тени скрывают мои дела!"
	)

/datum/antagonist/thievesguild/on_gain()
	. = ..()
	if(!owner?.current)
		return
	var/mob/living/L = owner.current
	L.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	L.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
	L.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	var/lockpick_type = text2path("/obj/item/lockpickring/mundane")
	if(ispath(lockpick_type, /obj/item))
		owner.special_items["Отмычки гильдии"] = lockpick_type
	var/poison_type = text2path("/obj/item/reagent_containers/glass/bottle/rogue/strongpoison")
	if(ispath(poison_type, /obj/item))
		owner.special_items["Крепкий яд гильдии"] = poison_type
	if(!length(objectives))
		var/datum/objective/thieves_guild_objective/O = new(null, owner)
		objectives += O
		owner.store_memory("Поручение Гильдии воров: [O.explanation_text]")
		to_chat(L, span_boldwarning("Вы стали тайным агентом Гильдии воров. Действуйте скрытно и не выдавайте себя."))
		to_chat(L, span_notice("Ваше задание: [O.explanation_text]"))
		to_chat(L, span_notice("Поручение записано во вкладке памяти."))

/datum/antagonist/thievesguild/apply_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/L = mob_override
	if(!L)
		L = owner?.current
	if(L)
		L.grant_language(/datum/language/thievescant, source = "[type]")

/datum/antagonist/thievesguild/remove_innate_effects(mob/living/mob_override)
	. = ..()
	var/mob/living/L = mob_override
	if(!L)
		L = owner?.current
	if(L)
		L.remove_language(/datum/language/thievescant, source = "[type]")

/datum/antagonist/thievesguild/on_removal()
	if(owner)
		owner.special_items -= "Отмычки гильдии"
		owner.special_items -= "Крепкий яд гильдии"
	return ..()
