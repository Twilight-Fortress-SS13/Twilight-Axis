//Handles donator modkit code - basically akin to old Citadel/F13 modkit donator system.
//Tl;dr - Click the assigned modkit to the object type's parent, it'll change it into the child. Modkits, aka enchanting kits, are what you get.
/obj/item/enchantingkit
	name = "morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item."
	icon = 'icons/obj/items/donor_objects.dmi'
	icon_state = "enchanting_kit"
	w_class = WEIGHT_CLASS_SMALL
	var/list/target_items = list()
	var/result_item = null
	var/icon_loadout = null

/obj/item/enchantingkit/proc/get_result_type(obj/item/I)
	if(!I)
		return null

	var/result_type = null

	if(LAZYLEN(target_items))
		for(var/T in target_items)
			if(istype(I, T))
				result_type = target_items[T]
				break

	if(!result_type && result_item)
		result_type = result_item

	if(!result_type && !result_item)
		CRASH("No result_item on a donator kit while result_type was empty. Something went wrong.")

	return result_type

/obj/item/enchantingkit/proc/prepare_morph_target(obj/item/I, mob/user)
	if(!I || !user)
		return FALSE

	if(I.loc == user)
		user.temporarilyRemoveItemFromInventory(I, TRUE)

	remove_item_from_storage(I)
	return TRUE

/obj/item/enchantingkit/proc/copy_item_var(datum/source, datum/target, var_name)
	if(!source || !target || !var_name)
		return

	if(!(var_name in source.vars) || !(var_name in target.vars))
		return

	var/value = source.vars[var_name]

	if(islist(value))
		var/list/value_list = value
		target.vars[var_name] = value_list.Copy()
	else
		target.vars[var_name] = value

/obj/item/enchantingkit/proc/inherit_item_mechanics(obj/item/source_item, obj/item/result_item)
	if(!source_item || !result_item)
		return

	var/static/list/common_item_vars = list(
		"w_class",
		"force",
		"throwforce",
		"throw_speed",
		"throw_range",
		"max_integrity",
		"obj_integrity",
		"integrity_failure",
		"resistance_flags",
		"item_flags",
		"slot_flags",
		"hitsound",
		"usesound",
		"mob_throw_hit_sound",
		"equip_sound",
		"pickup_sound",
		"drop_sound",
		"place_sound",
		"heat_protection",
		"cold_protection",
		"max_heat_protection_temperature",
		"min_cold_protection_temperature",
		"flags_inv",
		"flags_cover",
		"transparent_protection",
		"interaction_flags_item",
		"body_parts_covered",
		"body_parts_covered_dynamic",
		"body_parts_inherent",
		"surgery_cover",
		"gas_transfer_coefficient",
		"permeability_coefficient",
		"siemens_coefficient",
		"slowdown",
		"armor_penetration",
		"allowed",
		"equip_delay_self",
		"unequip_delay_self",
		"inv_storage_delay",
		"edelay_type",
		"equip_delay_other",
		"strip_delay",
		"breakouttime",
		"slipouttime",
		"species_exception",
		"block_chance",
		"hit_reaction_chance",
		"reach",
		"can_parry",
		"associated_skill",
		"possible_item_intents",
		"bigboy",
		"wdefense",
		"wdefense_wbonus",
		"wdefense_dynamic",
		"salvage_result",
		"salvage_amount",
		"fiber_salvage",
		"anvilrepair",
		"sewrepair",
		"breakpath",
		"sellprice",
		"blocksound",
		"armor"
	)

	for(var/var_name in common_item_vars)
		copy_item_var(source_item, result_item, var_name)

	if(istype(source_item, /obj/item/clothing) && istype(result_item, /obj/item/clothing))
		var/static/list/clothing_vars = list(
			"flash_protect",
			"tint",
			"up",
			"visor_flags",
			"visor_flags_inv",
			"visor_flags_cover",
			"visor_vars_to_toggle",
			"clothing_flags",
			"stack_fovs",
			"pocket_storage_component_path",
			"allowed_sex",
			"allowed_race",
			"immune_to_genderswap",
			"armor_class",
			"naledicolor",
			"chunkcolor",
			"material_category",
			"r_sleeve_status",
			"l_sleeve_status",
			"r_sleeve_zone",
			"l_sleeve_zone",
			"torn_sleeve_number",
			"nodismemsleeves"
		)

		for(var/var_name in clothing_vars)
			copy_item_var(source_item, result_item, var_name)

	if(istype(source_item, /obj/item/rogueweapon) && istype(result_item, /obj/item/rogueweapon))
		var/static/list/rogueweapon_vars = list(
			"is_silver"
		)

		for(var/var_name in rogueweapon_vars)
			copy_item_var(source_item, result_item, var_name)

	if(result_item.max_integrity && result_item.obj_integrity > result_item.max_integrity)
		result_item.obj_integrity = result_item.max_integrity

/obj/item/enchantingkit/proc/transfer_item_contents(obj/item/source_item, obj/item/result_item)
	if(!source_item || !result_item)
		return

	for(var/atom/movable/A in source_item.contents)
		if(A && A.loc == source_item)
			A.forceMove(result_item)

/obj/item/enchantingkit/pre_attack(obj/item/I, mob/user)
	if(!I || !user)
		return ..()

	if(!is_type_in_list(I, target_items))
		return ..()

	var/result_type = get_result_type(I)

	if(!result_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [I]."))
		return TRUE

	prepare_morph_target(I, user)

	var/turf/T = get_turf(user)
	if(!T)
		T = get_turf(I)
	if(!T)
		to_chat(user, span_warning("Nowhere to morph [I]."))
		return TRUE

	var/old_name = I.name
	var/obj/item/new_item = new result_type(T)

	inherit_item_mechanics(I, new_item)
	transfer_item_contents(I, new_item)

	to_chat(user, span_notice("You apply the [src] to [I], using the enchanting dust and tools to turn it into [new_item]."))
	new_item.name = "[initial(new_item.name)] ([old_name])"

	qdel(I)

	if(!user.put_in_hands(new_item))
		new_item.forceMove(get_turf(user))

	new_item.update_icon()
	new_item.update_transform()

	if(ismob(user))
		var/mob/M = user
		M.update_body()

	qdel(src)
	return TRUE

/obj/item/enchantingkit/weapon/pre_attack(obj/item/I, mob/user)
	if(!I || !user)
		return ..()

	if(!isturf(I.loc))
		to_chat(user, span_info("This should be on the floor, lest I spill it onto myself."))
		return

	if(!istype(I, /obj/item/rogueweapon))
		return ..()

	if(!is_type_in_list(I, target_items))
		return ..()

	var/R_type = result_item

	if(!R_type)
		to_chat(user, span_warning("[src] doesn't know how to morph [I]."))
		return TRUE

	var/obj/item/rogueweapon/RI = R_type
	var/obj/item/rogueweapon/TI = I

	var/old_is_silver = null
	if("is_silver" in TI.vars)
		old_is_silver = TI.vars["is_silver"]

	TI.icon = RI::icon
	TI.icon_state = RI::icon_state
	TI.item_state = RI::item_state
	TI.toggle_state = RI::icon_state
	TI.lefthand_file = RI::lefthand_file
	TI.righthand_file = RI::righthand_file
	TI.sheathe_icon = RI::sheathe_icon ? RI::sheathe_icon : TI.sheathe_icon
	TI.bigboy = RI::bigboy

	if("is_silver" in TI.vars)
		TI.vars["is_silver"] = old_is_silver

	to_chat(user, span_notice("You apply the [src] to [I], using the enchanting dust and tools to turn it into [RI::name]."))
	I.name = "[RI::name] ([I.name])"
	I.desc = RI::desc
	I.update_transform()

	if(ismob(user))
		var/mob/M = user
		M.update_body()

	qdel(src)
	return TRUE

/obj/item/enchantingkit/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-clicking the appropriate item with this elixir will gift it a unique appearance.")

/////////////////////////////
// ! Player / Donor Kits ! //
/////////////////////////////

//Plexiant - Custom rapier type
/obj/item/enchantingkit/plexiant
	name = "'Rapier di Aliseo' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Rapier"
	target_items = list(/obj/item/rogueweapon/sword/rapier)		//Takes any subpated rapier and turns it into unique one.
	result_item = /obj/item/rogueweapon/sword/rapier/aliseo

//Ryebread - Custom estoc type
/obj/item/enchantingkit/ryebread
	name = "'Worttrager' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Estoc"
	target_items = list(/obj/item/rogueweapon/estoc)		//Takes any subpated rapier and turns it into unique one.
	result_item = /obj/item/rogueweapon/estoc/worttrager

//Srusu - Custom dress type
/obj/item/enchantingkit/srusu
	name = "'Emerald Dress' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Dress"
	target_items = list(/obj/item/clothing/suit/roguetown/shirt/dress)	//Literally any type of dress
	result_item = /obj/item/clothing/suit/roguetown/shirt/dress/emerald

//Strudel - Custom leather vest type and xylix tabard
/obj/item/enchantingkit/strudel1
	name = "'Grenzelhoft Mage Vest' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Robe"
	target_items = list(/obj/item/clothing/suit/roguetown/shirt/robe)
	result_item = /obj/item/clothing/suit/roguetown/shirt/robe/sofiavest

/obj/item/enchantingkit/strudel2
	name = "'Xylixian Fasching Leotard' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Xylixian Cloak"
	target_items = list(/obj/item/clothing/cloak/templar/xylixian)
	result_item = /obj/item/clothing/cloak/templar/xylixian/faux

/obj/item/enchantingkit/strudel3
	name = "'Etruscan Design Cloak' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Poncho"
	target_items = list(/obj/item/clothing/cloak/poncho)
	result_item = /obj/item/clothing/cloak/poncho/dittocloak

/obj/item/enchantingkit/strudel4
	name = "'Form-fitting Padded Gambeson' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Padded Gambeson"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy)
	result_item = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/strudels

//Bat - Custom harp type
/obj/item/enchantingkit/bat
	name = "'Handcrafted Harp' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Harp"
	target_items = list(/obj/item/rogue/instrument/harp)
	result_item = /obj/item/rogue/instrument/harp/handcarved

//Rebel - Custom visored sallet type
/obj/item/enchantingkit/rebel
	name = "'Gilded Sallet' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Visored Sallet"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored)
	result_item = /obj/item/clothing/head/roguetown/helmet/sallet/visored/gilded

//Bigfoot - Custom knight helm type
/obj/item/enchantingkit/bigfoot
	name = "'Gilded Knight Helm' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Knight Helmet"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/gilded

//Bigfoot - Custom great axe type
/obj/item/enchantingkit/bigfoot_axe
	name = "'Gilded Great Axe' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Steel Greataxe"
	target_items = list(/obj/item/rogueweapon/greataxe/steel)
	result_item = /obj/item/rogueweapon/greataxe/steel/gilded

//Zydras donator items - Ironclad baddie
/obj/item/enchantingkit/zydrashauberk
	name = "Mailled Hauberk morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy)
	result_item = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy/zycuirass

/obj/item/enchantingkit/zydrasgreataxe
	name = "Greataxe morphing elixir"
	target_items = list(/obj/item/rogueweapon/greataxe)
	result_item = /obj/item/rogueweapon/greataxe/zygreataxe

/*
//Zydras donator items - Iconoclast pyromaniac
/obj/item/enchantingkit/zydrasiconocrown
	name = "Barred Helmet morphing elixir"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/sheriff)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/zydrasiconocrown

/obj/item/enchantingkit/zydrasiconopauldrons
	name = "Light Brigandine morphing elixir"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/brigandine/light)
	result_item = /obj/item/clothing/suit/roguetown/armor/brigandine/light/zydrasiconopauldrons

/obj/item/enchantingkit/zydrasiconosash
	name = "Iron Hauberk morphing elixir"
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/zydrasiconosash,
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zydrasiconosash)
	result_item = null
	icon_loadout = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/zydrasiconosash
*/

//Eiren - Zweihander and sabres
/obj/item/enchantingkit/weapon/eiren
	name = "'Regret' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Zweihander"
	target_items = list(
		/obj/item/rogueweapon/greatsword/grenz/flamberge,
		/obj/item/rogueweapon/greatsword/zwei,
		/obj/item/rogueweapon/greatsword
	)
	result_item = /obj/item/rogueweapon/example/eiren_greatsword
	icon_loadout = /obj/item/rogueweapon/example/eiren_greatsword

/obj/item/enchantingkit/weapon/eirensabre
	name = "'Lunae' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Sabre"
	target_items = list(/obj/item/rogueweapon/sword/sabre)
	result_item = /obj/item/rogueweapon/example/eiren_sabre

/obj/item/enchantingkit/weapon/eirensabre2
	name = "'Cinis' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Sabre"
	target_items = list(/obj/item/rogueweapon/sword/sabre)
	result_item = /obj/item/rogueweapon/example/eiren_sabre_alt

/obj/item/enchantingkit/weapon/eiren_m
	name = "'glintstone longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/eirenxiv/eiren_m

/obj/item/enchantingkit/weapon/eirensword
	name = "'stygian longsword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/eirenxiv/eirensword

/obj/item/enchantingkit/eiren_helmet
	name = "'strigidae armet' morphing elixir"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/eiren_helmet

//pretzel - custom steel greatsword. PSYDON LYVES. PSYDON ENDVRES.
/obj/item/enchantingkit/weapon/waff
	name = "'Weeper's Lathe' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Greatsword"
	target_items = list(/obj/item/rogueweapon/greatsword)		// i, uh. i really do promise i'm only gonna use it on steel greatswords.
	result_item = /obj/item/rogueweapon/example/waffai_greatsword

//inverserun claymore
/obj/item/enchantingkit/weapon/inverserun
	name = "'Votive Thorns' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/greatsword/grenz/flamberge,
		/obj/item/rogueweapon/greatsword/zwei,
		/obj/item/rogueweapon/greatsword
	)
	result_item = /obj/item/rogueweapon/example/inverserun_greatsword
	icon_loadout = /obj/item/rogueweapon/greatsword/zwei/inverserun

//Zoe - Tytos Blackwood cloak
/obj/item/enchantingkit/zoe
	name = "'Shroud of the Undermaiden' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Direbear Cloak"
	target_items = list(/obj/item/clothing/cloak/darkcloak/bear)
	result_item = /obj/item/clothing/cloak/raincloak/feather_cloak

//Zoe - Shovel
/obj/item/enchantingkit/zoe_shovel
	name = "'Silence' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Shovel"
	target_items = list(/obj/item/rogueweapon/shovel)
	result_item = /obj/item/rogueweapon/shovel/zoe_silence

//DasFox - Armet
/obj/item/enchantingkit/dasfox_helm
	name = "'archaic valkyrhelm' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Armet"
	target_items = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet)
	result_item = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dasfox

//DasFox - Cuirass
/obj/item/enchantingkit/dasfox_cuirass
	name = "'archaic cermonial cuirass' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Fluted Cuirass"
	target_items = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted)
	result_item = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/dasfox

//DasFox - Lance
/obj/item/enchantingkit/dasfox_lance
	name = "'decorated jousting lance' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Lance"
	target_items = list(/obj/item/rogueweapon/spear/lance)
	result_item = /obj/item/rogueweapon/spear/lance/dasfox

//Ryan180602 - Armet
/obj/item/enchantingkit/ryan_psyhelm
	name = "'maimed psydonic helm' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Psydonic Helmet(Armet,Barbute,Bucket Helmet or Sallet)"
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ryan,
		/obj/item/clothing/head/roguetown/helmet/heavy/psybucket = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ryan,
		/obj/item/clothing/head/roguetown/helmet/heavy/psysallet = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ryan,
		/obj/item/clothing/head/roguetown/helmet/heavy/psydonbarbute = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ryan)
	icon_loadout = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm/ryan

//Dakken12 - Armet/Hounskull/Swords
/obj/item/enchantingkit/dakken_zizhelm
	name = "'armoured avantyne barbute' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Armet or Hounskull Bascinet"
	target_items = list(
		/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dakken,
		/obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull/dakken,
		/obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor				= /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor/dakken
	)
	result_item = null
	icon_loadout = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/dakken

/obj/item/enchantingkit/dakken_alloybsword
	name = "'avantyne-threaded sword' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/sword/long	= /obj/item/rogueweapon/sword/long/dakken_longsword,
		/obj/item/rogueweapon/sword			= /obj/item/rogueweapon/sword/dakken_sword
	)
	result_item = null
	icon_loadout = /obj/item/rogueweapon/sword/long/dakken_longsword

//StinkethStonketh - Shashka & pike
/obj/item/enchantingkit/weapon/stinketh_shashka
	name = "'fencer's shashka' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Szöréndnížine Sabre Or Aavnic Shashka"
	target_items = list(
		/obj/item/rogueweapon/sword/sabre/freifechter,
		/obj/item/rogueweapon/sword/sabre/steppesman
	)
	result_item = /obj/item/rogueweapon/example/stinketh_sabre

/obj/item/enchantingkit/stinketh_pike
	name = "'Kindness of Ravens Standard' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Banner Of Szöréndnížina"
	target_items = list(/obj/item/rogueweapon/spear/boar/frei/pike)
	result_item = /obj/item/rogueweapon/spear/boar/frei/pike/stinketh

//Koruu - Glaive
/obj/item/enchantingkit/koruu_glaive
	name = "'Sixty Five Yils' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Glaive Or Naginata"
	target_items = list(
		/obj/item/rogueweapon/spear/naginata	= /obj/item/rogueweapon/spear/naginata/koruu,
		/obj/item/rogueweapon/halberd/glaive	= /obj/item/rogueweapon/halberd/glaive/koruu
	)
	icon_loadout = /obj/item/rogueweapon/halberd/glaive/koruu

//Koruu - Kukri
/obj/item/enchantingkit/weapon/koruu_kukri
	name = "'Leachwhacker' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/rogueweapon/huntingknife/idagger/steel,
		/obj/item/rogueweapon/huntingknife/combat,
		/obj/item/rogueweapon/huntingknife
		)
	result_item = /obj/item/rogueweapon/koruu/kukri

/obj/item/enchantingkit/weapon/koruu_kukri/warden
	name = "'Warden Leachwhacker' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/huntingknife/idagger/warden_machete
		)
	result_item = /obj/item/rogueweapon/koruu/kukri/warden

//DRD21 - Longsword
/obj/item/enchantingkit/drd_lsword
	name = "'ornate basket-hilt longsword' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Longsword"
	target_items = list(/obj/item/rogueweapon/sword/long)
	result_item = /obj/item/rogueweapon/sword/long/drd

//DRD21 - Shield
/obj/item/enchantingkit/weapon/drd_shield
	name = "'House Woerden shield' morphing elixir"
	target_items = list(
		/obj/item/rogueweapon/shield/tower/metal
	)
	result_item = /obj/item/rogueweapon/drd/shield

//Lmwevil - Beak Mask
/obj/item/enchantingkit/lmwevil_brassbeak
	name = "brass beak mask morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Head Physician's Mask Or Plague Mask"
	target_items = list(/obj/item/clothing/mask/rogue/courtphysician, /obj/item/clothing/mask/rogue/physician)
	result_item = /obj/item/clothing/mask/rogue/courtphysician/brassbeak

//Shudderfly - Steel Dagger
/obj/item/enchantingkit/shudderfly_dagger
	name = "'Eoran Spike' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Steel Dagger"
	target_items = list(/obj/item/rogueweapon/huntingknife/idagger/steel)
	result_item = /obj/item/rogueweapon/huntingknife/idagger/steel/shudderfly

//Maesune - Sabre/Shield
/obj/item/enchantingkit/weapon/maesune_shield
	name = "'Fy Annwyl' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Kite Shield"
	target_items = list(
		/obj/item/rogueweapon/shield/tower/metal
	)
	result_item = /obj/item/rogueweapon/maesune/shield

/obj/item/enchantingkit/weapon/maesune_sabre
	name = "'Y Ceirw' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Falchion, Longsword, Sword, Silver Sword Or Kriegmesser"
	target_items = list(
		/obj/item/rogueweapon/sword/short/falchion,
		/obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/long/silver,
		/obj/item/rogueweapon/sword,
		/obj/item/rogueweapon/sword/silver,
		/obj/item/rogueweapon/sword/long/kriegmesser
	)
	result_item = /obj/item/rogueweapon/maesune/sabre

//NeroCavalier - Sword
/obj/item/enchantingkit/weapon/noire_flsword
	name = "'Blacksteel Longsword' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Longsword"
	target_items = list(
		/obj/item/rogueweapon/sword/long
	)
	result_item = /obj/item/rogueweapon/nerocavalier/flsword

/obj/item/enchantingkit/aisuwand
	name = "Crystalline Wand morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Wand"
	target_items = list(/obj/item/rogueweapon/wand)
	result_item = /obj/item/rogueweapon/wand/aisu

/obj/item/enchantingkit/weapon/regnum
	name = "'Regnum' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Longsword Or Judgement"
	target_items = list(
		/obj/item/rogueweapon/sword/long,
		/obj/item/rogueweapon/sword/long/judgement
	)
	result_item = /obj/item/rogueweapon/example/regnum

/obj/item/enchantingkit/weapon/aeternum
	name = "'Aeternum' morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specifc item. Required: Greatsword, Claymore, Or Zweihander"
	target_items = list(
		/obj/item/rogueweapon/greatsword,
		/obj/item/rogueweapon/greatsword/zwei,
		/obj/item/rogueweapon/greatsword/grenz,
		/obj/item/rogueweapon/greatsword/grenz/flamberge,
		/obj/item/rogueweapon/greatsword/grenz/flamberge/blacksteel
	)
	result_item = /obj/item/rogueweapon/example/aeternum

/////////////////////////////
// ! Triumph-Exc. Kits !   //
/////////////////////////////

/obj/item/enchantingkit/triumph_armorkit
	name = "'Valorian' armor morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can restore the original appearance of.. </br>..a Steel Cuirass.. </br>..a Steel Halfplate.. </br>..a set of Steel Plate Armor.. </br>..or a set of Fluted Plate Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/plate/cuirass 		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full/fluted 	= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate/full 			= /obj/item/clothing/suit/roguetown/armor/plate/full/legacy,
		/obj/item/clothing/suit/roguetown/armor/plate 				= /obj/item/clothing/suit/roguetown/armor/plate/legacy
	)
	result_item = null
	icon_loadout = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted/legacy

/obj/item/enchantingkit/triumph_armorkit_drow
	name = "'Drowcraft' armor morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a set of Hardened Leather Armor.. </br>.. or a set of Studded Leather Armor."
	target_items = list(
		/obj/item/clothing/suit/roguetown/armor/leather/heavy 		= /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest,
		/obj/item/clothing/suit/roguetown/armor/leather/studded		= /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest
	)
	result_item = null
	icon_loadout = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest

/obj/item/enchantingkit/triumph_weaponkit_axe
	name = "'Valorian' axe morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..an Iron Axe.. </br>..or an Iron Hatchet."
	target_items = list(
		/obj/item/rogueweapon/stoneaxe/handaxe	= /obj/item/rogueweapon/stoneaxe/handaxe/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut	= /obj/item/rogueweapon/stoneaxe/woodcut/triumph
	)
	result_item = null
	icon_loadout = /obj/item/rogueweapon/stoneaxe/woodcut/triumph

/obj/item/enchantingkit/triumph_weaponkit_axedouble
	name = "'Doublehead' axe morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..an Iron Axe.. </br>..a Bronze Axe.. </br>..a Steel Axe.. </br>..a Battle Axe..  </br>..a Silver War Axe.. </br>..or a Psydonic War Axe."
	target_items = list(
		/obj/item/rogueweapon/stoneaxe/woodcut/steel	= /obj/item/rogueweapon/stoneaxe/woodcut/steel/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut/bronze	= /obj/item/rogueweapon/stoneaxe/woodcut/bronze/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut/silver	= /obj/item/rogueweapon/stoneaxe/woodcut/silver/triumph,
		/obj/item/rogueweapon/stoneaxe/battle/psyaxe	= /obj/item/rogueweapon/stoneaxe/battle/psyaxe/triumph,
		/obj/item/rogueweapon/stoneaxe/woodcut		= /obj/item/rogueweapon/stoneaxe/woodcut/triumphalt,
		/obj/item/rogueweapon/stoneaxe/battle		= /obj/item/rogueweapon/stoneaxe/battle/triumph
	)
	result_item = null
	icon_loadout = /obj/item/rogueweapon/stoneaxe/battle/triumph

/obj/item/enchantingkit/weapon/triumph_weaponkit_sword
	name = "'Valorian' sword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..an Iron Arming Sword.. </br>..an Iron Dueling Sword.. </br>..or a Maciejowski."
	target_items = list(
		/obj/item/rogueweapon/sword/iron,
		/obj/item/rogueweapon/sword/short/messer/iron/virtue,
		/obj/item/rogueweapon/sword/falchion/militia
	)
	result_item = /obj/item/rogueweapon/example/valorian_sword

/obj/item/enchantingkit/triumph_weaponkit_tri
	name = "'Valorian' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword."
	target_items = list(/obj/item/rogueweapon/sword/long)
	result_item = /obj/item/rogueweapon/sword/long/triumph

/obj/item/enchantingkit/triumph_weaponkit_wide
	name = "'Wideguard' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword </br>..or a Rapier."
	target_items = list(
		/obj/item/rogueweapon/sword/long		= /obj/item/rogueweapon/sword/long/triumph/wideguard,
		/obj/item/rogueweapon/sword/rapier		= /obj/item/rogueweapon/sword/rapier/wideguard
	)
	result_item = null
	icon_loadout = /obj/item/rogueweapon/sword/long/triumph/wideguard

/obj/item/enchantingkit/weapon/triumph_weaponkit_rock
	name = "'Rockhillian' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Broadsword.. </br>..or an Executioner Sword."
	target_items = list(
		/obj/item/rogueweapon/sword/long/broadsword/bronze,
		/obj/item/rogueweapon/sword/long/broadsword/steel,
		/obj/item/rogueweapon/sword/long/broadsword,
		/obj/item/rogueweapon/sword/long/exe
	)
	result_item = /obj/item/rogueweapon/example/valorian_broadsword
	icon_loadout = /obj/item/rogueweapon/sword/long/triumph/rockhill

/obj/item/enchantingkit/triumph_weaponkit_sabre
	name = "'Sabreguard' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword.. </br>..or a Kriegmesser."
	target_items = list(
		/obj/item/rogueweapon/sword/long/kriegmesser	= /obj/item/rogueweapon/sword/long/kriegmesser/sabreguard,
		/obj/item/rogueweapon/sword/long				= /obj/item/rogueweapon/sword/long/triumph/sabreguard
	)
	result_item = null
	icon_loadout = /obj/item/rogueweapon/sword/long/triumph/sabreguard

/obj/item/enchantingkit/triumph_weaponkit_psy
	name = "'Psycrucifix' longsword morphing elixir"
	desc = "A small container of special morphing dust, perfect to make a specific item. It can be used to alter the appearance of.. </br>..a Steel Longsword.. </br>..or a Psydonic Longsword."
	target_items = list(
		/obj/item/rogueweapon/sword/long/psysword	= /obj/item/rogueweapon/sword/long/psysword/psycrucifix,
		/obj/item/rogueweapon/sword/long			= /obj/item/rogueweapon/sword/long/triumph/psycrucifix
	)
	result_item = null
	icon_loadout = /obj/item/rogueweapon/sword/long/triumph/psycrucifix
