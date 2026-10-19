/datum/advclass/mercenary/twilight_republican_comendant
	name = "Republican Comendant"
	tutorial = "Regardless of your past whether you’re a marshal who turned down his titles or a guardsman who rose through the ranks on his own. From now on, you’ll earn your living by leading others."
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_republican_comendant
	traits_applied = list(TRAIT_STEELHEARTED)
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	maximum_possible_slots = 1
	origin_limits = list(/datum/virtue/origin/heartfelt)
	allowed_patrons = list(/datum/patron/divine/undivided, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/necra, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/old_god, /datum/patron/inhumen/graggar, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)
	class_select_category = CLASS_CAT_HEARTFELT
	subclass_languages = list(/datum/language/etruscan)
	cmode_music = sound("modular_twilight_axis/sound/music/republicantroublemaker.ogg")

	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN

	)

/datum/outfit/job/roguetown/mercenary/twilight_republican_comendant/pre_equip(mob/living/carbon/human/H)
	..()

	add_verb(H, /mob/proc/haltyell)

	add_verb(H, list(/mob/living/carbon/human/mind/proc/setorders))

	head = /obj/item/clothing/head/roguetown/duelhat/hrthat
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/hrtpants
	cloak = /obj/item/clothing/cloak/hrtcape
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/smoke
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/roguekey/mercenary = 1,
	)

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/movemovemove)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/takeaim)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/hold)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
		var/class = list("Sergeant", "Orator")
		var/class_choice = input(H, "Choose your path.", "CHOOSE YOUR STORY.") as anything in class
		switch(class_choice)
			if ("Sergeant")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick/plagua
				shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter/hrtshirt
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
				beltr = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/iron/snouted
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_STR, 2)
			if ("Orator")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/rapier/vaquero
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
				beltl = /obj/item/rogueweapon/scabbard/sword
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/hrtcoat
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/hrtboots
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/light
				beltr = /obj/item/clothing/head/roguetown/helmet/skullcap
				backl = /obj/item/quiver/bolt/light
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_SPD, 2)

