/obj/structure/chair/smallbench
	name = "small bench"
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "benchsmall"
	buildstackamount = 1
	item_chair = null
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	sleepy = 0.5
	layer = OBJ_LAYER
	density = FALSE

/obj/structure/chair/bench/chaiselounge
	name = "Chaise lounge"
	desc = "A particularly affluent piece of furniture, upholstered with red fabric."
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	icon_state = "chaiseloungeleft"

/obj/structure/chair/bench/chaiselounge/r
	name = "Chaise lounge"
	desc = "A particularly affluent piece of furniture, upholstered with red fabric."
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	icon_state = "chaiseloungeright"

/obj/structure/chair/bench/cuckold_chair
	name = "Red chair"
	desc = "A particularly affluent piece of furniture, upholstered with red fabric."
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	icon_state = "chair_fancyplush"

/obj/structure/chair/stool/rogue/fancy
	name = "Fancy stool"
	desc = "A particularly affluent piece of furniture, upholstered with red fabric."
	icon_state = "fancystool"
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	item_chair = /obj/item/chair/stool/bar/rogue/fancy
	max_integrity = 100
	blade_dulling = DULLING_BASHCHOP
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"

/obj/item/chair/stool/bar/rogue/fancy
	name = "Fancy stool"
	desc = "A particularly affluent piece of furniture, upholstered with red fabric."
	icon_state = "fancystoolover"
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	origin_type = /obj/structure/chair/stool/rogue/fancy
	blade_dulling = DULLING_BASHCHOP
	can_parry = TRUE
	force = 15
	force_wielded = 15
	throwforce = 20
	wdefense = 1
	possible_item_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	gripped_intents = list(/datum/intent/mace/strike/wood, /datum/intent/mace/smash/wood)
	max_integrity = 50
	obj_flags = CAN_BE_HIT
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	associated_skill = /datum/skill/combat/unarmed
	swingsound = BLUNTWOOSH_LARGE

/obj/structure/chair/bench/stone
	name = "Stone bench"
	desc = "A bench carved from a single piece of stone."
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	icon_state = "stonebench"

/obj/structure/chair/bench/stonethrone
	name = "Stone throne"
	desc = "A throne carved from a single piece of stone"
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	icon_state = "stonethrone"


/obj/structure/bed/rogue/stonebed
	name = "Stone bed"
	desc = "A bed carved from stone. Cold and hard—just the thing for ascetics."
	icon_state = "stonebed"
	icon = 'modular_twilight_axis/icons/roguetown/misc/structure.dmi'
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = 90
	sleepy = 3
	debris = list(/obj/item/natural/stone = 1)
