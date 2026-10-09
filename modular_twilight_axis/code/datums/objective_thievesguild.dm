/datum/objective/thieves_guild_objective
	name = "Задание Гильдии воров"
	explanation_text = "Выполните поручение Гильдии воров."
	triumph_count = 5
	var/target_item_path
	var/target_item_name
	// var/mammon_amount = 1000
	var/datum/mind/assassination_target
	var/objective_kind = "steal"

/datum/objective/thieves_guild_objective/New(text, datum/mind/objective_owner)
	..(text, objective_owner)
	var/success = FALSE
	switch(rand(1, 3))
		if(1, 2)
			success = setup_steal_objective()
		// if(2)
		// 	success = setup_mammon_objective()
		if(3)
			success = setup_assassinate_objective()
	if(!success)
		success = setup_steal_objective()
	if(!success)
		success = setup_assassinate_objective()
	if(!success)
		explanation_text = "Не удалось подобрать поручение Гильдии воров."
		return
	update_explanation_text()

/datum/objective/thieves_guild_objective/proc/setup_steal_objective()
	var/list/possible_items = list(
		"Staff of the Shepherd" = "/obj/item/rogueweapon/woodstaff/aries",
		"Crown of the Realm" = "/obj/item/clothing/head/roguetown/crown/serpcrown",
		"Bell Ringer" = "/obj/item/rogueweapon/mace/church",
		"Sword of the Mad Duke" = "/obj/item/rogueweapon/sword/rapier/lord",
		"Judgement" = "/obj/item/rogueweapon/sword/long/judgement",
		"The Master Key" = "/obj/item/roguekey/lord",
		"Garrison houndstone" = "/obj/item/scomstone/bad/garrison"
	)
	var/list/valid_items = list()
	for(var/item_name in possible_items)
		var/item_path = text2path(possible_items[item_name])
		if(ispath(item_path, /obj/item))
			valid_items[item_name] = item_path
	if(!length(valid_items))
		return FALSE
	target_item_name = pick(valid_items)
	target_item_path = valid_items[target_item_name]
	objective_kind = "steal"
	return TRUE

// /datum/objective/thieves_guild_objective/proc/setup_mammon_objective()
// 	objective_kind = "money"
// 	mammon_amount = 1000
// 	return TRUE

/datum/objective/thieves_guild_objective/proc/setup_assassinate_objective()
	var/list/eligible_jobs = list(
		"Grand Duke", "Grand Duchess", "Sultan", "Sultana",
		"Prince", "Princess", "Consort", "Consort Dowager",
		"Bishop", "Councillor", "Inquisitor",
		"Merchant", "Guildmaster", "Steward", "Clerk",
		"Town Sheriff", "Marshal", "Sergeant", "Mayor"
	)
	var/list/candidates = list()
	for(var/client/C in GLOB.clients)
		var/mob/living/carbon/human/H = C.mob
		if(!istype(H) || !H.mind || H.mind == owner || H.stat == DEAD)
			continue
		if(H == SSticker.rulermob || H.mind.assigned_role in eligible_jobs)
			candidates += H.mind
	if(!length(candidates))
		return FALSE
	assassination_target = pick(candidates)
	objective_kind = "assassination"
	return TRUE

/datum/objective/thieves_guild_objective/update_explanation_text()
	..()
	switch(objective_kind)
		if("assassination")
			if(assassination_target?.current)
				explanation_text = "Добейтесь, чтобы <b>[assassination_target.current.real_name]</b> ([assassination_target.assigned_role]) был мёртв к концу раунда."
			else
				explanation_text = "Добейтесь гибели назначенной цели к концу раунда."
		// if("money")
		// 	explanation_text = "К концу раунда держите при себе не менее <b>[mammon_amount] маммонов</b>."
		if("steal")
			explanation_text = "Украдите <b>[target_item_name]</b> и удерживайте предмет при себе до конца раунда."

/datum/objective/thieves_guild_objective/proc/has_stolen_item(atom/container, depth = 0)
	if(!container || depth > 12 || !target_item_path)
		return FALSE
	for(var/obj/item/I in container.contents)
		if(istype(I, target_item_path))
			return TRUE
		if(length(I.contents) && has_stolen_item(I, depth + 1))
			return TRUE
	return FALSE

/datum/objective/thieves_guild_objective/check_completion()
	if(!owner?.current)
		return FALSE
	switch(objective_kind)
		if("assassination")
			return assassination_target?.current && assassination_target.current.stat == DEAD
		// if("money")
		// 	return get_mammons_in_atom(owner.current) >= mammon_amount
		if("steal")
			return has_stolen_item(owner.current)
	return FALSE
