/datum/crafting_recipe/roguetown/alchemy/smartium
	name = "smartium"
	structurecraft = null
	result = list(/obj/item/reagent_containers/powder/smartium)
	reqs = list(/obj/item/ash = 2, /datum/reagent/berrypoison = 2, /obj/item/reagent_containers/food/snacks/grown/manabloom = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/smartium_3x
	name = "smartium (x3)"
	structurecraft = null
	result = list(/obj/item/reagent_containers/powder/smartium,
					/obj/item/reagent_containers/powder/smartium,
					/obj/item/reagent_containers/powder/smartium)
	reqs = list(/obj/item/ash = 3, /datum/reagent/berrypoison = 3, /obj/item/reagent_containers/food/snacks/grown/manabloom = 3, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/corps_dust
	name = "corps dust"
	structurecraft = null
	result = list(/obj/item/reagent_containers/powder/corps_dust)
	reqs = list(/obj/item/ash = 1, /datum/reagent/berrypoison = 2, /obj/item/alch/viscera = 2, /obj/item/alch/bone = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/corps_dust_3x
	name = "corps dust (x3)"
	structurecraft = null
	result = list(/obj/item/reagent_containers/powder/corps_dust,
					/obj/item/reagent_containers/powder/corps_dust,
					/obj/item/reagent_containers/powder/corps_dust)
	reqs = list(/obj/item/ash = 2, /datum/reagent/berrypoison = 3, /obj/item/alch/viscera = 3, /obj/item/alch/bone = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/grave_powder
	name = "grave powder"
	structurecraft = null
	result = list(/obj/item/reagent_containers/powder/grave_powder)
	reqs = list(/obj/item/alch/matricaria = 1, /obj/item/alch/calendula = 1, /obj/item/reagent_containers/powder/ozium = 1, /obj/item/reagent_containers/powder/corps_dust = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/grave_powder_3x
	name = "grave powder (x3)"
	structurecraft = null
	result = list(/obj/item/reagent_containers/powder/grave_powder,
					/obj/item/reagent_containers/powder/grave_powder,
					/obj/item/reagent_containers/powder/grave_powder)
	reqs = list(/obj/item/alch/matricaria = 3, /obj/item/alch/calendula = 3, /obj/item/reagent_containers/powder/ozium = 2, /obj/item/reagent_containers/powder/corps_dust = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/inferrum
	name = "inferrum"
	structurecraft = null
	result = list(/obj/item/reagent_containers/powder/inferrum)
	reqs = list(/obj/item/alch/firedust = 1, /obj/item/alch/irondust = 1, /obj/item/alch/coaldust = 1, /datum/reagent/berrypoison = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/inferrum_3x
	name = "inferrum (x3)"
	structurecraft = null
	result = list(/obj/item/reagent_containers/powder/inferrum,
					/obj/item/reagent_containers/powder/inferrum,
					/obj/item/reagent_containers/powder/inferrum)
	reqs = list(/obj/item/alch/firedust = 1, /obj/item/alch/irondust = 3, /obj/item/alch/coaldust = 3, /datum/reagent/berrypoison = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/moondust_purest
	name = "moondust purest"
	category = "Table"
	result = list(/obj/item/reagent_containers/powder/moondust_purest)
	reqs = list(/obj/item/ash = 1, /obj/item/reagent_containers/powder/ozium = 1, /obj/item/reagent_containers/powder/moondust = 1, /obj/item/reagent_containers/powder/smartium)
	craftdiff = 4

