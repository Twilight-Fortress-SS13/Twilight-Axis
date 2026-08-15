#define CTAG_GRONN_JARL "gronn_jarl"
#define CTAG_GRONN_TIDEWEAVER "gronn_tideweaver"
#define CTAG_GRONN_VOLFSKIN "gronn_volfskin"
#define CTAG_GRONN_HUSCARL "gronn_huscarl"
#define CTAG_GRONN_THRALL "gronn_thrall"

/datum/migrant_wave/gronn_reavers
	name = "Gronnian Reavers"
	track = MIGRANT_TRACK_SPECIAL
	weight = 6
	min_round_time = 40 MINUTES
	min_pop = 40
	max_spawns = 1
	triumph_threshold = 100
	triumph_weight_multiplier = 4
	required_roles = list(
		/datum/migrant_role/gronn/jarl = 1,
	)
	optional_roles = list(
		/datum/migrant_role/gronn/huscarl = 2,
		/datum/migrant_role/gronn/volfskin = 1,
		/datum/migrant_role/gronn/tideweaver = 1,
		/datum/migrant_role/gronn/thrall = 2,
	)
	greet_text = "You are a warband of Gronnian reavers, raiders from the cold north who have come ashore seeking plunder, glory, or a new place to call your own. Stick close to your jarl and remember: the weak serve the strong."

/datum/migrant_role/gronn/jarl
	name = "Gronnian Jarl"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "You are the jarl of this warband. Lead your reavers to wealth and glory, or at least back home alive."
	advclass_cat_rolls = list(CTAG_GRONN_JARL = 20)

/datum/migrant_role/gronn/tideweaver
	name = "Gronnian Tideweaver"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "You are a tideweaver, a seer and priest of the Lord of Abyss who sails with the reavers. Keep the warband whole and the jarl's spirit anchored."
	advclass_cat_rolls = list(CTAG_GRONN_TIDEWEAVER = 20)

/datum/migrant_role/gronn/volfskin
	name = "Gronnian Volfskin"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "You are a volfskin, a warrior touched by raging spirits. The jarl values your fangs more than your manners."
	advclass_cat_rolls = list(CTAG_GRONN_VOLFSKIN = 20)

/datum/migrant_role/gronn/huscarl
	name = "Gronnian Huscarl"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "You are a huscarl, sworn shield and plunder-taker of the jarl. Keep him alive, take prisoners, and do not shame the warband."
	advclass_cat_rolls = list(CTAG_GRONN_HUSCARL = 20)

/datum/migrant_role/gronn/thrall
	name = "Gronnian Thrall"
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	greet_text = "You are a thrall, a captive taken in raid or debt. Serve the warband well and you might yet earn your place among free reavers."
	advclass_cat_rolls = list(CTAG_GRONN_THRALL = 20)

/datum/advclass/gronn
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	category_tags = list(CTAG_DISABLED)
	min_pq = 0
	traits_applied = list(TRAIT_STEELHEARTED)
	subclass_languages = list(/datum/language/gronnic)
	origin_limits = list(/datum/virtue/origin/gronn)

/datum/advclass/gronn/jarl
	name = "Gronnian Jarl"
	tutorial = "You are a warrior-lord from Gronn and the leader of your warband. Guide them to glory and wealth or try to survive."
	outfit = /datum/outfit/job/roguetown/gronn/jarl
	class_select_category = CLASS_CAT_NOMAD
	cmode_music = 'sound/music/combat_knight.ogg'
	category_tags = list(CTAG_GRONN_JARL)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_NOBLE, TRAIT_HEAVYARMOR)
	min_pq = 40
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gronn/jarl
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/gronn/jarl/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel
	neck = /obj/item/clothing/neck/roguetown/gorget
	cloak = /obj/item/clothing/cloak/darkcloak/bear
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi
	pants = /obj/item/clothing/under/roguetown/platelegs/iron/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
	gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather/steel
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/mace/steel
	beltr = /obj/item/flashlight/flare/torch/lantern
	r_hand = /obj/item/rogueweapon/greataxe/steel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
	)
	H.set_blindness(0)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic

/datum/advclass/gronn/tideweaver
	name = "Gronnian Tideweaver"
	tutorial = "You are a cleric of the Lord of Abyss, devoted to him in prayer and arcyne. You have minor magical spells and medical knowledge in addition to your miracles, and can convert those shunned by the Holy See."
	outfit = /datum/outfit/job/roguetown/gronn/tideweaver
	class_select_category = CLASS_CAT_CLERIC
	allowed_patrons = list(/datum/patron/divine/abyssor)
	cmode_music = 'sound/music/combat_shaman2.ogg'
	category_tags = list(CTAG_GRONN_TIDEWEAVER)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT, TRAIT_ARCYNE)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 0, "ward" = TRUE)
	min_pq = 30
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/fishing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gronn/tideweaver
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/gronn/tideweaver/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/storage/belt/rogue/surgery_bag/full/bad
	r_hand = /obj/item/rogueweapon/spear/trident
	l_hand = /obj/item/rogueweapon/huntingknife/bronze
	backpack_contents = list(
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/pestle = 1,
		/obj/item/flashlight/flare/torch = 1,
	)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose)
		H.mind.AddSpell(new /datum/action/cooldown/spell/create_campfire)
		H.mind.AddSpell(new /datum/action/cooldown/spell/darkvision)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_4)
	H.set_blindness(0)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic

/datum/advclass/gronn/volfskin
	name = "Gronnian Volfskin"
	tutorial = "You are a volfskin, one of the legendary Gronnian warriors who are said to be possessed by raging volf spirits in battles. Distrusted due to your less than savoury religious practices, but well-respected for your combat prowess."
	outfit = /datum/outfit/job/roguetown/gronn/volfskin
	class_select_category = CLASS_CAT_WARRIOR
	cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	category_tags = list(CTAG_GRONN_VOLFSKIN)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_ORGAN_EATER, TRAIT_DUALWIELDER, TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN)
	min_pq = 30
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_INT = -2,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/gronn/volfskin
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/gronn/volfskin/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/trou/leather/gronn
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronn
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/reagent_containers/powder/moondust = 2,
	)
	H.set_blindness(0)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
	H.remove_language(/datum/language/common)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic

/datum/advclass/gronn/huscarl
	name = "Gronnian Huscarl"
	tutorial = "You are a loyal and skilled bodyguard to your jarl, specialising in pillaging, kidnapping and fighting with an axe and shield."
	outfit = /datum/outfit/job/roguetown/gronn/huscarl
	class_select_category = CLASS_CAT_WARRIOR
	cmode_music = 'sound/music/combat_vagarian.ogg'
	category_tags = list(CTAG_GRONN_HUSCARL)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	min_pq = 20
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/gronn/huscarl
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/gronn/huscarl/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel
	neck = /obj/item/clothing/neck/roguetown/gorget
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	pants = /obj/item/clothing/under/roguetown/splintlegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/atgervi
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
	)
	H.set_blindness(0)
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/slave)
	H.remove_language(/datum/language/common)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic

/datum/advclass/gronn/thrall
	name = "Gronnian Thrall"
	tutorial = "An unlucky soul. Perhaps caught in a pillaging raid, or alone in the wilderness, you have been enslaved by the Gronnian warband. Work hard to appease your new masters."
	outfit = /datum/outfit/job/roguetown/gronn/thrall
	class_select_category = CLASS_CAT_NOMAD
	cmode_music = 'sound/music/combat_vagarian.ogg'
	category_tags = list(CTAG_GRONN_THRALL)
	traits_applied = list(TRAIT_STEELHEARTED)
	min_pq = 0
	subclass_stats = list(
		STATKEY_CON = -2,
		STATKEY_WIL = 1,
		STATKEY_STR = -2,
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gronn/thrall
	job_bitflag = NONE

/datum/outfit/job/roguetown/gronn/thrall/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/collar
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch
	beltr = /obj/item/flint
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	H.set_blindness(0)
	if(H.mind)
		var/classes = list("Captured Worker", "Captured Artisan", "Captured Noble", "Captured Bard")
		var/classchoice = tgui_input_list(H, "Choose your archetype.", "Available archetypes", classes)
		if(!classchoice)
			classchoice = "Captured Worker"
		switch(classchoice)
			if("Captured Worker")
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/blue
				pants = /obj/item/clothing/under/roguetown/trou
				backl = /obj/item/storage/backpack/rogue/satchel
				r_hand = /obj/item/rogueweapon/pitchfork
				l_hand = /obj/item/rogueweapon/pick
				backpack_contents = list(
					/obj/item/flashlight/flare/torch = 1,
				)
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Captured Artisan")
				beltr = /obj/item/rogueweapon/hammer/iron
				beltl = /obj/item/rogueweapon/tongs
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
				cloak = /obj/item/clothing/cloak/apron/blacksmith
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/blue
				pants = /obj/item/clothing/under/roguetown/trou
				backl = /obj/item/storage/backpack/rogue/backpack
				backr = /obj/item/rogueweapon/scabbard/sheath
				backpack_contents = list(
					/obj/item/flint = 1,
					/obj/item/rogueore/coal = 4,
					/obj/item/rogueore/iron = 5,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/recipe_book/blacksmithing = 1,
					/obj/item/recipe_book/survival = 1,
					/obj/item/armor_brush = 1,
					/obj/item/polishing_cream = 1,
				)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/engineering, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Captured Noble")
				id = /obj/item/clothing/ring/silver
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/half/red
					shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
					pants = /obj/item/clothing/under/roguetown/tights/black
				if(should_wear_femme_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
					cloak = /obj/item/clothing/cloak/raincloak/purple
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_NOVICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
			if("Captured Bard")
				cloak = /obj/item/clothing/cloak/half
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/blue
				pants = /obj/item/clothing/under/roguetown/tights/random
				backl = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
					/obj/item/rogue/instrument/lute = 1,
					/obj/item/rogue/instrument/flute = 1,
					/obj/item/rogue/instrument/drum = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
				)
				H.adjust_skillrank_up_to(/datum/skill/misc/music, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_APPRENTICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/crafting, SKILL_LEVEL_NOVICE, TRUE)
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
				var/datum/inspiration/I = new /datum/inspiration(H)
				I.grant_inspiration(H, bard_tier = BARD_T2)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic

#undef CTAG_GRONN_JARL
#undef CTAG_GRONN_TIDEWEAVER
#undef CTAG_GRONN_VOLFSKIN
#undef CTAG_GRONN_HUSCARL
#undef CTAG_GRONN_THRALL
