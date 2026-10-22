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

/datum/crafting_recipe/roguetown/alchemy/quicksilver/blessed
	name = "quicksilver (blessed silver)"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied = 1, /datum/reagent/water/blessed = 45, /obj/item/natural/cloth = 1, /obj/item/alch/silverdust_blessed = 1)

/datum/crafting_recipe/roguetown/alchemy/qsabsolution/blessed
	name = "absolving silver (blessed silver)"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied = 1, /datum/reagent/water/blessed = 45, /obj/item/natural/cloth = 1, /obj/item/alch/silverdust_blessed = 1)

/obj/item/alch/stonedust
	name = "stone dust"
	desc = "Finely ground mineral dust used for glass clay refinement."
	icon_state = "coaldust"
	major_pot = null
	med_pot = null
	minor_pot = null

/obj/item/alch/blessedseedpowder
	name = "blessed seed powder"
	desc = "Luminous seed dust prepared with sanctified water. Dendor's touch lingers within it."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "flour"
	color = "#BFFFC4"
	major_pot = null
	med_pot = null
	minor_pot = null

/obj/item/alch/blessedseedpowder/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#58C86A")
	add_filter("blessedseed_glow", 2, list("type" = "outline", "color" = "#58C86A", "alpha" = 95, "size" = 1))

/obj/item/alch/blessedseedpowder/Destroy()
	remove_filter("blessedseed_glow")
	return ..()

/obj/item/alch/bloomstone
	name = "harvest bloomstone"
	desc = "A smooth stone suffused with the Treefather's living power. When held during while using the Bless Crops miracle it functions like blessed seed powder and spends a charge instead of being consumed — good for twenty uses before it shatters."
	icon = 'icons/roguetown/gems/gem_shell.dmi'
	icon_state = "cutgem_shell"
	color = "#228B22"
	major_pot = null
	med_pot = null
	minor_pot = null
	var/charges = 20

/obj/item/alch/bloomstone/Initialize(mapload)
	. = ..()
	set_light(1, 1, 2, l_color = "#73c47a")
	add_filter("bloomstone_glow", 2, list("type" = "outline", "color" = "#73c47a", "alpha" = 95, "size" = 1))

/obj/item/alch/bloomstone/examine(mob/user)
	. = ..()
	. += span_info("It has [charges] charge\s remaining.")

/obj/item/alch/bloomstone/Destroy(force=FALSE)
	if(force)
		charges = 0
	remove_filter("bloomstone_glow")
	charges--
	if(charges > 0)
		add_filter("bloomstone_glow", 2, list("type" = "outline", "color" = "#73c47a", "alpha" = 95, "size" = 1))
		return QDEL_HINT_LETMELIVE // <---- DO NOT EVER EVER EVER EVER EVER EVER EVER EVER EVER DO THIS
	new /obj/item/alch/stonedust(get_turf(src))
	if(loc && isliving(loc))
		var/mob/living/holder = loc
		to_chat(holder, span_warning("The Harvest Bloomstone's light gutters and the stone crumbles to dust in my hand!"))
	return ..()

/datum/crafting_recipe/roguetown/druidic
	abstract_type = /datum/crafting_recipe/roguetown/druidic
	req_table = FALSE
	always_availible = TRUE
	skillcraft = /datum/skill/magic/druidic
	subtype_reqs = FALSE
	verbage_simple = "prepare"
	verbage = "prepares"
	craftsound = 'sound/foley/mortarpestle.ogg'

/datum/crafting_recipe/roguetown/druidic/blessedseedpowder
	name = "blessed seed powder"
	result = list(/obj/item/alch/blessedseedpowder)
	reqs = list(
		/obj/item/seeds/treesap = 1,
		/datum/reagent/water/blessed = 10,
	)
	tools = list(/obj/item/pestle = 1)
	craftdiff = SKILL_LEVEL_NOVICE
	time = 2 SECONDS
