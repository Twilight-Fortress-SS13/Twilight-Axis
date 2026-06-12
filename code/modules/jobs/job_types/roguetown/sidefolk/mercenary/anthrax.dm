/datum/advclass/mercenary/anthrax
	name = "Underdark Pursuer" //TA EDIT
	tutorial = "Frontline shock troopers of Her blessed legions, Pursuers are clad in darksteel armor and are first to march into the fray when the Spider Queen demands it. You have been chosen for a mission to the surface, and while out there, you will have to earn coin to sustain yourself. Regardless of whom you work for, never forget where your true allegiance lies." //TA EDIT
	forbidden_races = list(RACES_ANTHRAX)
	outfit = /datum/outfit/job/roguetown/mercenary/anthrax
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/combat_delf.ogg'

	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ANTHRAXI, TRAIT_ALCHEMY_EXPERT) //TA EDIT
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,

	)
	subclass_languages = list(/datum/language/undercommon)
	extra_context = "This subclass is race-restricted to the Dark Elf species, and can pick between two bonuses; an extra level to Athletics, or a rideable mount."

/datum/outfit/job/roguetown/mercenary/anthrax/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
	backl = /obj/item/storage/backpack/rogue/satchel/black
	head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/rogueweapon/scabbard/sheath)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask/shadowfacemask
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	backr = /obj/item/rogueweapon/shield/tower/spidershield
	beltr = /obj/item/rogueweapon/whip/spiderwhip	
	beltl = /obj/item/rope/chain


	//H.faction += "spider_lowers" //TA EDIT

	if(H.mind)
		var/faction = list("Zizite Loyalists (Drow are Neutral & Darkvision)", "Tenebrite Rebels (Self-Sustenance trait)") //TA EDIT START
		var/factionchoice = input(H, "The Underdark stands divided. Which side do you fight for?", "PLEDGE YOUR ALLEGIANCE.") as anything in faction
		switch(factionchoice)
			if("Zizite Loyalists (Drow are Neutral & Darkvision)")
				H.faction += "spider_lowers"
				ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
				if (!(istype(H.patron, /datum/patron/inhumen/zizo)))
					H.set_patron(/datum/patron/inhumen/zizo)
				to_chat(H, span_warning("Her Chosen priestesses have dictated that I must scout these lands, pretending to be a mere stray. For now, I stay my hand. The time of our salvation will come."))
			if("Tenebrite Rebels (Self-Sustenance trait)")
				ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
				H.mind.special_items["Hammer"] = /obj/item/rogueweapon/hammer/iron
				to_chat(H, span_warning("Our fight grows more desperate. I must gather resources and allies, so that the Underdark can be free from the tyrant goddess.")) //TA EDIT END
		var/riding = list("Spidertamer (Tameable Spider Mount)", "Shroomwalker (+I to Athletics)")
		var/ridingchoice = input(H, "Choose your TRAVELBOON.", "ROAM ABROAD AND ROAM FAR.") as anything in riding
		switch(ridingchoice)
			if("Spidertamer (Tameable Spider Mount)")
				apply_virtue(H, new /datum/virtue/utility/riding)
			if("Shroomwalker (+I to Athletics)")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)

	H.merctype = 15

/datum/advclass/mercenary/anthrax_assassin
	name = "Anthraxi Assassin" //TA EDIT
	tutorial = "Black Venom's infamous killers for hire. It is said a single cut \
	from their poison tipped blades is enough to send their victim to an early grave. You are one \
	of those assassins, use your trusty bow and arrow to bring your targets' demise \
	from afar or take a second sabre and weave a beautiful dance of death. All that matters is \
	that your contract is fulfilled and your pockets heavy with mammon."
	outfit = /datum/outfit/job/roguetown/mercenary/anthrax_assassin
	forbidden_races = list(RACES_ANTHRAX)
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_RACIAL
	cmode_music = 'sound/music/combat_delf.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_ANTHRAXI, TRAIT_ALCHEMY_EXPERT) //TA EDIT
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
	)
	extra_context = "This subclass is race-restricted to the Dark Elf species, and can pick between two bonuses; an extra level to Athletics, or a rideable mount."

/datum/outfit/job/roguetown/mercenary/anthrax_assassin/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/rogueweapon/scabbard/sheath)
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	cloak = /obj/item/clothing/cloak/half/shadowcloak
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre/stalker
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants

	//H.faction += "spider_lowers" //TA EDIT

	if(H.mind)
		var/faction = list("Zizite Loyalists (Drow are Neutral & Darkvision)", "Tenebrite Rebels (Self-Sustenance trait)") //TA EDIT START
		var/factionchoice = input(H, "The Underdark stands divided. Which side do you fight for?", "PLEDGE YOUR ALLEGIANCE.") as anything in faction
		switch(factionchoice)
			if("Zizite Loyalists (Drow are Neutral & Darkvision)")
				H.faction += "spider_lowers"
				ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
				if (!(istype(H.patron, /datum/patron/inhumen/zizo)))
					H.set_patron(/datum/patron/inhumen/zizo)
				to_chat(H, span_warning("Her Chosen priestesses have dictated that I must scout these lands, pretending to be a mere stray. For now, I stay my hand. The time of our salvation will come."))
			if("Tenebrite Rebels (Self-Sustenance trait)")
				ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
				H.mind.special_items["Hammer"] = /obj/item/rogueweapon/hammer/iron
				to_chat(H, span_warning("Our fight grows more desperate. I must gather resources and allies, so that the Underdark can be free from the tyrant goddess.")) //TA EDIT END
		var/weapon = list("Bow & Poisoned Arrows", "Dual Sabres")
		var/weaponchoice = input(H, "Choose your WEAPON.", "PICK YOUR INSTRUMENTS.") as anything in weapon
		switch(weaponchoice)
			if("Bow & Poisoned Arrows")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
				beltr = /obj/item/quiver/poisonarrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			if("Dual Sabres")
				l_hand = /obj/item/rogueweapon/sword/sabre/stalker
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = null
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
		var/riding = list("Spidertamer (Tameable Spider Mount)", "Shroomwalker (+I to Athletics)")
		var/ridingchoice = input(H, "Choose your TRAVELBOON.", "ROAM ABROAD AND ROAM FAR.") as anything in riding
		switch(ridingchoice)
			if("Spidertamer (Tameable Spider Mount)")
				apply_virtue(H, new /datum/virtue/utility/riding)
			if("Shroomwalker (+I to Athletics)")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)	

	H.merctype = 15	

/datum/advclass/mercenary/anthrax_paladin //TA EDIT START
	name = "Spider Queen Baneblade"
	tutorial = "Hailing primarily from the Undercity of Faerlin, the Baneblades are the Spider Queen's warrior-priests, wielding both Her blades and Her gifts with great proficiency. You have been chosen for a mission to the surface, and while you earn your bread and gather the information your clan requires, you are also expected to ensure the thoughts of your comrades stay true to the cause."
	forbidden_races = list(RACES_ANTHRAX)
	outfit = /datum/outfit/job/roguetown/mercenary/anthrax_paladin
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/combat_delf.ogg'

	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ANTHRAXI, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)

	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, 
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_languages = list(/datum/language/undercommon)
	extra_context = "This subclass is race-restricted to the Dark Elf species. Pick your side in the Underdark Feud Wars, and choose between Spidertamer and Shroomwalker travelboons."

/datum/outfit/job/roguetown/mercenary/anthrax_paladin/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/twilight_drow
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/chainlegs/twilight_drow
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1, 
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/rogueweapon/scabbard/sheath)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/twilight_shadowplate
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	l_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/relevement
	beltl = /obj/item/rope/chain

	if(H.mind)
		var/faction = list("Zizite Loyalists (Drow are Neutral & Darkvision)", "Tenebrite Rebels (Self-Sustenance trait)")
		var/factionchoice = input(H, "The Underdark stands divided. Which side do you fight for?", "PLEDGE YOUR ALLEGIANCE.") as anything in faction
		switch(factionchoice)
			if("Zizite Loyalists (Drow are Neutral & Darkvision)")
				H.faction += "spider_lowers"
				ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
				if (!(istype(H.patron, /datum/patron/inhumen/zizo)))
					H.set_patron(/datum/patron/inhumen/zizo)
				to_chat(H, span_warning("Her Chosen priestesses have dictated that I must scout these lands, pretending to be a mere stray. For now, I stay my hand. The time of our salvation will come."))
			if("Tenebrite Rebels (Self-Sustenance trait)")
				ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
				H.mind.special_items["Hammer"] = /obj/item/rogueweapon/hammer/iron
				to_chat(H, span_warning("Our fight grows more desperate. I must gather resources and allies, so that the Underdark can be free from the tyrant goddess."))
		var/helmets = list("Anthraxi War Mask", "Scourge Barbute", "Razormaw Helm")
		var/helmetschoice = input(H, "Choose your Helm.", "CONCEAL YOUR VISAGE.") as anything in helmets
		switch(helmetschoice)
			if("Anthraxi War Mask")
				mask = /obj/item/clothing/mask/rogue/facemask/shadowfacemask
				head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
			if("Scourge Barbute")
				head = /obj/item/clothing/head/roguetown/helmet/heavy/twilight_drow
			if("Razormaw Helm")
				head = /obj/item/clothing/head/roguetown/helmet/heavy/twilight_drow/volf
		var/riding = list("Spidertamer (Tameable Spider Mount)", "Shroomwalker (+I to Athletics)")
		var/ridingchoice = input(H, "Choose your TRAVELBOON.", "ROAM ABROAD AND ROAM FAR.") as anything in riding
		switch(ridingchoice)
			if("Spidertamer (Tameable Spider Mount)")
				apply_virtue(H, new /datum/virtue/utility/riding)
			if("Shroomwalker (+I to Athletics)")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

	H.merctype = 15 //TA EDIT END
