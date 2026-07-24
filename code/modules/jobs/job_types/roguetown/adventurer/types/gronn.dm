//Gronnian Reavers - ported from Ratwood 2.0 PR #2179 and adapted as Adventurer subclasses for Twilight Axis

/datum/advclass/gronn/jarl
	name = "Gronnian Jarl"
	tutorial = "You are a warrior-lord from Gronn and the leader of your warband. Guide them to glory and wealth or try to survive."
	outfit = /datum/outfit/job/roguetown/gronn/jarl
	class_select_category = CLASS_CAT_NOMAD
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	category_tags = list(CTAG_ADVENTURER)
	min_pq = -100
	traits_applied = list(TRAIT_STEELHEARTED)
	origin_limits = list(/datum/virtue/origin/gronn)

/datum/advclass/gronn/tideweaver
	name = "Gronnian Tideweaver"
	tutorial = "You are a cleric of the Lord of Abyss, devoted to him in prayer and arcyne. You have minor magical spells and medical knowledge in addition to your miracles, and can convert those shunned by the Holy See."
	outfit = /datum/outfit/job/roguetown/gronn/tideweaver
	class_select_category = CLASS_CAT_CLERIC
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	category_tags = list(CTAG_ADVENTURER)
	min_pq = -100
	traits_applied = list(TRAIT_STEELHEARTED)
	origin_limits = list(/datum/virtue/origin/gronn)

/datum/advclass/gronn/volfskin
	name = "Gronnian Volfskin"
	tutorial = "You are a volfskin, one of the legendary Gronnian warriors who are said to be possessed by raging volf spirits in battles. Distrusted due to your less than savoury religious practices, but well-respected for your combat prowess."
	outfit = /datum/outfit/job/roguetown/gronn/volfskin
	class_select_category = CLASS_CAT_WARRIOR
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	category_tags = list(CTAG_ADVENTURER)
	min_pq = -100
	traits_applied = list(TRAIT_STEELHEARTED)
	origin_limits = list(/datum/virtue/origin/gronn)

/datum/advclass/gronn/huscarl
	name = "Gronnian Huscarl"
	tutorial = "You are a loyal and skilled bodyguard to your jarl, specialising in pillaging, kidnapping and fighting with an axe and shield."
	outfit = /datum/outfit/job/roguetown/gronn/huscarl
	class_select_category = CLASS_CAT_WARRIOR
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	category_tags = list(CTAG_ADVENTURER)
	min_pq = -100
	traits_applied = list(TRAIT_STEELHEARTED)
	origin_limits = list(/datum/virtue/origin/gronn)

/datum/advclass/gronn/thrall
	name = "Gronnian Thrall"
	tutorial = "An unlucky soul. Perhaps caught in a pillaging raid, or alone in the wilderness, you have been enslaved by the Gronnian warband. Work hard to appease your new masters."
	outfit = /datum/outfit/job/roguetown/gronn/thrall
	class_select_category = CLASS_CAT_NOMAD
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	category_tags = list(CTAG_ADVENTURER)
	min_pq = -100
	traits_applied = list(TRAIT_STEELHEARTED)
	origin_limits = list(/datum/virtue/origin/gronn)

//Jarl outfit. Heavy armour guy with a greataxe and a sidearm mace.
/datum/outfit/job/roguetown/gronn/jarl
	job_bitflag = BITFLAG_GARRISON

/datum/outfit/job/roguetown/gronn/jarl/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi
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
	id = /obj/item/clothing/neck/roguetown/psicross/silver
	r_hand = /obj/item/rogueweapon/greataxe/steel
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_PER, 1)

	H.cmode_music = 'sound/music/combat_knight.ogg'
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]

	ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.grant_language(/datum/language/gronnic)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic

//Tideweaver outfit. T4 miraclist and some minor magics.
/datum/outfit/job/roguetown/gronn/tideweaver
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/gronn/tideweaver/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.set_patron(/datum/patron/divine/abyssor)
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
	id = /obj/item/clothing/neck/roguetown/psicross/abyssor
	r_hand = /obj/item/rogueweapon/spear/trident
	l_hand = /obj/item/rogueweapon/huntingknife/bronze
	backpack_contents = list(
		/obj/item/reagent_containers/glass/mortar = 1,
		/obj/item/pestle = 1,
		/obj/item/flashlight/flare/torch = 1
		)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 6, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/fishing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_WIL, 2)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 1)

	H.cmode_music = 'sound/music/combat_shaman2.ogg'

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose)
		H.mind.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
		H.mind.AddSpell(new /datum/action/cooldown/spell/create_campfire)
		H.mind.AddSpell(new /datum/action/cooldown/spell/darkvision)

		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, devotion_limit = CLERIC_REQ_4)

	H.grant_language(/datum/language/gronnic)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic

//Volfskin outfit. CritResist+Enduring guy with two axes.
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
	id = /obj/item/clothing/neck/roguetown/psicross/silver
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/reagent_containers/powder/moondust = 2
		)

	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 3, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 3, TRUE)

	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_INT, -2)

	H.cmode_music = 'sound/music/combat_hornofthebeast.ogg'
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]

	ADD_TRAIT(H, TRAIT_ORGAN_EATER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)

	H.grant_language(/datum/language/gronnic)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic
	H.remove_language(/datum/language/common)

//Huscarl outfit. Fighters with steel axes and shields.
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
	id = /obj/item/clothing/neck/roguetown/psicross/silver
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1
		)

	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)

	H.change_stat(STATKEY_WIL, 3)
	H.change_stat(STATKEY_CON, 3)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_SPD, -1)

	H.cmode_music = 'sound/music/combat_vagarian.ogg'
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	H.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/female/warrior]

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/slave)

	H.grant_language(/datum/language/gronnic)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic
	H.remove_language(/datum/language/common)

//Thrall outfit. Same as Gronn Wave's Slave, just with better clothes. Not required to be an Abyssorite like the rest of them.
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
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.change_stat(STATKEY_CON, -2)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_STR, -2)
	H.change_stat(STATKEY_INT, 2)
	H.change_stat(STATKEY_SPD, 2)

	H.cmode_music = 'sound/music/combat_vagarian.ogg'

	H.grant_language(/datum/language/gronnic)
	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/gronnic

	if(H.mind)
		var/classes = list("Captured Worker", "Captured Artisan", "Captured Noble", "Captured Bard")
		var/classchoice = tgui_input_list(H, "Choose your archetype.", "Available archetypes", classes)
		if(!classchoice)
			classchoice = "Captured Worker"

		H.set_blindness(0)
		switch(classchoice)
			if("Captured Worker")
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/blue
				pants = /obj/item/clothing/under/roguetown/trou
				backl = /obj/item/storage/backpack/rogue/satchel
				r_hand = /obj/item/rogueweapon/pitchfork
				l_hand = /obj/item/rogueweapon/pick

				backpack_contents = list(
					/obj/item/flashlight/flare/torch = 1
					)

				H.adjust_skillrank(/datum/skill/labor/farming, 3, TRUE)
				H.adjust_skillrank(/datum/skill/labor/mining, 2, TRUE)
				H.adjust_skillrank(/datum/skill/labor/butchering, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/crafting, 3, TRUE)

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
					/obj/item/polishing_cream = 1
					)

				H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/smelting, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/blacksmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/armorsmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/engineering, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/ceramics, 2, TRUE)

			if("Captured Noble")
				id = /obj/item/clothing/ring/silver
				if(should_wear_masc_clothes(H))
					cloak = /obj/item/clothing/cloak/half/red
					shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/red
					pants = /obj/item/clothing/under/roguetown/tights/black
				if(should_wear_femme_clothes(H))
					shirt = /obj/item/clothing/suit/roguetown/shirt/dress/gen/purple
					cloak = /obj/item/clothing/cloak/raincloak/purple
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
				H.adjust_skillrank(/datum/skill/craft/sewing, 3, TRUE)
				H.adjust_skillrank(/datum/skill/craft/cooking, 3, TRUE)
				H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)

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
					/obj/item/rogueweapon/scabbard/sheath = 1
					)
				H.adjust_skillrank(/datum/skill/misc/music, 4, TRUE)
				H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
				H.adjust_skillrank(/datum/skill/misc/stealing, 2, TRUE)
				H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)

				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
				var/datum/inspiration/I = new /datum/inspiration(H)
				I.grant_inspiration(H, bard_tier = BARD_T2)
