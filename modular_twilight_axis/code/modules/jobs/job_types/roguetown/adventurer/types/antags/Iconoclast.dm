/datum/advclass/iconoclast
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 2
	)


/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(mob/living/carbon/human/H)
	add_verb(H, /mob/proc/haltyell_exhausting)
	if (!(istype(H.patron, /datum/patron/inhumen/matthios)))
		to_chat(H, span_warning("Matthios embraces me.. I must uphold his creed. I am his light in the darkness."))
		H.set_patron(/datum/patron/inhumen/matthios)
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/ritechalk = 1,
					)
	id = /obj/item/mattcoin
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)
	H.mind.AddSpell(new /datum/action/cooldown/spell/matthios/raze)
	var/subtype = list("Chosen of Matthios", "Golden Serpent")
	if(H.mind)
		var/subtype_choice = input(H, "Choose your path.", "TAKE UP ARMS") as anything in subtype
		H.set_blindness(0)
		switch(subtype_choice)
			if("Chosen of Matthios") //Classic
				r_hand = /obj/item/rogueweapon/woodstaff
				head = /obj/item/clothing/head/roguetown/roguehood
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				beltr = /obj/item/rogueweapon/katar
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
				shoes = /obj/item/clothing/shoes/roguetown/shortboots
				cloak = /obj/item/clothing/cloak/raincloak/furcloak/brown
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
			if("Golden Serpent") //Pugilist
				head = /obj/item/clothing/head/roguetown/headband/monk
				mask = /obj/item/clothing/mask/rogue/eyepatch
				wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/iconoclast
				shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
				shoes = /obj/item/clothing/shoes/roguetown/sandals
				ADD_TRAIT(H, TRAIT_CYCLOPS_RIGHT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_LEGENDARY, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_LEGENDARY, TRUE)
				var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff")
				var/technique_choice = input(H, "Choose your TECHNIQUE.", "DECIMATE AND DOMINATE WITH FLAIR.") as anything in techniques
				switch(technique_choice)
					if("Dropkick - Pushback + Extra Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
					if("Chokeslam - Stamina Damage")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
					if("Stunner - Dazed Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
					if("Headbutt - Vulnerable Debuff")
						H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)
				var/static/list/safe_bodyzones = list(
					BODY_ZONE_HEAD,
					BODY_ZONE_CHEST,
					BODY_ZONE_R_ARM,
					BODY_ZONE_L_LEG,
					BODY_ZONE_R_LEG
				)
				for(var/obj/item/bodypart/limb in H.bodyparts)
					if(limb.body_zone in safe_bodyzones)
						continue
					limb.drop_limb()
					qdel(limb)
				var/obj/item/bodypart/l_arm/prosthetic/bronzeleft/L = new()
				L.attach_limb(H)
