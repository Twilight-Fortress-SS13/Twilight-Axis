/datum/crafting_recipe/roguetown/survival/rope_leash
	name = "rope leash"
	result = /obj/item/leash
	reqs = list(/obj/item/rope = 1)
	tools = list(/obj/item/needle)

/datum/crafting_recipe/roguetown/survival/chain_leash
	name = "chain leash"
	result = /obj/item/leash/chain
	reqs = list(/obj/item/rope/chain = 1)

/datum/crafting_recipe/roguetown/sewing/grenzelhelm
	subtype_reqs = FALSE

/datum/crafting_recipe/roguetown/sewing/grenzelsallet_visor
	name = "grenzelhoftian hat with steel visored sallet"
	result = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored/grenzelhoft)
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
				/obj/item/clothing/head/roguetown/helmet/sallet/visored = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelsallet_visor/off
	name = "take hat off steel visored sallet"
	result = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/sallet/visored = 1)
	reqs = list(/obj/item/clothing/head/roguetown/helmet/sallet/visored/grenzelhoft = 1)
	bypass_dupe_test = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelarmet
	name = "grenzelhoftian hat with armet"
	result = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/grenzelhoft)
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
				/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelarmet/off
	name = "take hat off armet"
	result = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet = 1)
	reqs = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/grenzelhoft = 1)
	bypass_dupe_test = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelskettle
	name = "grenzelhoftian hat with slitted kettle helm"
	result = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/grenzelhoft)
	reqs = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1,
				/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelskettle/off
	name = "take hat off slitted kettle helm"
	result = list(/obj/item/clothing/head/roguetown/grenzelhofthat = 1, /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle = 1)
	reqs = list(/obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle/grenzelhoft = 1)
	bypass_dupe_test = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/grenzelchain_legs
	name = "layer grenzelhoftian paumpers atop chain chausses"
	result = /obj/item/clothing/under/roguetown/chainlegs/grenzelhoft
	reqs = list(/obj/item/clothing/under/roguetown/chainlegs = 1,
				/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/grenzelchain_legs/off
	name = "take grenzelhoftian paumpers off the chain chausses"
	result = list(/obj/item/clothing/under/roguetown/chainlegs = 1, /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants = 1)
	reqs = list(/obj/item/clothing/under/roguetown/chainlegs/grenzelhoft = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/grenzelhauberk
	name = "layer a grenzelhoftian hip-shirt atop hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1,
				/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/grenzelhauberk/off
	name = "take a grenzelhoftian hip-shirt off the hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/grenzelhauberk/off
	name = "take a grenzelhoftian hip-shirt off the hauberk"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft = 1, /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/naledymask_up
	name = "combining a war scholar's mask with a steel mask"
	result = list(/obj/item/clothing/mask/rogue/lordmask/naledi/steel = 1)
	reqs = list(/obj/item/clothing/mask/rogue/lordmask/naledi = 1, /obj/item/clothing/mask/rogue/facemask/steel = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

/datum/crafting_recipe/roguetown/survival/naledymask_up_decorative
	name = "combining a war scholar's decorated mask with a steel mask"
	result = list(/obj/item/clothing/mask/rogue/lordmask/naledi/steel = 1)
	reqs = list(/obj/item/clothing/mask/rogue/lordmask/naledi/decorated = 1, /obj/item/clothing/mask/rogue/facemask/steel = 1)
	craftdiff = 0
	req_table = TRUE
	bypass_dupe_test = TRUE

//CRAFTKITS_STUFF

/datum/crafting_recipe/roguetown/survival/metal_stake
	name = "heat-treat stake to metal stake"
	result = list(/obj/item/metal_stake = 1)
	reqs = list(/obj/item/scrap = 2, /obj/item/grown/log/tree/stake = 1)
	structurecraft = /obj/machinery/light/rogue
	craftdiff = 3
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "heat-treat"
	verbage = "heat-treats"

//////////////////////////////////////// IRON ////////////////////////////////////////

//HELMET

/datum/crafting_recipe/roguetown/survival/chaincoif
	name = "scrap-weave an iron chain coif"
	result = list(/obj/item/clothing/neck/roguetown/chaincoif/iron = 1)
	reqs = list(/obj/item/scrap = 5)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-weave"
	verbage = "scrap-weaves"

/datum/crafting_recipe/roguetown/survival/chaincoif_full
	name = "scrap-extend an iron chain coif into a full coif"
	result = list(/obj/item/craft_kit/full_chaincoif = 1)
	reqs = list(/obj/item/scrap = 3, /obj/item/clothing/neck/roguetown/chaincoif/iron = 1)
	craftdiff = 4
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-extend"
	verbage = "scrap-extends"

//ARMOR

/datum/crafting_recipe/roguetown/survival/haubergeon
	name = "scrap-weave an iron haubergeon"
	result = list(/obj/item/craft_kit/haubergeon = 1)
	reqs = list(/obj/item/scrap = 5)
	craftdiff = 3
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-weave"
	verbage = "scrap-weaves"

/datum/crafting_recipe/roguetown/survival/brustplate
	name = "scrap-reinforce an iron breastplate"
	result = list(/obj/item/craft_kit/cuirass = 1)
	reqs = list(/obj/item/scrap = 5, /obj/item/clothing/suit/roguetown/armor/chainmail/iron = 1)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-reinforce"
	verbage = "scrap-reinforces"

/datum/crafting_recipe/roguetown/survival/haubergeon_light
	name = "scrap-line a haubergeon with silk"
	result = list(/obj/item/craft_kit/haubergeon_light = 1)
	reqs = list(/obj/item/scrap = 5, /obj/item/clothing/suit/roguetown/armor/chainmail/iron = 1)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-line"
	verbage = "scrap-lines"

/datum/crafting_recipe/roguetown/survival/brigandine_light
	name = "scrap-combine a handmade brigandine"
	result = list(/obj/item/craft_kit/brigandine_light = 1)
	reqs = list(/obj/item/scrap = 3, /obj/item/clothing/suit/roguetown/armor/chainmail/iron = 1, /obj/item/clothing/suit/roguetown/armor/gambeson = 1)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-combine"
	verbage = "scrap-combines"

//////////////////////////////////////// CONVERT ////////////////////////////////////////

/datum/crafting_recipe/roguetown/survival/i_haubergeon
	name = "scrap-shorten an iron hauberk into a haubergeon"
	result = list(/obj/item/craft_kit/haubergeon = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron = 1, /obj/item/scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-shorten"
	verbage = "scrap-shortens"

/datum/crafting_recipe/roguetown/survival/i_hauberk
	name = "scrap-lengthen an iron haubergeon into a hauberk"
	result = list(/obj/item/craft_kit/hauberk = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/iron = 1, /obj/item/scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-lengthen"
	verbage = "scrap-lengthens"

/datum/crafting_recipe/roguetown/survival/i_cuirass
	name = "scrap-strip an iron half-plate down to a cuirass"
	result = list(/obj/item/craft_kit/cuirass = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/iron = 1, /obj/item/scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-strip"
	verbage = "scrap-strips"

/datum/crafting_recipe/roguetown/survival/i_cuirass_to_halfplate
	name = "scrap-upgrade an iron cuirass to a half-plate"
	result = list(/obj/item/craft_kit/halfplate = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron = 1, /obj/item/scrap = 2)
	craftdiff = 4
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-upgrade"
	verbage = "scrap-upgrades"

/datum/crafting_recipe/roguetown/survival/i_plate_to_halfplate
	name = "scrap-disassemble an iron full-plate to a half-plate"
	result = list(/obj/item/craft_kit/halfplate = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/full/iron = 1, /obj/item/scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-disassemble"
	verbage = "scrap-disassembles"

/datum/crafting_recipe/roguetown/survival/i_plate
	name = "scrap-assemble an iron half-plate into a full-plate"
	result = list(/obj/item/craft_kit/plate = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/iron = 1, /obj/item/scrap = 2)
	craftdiff = 4
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-assemble"
	verbage = "scrap-assembles"

//WRISTS

/datum/crafting_recipe/roguetown/survival/splintarms
	name = "scrap-splint leather bracers"
	result = list(/obj/item/craft_kit/splintarms = 1)
	reqs = list(/obj/item/clothing/wrists/roguetown/bracers/leather = 1, /obj/item/scrap = 4)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-splint"
	verbage = "scrap-splints"

//PANTS

/datum/crafting_recipe/roguetown/survival/splintlegs
	name = "scrap-splint leather trousers"
	result = list(/obj/item/craft_kit/splintlegs = 1)
	reqs = list(/obj/item/clothing/under/roguetown/trou/leather = 1, /obj/item/scrap = 4)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-splint"
	verbage = "scrap-splints"

/datum/crafting_recipe/roguetown/survival/chainlegs
	name = "scrap-weave iron chain chausses"
	result = list(/obj/item/craft_kit/chainlegs = 1)
	reqs = list(/obj/item/scrap = 5)
	craftdiff = 3
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-weave"
	verbage = "scrap-weaves"

//BOOTS

/datum/crafting_recipe/roguetown/survival/lplateboots
	name = "scrap-plate iron maille boots"
	result = list(/obj/item/craft_kit/lplateboots = 1)
	reqs = list(/obj/item/clothing/shoes/roguetown/boots/leather = 1, /obj/item/scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-plate"
	verbage = "scrap-plates"

//////////////////////////////////////// CONVERT ////////////////////////////////////////

/datum/crafting_recipe/roguetown/survival/i_chainlegs
	name = "scrap-alter an iron chain kilt into chausses"
	result = list(/obj/item/craft_kit/chainlegs = 1)
	reqs = list(/obj/item/clothing/under/roguetown/chainlegs/iron/kilt = 1, /obj/item/scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-alter"
	verbage = "scrap-alters"

/datum/crafting_recipe/roguetown/survival/i_kilt
	name = "scrap-alter iron chain chausses into a kilt"
	result = list(/obj/item/craft_kit/kilt = 1)
	reqs = list(/obj/item/clothing/under/roguetown/chainlegs/iron = 1, /obj/item/scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-alter"
	verbage = "scrap-alters"

//////////////////////////////////////// ITEMS ////////////////////////////////////////

/datum/crafting_recipe/roguetown/survival/scrap_lamp
	name = "scrap-fashion an iron scrap lantern"
	result = list(/obj/item/flashlight/flare/torch/lantern/scrap = 1)
	reqs = list(/obj/item/scrap = 4, /obj/item/natural/clay = 2, /obj/item/flashlight/flare/torch = 1)
	craftdiff = 3
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-fashion"
	verbage = "scrap-fashions"

/datum/crafting_recipe/roguetown/survival/scrap_tongs
	name = "scrap-assemble makeshift smithing tongs"
	result = list(/obj/item/rogueweapon/tongs = 1)
	reqs = list(/obj/item/scrap = 2, /obj/item/grown/log/tree/stick = 2)
	craftdiff = 3
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-assemble"
	verbage = "scrap-assembles"

/datum/crafting_recipe/roguetown/survival/scrap_saw
	name = "scrap-fashion a handsaw"
	result = list(/obj/item/rogueweapon/handsaw = 1)
	reqs = list(/obj/item/scrap = 4, /obj/item/grown/log/tree/small = 1)
	craftdiff = 3
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-fashion"
	verbage = "scrap-fashions"

/datum/crafting_recipe/roguetown/survival/scrap_chisel
	name = "scrap-forge a chisel"
	result = list(/obj/item/rogueweapon/chisel = 1)
	reqs = list(/obj/item/scrap = 3, /obj/item/grown/log/tree/small = 1)
	craftdiff = 3
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-forge"
	verbage = "scrap-forges"

/datum/crafting_recipe/roguetown/survival/shortsachel
	name = "scrap-trim a satchel down to a short satchel"
	result = list(/obj/item/storage/backpack/rogue/satchel/short = 1)
	reqs = list(/obj/item/scrap = 2, /obj/item/storage/backpack/rogue/satchel = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	craftdiff = 4
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-trim"
	verbage = "scrap-trims"

//////////////////////////////////////// WEAPONS ////////////////////////////////////////

/datum/crafting_recipe/roguetown/survival/peasantry/peasantwarflail_scrap
	name = "scrap-lash a militia thresher"
	result = /obj/item/rogueweapon/flail/peasantwarflail
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/rope = 1,
		/obj/item/scrap = 3,
		)
	craftdiff = 3
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-lash"
	verbage = "scrap-lashes"

/datum/crafting_recipe/roguetown/survival/peasantry/waraxe_scrap
	name = "scrap-fashion a militia war axe"
	result = /obj/item/rogueweapon/greataxe/militia
	reqs = list(
		/obj/item/scrap = 3,
		/obj/item/grown/log/tree/small = 2,
		/obj/item/rope = 1,
		)
	craftdiff = 3
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-fashion"
	verbage = "scrap-fashions"

/datum/crafting_recipe/roguetown/survival/peasantry/warspear_hoe_scrap
	name = "scrap-improvise a militia warspear"
	result = /obj/item/rogueweapon/spear/militia
	reqs = list(
		/obj/item/scrap = 3,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/rope = 1,
		)
	craftdiff = 3
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-improvise"
	verbage = "scrap-improvises"

/datum/crafting_recipe/roguetown/survival/peasantry/warflail_scrap
	name = "scrap-assemble a militia flail"
	result = /obj/item/rogueweapon/flail/militia
	reqs = list(
		/obj/item/scrap = 3,
		/obj/item/rope = 1,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 3
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-assemble"
	verbage = "scrap-assembles"

/datum/crafting_recipe/roguetown/survival/peasantry/warpick_scrap
	name = "scrap-forge a militia warpick"
	result = /obj/item/rogueweapon/pick/militia
	reqs = list(
		/obj/item/scrap = 3,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 3
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-forge"
	verbage = "scrap-forges"

/datum/crafting_recipe/roguetown/survival/peasantry/warpick_steel_scrap
	name = "steel-scrap-forge a militia steel warpick"
	result = /obj/item/rogueweapon/pick/militia/steel
	reqs = list(
		/obj/item/steel_scrap = 3,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 3
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-forge"
	verbage = "steel-scrap-forges"

/datum/crafting_recipe/roguetown/survival/peasantry/maciejowski_knife_scrap
	name = "scrap-grind a maciejowski"
	result = /obj/item/rogueweapon/sword/falchion/militia
	reqs = list(
		/obj/item/scrap = 2,
		/obj/item/natural/whetstone = 1,
		)
	craftdiff = 3
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "scrap-grind"
	verbage = "scrap-grinds"

//////////////////////////////////////// STEEL ////////////////////////////////////////

//HELMET

/datum/crafting_recipe/roguetown/survival/chaincoif_steel
	name = "steel-scrap-weave a steel chain coif"
	result = list(/obj/item/clothing/neck/roguetown/chaincoif = 1)
	reqs = list(/obj/item/steel_scrap = 5)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-weave"
	verbage = "steel-scrap-weaves"

/datum/crafting_recipe/roguetown/survival/chaincoif_full_steel
	name = "steel-scrap-extend a steel chain coif into a full coif"
	result = list(/obj/item/craft_kit/steel/full_chaincoif = 1)
	reqs = list(/obj/item/steel_scrap = 2, /obj/item/clothing/neck/roguetown/chaincoif = 1)
	craftdiff = 4
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-extend"
	verbage = "steel-scrap-extends"

//ARMOR

/datum/crafting_recipe/roguetown/survival/steel_haubergeon
	name = "steel-scrap-weave a steel haubergeon"
	result = list(/obj/item/craft_kit/steel/haubergeon = 1)
	reqs = list(/obj/item/steel_scrap = 4)
	craftdiff = 4
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-weave"
	verbage = "steel-scrap-weaves"

/datum/crafting_recipe/roguetown/survival/steel_cuirass
	name = "steel-scrap-mount a cuirass over chainmail"
	result = list(/obj/item/craft_kit/steel/cuirass = 1)
	reqs = list(/obj/item/steel_scrap = 4, /obj/item/clothing/suit/roguetown/armor/chainmail = 1)
	craftdiff = 4
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-mount"
	verbage = "steel-scrap-mounts"

/datum/crafting_recipe/roguetown/survival/steel_haubergeon_light
	name = "steel-scrap-line a haubergeon with silk"
	result = list(/obj/item/craft_kit/steel/haubergeon_light = 1)
	reqs = list(/obj/item/steel_scrap = 4, /obj/item/clothing/suit/roguetown/armor/chainmail = 1)
	craftdiff = 5
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-line"
	verbage = "steel-scrap-lines"

//////////////////////////////////////// CONVERT ////////////////////////////////////////

/datum/crafting_recipe/roguetown/survival/s_haubergeon
	name = "steel-scrap-shorten a hauberk into a haubergeon"
	result = list(/obj/item/craft_kit/steel/haubergeon = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1, /obj/item/steel_scrap = 2)
	craftdiff = 3
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-shorten"
	verbage = "steel-scrap-shortens"

/datum/crafting_recipe/roguetown/survival/s_hauberk
	name = "steel-scrap-lengthen a haubergeon into a hauberk"
	result = list(/obj/item/craft_kit/steel/hauberk = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail = 1, /obj/item/steel_scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-lengthen"
	verbage = "steel-scrap-lengthens"

/datum/crafting_recipe/roguetown/survival/s_cuirass
	name = "steel-scrap-strip a half-plate down to a cuirass"
	result = list(/obj/item/craft_kit/steel/cuirass = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate = 1, /obj/item/steel_scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-strip"
	verbage = "steel-scrap-strips"

/datum/crafting_recipe/roguetown/survival/s_cuirass_to_halfplate
	name = "steel-scrap-upgrade a cuirass to a half-plate"
	result = list(/obj/item/craft_kit/steel/halfplate = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/cuirass = 1, /obj/item/steel_scrap = 2)
	craftdiff = 5
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-upgrade"
	verbage = "steel-scrap-upgrades"

/datum/crafting_recipe/roguetown/survival/s_plate_to_halfplate
	name = "steel-scrap-disassemble a full-plate to a half-plate"
	result = list(/obj/item/craft_kit/steel/halfplate = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate/full = 1, /obj/item/steel_scrap = 2)
	craftdiff = 4
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-disassemble"
	verbage = "steel-scrap-disassembles"

/datum/crafting_recipe/roguetown/survival/s_plate
	name = "steel-scrap-assemble a half-plate into a full-plate"
	result = list(/obj/item/craft_kit/steel/plate = 1)
	reqs = list(/obj/item/clothing/suit/roguetown/armor/plate = 1, /obj/item/steel_scrap = 2)
	craftdiff = 5
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-assemble"
	verbage = "steel-scrap-assembles"

//PANTS

/datum/crafting_recipe/roguetown/survival/steel_chainlegs
	name = "steel-scrap-weave chain chausses"
	result = list(/obj/item/craft_kit/steel/chainlegs = 1)
	reqs = list(/obj/item/steel_scrap = 5)
	craftdiff = 4
	req_table = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-weave"
	verbage = "steel-scrap-weaves"

//////////////////////////////////////// CONVERT ////////////////////////////////////////

/datum/crafting_recipe/roguetown/survival/s_chainlegs
	name = "steel-scrap-alter a chain kilt into chausses"
	result = list(/obj/item/craft_kit/steel/chainlegs = 1)
	reqs = list(/obj/item/clothing/under/roguetown/chainlegs/kilt = 1, /obj/item/steel_scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-alter"
	verbage = "steel-scrap-alters"

/datum/crafting_recipe/roguetown/survival/s_kilt
	name = "steel-scrap-alter chain chausses into a kilt"
	result = list(/obj/item/craft_kit/steel/kilt = 1)
	reqs = list(/obj/item/clothing/under/roguetown/chainlegs = 1, /obj/item/steel_scrap = 2)
	craftdiff = 3
	req_table = TRUE
	bypass_dupe_test = TRUE
	craftsound = 'sound/foley/dropsound/scrap_drop.ogg'
	verbage_simple = "steel-scrap-alter"
	verbage = "steel-scrap-alters"
