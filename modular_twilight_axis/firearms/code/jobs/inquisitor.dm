/datum/advclass/inquisitor/blackpowder
	name = "Blackpowder Emissary"
	tutorial = "A truly rare specimen among the ranks of the Inquisition - an agent of the Blackpowder Order now serving as an Ordinator, hunting down Psydon's many enemies, set upon this task by Marshal Inquisitionis himself. There are many mistakes a heretic can commit over their lifespan, but when facing a Blackpowder Marksman, their final error tends to be the fact that they brought a sword to a gunfight."
	outfit = /datum/outfit/job/roguetown/inquisitor/blackpowder
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'modular_twilight_axis/firearms/sound/music/combat_blackpowder.ogg'
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
				beltl = /obj/item/rogueweapon/knuckledusters/psy/relic
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
	shoes = /obj/item/clothing/shoes/roguetown/boots/otavan/inqboots
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	gloves = /obj/item/clothing/gloves/roguetown/otavan/inqgloves
	id = /obj/item/clothing/ring/signet/psy

	change_origin(H, /datum/virtue/origin/otava, "Holy order")

/obj/item/rogueweapon/sword/rapier/psy/folding/relic
	name = "\"Testament\""
	desc = "Commissioned by the Inquisition and wrought by the blacksmiths of Arkenfeit, this peculiar blade was made for those \
	who could ill afford to announce their calling before the time came to draw steel. Its silvered edge folds neatly into \
	the hilt, concealing a weapon fit for the most delicate of investigations. Many a heretic has mistaken its bearer for \
	a harmless clerk, only to learn that the Inquisition keeps its sharpest judgements close at hand."
	max_integrity = 250
	max_blade_int = 250
	extended = FALSE

/obj/item/rogueweapon/sword/rapier/psy/folding/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/psy/folding/relic/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier, /datum/intent/sword/thrust/rapier/lunge)
		wlength = WLENGTH_NORMAL
		w_class = WEIGHT_CLASS_BULKY
		sharpness = IS_SHARP
		slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
		icon_state = "psyfoldingblade_on"
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
	else
		possible_item_intents = list(/datum/intent/sword/strike)
		wlength = WLENGTH_SHORT
		w_class = WEIGHT_CLASS_SMALL
		sharpness = IS_BLUNT
		slot_flags = ITEM_SLOT_HIP
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS
		icon_state = "psyfoldingblade_off"
	if(user.a_intent)
		var/datum/intent/I = user.a_intent
		if(istype(I))
			I.afterchange()
	user.update_a_intents()
	update_icon()

/obj/item/rogueweapon/knuckledusters/psy/relic
	name = "\"Penance\""
	desc = "Forged in the workshops of Otava from silver-blessed steel, these brutal knuckles were carried by an inquisitor \
	who made a practice of delivering judgement without drawing a blade. The three crowned studs bear the mark of Psydon, \
	and each blow is said to serve as a reminder that faith need not wield a sword to break the bones of the wicked."
	force = 30
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'

/obj/item/rogueweapon/knuckledusters/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 0,\
	)

/obj/item/rogueweapon/knuckledusters/psy/relic/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] starts adjusting their grip on [src]."))
	if(do_after(user, 3 SECONDS))
		var/obj/item/rogueweapon/knuckledusters/psy/relic/P = new /obj/item/clothing/gloves/roguetown/knuckles/psydon/relic(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = src.obj_integrity
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops adjusting their grip on [src]."))
		return

/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic
	name = "\"Penance\""
	desc = "Forged in the workshops of Otava from silver-blessed steel, these brutal knuckles were carried by an inquisitor \
	who made a practice of delivering judgement without drawing a blade. The three crowned studs bear the mark of Psydon, \
	and each blow is said to serve as a reminder that faith need not wield a sword to break the bones of the wicked."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	unarmed_bonus = 10

/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] starts adjusting their grip on [src]."))
	if(do_after(user, 3 SECONDS))
		var/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic/P = new /obj/item/rogueweapon/knuckledusters/psy/relic(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = src.obj_integrity
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops adjusting their grip on [src]."))
		return
