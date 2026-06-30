/datum/advclass/lost_grenzel/lost_mage
	name = "Lost Gefechtsgelehrter"
	tutorial = "Когда-то вы гордо называли себя магом. Теперь же вы ещё более жалки чем местные пустынные крысы - единственное, что вас отличает от них - это язык и остатки гордости выпускника Имперской Академии."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/lost_grenzel/lost_mage
	category_tags = list(CTAG_LOSTGRENZEL)
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_INTELLECTUAL, TRAIT_STEELHEARTED, TRAIT_ALCHEMY_EXPERT, TRAIT_ARCYNE)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 2, "minor" = 3, "utilities" = 6, "variants" = list(/datum/magic_aspect/pyromancy = "grenzelhoftian"), "post_aspect_spells" = list(/datum/action/cooldown/spell/message, /datum/action/cooldown/spell/magicians_brick), "ward" = TRUE)
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_WIL = 4,
		STATKEY_PER = 4,
		STATKEY_SPD = 2
	)
	age_mod = /datum/class_age_mod/grenzel_mage
	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/lost_grenzel/lost_mage/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/battleskirt
	backl = /obj/item/rogueweapon/woodstaff/implement/greater/blacksteel
	mask = /obj/item/clothing/mask/rogue/ragmask
	cloak = /obj/item/clothing/cloak/tabard/stabard/grenzelmage
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
	head = /obj/item/clothing/head/roguetown/turban
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	shoes = /obj/item/clothing/shoes/roguetown/shalal/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/book/spellbook = 1,
		/obj/item/chalk = 1
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/ballistic_mortar)
