/datum/advclass/inquisitor/blackpowder
	name = "Blackpowder Emissary"
	tutorial = "A truly rare specimen among the ranks of the Inquisition - an agent of the Blackpowder Order now serving as an Ordinator, hunting down Psydon's many enemies, set upon this task by Marshal Inquisitionis himself. There are many mistakes a heretic can commit over their lifespan, but when facing a Blackpowder Marksman, their final error tends to be the fact that they brought a sword to a gunfight."
	outfit = /datum/outfit/job/roguetown/inquisitor/blackpowder
	subclass_languages = list(/datum/language/otavan)
	cmode_music = sound("modular_twilight_axis/firearms/sound/music/combat_blackpowder.ogg")
	category_tags = list(CTAG_INQUSITOR)
	classes = list(
	"Vanguard" = "A veteran of the Blackpowder Order, hardened by years of service and entrusted with its deadliest weapons. Armed with a Doomsdae runelock rifle and blessed by Psydon, you bring overwhelming firepower and unwavering faith to the battlefield.",
	"Volfseeker" = "A hunter trained to stalk Psydon's enemies from the shadows. Through forbidden runic arts and ruthless discipline, you became something between an inquisitor and an assassin, striking from concealment before your prey can even draw breath.")
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_SILVER_BLESSED,
		TRAIT_INQUISITION,
		TRAIT_FIREARMS_MARKSMAN,
		TRAIT_PURITAN,
		TRAIT_OUTLANDER,
		TRAIT_ARTILLERY_EXPERT
		)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 4,
		STATKEY_CON = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/twilight_firearms = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy,
		"Branding Letters" = /obj/item/branding_letters, //TA Branding
		"Branding Iron" = /obj/item/branding_iron
	)
	extra_context = "This subclass can choose between two Disciplines; the Vanguard and Volfseeker. Taking the former grants the runelock rifle, minor miracles and the 'Medium Armor' trait, while the latter provides the silent firearm, runic magic, exceptional stealth and the 'Dodge Expert' trait."

/datum/outfit/job/roguetown/inquisitor/blackpowder/pre_equip(mob/living/carbon/human/H)
	..()
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1) //Capped to T1 miracles.
	add_verb(H, /mob/living/carbon/human/proc/faith_test)
	add_verb(H, /mob/living/carbon/human/proc/torture_victim)
	if(H.mind)
		var/armors = list("Vanguard - Runelock Rifle, Medium Armor", "Volfseeker - Silent Firearm, Runic Magic & Dodge Expert")
		var/armorchoice = input(H,"EMBRACE YOUR CALLING.", "FULFILL PSYDON'S WILL.") as anything in armors
		switch(armorchoice)
			if("Vanguard - Runelock Rifle, Medium Armor")
				head = /obj/item/clothing/head/roguetown/inqhat
				cloak = /obj/item/clothing/cloak/bandolier/inq
				belt = /obj/item/storage/belt/rogue/leather/black
				beltr = /obj/item/quiver/twilight_bullet/runicbag/blessed
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/twilight_runelock/rifle
				l_hand = /obj/item/rogueweapon/sword/rapier/psy/folding/relic
				backpack_contents = list(
					/obj/item/storage/keyring/inquisitor = 1,
					/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
					/obj/item/rope/inqarticles/inquirycord = 1,
					/obj/item/grapplinghook = 1,
					/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
					/obj/item/paper/inqslip/arrival/inq = 1,
					/obj/item/rogueweapon/scabbard/sheath/noble = 1
					)
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
			if("Volfseeker - Silent Firearm, Runic Magic & Dodge Expert")
				head = /obj/item/clothing/head/roguetown/roguehood/psydon/confessor
				mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor
				cloak = /obj/item/storage/backpack/rogue/satchel/beltpack
				belt = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt/blackpowder/umbra
				r_hand = /obj/item/clothing/gloves/roguetown/knuckles/psydon/relic
				beltr = /obj/item/quiver/twilight_bullet/silver
				backpack_contents = list(
					/obj/item/storage/keyring/inquisitor = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger,
					/obj/item/clothing/head/inqarticles/blackbag = 1,
					/obj/item/inqarticles/garrote = 1,
					/obj/item/rope/inqarticles/inquirycord = 1,
					/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
					/obj/item/paper/inqslip/arrival/inq = 1,
					/obj/item/rogueweapon/scabbard/sheath/noble = 1
					)
				var/quivers = list("Holy Fyrepowder", "Psydonian Powder")
				var/ammochoice = input(H,"SELECT YOUR POWDER.", "LAY WASTE TO THE HERETICS.") as anything in quivers
				switch(ammochoice)
					if("Holy Fyrepowder")
						l_hand = /obj/item/twilight_powderflask/holyfyre
					if("Psydonian Powder")
						l_hand = /obj/item/twilight_powderflask/volf
				ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_BLACKBAGGER, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, 5, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, 5, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/climbing, 4, TRUE)
				H.mind?.AddSpell(new /datum/action/cooldown/spell/blink/shadowstep/runed)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/shadowstep/runed)
				H.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/repel/runed)
				H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/invisibility/runed)
				H.mind?.AddSpell(new /datum/action/cooldown/spell/stasis)

	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	neck = /obj/item/clothing/neck/roguetown/bevor/blackpowder
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan/inqgloves
	id = /obj/item/clothing/ring/signet/psy
	if(H.pronouns == HE_HIM || H.pronouns == THEY_THEM)
		shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	else
		shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots/heels

	change_origin(H, /datum/virtue/origin/otava, "Holy order")
