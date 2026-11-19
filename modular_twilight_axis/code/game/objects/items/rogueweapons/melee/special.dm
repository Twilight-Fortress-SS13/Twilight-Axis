/obj/item/rogueweapon/pick/militia
	associated_skill = /datum/skill/combat/axes

/obj/item/rogueweapon/handclaw/gronn/silver/psy
	icon = 'modular_twilight_axis/icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "psyclaws"
	name = "psydonic claws"
	desc = "Three silver claws mounted upon a reinforced gauntlet, blessed for those who hunt in silence. \
	Though lacking the reach of a sword, they find purchase where steel cannot, rending the servants of darkness in Psydon's name."

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
