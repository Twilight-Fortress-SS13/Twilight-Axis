/datum/mind
	var/knight_advancetext = "Advance!"
	var/knight_holdfasttext = "Hold fast!"
	var/knight_noretreattext = "Not one step back!"

/datum/outfit/job/roguetown/knight
	cloak = null

/datum/advclass/knight/heavy
	category_tags = list(CTAG_DISABLED)

/datum/advclass/knight/footknight
	category_tags = list(CTAG_DISABLED)

/datum/advclass/knight/mountedknight
	category_tags = list(CTAG_DISABLED)

/datum/advclass/knight/irregularknight
	category_tags = list(CTAG_DISABLED)

/datum/advclass/knight/banneret
	name = "Knight Banneret"
	tutorial = "A master of the blade, a noble of the Realm and a field commander of the Grand Duke's army. You lead by example, bearing your own banner and fighting on the frontlines. Your plate armor makes you nearly invincible on the battlefield - assuming the enemy can even get through your deadly two-handed blade dance."
	outfit = /datum/outfit/job/roguetown/knight/banneret
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

	category_tags = list(CTAG_ROYALGUARD)

/datum/outfit/job/roguetown/knight/banneret/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/knight_advance)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/knight_holdfast)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/knight_noretreat)
	H.verbs |= list(/mob/proc/haltyell, /mob/living/carbon/human/mind/proc/knight_setorders)

	H.change_stat("strength", 3)
	H.change_stat("intelligence", 3)
	H.change_stat("constitution", 1)
	H.change_stat("endurance", 1)
	H.change_stat("speed", -1)

	H.adjust_blindness(-3)

	var/weapons = list("Zweihander","Great Mace","Greataxe","Estoc","Lucerne", "Partizan","Glaive","Lance + Kite Shield")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Zweihander")
			r_hand = /obj/item/rogueweapon/greatsword/zwei
			backl = /obj/item/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		if("Great Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/steel
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 5, TRUE)
		if("Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel
			backl = /obj/item/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)
		if("Estoc")
			r_hand = /obj/item/rogueweapon/estoc
			backl = /obj/item/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		if("Lucerne")
			r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
			backl = /obj/item/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
		if("Partizan")
			r_hand = /obj/item/rogueweapon/spear/partizan
			backl = /obj/item/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
		if("Glaive")
			r_hand = /obj/item/rogueweapon/halberd/glaive
			backl = /obj/item/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
		if("Lance + Kite Shield")
			r_hand = /obj/item/rogueweapon/spear/lance
			backl = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/platelegs

	var/heraldy = list( //Bannerets get normal heraldy, as they can have wield own banner
				"Surcoat" 	= /obj/item/clothing/cloak/stabard,
				"Tabard"		= /obj/item/clothing/cloak/tabard,
				"Jupon"		= /obj/item/clothing/cloak/stabard/surcoat,
				)
	var/heraldychoice = input("Choose your heraldy.", "RAISE UP THE BANNER") as anything in heraldy
	cloak = heraldy[heraldychoice]

	var/helmets = list(
		"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"None"
	)
	var/helmchoice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, 
		/obj/item/rope/chain = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1
	)

/mob/living/carbon/human/mind/proc/knight_setorders()
	set name = "Rehearse Orders"
	set category = "Voice of Command"
	mind.knight_advancetext = input("Send a message.", "Advance!") as text|null
	if(!mind.knight_advancetext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.knight_holdfasttext = input("Send a message.", "Hold fast!") as text|null
	if(!mind.knight_holdfasttext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.knight_noretreattext = input("Send a message.", "Not one step back!") as text|null
	if(!mind.knight_noretreattext)
		to_chat(src, "I must rehearse something for this order...")
		return

/obj/effect/proc_holder/spell/invoked/order/knight_advance
	name = "Advance!"
	desc = "Orders your underlings to move faster. +5 Speed."
	overlay_state = "movemovemove"

/obj/effect/proc_holder/spell/invoked/order/knight_advance/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.knight_advancetext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Knight")
			if(!target.job in list("Man at Arms", "Squire"))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/movemovemove)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/order/knight_holdfast
	name = "Hold fast!"
	desc = "Orders your underlings to stand up, enduring through the pain."
	overlay_state = "onfeet"

/obj/effect/proc_holder/spell/invoked/order/knight_holdfast/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.knight_holdfasttext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Knight")
			if(!target.job in list("Man at Arms", "Squire"))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/onfeet)
		if(!(target.mobility_flags & MOBILITY_STAND))
			target.SetUnconscious(0)
			target.SetSleeping(0)
			target.SetParalyzed(0)
			target.SetImmobilized(0)
			target.SetStun(0)
			target.SetKnockdown(0)
			target.set_resting(FALSE)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/order/knight_noretreat
	name = "Not one step back!"
	desc = "Orders your underlings to hold the line at all costs. +2 Endurance and Constitution."
	overlay_state = "hold"

/obj/effect/proc_holder/spell/invoked/order/knight_noretreat/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.knight_noretreattext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Knight")
			if(!target.job in list("Man at Arms", "Squire"))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/hold)
		return TRUE
	revert_cast()
	return FALSE

/datum/advclass/knight/bachelor
	name = "Knight Bachelor"
	tutorial = "You are among the ranks of what constitutes foot soldiers among the knights of the realm. While you may not be a leader by rank, you certainly do lead the charge more ofthen than not, wielding a tower shield along with heavy plate armor. You are the bulwark against the darkness, the first line of defense - and Azuria is right behind you."
	outfit = /datum/outfit/job/roguetown/knight/bachelor

	category_tags = list(CTAG_ROYALGUARD)

/datum/outfit/job/roguetown/knight/bachelor/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)	
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.change_stat("strength", 1)
	H.change_stat("constitution", 3)
	H.change_stat("endurance", 3)
	H.change_stat("intelligence", 1)

	H.adjust_blindness(-3)

	var/weapons = list("Longsword","Flail","Warhammer","Sabre","Battle Axe")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Longsword")
			beltl = /obj/item/rogueweapon/scabbard/sword
			l_hand = /obj/item/rogueweapon/sword/long
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		if("Flail")
			beltr = /obj/item/rogueweapon/flail/sflail
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 5, TRUE)
		if ("Warhammer")
			beltr = /obj/item/rogueweapon/mace/warhammer //Iron warhammer. This is one-handed and pairs well with shields. They can upgrade to steel in-round.
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 5, TRUE)
		if("Sabre")
			beltl = /obj/item/rogueweapon/scabbard/sword
			l_hand = /obj/item/rogueweapon/sword/sabre
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		if("Battle Axe")
			l_hand = /obj/item/rogueweapon/stoneaxe/battle
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/platelegs
	backl = /obj/item/rogueweapon/shield/tower/metal
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full
	
	var/heraldy = list( //Bachelors get guard heraldy, as they do NOT bear their own coat of arms
				"Surcoat" 	= /obj/item/clothing/cloak/stabard/guard,
				"Tabard"		= /obj/item/clothing/cloak/tabard/knight,
				"Jupon"		= /obj/item/clothing/cloak/stabard/surcoat/guard,
				)
	var/heraldychoice = input("Choose your heraldy.", "RAISE UP THE BANNER") as anything in heraldy
	cloak = heraldy[heraldychoice]
	
	var/helmets = list(
		"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"None"
	)
	var/helmchoice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, 
		/obj/item/rope/chain = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1
	)


/datum/advclass/knight/champion
	name = "Champion of the Realm"
	tutorial = "While other knights lead among the rank-and-file, you prefer the style and elegancy of a good, old-fashioned noble duel. Your swift maneuvers and masterful technique impress both lords and ladies alike, and you have a preference for quicker, more elegant blades. While you are an effective fighting force in medium armor, your evasive skills will only truly shine if you don even lighter protection."
	outfit = /datum/outfit/job/roguetown/knight/champion

	category_tags = list(CTAG_ROYALGUARD)

/datum/outfit/job/roguetown/knight/champion/pre_equip(mob/living/carbon/human/H)
	..()	
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)	
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)	
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)	
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)		
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/tracking, 2, TRUE)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.change_stat("strength", 1)
	H.change_stat("endurance", 2)
	H.change_stat("speed", 2)
	H.change_stat("intelligence", 1)

	H.adjust_blindness(-3)
	var/weapons = list("Rapier + Longbow","Estoc + Recurve Bow","Sabre + Buckler","Whip + Crossbow","Shamshir + Pistol")
	var/armor_options = list("Hardened Leather Coat", "Brigandine", "Scalemail")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	var/armor_choice = input("Choose your armor.", "TAKE UP ARMS") as anything in armor_options
	H.set_blindness(0)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, 
		/obj/item/rope/chain = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
	switch(weapon_choice)
		if("Rapier + Longbow")
			r_hand = /obj/item/rogueweapon/sword/rapier
			beltl = /obj/item/rogueweapon/scabbard/sword
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltr = /obj/item/quiver/arrows
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, 5, TRUE)
		if("Estoc + Recurve Bow")
			r_hand = /obj/item/rogueweapon/estoc
			backl = /obj/item/gwstrap
			beltr = /obj/item/quiver/arrows
			beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, 5, TRUE)
		if("Sabre + Buckler")
			beltl = /obj/item/rogueweapon/scabbard/sword
			r_hand = /obj/item/rogueweapon/sword/sabre
			backl = /obj/item/rogueweapon/shield/buckler
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
		if("Whip + Crossbow")
			beltl = /obj/item/rogueweapon/whip
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			beltr = /obj/item/quiver/bolts
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 5, TRUE)
		if("Shamshir + Pistol")
			r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
			backl = /obj/item/rogueweapon/scabbard/sword
			beltr = /obj/item/gun/ballistic/twilight_firearm/arquebus_pistol
			beltl = /obj/item/quiver/twilight_bullet/lead
			backpack_contents += /obj/item/twilight_powderflask
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/twilight_firearms, 4, TRUE)
	
	switch(armor_choice)
		if("Hardened Leather Coat")
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
			pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Brigandine")
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
			pants = /obj/item/clothing/under/roguetown/chainlegs
			armor = /obj/item/clothing/suit/roguetown/armor/brigandine/sheriff
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
		if("Scalemail")
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
			pants = /obj/item/clothing/under/roguetown/chainlegs
			armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	
	var/heraldy = list( //Champions get lord's heraldy with a bit more variety, due to their unusual equipment
				"Surcoat" 	= /obj/item/clothing/cloak/stabard/guard,
				"Tabard"		= /obj/item/clothing/cloak/tabard/knight,
				"Jupon"		= /obj/item/clothing/cloak/stabard/surcoat/guard,
				"Halfcloak" = /obj/item/clothing/cloak/half/knight,
				"Fur Cloak" = /obj/item/clothing/cloak/raincloak/furcloak/knight,
				)
	var/heraldychoice = input("Choose your heraldy.", "RAISE UP THE BANNER") as anything in heraldy
	cloak = heraldy[heraldychoice]

	var/helmets = list(
		"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"None"
	)
	
	var/helmchoice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]
