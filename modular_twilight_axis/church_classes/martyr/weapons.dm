/obj/item/rogueweapon/halberd/bardiche/scythe/martyr
	force = 22
	force_wielded = 37
	possible_item_intents = list(/datum/intent/spear/thrust/bad, /datum/intent/spear/bash)
	gripped_intents = list(/datum/intent/spear/cut/bardiche, /datum/intent/spear/cut/bardiche/cleave, /datum/intent/spear/cut/glaive/sweep, /datum/intent/axe/chop/scythe)
	icon_state = "martyrscyth"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/polearms64.dmi'
	item_state = "martyrscyth"
	name = "divine scythe"
	desc = "A relic from the Holy See's own vaults; a blessed silver scythe, marked with the ten-pointed sigil of Astrata's undivided might. </br>It simmers with godly energies, and will only yield to the hands of those who have taken the Oath."
	max_blade_int = 250
	max_integrity = 9999
	bigboy = 1
	wlength = WLENGTH_LONG
	associated_skill = /datum/skill/combat/polearms
	smeltresult = null
	is_silver = TRUE
	toggle_state = null
	is_important = TRUE
	special = /datum/special_intent/martyr_dendor_vine_reap

/obj/item/rogueweapon/halberd/bardiche/scythe/martyr/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)

/datum/intent/spear/cut/bardiche/martyr
		item_d_type = "fire"
		blade_class = BCLASS_CUT

/datum/intent/spear/cut/bardiche/cleave/martyr
		item_d_type = "fire"
		blade_class = BCLASS_CUT

/datum/intent/spear/cut/glaive/sweep/martyr
		item_d_type = "fire"
		blade_class = BCLASS_CHOP

/datum/intent/axe/chop/scythe/martyr
		item_d_type = "fire"
		blade_class = BCLASS_CHOP
		swingdelay = 5

/datum/intent/spear/thrust/bad/martyr
		item_d_type = "fire"
		blade_class = BCLASS_PICK

/obj/item/rogueweapon/halberd/bardiche/scythe/martyr/Initialize()
	. = ..()
	if(SSroguemachine.martyrweapon)
		qdel(src)
	else
		SSroguemachine.martyrweapon = src
	if(!gc_destroyed)
		var/list/active_intents = list(/datum/intent/spear/thrust/bad/martyr, /datum/intent/spear/bash/martyr)
		var/list/active_intents_wielded = list(/datum/intent/spear/cut/bardiche/martyr, /datum/intent/spear/cut/bardiche/cleave/martyr, /datum/intent/spear/cut/glaive/sweep/martyr, /datum/intent/axe/chop/scythe/martyr)
		var/safe_damage = 15
		var/safe_damage_wielded = 35
		AddComponent(/datum/component/martyrweapon, active_intents, active_intents_wielded, safe_damage, safe_damage_wielded)

/obj/item/rogueweapon/halberd/bardiche/scythe/martyr/proc/anti_stall()
	src.visible_message(span_danger("The Martyr's scythe dissolved into sparkling dust, which instantly rose up and was carried away by the wind."))
	SSroguemachine.martyrweapon = null
	qdel(src)

/obj/item/rogueweapon/halberd/bardiche/scythe/martyr/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/datum/job/J = SSjob.GetJob(H.mind?.assigned_role)
		if(J.title == "Bishop" || J.title == "Martyr")
			return ..()
		else if (H.job in GLOB.church_positions)
			to_chat(user, span_warning("You feel a jolt of holy energies just for a split second, and then the axe slips from your grasp! You are not devout enough."))
			return FALSE
		else if(istype(H.patron, /datum/patron/inhumen))
			var/datum/component/martyrweapon/marty = GetComponent(/datum/component/martyrweapon)
			to_chat(user, span_warning("YOU FOOL! IT IS ANATHEMA TO YOU! GET AWAY!"))
			H.Stun(40)
			H.Knockdown(40)
			if(marty.is_active) //Inhumens are touching this while it's active, very fucking stupid of them
				visible_message(span_warning("[H] lets out a painful shriek as the axe lashes out at them!"))
				H.emote("agony")
				H.adjust_fire_stacks(5)
				H.ignite_mob()
			return FALSE
		else	//Everyone else
			to_chat(user, span_warning("A painful jolt across your entire body sends you to the ground. You cannot touch this thing."))
			H.emote("groan")
			H.Stun(10)
			return FALSE
	else
		return FALSE

/obj/item/rogueweapon/halberd/bardiche/scythe/martyr/Destroy()
	var/datum/component/martyr = GetComponent(/datum/component/martyrweapon)
	if(martyr)
		martyr.ClearFromParent()
	return ..()
