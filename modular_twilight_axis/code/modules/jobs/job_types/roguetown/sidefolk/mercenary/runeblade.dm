/datum/advclass/mercenary/twilight_runeblade
	name = "Gronnic Runeblade"
	tutorial = "Coming from the northern lands of Grimmoria, the Runeblades are masters of the Runes, holding knowledge of exotic ones, that helps them to survive in the wild and brings victory over their foes."
	allowed_sexes = list(MALE)
	allowed_races = list(/datum/species/human/northern)
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_runeblade
	category_tags = list(CTAG_MERCENARY)
	class_select_category = CLASS_CAT_GRONN
	maximum_possible_slots = 1
	cmode_music = 'modular_twilight_axis/sound/music/combat_tabaxi.ogg'
	subclass_languages = list(/datum/language/gronnic)
	traits_applied = list(TRAIT_RUNEMASTER, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_STR = 2
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE
	)
	extra_context = "This subclass is race-limited to: Humen Male Only."

/datum/outfit/job/roguetown/mercenary/twilight_runeblade/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("It was a long journey to this country, but the one, who knows the magic older than bricks, that town was build from, but you finally arrived to bring more glory to skills that you mastered in years on wild north."))
	pants = /obj/item/clothing/under/roguetown/gronn_kilt
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle/gronn
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	neck = /obj/item/clothing/neck/roguetown/leather
	backr = /obj/item/rogueweapon/sword/long/exe
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/huntingknife/copper
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1
		)
	H.merctype = 2
	H.AddComponent(/datum/component/combo_core/runeblade, 30 SECONDS, 3, 3)

/obj/item/clothing/under/roguetown/gronn_kilt
	name = "gronnic leather kilt"
	desc = "A set of special furried leather kilt."
	gender = PLURAL
	sewrepair = FALSE
	armor = ARMOR_LEATHER_STUDDED
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	icon_state = "gronnicleather_kilt"
	item_state = "gronnicleather_kilt"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/pants.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/pants.dmi'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor.ogg'
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_LIGHT
