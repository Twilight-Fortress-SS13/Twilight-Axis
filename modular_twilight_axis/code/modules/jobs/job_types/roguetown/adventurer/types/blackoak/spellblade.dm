// WOE: SPELLBLADE DODGE EXPERT POLEARM BUILD UPON YE.
/datum/advclass/blackoak/spellblade
	name = "Spellblade"
	tutorial = "You are a master of ancient Azurian spellbladery. A sacred art meant only for the pure-blooded. To see the False Crown hand your birthright to lesser breeds was a heresy you could not stomach. Now, an outcast from a softened society, you channel the raw, untamed magycks of the Peaks into your blade. You spend your daes weaving spells of ruin and striking down the invaders with elemental fury. Your blade is the true law of the forest, cleansing the rot of civilization with every strike."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/blackoak/spellblade
	cmode_music = 'sound/music/combat_blackoak.ogg'
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 6)
	subclass_languages = list(/datum/language/elvish)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
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
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )


/datum/outfit/job/roguetown/blackoak/spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/blackoak/spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/blackoak/spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/elvish
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/silver/elvish = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "blackoak")
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade"

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = subclass_selected

	if(H.mind)
		switch(subclass_selected)
			if("blade")
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)

	var/discipline = list("Ambush (Dodge Expert)", "Cleansing (Medium Armor)")
	var/discipline_choice = input(H, "Choose your DISCIPLINE.", "HOW WILL YOU PURGE THEM?") as anything in discipline
	switch(discipline_choice)
		if("Ambush (Dodge Expert)")
			var/armors = list("Woad Elven Maille", "Trophy Fur Robes")
			var/armor_choice = input(H, "Choose your ARMOR.", "THE FOREST CLOAKS YOU.") as anything in armors
			switch(armor_choice)
				if("Woad Elven Maille")
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/light, SLOT_ARMOR, TRUE)
				if("Trophy Fur Robes")
					H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/elven, SLOT_ARMOR, TRUE)
			var/helmets = list(
				"Woad Elven Barbute"		= /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/light,
				"Elven Barbute"				= /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak,
				"Winged Elven Barbute"		= /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak,
			)
			var/helmchoice = input(H, "Choose your HELMET.", "LEAVES OVER STEEL.") as anything in helmets
			head = helmets[helmchoice]
		if("Cleansing (Maille Training)")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
			armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate
			pants = /obj/item/clothing/under/roguetown/chainlegs

	switch(subclass_selected)
		if("blade")
			var/weapons = list("Elvish Longsword", "Elvish Saber", "Elvish Curveblade", "Elvish Dagger")
			var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in weapons
			switch(weapon_choice)
				if("Elvish Longsword")
					r_hand = /obj/item/rogueweapon/sword/long/elvish
					beltr = /obj/item/rogueweapon/scabbard/sword
					backr = /obj/item/rogueweapon/shield/tower
				if("Elvish Saber")
					r_hand = /obj/item/rogueweapon/sword/sabre/elf
					beltr = /obj/item/rogueweapon/scabbard/sword
					backr = /obj/item/rogueweapon/shield/tower
				if("Elvish Curveblade")
					r_hand = /obj/item/rogueweapon/greatsword/elvish
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Elvish Dagger")
					r_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
					backr = /obj/item/rogueweapon/shield/tower
			if(weapon_choice == "Elvish Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("phalangite")
			r_hand = /obj/item/rogueweapon/halberd/glaive/elvish/silver
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("macebearer")
			backr = /obj/item/rogueweapon/shield/tower
			var/mace_weapons = list("Steel Mace", "Steel Warhammer", "Grand Mace", "Battle Axe", "Steel Greataxe")
			var/mace_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in mace_weapons
			var/picked_axe = FALSE
			switch(mace_choice)
				if("Steel Mace")
					r_hand = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer")
					r_hand = /obj/item/rogueweapon/mace/warhammer/steel
				if("Grand Mace")
					r_hand = /obj/item/rogueweapon/mace/goden/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Battle Axe")
					r_hand = /obj/item/rogueweapon/stoneaxe/battle
					picked_axe = TRUE
				if("Steel Greataxe")
					r_hand = /obj/item/rogueweapon/greataxe/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1, start_maxed = TRUE)
