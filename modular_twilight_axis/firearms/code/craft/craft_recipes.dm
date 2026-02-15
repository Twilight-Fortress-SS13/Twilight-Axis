/datum/crafting_recipe/roguetown/survival/twilight_arquebus_bayonet
	name = "bayonet"
	category = "Ranged"
	result = /obj/item/gun/ballistic/twilight_firearm/arquebus/bayonet
	reqs = list(/obj/item/rogueweapon/huntingknife = 1, /obj/item/gun/ballistic/twilight_firearm/arquebus = 1)
	verbage_simple = "fix"
	verbage = "fixes"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/twilight_arquebus_bayonet_dagger_steel
	name = "bayonet"
	category = "Ranged"
	result = /obj/item/gun/ballistic/twilight_firearm/arquebus/bayonet
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/steel = 1, /obj/item/gun/ballistic/twilight_firearm/arquebus = 1)
	verbage_simple = "fix"
	verbage = "fixes"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/twilight_arquebus_bayonet_dagger
	name = "bayonet"
	category = "Ranged"
	result = /obj/item/gun/ballistic/twilight_firearm/arquebus/bayonet
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger = 1, /obj/item/gun/ballistic/twilight_firearm/arquebus = 1)
	verbage_simple = "fix"
	verbage = "fixes"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/twilight_jagerrifle_bayonet
	name = "bayonet"
	category = "Ranged"
	reqs = list(/obj/item/rogueweapon/huntingknife = 1, /obj/item/gun/ballistic/twilight_firearm/arquebus/jagerrifle = 1)
	result = /obj/item/gun/ballistic/twilight_firearm/arquebus/bayonet/jagerrifle
	verbage_simple = "fix"
	verbage = "fixes"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/twilight_jagerrifle_bayonet_dagger_steel
	name = "bayonet"
	category = "Ranged"
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger/steel = 1, /obj/item/gun/ballistic/twilight_firearm/arquebus/jagerrifle = 1)
	result = /obj/item/gun/ballistic/twilight_firearm/arquebus/bayonet/jagerrifle
	verbage_simple = "fix"
	verbage = "fixes"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/twilight_jagerrifle_bayonet_dagger
	name = "bayonet"
	category = "Ranged"
	reqs = list(/obj/item/rogueweapon/huntingknife/idagger = 1, /obj/item/gun/ballistic/twilight_firearm/arquebus/jagerrifle = 1)
	result = /obj/item/gun/ballistic/twilight_firearm/arquebus/bayonet/jagerrifle
	verbage_simple = "fix"
	verbage = "fixes"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/twilight_barker_light
	name = "barker with lamptern"
	reqs = list(/obj/item/gun/ballistic/twilight_firearm/barker = 1, /obj/item/flashlight/flare/torch/lantern = 1)
	result = /obj/item/gun/ballistic/twilight_firearm/barker/barker_light
	verbage_simple = "fix"
	verbage = "fixes"
	craftdiff = 0

/datum/crafting_recipe/roguetown/leather/container/belt/twilight_holsterbelt
    name = "holster belt (2 leather, 2 fibers; APPRENTICE)"
    result = /obj/item/storage/belt/rogue/leather/twilight_holsterbelt
    reqs = list(/obj/item/natural/hide/cured = 2,
                /obj/item/natural/fibers = 2)
    craftdiff = 2

/datum/crafting_recipe/roguetown/leather/container/twilight_ammoholder
	name = "ammo bag (cured leather, 1 fibers)"
	result = /obj/item/quiver/twilight_bullet
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	sellprice = 6
	craftdiff = 0

/datum/crafting_recipe/roguetown/leather/container/twilight_ammoholder_cannonball
	name = "cannonball bag (2 cured leather, 3 fibers)"
	result = /obj/item/quiver/twilight_bullet/cannonball
	reqs = list(/obj/item/natural/hide/cured = 2,
				/obj/item/natural/fibers = 3)
	sellprice = 6
	craftdiff = 0

//Silverdust blessing related stuff, for Inq funny gunpowder
/obj/item/alch/silverdust/examine(mob/user)
	. = ..()
	. += span_info("<font color = '#cfa446'>This object may be blessed by the lingering shard of COMET SYON.</font>")

/obj/item/alch/silverdust_blessed
	name = "blessed silver dust"
	icon = 'modular_twilight_axis/firearms/icons/misc.dmi'
	icon_state = "silverdust_blessed"
	major_pot = /datum/alch_cauldron_recipe/strong_antidote
	med_pot = /datum/alch_cauldron_recipe/antidote
	minor_pot = /datum/alch_cauldron_recipe/big_health_potion

/obj/item/alch/silverdust/attackby(obj/item/A, mob/user, params)
	if(istype(A, /obj/item/flashlight/flare/torch/lantern/psycenser))
		var/obj/item/flashlight/flare/torch/lantern/psycenser/golgotha = A
		if(golgotha.on && (user.used_intent.type == /datum/intent/bless))
			playsound(src, 'sound/magic/holyshield.ogg', 100)
			src.visible_message(span_notice("[src] glistens with power as dust of COMET SYON lands upon it!"))
			new /obj/item/alch/silverdust_blessed(get_turf(src))
			qdel(src)
	..()

/datum/alch_grind_recipe/blessed_silver_bar
	valid_outputs = list(/obj/item/alch/silverdust_blessed = 1)

/datum/alch_grind_recipe/blessed_bullion
	name = "Blessed Silver Bullion"
	valid_input = /obj/item/ingot/silverblessed/bullion
	valid_outputs = list(/obj/item/alch/silverdust_blessed = 1)
	bonus_chance_outputs = list(/obj/item/alch/silverdust_blessed = 33, /obj/item/alch/firedust = 25)

/datum/crafting_recipe/roguetown/leather/twilight_powderflask
	name = "empty powderflask (cured leather, 2 fibers)"
	result = /obj/item/twilight_powderflask_empty
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 2)
	sellprice = 15
	craftdiff = 0

/datum/crafting_recipe/roguetown/engineering/twilight_powderflask/basic
	name = "engineer black gunpowder (4 coaldust, 1 fire essentia, powderflask)"
	result = /obj/item/twilight_powderflask
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/coaldust = 4,
				/obj/item/alch/firedust = 1)
	verbage_simple = "work on"
	verbage = "finishes"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/twilight_powderflask/fyre
	name = "engineer fyrepowder (4 fire essentia, 1 silverdust, powderflask)"
	result = /obj/item/twilight_powderflask/fyre
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/firedust = 4,
				/obj/item/alch/silverdust = 1)
	verbage_simple = "work on"
	verbage = "finishes"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/twilight_powderflask/holyfyre
	name = "engineer holy fyrepowder (4 fire essentia, 1 blessed silverdust, powderflask)"
	result = /obj/item/twilight_powderflask/holyfyre
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/firedust = 4,
				/obj/item/alch/silverdust_blessed = 1)
	verbage_simple = "work on"
	verbage = "finishes"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/twilight_powderflask/thunder
	name = "engineer thunderpowder (6 coal dust, 4 air essentia, powderflask)"
	result = /obj/item/twilight_powderflask/thunder
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/coaldust = 6,
				/obj/item/alch/airdust = 4)
	verbage_simple = "work on"
	verbage = "finishes"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/twilight_powderflask/terror
	name = "engineer terrorpowder (6 coal dust, 15 oz elixir of mana, powderflask)"
	result = /obj/item/twilight_powderflask/terror
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/coaldust = 6,
				/datum/reagent/medicine/manapot = 15)
	verbage_simple = "work on"
	verbage = "finishes"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/engineering/twilight_powderflask/corrosive
	name = "engineer corrosive gunpowder (4 fire essentia, 3 earth essentia, powderflask)"
	result = /obj/item/twilight_powderflask/corrosive
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/firedust = 4,
				/obj/item/alch/earthdust = 3)
	verbage_simple = "work on"
	verbage = "finishes"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/engineering/twilight_powderflask/arcyne
	name = "engineer arcyne gunpowder (4 fire essentia, 2 pure essentia, 30 oz elixir of mana, powderflask)"
	result = /obj/item/twilight_powderflask/arcyne
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/firedust = 4,
				/obj/item/alch/magicdust = 2,
				/datum/reagent/medicine/manapot = 30)
	verbage_simple = "work on"
	verbage = "finishes"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/twilight_powderflask
	name = "mix black gunpowder (4 coaldust, 1 fire essentia, powderflask)"
	result = /obj/item/twilight_powderflask
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/coaldust = 4,
				/obj/item/alch/firedust = 1)
	verbage_simple = "work on"
	verbage = "finishes"
	category = "Table"
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/twilight_powderflask/fyre
	name = "mix fyrepowder (4 fire essentia, 1 silverdust, powderflask)"
	result = /obj/item/twilight_powderflask/fyre
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/firedust = 4,
				/obj/item/alch/silverdust = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/twilight_powderflask/holyfyre
	name = "mix holy fyrepowder (4 fire essentia, 1 blessed silverdust, powderflask)"
	result = /obj/item/twilight_powderflask/holyfyre
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/firedust = 4,
				/obj/item/alch/silverdust_blessed = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/twilight_powderflask/thunder
	name = "mix thunderpowder (6 coal dust, 4 air essentia, powderflask)"
	result = /obj/item/twilight_powderflask/thunder
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/coaldust = 6,
				/obj/item/alch/airdust = 4)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/twilight_powderflask/terror
	name = "mix terrorpowder (6 coal dust, 15 oz elixir of mana, powderflask)"
	result = /obj/item/twilight_powderflask/terror
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/coaldust = 6,
				/datum/reagent/medicine/manapot = 15)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/twilight_powderflask/corrosive
	name = "mix corrosive gunpowder (4 fire essentia, 3 earth essentia, powderflask)"
	result = /obj/item/twilight_powderflask/corrosive
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/firedust = 4,
				/obj/item/alch/earthdust = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/twilight_powderflask/arcyne
	name = "mix arcyne gunpowder (4 fire essentia, 2 pure essentia, 30 oz elixir of mana, powderflask)"
	result = /obj/item/twilight_powderflask/arcyne
	reqs = list(/obj/item/twilight_powderflask_empty = 1,
				/obj/item/alch/firedust = 4,
				/obj/item/alch/magicdust = 2,
				/datum/reagent/medicine/manapot = 30)
	craftdiff = 3
