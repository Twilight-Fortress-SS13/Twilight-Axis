/datum/advclass/rogue/soundbreaker
	name = "Soundbreaker"
	tutorial = "You are a brawling bard who turns rhythm and motion into weapons. Your fists, feet, and music break bones and shatter morale."
	outfit = /datum/outfit/job/roguetown/adventurer/soundbreaker
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(
		TRAIT_GOODLOVER, TRAIT_EMPATH, TRAIT_NOPAINSTUN, TRAIT_CIVILIZEDBARBARIAN
	)
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_ADVENTURER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/adventurer/soundbreaker/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a Soundbreaker – a brawling bard who weaves strikes into melody. Your fists keep the rhythm, your enemies keep the bruises."))
	head = /obj/item/clothing/head/roguetown/bardhat/soundbreakerhat
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe/soundbreakerrobe
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/half/red
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern

	backpack_contents = list(
		/obj/item/book/rogue/soundbreaker_codex = 1,
		/obj/item/recipe_book/survival = 1,
	)

	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)

	if(H.mind)
		H.AddComponent(/datum/component/combo_core/soundbreaker, SB_COMBO_WINDOW, SB_MAX_HISTORY, SB_MAX_VISIBLE_NOTES)
		var/weapons = list("Lute","Guitar","Hurdy-Gurdy")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy

		to_chat(H, span_notice("You feel a fighting rhythm pulsing in your veins. Your music belongs in a brawl."))
