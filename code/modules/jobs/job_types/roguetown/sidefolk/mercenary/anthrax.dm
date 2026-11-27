/datum/advclass/mercenary/anthrax
	name = "\"Scourge\" Pursuer" //TA EDIT
	tutorial = "Raised in the war halls of Underdark, Pursuers are the shield-wall of the noble Houses. Clad in darksteel, \
	armed with flails and shields, they march first into the fray when a Matriarch commands it. \
	You have been chosen for a mission to the surface, and while you are out there, you must earn coin to sustain yourself. \
	Regardless of whom you work for, never forget where your true allegiance lies." //TA EDIT
	forbidden_races = list(RACES_ANTHRAX)
	outfit = /datum/outfit/job/roguetown/mercenary/anthrax
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_BRAVO)

	cmode_music = sound("sound/music/combat_delf.ogg")

	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ANTHRAXI, TRAIT_ALCHEMY_EXPERT) //TA EDIT
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,

	)
	subclass_languages = list(/datum/language/undercommon)
	extra_context = "This subclass is race-restricted to the Dark Elf species, and can pick between two bonuses; an extra level to Athletics, or a rideable mount."

/datum/outfit/job/roguetown/mercenary/anthrax/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
	backl = /obj/item/storage/backpack/rogue/satchel/black
	head = /obj/item/clothing/head/roguetown/helmet/heavy/shadowvisage //TA EDIT
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/rogueweapon/scabbard/sheath)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/shadowbracers //TA EDIT
	mask = /obj/item/clothing/mask/rogue/facemask/shadowfacemask
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/shadowmantle //TA EDIT
	backr = /obj/item/rogueweapon/shield/tower/spidershield
	beltr = /obj/item/rogueweapon/whip/spiderwhip
	beltl = /obj/item/rogueweapon/flail/sflail/spiderflail //TA EDIT

	//H.faction += FACTION_SPIDER_LOWERS //TA EDIT

	if(H.mind)
		var/faction = list("Zizite Loyalists (Drow are Neutral & Darkvision)", "Tenebrite Rebels (Self-Sustenance Trait)") //TA EDIT START
		var/factionchoice = input(H, "The Underdark stands divided. Which side do you fight for?", "PLEDGE YOUR ALLEGIANCE.") as anything in faction
		switch(factionchoice)
			if("Zizite Loyalists (Drow are Neutral & Darkvision)")
				H.faction += FACTION_SPIDER_LOWERS
				ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
				if(!(istype(H.patron, /datum/patron/inhumen/zizo)))
					H.set_patron(/datum/patron/inhumen/zizo)
				to_chat(H, span_warning("Her Chosen priestesses have dictated that I must scout these lands, pretending to be a mere stray. For now, I stay my hand. The time of our salvation will come."))
			if("Tenebrite Rebels (Self-Sustenance Trait)")
				ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
				H.mind.special_items["Hammer"] = /obj/item/rogueweapon/hammer/iron
				to_chat(H, span_warning("Our fight grows more desperate. I must gather resources and allies, so that the Underdark can be free from the tyrant goddess.")) //TA EDIT END
		var/riding = list("Spidertamer (Tameable Spider Mount)", "Shroomwalker (+I to Athletics)")
		var/ridingchoice = input(H, "Choose your TRAVELBOON.", "ROAM ABROAD AND ROAM FAR.") as anything in riding
		switch(ridingchoice)
			if("Spidertamer (Tameable Spider Mount)")
				apply_virtue(H, new /datum/virtue/utility/riding)
			if("Shroomwalker (+I to Athletics)")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)

	H.merctype = 15

/datum/advclass/mercenary/anthrax_assassin
	name = "\"Anthraxi\" Assassin" //TA EDIT
	tutorial = "Every noble House keeps its knives in the dark, and you are one of them. Trained in the shadowed streets of Underdark, \
	where success is measured by a massacre that leaves no witnesses, you kill with bolts from afar or with a pair of sabres up close. \
	You have been chosen for a mission to the surface, and while you sell your blade to the highest bidder, you quietly listen for whispers your House will pay dearly to hear. \
	Whatever the contract, never forget who holds your leash." //TA EDIT
	outfit = /datum/outfit/job/roguetown/mercenary/anthrax_assassin
	forbidden_races = list(RACES_ANTHRAX)
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_BRAVO)
	class_select_category = CLASS_CAT_RACIAL
	cmode_music = sound("sound/music/combat_delf.ogg")
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_ANTHRAXI, TRAIT_ALCHEMY_EXPERT) //TA EDIT
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_INT = 1,
		STATKEY_SPD = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
	)
	extra_context = "This subclass is race-restricted to the Dark Elf species, and can pick between two bonuses; an extra level to Athletics, or a rideable mount."

/datum/outfit/job/roguetown/mercenary/anthrax_assassin/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/neck/roguetown/chaincoif/full/shadowcoif //TA EDIT
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/rogueweapon/scabbard/sheath)
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	cloak = /obj/item/clothing/cloak/half/shadowcloak
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/shadowmantle //TA EDIT
	beltl = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre/stalker
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants

	//H.faction += FACTION_SPIDER_LOWERS //TA EDIT

	if(H.mind)
		var/faction = list("Zizite Loyalists (Drow are Neutral & Darkvision)", "Tenebrite Rebels (Self-Sustenance Trait)") //TA EDIT START
		var/factionchoice = input(H, "The Underdark stands divided. Which side do you fight for?", "PLEDGE YOUR ALLEGIANCE.") as anything in faction
		switch(factionchoice)
			if("Zizite Loyalists (Drow are Neutral & Darkvision)")
				H.faction += FACTION_SPIDER_LOWERS
				ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
				if(!(istype(H.patron, /datum/patron/inhumen/zizo)))
					H.set_patron(/datum/patron/inhumen/zizo)
				to_chat(H, span_warning("Her Chosen priestesses have dictated that I must scout these lands, pretending to be a mere stray. For now, I stay my hand. The time of our salvation will come."))
			if("Tenebrite Rebels (Self-Sustenance Trait)")
				ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
				H.mind.special_items["Hammer"] = /obj/item/rogueweapon/hammer/iron
				to_chat(H, span_warning("Our fight grows more desperate. I must gather resources and allies, so that the Underdark can be free from the tyrant goddess.")) //TA EDIT END
		var/weapon = list("Bow & Poisoned Arrows", "Crossbow & Smallsword", "Dual Sabres") //TA EDIT
		var/weaponchoice = input(H, "Choose your WEAPON.", "PICK YOUR INSTRUMENTS.") as anything in weapon
		switch(weaponchoice)
			if("Bow & Poisoned Arrows")
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
				beltr = /obj/item/quiver/poisonarrows
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE) //TA EDIT
			if("Crossbow & Smallsword") //TA EDIT START
				r_hand = null
				l_hand = /obj/item/rogueweapon/sword/rapier/stalker
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/stalker
				beltr = /obj/item/quiver/bolt/standard
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE) //TA EDIT END
			if("Dual Sabres")
				l_hand = /obj/item/rogueweapon/sword/sabre/stalker
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = null
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
		var/riding = list("Spidertamer (Tameable Spider Mount)", "Shroomwalker (+I to Athletics)")
		var/ridingchoice = input(H, "Choose your TRAVELBOON.", "ROAM ABROAD AND ROAM FAR.") as anything in riding
		switch(ridingchoice)
			if("Spidertamer (Tameable Spider Mount)")
				apply_virtue(H, new /datum/virtue/utility/riding)
			if("Shroomwalker (+I to Athletics)")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)

	H.merctype = 15

/datum/advclass/mercenary/anthrax_paladin //TA EDIT START
	name = "\"Spider Queen\" Baneblade"
	tutorial = "Hailing primarily from the Undercity of Faerlin, the Baneblades are the Spider Queen's warrior-priests, wielding both Her blades and Her gifts with great proficiency. You have been chosen for a mission to the surface, and while you earn your bread and gather the information your clan requires, you are also expected to ensure the thoughts of your comrades stay true to the cause."
	forbidden_races = list(RACES_ANTHRAX)
	outfit = /datum/outfit/job/roguetown/mercenary/anthrax_paladin
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_BULWARK)

	cmode_music = sound("sound/music/combat_delf.ogg")

	maximum_possible_slots = 2
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ANTHRAXI, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)

	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_languages = list(/datum/language/undercommon)
	extra_context = "This subclass is race-restricted to the Dark Elf species. Pick your side in the Underdark Feud Wars."

/datum/outfit/job/roguetown/mercenary/anthrax_paladin/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/shadowskirt
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison = 1,
		/obj/item/rogueweapon/scabbard/sheath)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate/shadowhalfplate
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
	gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
	wrists = /obj/item/clothing/wrists/roguetown/bracers/shadowbracers
	mask = /obj/item/clothing/mask/rogue/facemask/steel/shadowfacemask/shadowjawmask
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle/shadowmantle
	l_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/spiderflamberge
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk

	if(H.mind)
		var/faction = list("Zizite Loyalists (Drow are Neutral & Darkvision)", "Tenebrite Rebels (Self-Sustenance Trait)")
		var/factionchoice = input(H, "The Underdark stands divided. Which side do you fight for?", "PLEDGE YOUR ALLEGIANCE.") as anything in faction
		switch(factionchoice)
			if("Zizite Loyalists (Drow are Neutral & Darkvision)")
				H.faction += FACTION_SPIDER_LOWERS
				ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
				if(!(istype(H.patron, /datum/patron/inhumen/zizo)))
					H.set_patron(/datum/patron/inhumen/zizo)
				to_chat(H, span_warning("Her Chosen priestesses have dictated that I must scout these lands, pretending to be a mere stray. For now, I stay my hand. The time of our salvation will come."))
			if("Tenebrite Rebels (Self-Sustenance Trait)")
				ADD_TRAIT(H, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC)
				H.mind.special_items["Hammer"] = /obj/item/rogueweapon/hammer/iron
				to_chat(H, span_warning("Our fight grows more desperate. I must gather resources and allies, so that the Underdark can be free from the tyrant goddess."))

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.

	H.merctype = 15 //TA EDIT END

/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/shadowskirt
	name = "silk vestments"
	desc = "Form-fitting vestments, marked with the symbols of the Underdark."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/anthrax.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/anthrax.dmi'
	icon_state = "shadowskirt"
	armor = ARMOR_MAILLE

/obj/item/clothing/neck/roguetown/chaincoif/full/shadowcoif
	name = "full darkplate coif"
	desc = "A hood of blackened rings that shrouds the head and throat. Whatever stares out from behind it is of no concern to the metal."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/anthrax.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/anthrax.dmi'
	icon_state = "fshadowcoif"
	smeltresult = /obj/item/ingot/drow

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/shadowmantle
	name = "darkplate mantle"
	desc = "A mantle of lightless links, heavy across the shoulders. A fitting weight for those who answer to something greater."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/anthrax.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/anthrax.dmi'
	icon_state = "shadowmantle"
	smeltresult = /obj/item/ingot/drow

/obj/item/clothing/wrists/roguetown/bracers/shadowbracers
	name = "darkplate bracers"
	desc = "Bracers of darkened steel, etched with a pattern of webbing. Each strand is said to represent a debt owed."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/anthrax.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/anthrax.dmi'
	icon_state = "shadowbracers"
	smeltresult = /obj/item/ingot/drow

/obj/item/clothing/suit/roguetown/armor/plate/fluted/shadowplate/shadowhalfplate
	name = "scourge half-plate"
	desc = "Less gilding, more darksteel. This is armor made for the front of the line, not the center of the court."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/anthrax.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/anthrax.dmi'
	icon_state = "shadowhalfplate"

/obj/item/clothing/head/roguetown/helmet/heavy/shadowvisage
	name = "scourge visage"
	desc = "Gilded horns, darkened iron; a warning of the venom not held by itself, but by the one who has taken up this visage."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/anthrax.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/anthrax.dmi'
	icon_state = "shadowvisage"
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDESNOUT
	adjustable = CAN_CADJUST
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL - ARMOR_INT_HELMET_HEAVY_ADJUSTABLE_PENALTY
	smeltresult = /obj/item/ingot/drow
	stack_fovs = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/shadowvisage/ComponentInitialize()
	..()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS), null, 'sound/items/visor.ogg', null, UPD_HEAD)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_HONORBOUND)
	AddComponent(/datum/component/armour_filtering/negative, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/head/roguetown/helmet/heavy/shadowvisage/attackby(obj/item/W, mob/living/user, params)
	..()
	if(!(istype(W, /obj/item/natural/feather) && !detail_tag))
		return
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	user.transferItemToLoc(W, src, FALSE, FALSE)
	detail_color = COLOR_WHITE
	detail_tag = "_detail"
	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/H = user
		H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/heavy/shadowvisage/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[get_detail_state(icon_state)][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/head/roguetown/helmet/heavy/shadowvisage/shadowsavoyard
	name = "scourge savoyard"
	desc = "A helmet forged in the great Underdark, no doubt a Duergar had a hand in making this. The material has started to lose its color under Astrata's gaze, yet one feature stands above all - a combination \
	of a visor and gold that inspires happiness, or tries to. Lighten up, will you?"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/anthrax.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/anthrax.dmi'
	icon_state = "shadowsavoyard"

/obj/item/clothing/mask/rogue/facemask/steel/shadowfacemask/shadowjawmask
	name = "anthraxi jawmask"
	desc = "A half-mask of blackened steel, its teeth cut into a grin. Some wish to be recognized only by their work."
	block2add = null
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_MASK_IRON
	icon = 'modular_twilight_axis/icons/roguetown/clothing/special/anthrax.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/special/onmob/anthrax.dmi'
	icon_state = "shadowjawmask"

/obj/item/rogueweapon/greatsword/grenz/flamberge/spiderflamberge
	name = "spider flamberge"
	desc = "The grave wounds caused by flame-bladed swords make them a highly sought-after weapon among the Drow - the charges of dishonorable warfare notwithstanding. \
	Consequentially, these weapons are often wielded by both sides of the Underdark Feud Wars."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/anthrax64.dmi'
	icon_state = "spiderflamberge"
	max_integrity = 240
	max_blade_int = 180
	smeltresult = /obj/item/ingot/drow

/obj/item/rogueweapon/flail/sflail/spiderflail
	name = "spider flail"
	desc = "A fanged head on a length of braided chain, its haft wrapped in dried silk. The swingle were never meant to kill quickly."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/anthrax.dmi'
	icon_state = "spiderflail"
	smeltresult = /obj/item/ingot/drow

/obj/item/rogueweapon/sword/rapier/stalker
	name = "stalker smallsword"
	desc = "A slender, needle-pointed blade, made to find the gaps between plate and rib. Elegant in the hand, and more so in the deed."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/anthrax.dmi'
	icon_state = "spidersmallsword"
	sheathe = "modular_twilight_axis/icons/obj/items/scabbard.dmi"
	sheathe_icon = "spidersmallsword"
	grid_width = 32
	grid_height = 64
	dropshrink = 0
	bigboy = FALSE
	smeltresult = /obj/item/ingot/drow

/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/stalker
	name = "stalker crossbow"
	desc = "A compact crossbow of dark wood and blackened steel, its stock carved with a pattern of webs. Quiet work for those who prefer their quarrels to be the last thing heard."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/anthrax.dmi'
	icon_state = "spidercrossbow0"
	item_state = "spidercrossbow"
	smeltresult = /obj/item/ingot/drow
