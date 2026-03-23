/datum/advclass/wretch/twilight_runemaster
	name = "Otavian Runemaster"
	tutorial = "Fleed from strong and harsh Otavian domain, a skilled runemaster that cames to this lands to seek shelter and protect his earned freedom."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/twilight_runemaster
	category_tags = list(CTAG_WRETCH)
	maximum_possible_slots = 1
	cmode_music = 'modular_twilight_axis/sound/music/combat_tabaxi.ogg'
	subclass_languages = list(/datum/language/otavan)
	traits_applied = list(TRAIT_RUNEMASTER, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_STR = 2
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE
	)
	extra_context = "This subclass is race-limited to: Humen Male Only. Will enforce faith to Psydon"

/datum/outfit/job/roguetown/wretch/twilight_runemaster/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("A long painful years of struggle has finally ended, and you finally arrived to this lands to escape from the Otavian rules and live in your own way with noledge of powerfull runes."))
	H.mind?.current.faction += "[H.name]_faction"
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.set_patron(/datum/patron/old_god)

	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	cloak = /obj/item/clothing/cloak/tabard/psydontabard
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	neck = /obj/item/clothing/neck/roguetown/leather
	backr = /datum/anvil_recipe/weapons/silver/exec
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/huntingknife/copper
	backpack_contents = list(
		/obj/item/book/rogue/runemaster_codex = 1
		)
	H.merctype = 2
	H.AddComponent(/datum/component/combo_core/runeblade, 30 SECONDS, 3, 3)
