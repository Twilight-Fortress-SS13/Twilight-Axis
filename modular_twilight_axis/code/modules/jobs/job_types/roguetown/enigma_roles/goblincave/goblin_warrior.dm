/datum/job/roguetown/goblin_warrior
	title = "Goblin Warrior"
	flag = GOBLINWARRIOR
	department_flag = GOBLINCAVE
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_races = list(
		/datum/species/goblinp,
	)
	allowed_patrons = list(/datum/patron/inhumen/graggar)
	tutorial = "You are Graggar's spawn, born of his own blood — pitiful yet hungry for power. You have proven you can cut throats and survive. Now your life has savour: enemy blood, trophies, and dominion over the weak. \
				Submit only to those stronger than you, or they will tear out your liver. Fight savagely, break and enslave, devour the weak after victory — weakness is punished by death, strength earns the right to take everything. \
				To die choking on the blood of your enemies and your own — that is the highest grace. The Chief growls each night: the father beats heroes last, and cowards first, with great pleasure."
	class_categories = FALSE

	outfit = null
	outfit_female = null

	display_order = JDO_GOBLINWARRIOR
	selection_color = JCOLOR_WANDERER
	show_in_credits = FALSE
	min_pq = 5
	max_pq = null

	advclass_cat_rolls = list(CTAG_GOBLINWARRIOR = 10)

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = FALSE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES

	cmode_music = 'sound/music/cmode/antag/combat_darkstar.ogg'

	job_subclasses = list(
		/datum/advclass/goblin_warrior/brute,
		/datum/advclass/goblin_warrior/assassin,
		/datum/advclass/goblin_warrior/archer,
	)

/datum/job/roguetown/goblin_warrior/after_spawn(mob/living/H, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(H))
		var/mob/living/carbon/human/human = H
		human.grant_language(/datum/language/orcish)
		human.remove_language(/datum/language/common)

/datum/advclass/goblin_warrior/brute
	name = "Brute"
	tutorial = "You are a goblin brute — Graggar's blood boils in your veins. Break enemies with bare hands or melee weapons, with no armour, through sheer strength alone. Shatter skulls, crush spirits, and snap bones in close combat."
	outfit = /datum/outfit/job/roguetown/goblin_warrior/brute
	category_tags = list(CTAG_GOBLINWARRIOR)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_GOBLINCAVE, TRAIT_AZURENATIVE, TRAIT_LEECHIMMUNE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = -1,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "This subclass offers two disciplines: one grants EXPERT unarmed skill along with the 'Expert Pugilist' and 'Critical Resistance' traits, while the other grants mastery of one weapon type of your choice."

/datum/outfit/job/roguetown/goblin_warrior/brute/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("You are a goblin brute. Crush your enemies!"))
	H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()
	if(!visualsOnly)
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			var/has_wild_goblin_eye_action = FALSE
			for(var/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/action in eyes.actions)
				has_wild_goblin_eye_action = TRUE
				break
			if(!has_wild_goblin_eye_action)
				var/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/action = new(eyes)
				action.Grant(H)
	H.set_blindness(-3)
	if(!H.mind)
		return

	var/weapons = list("Bronze Katar","Bronze Sword and Shield","Bronze Axe and Shield","Bronze Mace and Shield","Bronze Spear and Shield","Bronze Flail and Shield","Discipline - Unarmed")
	var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Bronze Katar")
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			r_hand = /obj/item/rogueweapon/katar/bronze
			gloves = /obj/item/clothing/gloves/roguetown/bandages
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
		if("Bronze Axe and Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
			gloves = /obj/item/clothing/gloves/roguetown/bandages
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
			backr = /obj/item/rogueweapon/shield/wood
		if("Bronze Sword and Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			beltr = /obj/item/rogueweapon/scabbard/sword
			r_hand = /obj/item/rogueweapon/sword/bronze
			gloves = /obj/item/clothing/gloves/roguetown/bandages
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
			backr = /obj/item/rogueweapon/shield/wood
		if("Bronze Mace and Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			r_hand = /obj/item/rogueweapon/mace/bronze
			gloves = /obj/item/clothing/gloves/roguetown/bandages
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
			backr = /obj/item/rogueweapon/shield/wood
		if("Bronze Spear and Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			r_hand = /obj/item/rogueweapon/spear/bronze
			gloves = /obj/item/clothing/gloves/roguetown/bandages
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
			backr = /obj/item/rogueweapon/shield/wood
		if("Bronze Flail and Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			r_hand = /obj/item/rogueweapon/flail/bronze
			gloves = /obj/item/clothing/gloves/roguetown/bandages
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
			backr = /obj/item/rogueweapon/shield/wood
		if ("Discipline - Unarmed")
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
			gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
			armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/barbarian
	mask = /obj/item/clothing/mask/rogue/facemask
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	shoes = /obj/item/clothing/shoes/roguetown/boots/furlinedboots
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	if(should_wear_masc_clothes(H))
		H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	if(should_wear_femme_clothes(H))
		H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/bronze = 1,
		/obj/item/roguekey/goblinkey,
		)

/datum/advclass/goblin_warrior/assassin
	name = "Assassin"
	tutorial = "You are a goblin assassin — you slink through darkness, slit throats with a dagger or shoot from afar, then vanish in an instant. \
				Your strength is stealth: striking from the shadows, and the fear in your enemies' eyes. \
				Graggar disapproves, and the tribal warriors eye you with contempt — but you are still alive, and those brutes are not."
	outfit = /datum/outfit/job/roguetown/goblin_warrior/assassin
	category_tags = list(CTAG_GOBLINWARRIOR)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_LIGHT_STEP, TRAIT_STEELHEARTED, TRAIT_AZURENATIVE, TRAIT_LEECHIMMUNE)
	maximum_possible_slots = 2
	subclass_stats = list(
		STATKEY_STR = -2,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/goblin_warrior/assassin/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("You are a goblin assassin. Slink through darkness, strike from the shadows, and vanish before your foes can retaliate."))
	H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()
	if(!visualsOnly)
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			var/has_wild_goblin_eye_action = FALSE
			for(var/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/action in eyes.actions)
				has_wild_goblin_eye_action = TRUE
				break
			if(!has_wild_goblin_eye_action)
				var/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/action = new(eyes)
				action.Grant(H)
	H.set_blindness(-3)
	if(!H.mind)
		return

	armor = /obj/item/clothing/suit/roguetown/armor/leather
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/iron
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	beltl = /obj/item/quiver/Warrows
	beltr = /obj/item/storage/belt/rogue/pouch
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguekey/goblinkey = 1,
		/obj/item/bomb/smoke = 2
		)

/datum/advclass/goblin_warrior/archer
	name = "Archer"
	tutorial = "You are a goblin archer — you shoot from range, covering your allies from a safe distance. \
				Your strength lies in stealth, distance, and poisoned arrows that weaken your foes. \
				Graggar disapproves, and the tribal warriors eye you with contempt — but you are still alive, and those brutes are not."
	outfit = /datum/outfit/job/roguetown/goblin_warrior/archer
	category_tags = list(CTAG_GOBLINWARRIOR)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_LIGHT_STEP, TRAIT_STEELHEARTED, TRAIT_AZURENATIVE, TRAIT_LEECHIMMUNE)
	maximum_possible_slots = 2
	subclass_stats = list(
		STATKEY_STR = -3,
		STATKEY_CON = -1,
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/goblin_warrior/archer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("You are a goblin archer. Cover your allies from range and weaken enemies with poisoned arrows."))
	H.dna.species.soundpack_m = new /datum/voicepack/male/goblincave()
	H.dna.species.soundpack_f = new /datum/voicepack/female/goblincave()
	if(!visualsOnly)
		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			var/has_wild_goblin_eye_action = FALSE
			for(var/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/action in eyes.actions)
				has_wild_goblin_eye_action = TRUE
				break
			if(!has_wild_goblin_eye_action)
				var/datum/action/item_action/organ_action/use/goblin_cave_wild_eyes/action = new(eyes)
				action.Grant(H)
	H.set_blindness(-3)
	if(!H.mind)
		return

	armor = /obj/item/clothing/suit/roguetown/armor/leather
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
	beltl = /obj/item/quiver/poisonarrows
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/roguekey/goblinkey,
		)

/proc/update_goblin_cave_slots()
	update_goblin_chief_slots()
	update_goblin_shaman_slots()
	update_goblin_slave_slots()
	update_goblin_warrior_slots()

/proc/update_goblin_warrior_slots()
	var/datum/job/goblin_warrior_job = SSjob.GetJob("Goblin Warrior")
	if(!goblin_warrior_job)
		return

	var/player_count = length(GLOB.joined_player_list)
	var/ready_player_count = length(GLOB.ready_player_list)
	var/slots = 0

	var/current_players = (SSticker.current_state == GAME_STATE_PREGAME) ? ready_player_count : player_count

	// На 80 игроков, 6 слотов; +1 за каждые 10 игроков после 80
	if(SSmapping.config.map_name == "Rockhill")
		if(current_players >= 80)
			slots = 6 + floor((current_players - 80) / 10)
	else
		slots = 0

	goblin_warrior_job.total_positions = slots
	goblin_warrior_job.spawn_positions = slots
