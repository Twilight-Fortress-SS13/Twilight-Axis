/datum/hag_boon/trait/no_hunger
	name = "Trait - Foodless"
	trait_to_apply = TRAIT_NOHUNGER
	desc = "The bearer can survive and live without food and water."
	points = 30

/datum/hag_boon/trait/death_sight
	name = "Trait - Death Sight"
	trait_to_apply = TRAIT_DEATHSIGHT
	desc = "The bearer can feel if someone died near him..."
	points = 20

/datum/hag_boon/trait/parry_expert
	name = "Trait - Parry Expert"
	trait_to_apply = TRAIT_PARRYEXPERT
	desc = "Enhances the bearer's abiliy to parry with weapon."
	points = 30

/datum/hag_boon/trait/poison_immune
	name = "Trait - Poison Immune"
	trait_to_apply = TRAIT_TOXIMMUNE
	desc = "Grants the snake constitution, that allows to endure any poison."
	points = 30

/datum/hag_boon/trait/eoran_serene
	name = "Trait - No Stress"
	trait_to_apply = TRAIT_EORAN_SERENE
	desc = "Grants the bearer the blessing of Eora, removing any stress."
	points = 40

/datum/hag_boon/trait/light_step
	name = "Trait - Light Steps"
	trait_to_apply = TRAIT_LIGHT_STEP
	desc = "Bearer steps more lighty and swifty, makes less noise when walking and can sneak much quicker."
	points = 20

/datum/hag_boon/trait/noble
	name = "Trait - Noble"
	trait_to_apply = TRAIT_NOBLE
	desc = "Bearer becomes noble!"
	points = 50

/datum/hag_boon/trait/noble/apply_boon_effect(mob/living/L)
	ADD_TRAIT(L, TRAIT_NOBLE_UNLANDED, TRAIT_HAG_BOON)
	..()

/datum/hag_boon/trait/regeneration
	name = "Trait - Regrow Limb"
	trait_to_apply = TRAIT_REGROW_LIMBS
	desc = "The bearer will gain ability to regrow limbs if sleeping."
	points = 30

/datum/hag_boon/trait/lightweight_armor
	name = "Trait - Armor No Speed Cap"
	trait_to_apply = TRAIT_ARMOR_NOSPDCAP
	desc = "The bearer will never get slowdowned by armor."
	points = 30

/datum/hag_boon/trait/lightweight_armor
	name = "Trait - Heretic Seer"
	trait_to_apply = TRAIT_HERETIC_SEER
	desc = "The bearer can see if someone heretic-minded."
	points = 30

/datum/hag_boon/trait/strong_kick
	name = "Trait - Strong Kick"
	trait_to_apply = TRAIT_STRONGKICK
	desc = "The bearer will be guaranteed to knockdown the victim on kick."
	points = 50

/datum/hag_boon/trait/sentinel_of_wits
	name = "Trait - Sentinel Of Wits"
	trait_to_apply = TRAIT_SENTINELOFWITS
	desc = "The bearer will gain bonus to parry/dodge the smarter he is."
	points = 10

/datum/hag_boon/trait/firearms_marksman
	name = "Trait - Firearms Marksman"
	desc = "The bearer can progress firearms to legendary level, and will become better at it when taking a boon."
	points = 30

/datum/hag_boon/trait/firearms_marksman/apply_boon_effect(mob/living/L)
	ADD_TRAIT(L, TRAIT_FIREARMS_MARKSMAN, TRAIT_HAG_BOON)
	L.adjust_skillrank(/datum/skill/combat/twilight_firearms, 2, TRUE)
	return

/datum/hag_boon/trait/firearms_marksman/remove_boon_effect(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_FIREARMS_MARKSMAN, TRAIT_HAG_BOON)
	L.adjust_skillrank(/datum/skill/combat/twilight_firearms, -2, TRUE)
	return

/datum/hag_boon/trait/intellectual
	name = "Trait - Intellectual"
	trait_to_apply = TRAIT_INTELLECTUAL
	desc = "The bearer will see if someone smarter or dumber or him, and will see a little more information about enemy."
	points = 10

/datum/hag_boon/trait/noc_light_blessing
	name = "Trait - Noc Blessing"
	trait_to_apply = TRAIT_NOC_LIGHT_BLESSING
	desc = "The bearer will become stronger at night."
	points = 30

/datum/hag_boon/trait/civil_barbarian
	name = "Trait - Unarmed Amplifier"
	trait_to_apply = TRAIT_CIVILIZEDBARBARIAN
	desc = "The bearer will parry far more effectively with bracers, knuckles, and bandages, strike harder with unarmed attacks, and be able to reach any limb with their fists and feet."
	points = 30


// MODULAR CHANGES
// Anyone can use this with just having magica, why do it cost 40???
/datum/hag_boon/trait/mirror_magic
	points = 10

// I don't think this should cost SO much
/datum/hag_boon/trait/wood_walker
	points = 10

// Same
/datum/hag_boon/trait/azure_native
	points = 20

/datum/hag_boon/trait/crackhead
	points = 20

/datum/hag_boon/trait/civil_barbarian/apply_boon_effect(mob/living/L)
	. = ..()
	L.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	L.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	return

/datum/hag_boon/trait/civil_barbarian/remove_boon_effect(mob/living/L)
	. = ..()
	L.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	L.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	return

/datum/hag_boon/trait/expert_smithing/apply_boon_effect(mob/living/L)
	. = ..()
	L.adjust_skillrank(/datum/skill/craft/weaponsmithing, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/armorsmithing, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/blacksmithing, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/smelting, 2, FALSE)

/datum/hag_boon/trait/expert_alchemy/apply_boon_effect(mob/living/L)
	. = ..()
	L.adjust_skillrank(/datum/skill/craft/alchemy, 2, FALSE)

/datum/hag_boon/trait/expert_medicine/apply_boon_effect(mob/living/L)
	. = ..()
	L.adjust_skillrank(/datum/skill/misc/medicine, 2, FALSE)
	if(!L.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
		L.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)

/datum/hag_boon/trait/expert_sewing/apply_boon_effect(mob/living/L)
	. = ..()
	L.adjust_skillrank(/datum/skill/craft/tanning, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/sewing, 2, FALSE)
	L.adjust_skillrank(/datum/skill/labor/butchering, 2, FALSE)

/datum/hag_boon/trait/expert_survival/apply_boon_effect(mob/living/L)
	. = ..()
	L.adjust_skillrank(/datum/skill/craft/traps, 2, FALSE)
	L.adjust_skillrank(/datum/skill/misc/tracking, 2, FALSE)
	L.adjust_skillrank(/datum/skill/labor/butchering, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/sewing, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/tanning, 2, FALSE)
	L.adjust_skillrank(/datum/skill/misc/hunting, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/cooking, 2, FALSE)

/datum/hag_boon/trait/expert_homestead/apply_boon_effect(mob/living/L)
	. = ..()
	L.adjust_skillrank(/datum/skill/craft/cooking, 2, FALSE)
	L.adjust_skillrank(/datum/skill/labor/farming, 2, FALSE)
	L.adjust_skillrank(/datum/skill/labor/fishing, 2, FALSE)
	L.adjust_skillrank(/datum/skill/labor/lumberjacking, 2, FALSE)
	L.adjust_skillrank(/datum/skill/labor/mining, 2, FALSE)
	L.adjust_skillrank(/datum/skill/labor/butchering, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/masonry, 2, FALSE)
	L.adjust_skillrank(/datum/skill/craft/ceramics, 2, FALSE)
