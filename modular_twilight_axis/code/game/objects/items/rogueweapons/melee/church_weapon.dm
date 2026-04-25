GLOBAL_LIST_INIT(church_weapon_list, list(
										/obj/item/rogueweapon/whip/xylix,
										/obj/item/rogueweapon/huntingknife/idagger/steel/devilsknife,
										/obj/item/rogueweapon/sword/rapier/eora,
										/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/eora,
										/obj/item/clothing/gloves/roguetown/knuckles/eora,
										/obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle,
										/obj/item/rogueweapon/halberd/pestran,
										/obj/item/rogueweapon/sword/long/kriegmesser/pestran,
										/obj/item/rogueweapon/huntingknife/idagger/steel/astrata,
										/obj/item/rogueweapon/sword/long/exe/astrata,
										/obj/item/rogueweapon/huntingknife/throwingknife/steel/noc,
										/obj/item/rogueweapon/sword/sabre/nockhopesh,
										/obj/item/rogueweapon/sword/long/kriegmesser/noc,
										/obj/item/rogueweapon/huntingknife/idagger/steel/ravox,
										/obj/item/rogueweapon/mace/goden/steel/ravox,
										/obj/item/rogueweapon/greatsword/grenz/flamberge/ravox,
										/obj/item/rogueweapon/huntingknife/idagger/steel/abyssor,
										/obj/item/rogueweapon/katar/abyssor,
										/obj/item/rogueweapon/stoneaxe/battle/abyssoraxe,
										/obj/item/rogueweapon/huntingknife/idagger/steel/dendor,
										/obj/item/rogueweapon/halberd/bardiche/scythe,
										/obj/item/rogueweapon/huntingknife/idagger/steel/necra,
										/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe/preblessed,
										/obj/item/rogueweapon/flail/sflail/necraflail,
										/obj/item/rogueweapon/huntingknife/idagger/steel/malum,
										/obj/item/rogueweapon/greatsword/grenz/flamberge/malum,
										/obj/item/rogueweapon/mace/maul/grand/malum,
										/obj/item/rogueweapon/sword/long/undivided
))

/obj/item/rogueweapon/Initialize()
	. = ..()
	if(src.type in GLOB.church_weapon_list)
		AddComponent(/datum/component/church_weapon, TRAIT_CLERGY)

/obj/item/clothing/gloves/roguetown/knuckles/eora/Initialize()
	. = ..()
	AddComponent(/datum/component/church_weapon, TRAIT_CLERGY)