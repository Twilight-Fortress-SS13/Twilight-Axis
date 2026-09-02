/datum/advclass/blackoak/wardancer
	name = "Wardancer"
	tutorial = "You are a fearless and unpredictable warrior of the woods. You choose paths that others don't even dare to use. Other kin may see your actions rather wild, but you rejoice once you enact a pattern of lethal movements, complementing your dance in the battle with foes of the Oak. Your body is filled with wild magic, making you resilient to any strikes. Let your deadly dance be remembered by surviving serfs of the False Crown."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/blackoak/wardancer
	category_tags = list(CTAG_BLACKOAK)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	subclass_languages = list(/datum/language/elvish)
	traits_applied = list(TRAIT_CRITICAL_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_DUALWIELDER, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_CON = 3,
		STATKEY_PER = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 2
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )

/datum/outfit/job/roguetown/blackoak/wardancer/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/briarthorns/bloack
	mask = /obj/item/clothing/head/roguetown/dendormask/armored
//	armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/light  // to be changed
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/dress/tavern  //Huh why dresss??? Brother, I chose  warhammer's wardancers, and they're wearing dresses there and it looks sick, aight?
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/elvish = 1,
		)
	H.mind.AddSpell(new /datum/action/cooldown/spell/conjure_arcyne_ward/druid)

/datum/outfit/job/roguetown/blackoak/wardancer/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Double Elvish Sabres", "Double Elvish Shortswords", "Double Elvish Daggersd")
	var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in weapons
	switch(weapon_choice)
		if("Double Elvish Sabres")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/elf)
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/elf)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Double Elvish Shortswords")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/elvish)
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_L, TRUE)
		if("Double Elvish Daggers")
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/elvish)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_L, TRUE)


/obj/item/clothing/head/roguetown/briarthorns/bloack
	name = "black oak thorns"
	desc = "A circlet of thorns often worn by wardancers of the Black Oak. Designed to dig \
	into the flesh strengthening the will of the wearer."
	armor = ARMOR_BRIGANDINE
