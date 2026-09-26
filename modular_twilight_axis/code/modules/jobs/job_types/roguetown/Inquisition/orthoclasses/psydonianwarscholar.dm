/datum/advclass/psydonianwarscholar
	name = "Warscholar"
	tutorial = "You are a Warscholar of the Golden Cross Order, reluctantly attached to the Otavan Inquisition. \
	Grounded in the unique Naledian Psydonite faith, you blend unwavering devotion with esoteric arts that orthodox Inquisitors view with profound suspicion. \
	Your expertise lies in the Arcana of Reversed Decay—manipulating the very fabric of time to mend catastrophic wounds and purge demonic blights—alongside powerful protective wards designed to cast out ifrits and djinn. \
	Though the Inquisition questions your methods and your dual veneration of the Psydon and Noc, they cannot deny your indispensability."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/psydonianwarscholar
	subclass_languages = list(/datum/language/otavan, /datum/language/raneshi)
	cmode_music = 'sound/music/warscholar.ogg'
	category_tags = list(CTAG_ORTHODOXIST)
	traits_applied = list(
		TRAIT_PSYDONITE,
		TRAIT_ARCYNE,
		TRAIT_NALEDI,
		TRAIT_ALCHEMY_EXPERT,
	)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_STR = -1,
	)
	age_mod = /datum/class_age_mod/war_scholar
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "post_aspect_spells" = list(/datum/action/cooldown/spell/mindlink, /datum/action/cooldown/spell/mending), "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy,
		"Psydon Gift" = /obj/item/hourglass/temporal
	)

	extra_context = "As one of the best magicians, you managed to take your favorite watch with you."

/datum/outfit/job/roguetown/psydonianwarscholar
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/psydonianwarscholar/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	r_hand = /obj/item/rogueweapon/woodstaff/implement/grand/naledi/warscholar
	head = /obj/item/clothing/head/roguetown/roguehood/psydon/warscholar
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	cloak = /obj/item/clothing/cloak/tabard/psydontabard
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/warscholar
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/hierophant/warscholar
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/warscholar
	mask = /obj/item/clothing/mask/rogue/lordmask/naledi
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver/naledi
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/clothing/ring/signet/psy/g
	var/naledi_book = pick(/obj/item/book/rogue/naledi1, /obj/item/book/rogue/naledi2, /obj/item/book/rogue/naledi3, /obj/item/book/rogue/naledi4)
	backpack_contents = list(
		/obj/item/chalk = 1,
		/obj/item/roguekey/inquisitionmanor,
		/obj/item/paper/inqslip/arrival/ortho,
		/obj/item/rogueweapon/spellbook/greater,
		(naledi_book) = 1
	)

/obj/item/rogueweapon/woodstaff/implement/grand/naledi/warscholar
	base_implement_name = "naledian greater staff"
	name = "naledian greater staff"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/polearms64.dmi'
	desc = "A grand staff issued to the Warscholars of the Golden Cross. Instead of the traditional crescent moon, its crown features a gleaming golden psycross."
	icon_state = "naledistaffalt"

/obj/item/clothing/under/roguetown/trou/leather/pontifex/warscholar
	name = "war scholar's chaqchur"
	desc = "A sturdy pair of baggy, thin leather pants. The perfect garb for protecting one from the hot sun and the harsh sands of Naledi."
	naledicolor = FALSE

/obj/item/clothing/suit/roguetown/shirt/robe/hierophant/warscholar
	name = "war scholar's kandys"
	desc = "A thin piece of fabric worn under a robe to stop chafing and keep one's dignity if a harsh blow of wind comes through. Despite the light fabric, it offers decent protection."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "psydongown"
	item_state = "psydongown"
	naledicolor = FALSE

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/warscholar
	name = "war scholar's shawl"
	desc = "Thick and protective while remaining light and breezy; the perfect garb for protecting one from the hot sun and the harsh sands of Naledi."
	color = "#48443b"
	naledicolor = FALSE

/obj/item/clothing/head/roguetown/roguehood/psydon/warscholar
	name = "war scholar's pashmina"
	desc = "A protective hood, favored by the Golden Order. It offers reliable defense while allowing the wearer to remain focused amidst the chaos of battle."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	icon_state = "psydonhijab"
	item_state = "psydonhijab"