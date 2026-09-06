/obj/item/rogueweapon/handclaw/gronn/silver/psy
	name = "psydonic claws"
	desc = "Three silver claws mounted upon a reinforced gauntlet, blessed for those who hunt in silence. \
	Though lacking the reach of a sword, they find purchase where steel cannot, rending the servants of darkness in Psydon's name."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psyclaws"

/obj/item/rogueweapon/handclaw/gronn/silver/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/silver/psyrapier
	name = "psydonic foil"
	desc = "A slender silver foil crafted for swift and precise strikes. \
	Though elegant in form, it was forged with a singular purpose: to pierce both the hearts of men and the blasphemies that lurk beyond them."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psyrapier"
	sheathe_icon = "silverrapier"
	max_integrity = 175
	max_blade_int = 175
	grid_width = 32
	grid_height = 64
	dropshrink = 0
	bigboy = FALSE

/obj/item/rogueweapon/sword/rapier/silver/psyrapier/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/parrying
	name = "psydonic parrying dagger"
	desc = "A finely balanced silver parrying dagger, carried by loyal servants of the Inquisition. \
	Its crossguard turns aside wicked steel while its blessed edge delivers Psydon's judgement."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psypdagger"
	force = 15
	throwforce = 15
	wdefense = 9
	max_integrity = 150

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/parrying/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 2,\
	)
	sellprice += 200

/datum/advclass/blackpowder_legionnaire
	name = "Blackpowder Legionnaire"
	tutorial = "In the Blackpowder Order, every fourth soldier is a sharpshooter, armed with advanced Otavan firearms. These Legionnaires are the very essence of the everchanging face of warfare, and when the Final War begins, it is with their power that the evil will be driven back."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/blackpowder_legionnaire
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_blackpowder.ogg'
	category_tags = list(CTAG_ORTHODOXIST)
	traits_applied = list(TRAIT_PSYDONITE, TRAIT_ARTILLERY_EXPERT)
	subclass_stats = list(
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_INT = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE, //Using gunpowder in holy war brings me closer to Psydon.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose between two Disciplines; the Legionnaire and Rune Volf. Legionnaires may choose between light or medium armor, gaining either the 'Dodge Expert' or 'Maille Training' trait, alongside a selection of powerful blackpowder weapons. Rune Volfs instead specialize in stealth, rune magic and silent firearms."

/datum/outfit/job/roguetown/blackpowder_legionnaire
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/blackpowder_legionnaire/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/disciplines = list("Blackpowder Legionnaire - Heavy Firearms, Medium or Light Armor (+I CON / +I INT)", "Rune Volf - Stealth, Rune Magic & Silent Firearms (+I SPD)"
		)
		var/discipline_choice = input(H, "Choose your DISCIPLINE.", "TAKE UP PSYDON'S PATH.") as anything in disciplines
		switch(discipline_choice)
			if("Blackpowder Legionnaire - Heavy Firearms, Medium or Light Armor (+I CON / +I INT)")
				var/armors = list("Medium Armor - Maille Training, Psydonic Cuirass", "Light Armor - Dodge Expert, Psydonic Chestplate")
				var/armor_choice = input(H, "Choose your ARMOR.", "TAKE UP PSYDON'S MANTLE.") as anything in armors
				switch(armor_choice)
					if("Medium Armor - Maille Training, Psydonic Cuirass")
						armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/ornate
						pants = /obj/item/clothing/under/roguetown/chainlegs
						ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
					if("Light Armor - Dodge Expert, Psydonic Chestplate")
						armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/psydon
						pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
						ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				var/weapons = list("Psydonic Shortsword", "Psydonic Cudgel", "Psydonic Flanged Mace")
				var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
				switch(weapon_choice)
					if("Psydonic Shortsword")
						l_hand = /obj/item/rogueweapon/sword/short/psy
						r_hand = /obj/item/rogueweapon/scabbard/sword
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
					if("Psydonic Cudgel")
						l_hand = /obj/item/rogueweapon/mace/cudgel/psy
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
					if("Psydonic Flanged Mace")
						l_hand = /obj/item/rogueweapon/mace/cudgel/flanged/psy
						H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
				var/rangedweapons = list("Purgatory - Massive Damage, Grapeshot or Cannonballs", "Runelock Pistol - Rapid Reload, Runic Ammunition")
				var/rangedweapon_choice = input(H,"Choose your FIREARM.", "TAKE UP PSYDON'S ARCAGE") as anything in rangedweapons
				switch(rangedweapon_choice)
					if("Purgatory - Massive Damage, Grapeshot or Cannonballs")
						belt = /obj/item/storage/belt/rogue/leather/black
						backl = /obj/item/gun/ballistic/twilight_firearm/handgonne/purgatory
						backpack_contents += list(
							/obj/item/twilight_powderflask/holyfyre = 1,
							/obj/item/natural/bundle/fibers/full = 1,
							)
						var/quivers = list("Grapeshot - Wide Spread, Multiple Pellets", "Cannonballs - Maximum Damage, Single Projectile")
						var/ammochoice = input(H,"Choose your AMMUNITION.", "TAKE UP PSYDON'S JUDGEMENT.") as anything in quivers
						switch(ammochoice)
							if("Grapeshot - Wide Spread, Multiple Pellets")
								beltr = /obj/item/quiver/twilight_bullet/cannonball/grapeshot
							if("Cannonballs - Maximum Damage, Single Projectile")
								beltr = /obj/item/quiver/twilight_bullet/cannonball/lead
					if("Runelock Pistol - Rapid Reload, Runic Ammunition")
						belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt/blackpowder/runelock
						beltr = /obj/item/quiver/twilight_bullet/runicbag/runed
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				backpack_contents = list(
					/obj/item/roguekey/inquisitionmanor = 1,
					/obj/item/paper/inqslip/arrival/ortho = 1,
					)
			if("Rune Volf - Stealth, Rune Magic & Silent Firearms (+I SPD)")
				var/weapons = list("Psydonic Parrying Dagger", "Psydonic Foil", "Psydonic Claws")
				var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
				switch(weapon_choice)
					if("Psydonic Parrying Dagger")
						l_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/parrying
						r_hand = /obj/item/rogueweapon/scabbard/sheath
						H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
					if("Psydonic Foil")
						l_hand = /obj/item/rogueweapon/sword/rapier/silver/psyrapier
						r_hand = /obj/item/rogueweapon/scabbard/sword
						H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
					if("Psydonic Claws")
						r_hand = /obj/item/rogueweapon/handclaw/gronn/silver/psy
						H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE)
				var/runes = list("Runed Cloak", "Runed Stasis", "Runed Repel")
				var/rune_choice = input(H,"Choose your RUNE.", "PSYDON'S RUNE.") as anything in runes
				switch(rune_choice)
					if("Runed Cloak")
						H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/invisibility/runed)
					if("Runed Stasis")
						H.mind?.AddSpell(new /datum/action/cooldown/spell/stasis)
					if("Runed Repel")
						H.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/repel/runed)
				head = /obj/item/clothing/head/roguetown/roguehood/psydon/confessor
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/confessor
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt/blackpowder/umbra
				beltr = /obj/item/quiver/twilight_bullet/lead
				backpack_contents = list(
					/obj/item/roguekey/inquisitionmanor = 1,
					/obj/item/paper/inqslip/arrival/ortho = 1,
					/obj/item/twilight_powderflask/volf = 1,
					/obj/item/inqarticles/garrote = 1,
					/obj/item/clothing/head/inqarticles/blackbag = 1
					)
				ADD_TRAIT(H, TRAIT_BLACKBAGGER, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_down_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_APPRENTICE, TRUE)
				H.change_stat(STATKEY_CON, -1)
				H.change_stat(STATKEY_INT, -1)
				H.change_stat(STATKEY_SPD, 1)
				H.mind?.AddSpell(new /datum/action/cooldown/spell/blink/shadowstep/runed)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep/runed)
				H.mind?.RemoveSpell(H.mind.get_spell(/datum/action/cooldown/spell/touch/prestidigitation))

	beltl =/obj/item/storage/belt/rogue/pouch/coins/mid
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	cloak = /obj/item/clothing/cloak/bandolier/inq
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	neck = /obj/item/clothing/neck/roguetown/bevor/blackpowder
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor
	id = /obj/item/clothing/ring/signet/psy
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)

	change_origin(H, /datum/virtue/origin/otava, "Holy order")
