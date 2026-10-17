/datum/intent/mace/strike/tetsubo
	reach = 2

/datum/intent/mace/smash/tetsubo
	reach = 2

/obj/item/rogueweapon/mace/goden/steel/tetsubo
	name = "tetsubo"
	desc = "A heavier variant of the kanabo, fitted with a steel sleeve bearing menacing spikes and favored by Ogre Warlords. Requires immense strength to use, but hits like a raging bull."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/blunt64.dmi'
	icon_state = "tetsubo"
	force = 20
	possible_item_intents = list(/datum/intent/mace/strike/tetsubo)
	gripped_intents = list(/datum/intent/mace/strike/tetsubo, /datum/intent/mace/smash/tetsubo, /datum/intent/effect/daze)
	sharpness = IS_SHARP
	minstr = 11
	slot_flags = ITEM_SLOT_BACK
