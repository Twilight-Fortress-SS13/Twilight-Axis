/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe
	name = "equipoise"
	desc = "Often wielded by the Necran Immortals, this silver scythe is claimed to be capable of bypassing all protection, striking directly at the enemy's soul."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/64.dmi'
	icon_state = "necrascythe"
	possible_item_intents = list(/datum/intent/spear/cut/oneh, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/cut/bardiche, /datum/intent/rend/reach, /datum/intent/axe/chop/scythe, SPEAR_BASH)
	force_wielded = 35
	max_integrity = 300
	wdefense = 4
	is_silver = TRUE

/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)
/obj/item/rogueweapon/spear/partizan/baotha_ta
	name = "saccharine swordspear"
	desc = "Keep the rest at arm's length, lest you're burdened with the pain of rememberance."
	force = 25
	force_wielded = 35
	possible_item_intents = list(/datum/intent/sword/thrust/long, /datum/intent/sword/cut/long, /datum/intent/sword/strike, /datum/intent/sword/thrust/heavy)
	gripped_intents = list(SPEAR_THRUST, /datum/intent/spear/cut, PARTIZAN_REND, /datum/intent/spear/cut/glaive/sweep)
	icon_state = "swordstaff"
	icon = 'icons/roguetown/weapons/polearms64.dmi'
	parrysound = list(
	'sound/combat/parry/bladed/bladedmedium (1).ogg',
	'sound/combat/parry/bladed/bladedmedium (2).ogg',
	'sound/combat/parry/bladed/bladedmedium (3).ogg',
	)
	pickup_sound = 'sound/foley/equip/swordlarge1.ogg'
	minstr = 4
	thrown_bclass = BCLASS_PIERCE
	max_blade_int = 400
	max_integrity = 400
	throwforce = 45 //Pierce the heavens!
	wdefense = 4
	wdefense_wbonus = 5
	smeltresult = /obj/item/ingot/component/baotha
	slot_flags = ITEM_SLOT_BACK //No need for a supplemental greatweapon strap.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS
	icon_angle_wielded = null

/obj/item/rogueweapon/spear/partizan/baotha_ta/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "SWORDSPEAR")

/obj/item/rogueweapon/spear/partizan/baotha_ta/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.7, "sx" = -14, "sy" = -8, "nx" = 9, "ny" = -6, "wx" = -6, "wy" = -6, "ex" = -1, "ey" = -4, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -10, "sturn" = 108, "wturn" = -72, "eturn" = -10, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.75, "sx" = 5, "sy" = -3, "nx" = -5, "ny" = -3, "wx" = -5, "wy" = -3, "ex" = 3, "ey" = -4, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = 6, "sturn" = -8, "wturn" = 10, "eturn"= -10, "nflip" = 8, "sflip" = 0, "wflip" = 8, "eflip" = 0)

/obj/item/rogueweapon/spear/partizan/baotha_ta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_WEAPON)

/datum/special_intent/cudgel_knockout
	name = "Knockout"
	desc = "A strong attack right on the head of your victim. Precise anough for give her a nap."
	tile_coordinates = list(list(0,0))
	post_icon_state = "heavy_attack_long"
	pre_icon = 'icons/effects/telegraph.dmi'
	pre_icon_state = "warning"
	sfx_post_delay = 'sound/combat/flail_sweep_hit_minor.ogg'
	delay = 0.8 SECONDS
	cooldown = 25 SECONDS
	stamcost = 25
	var/eff_dur = 5
	var/dam
	var/KD_dur = 1 SECONDS
	requires_wielding = FALSE

/datum/special_intent/cudgel_knockout/on_create()
	. = ..()
	playsound(howner, 'sound/combat/clash_charge.ogg', 100, TRUE)

/datum/special_intent/cudgel_knockout/process_attack()
	var/obj/item/rogueweapon/W = iparent
	dam = W.force_dynamic * max((1 + (((howner.STASTR - 5) + (howner.STAPER - 5)) / 10)), 0.1)
	. = ..()

/datum/special_intent/cudgel_knockout/apply_hit(turf/T)
	for(var/mob/living/L in get_hearers_in_view(0, T))
		if(L != howner)

			var/throwtarget = get_edge_target_turf(howner, get_dir(howner, get_step_away(L, howner)))
			var/throwdist = 1
			var/target_zone = get_aimed_zone(L)

			if((!(L.can_see_cone(howner)) && (L.stat == CONSCIOUS)) || L.has_status_effect(/datum/status_effect/debuff/exposed) || L.has_status_effect(/datum/status_effect/debuff/vulnerable))
				dam = 110
				L.Knockdown(KD_dur)
				throwdist = rand(2,2)
				L.Stun(2 SECONDS)
				L.apply_status_effect(/datum/status_effect/debuff/knocked)
			else
				L.apply_status_effect(/datum/status_effect/debuff/dazed)

			target_zone = BODY_ZONE_HEAD
			apply_generic_weapon_damage(L, dam, "blunt", target_zone, bclass = BCLASS_BLUNT)
			L.safe_throw_at(throwtarget, throwdist, 1, howner, force = MOVE_FORCE_EXTREMELY_STRONG)
			L.apply_status_effect(/datum/status_effect/debuff/vulnerable, 10 SECONDS)
	..()

/datum/status_effect/debuff/knocked
	id = "dazed"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/dazed
	effectedstats = list(STATKEY_PER = -3, STATKEY_INT = -2, STATKEY_SPD = -3)
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REFRESH
