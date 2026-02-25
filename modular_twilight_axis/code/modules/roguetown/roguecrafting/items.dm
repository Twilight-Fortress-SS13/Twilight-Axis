/datum/crafting_recipe/roguetown/survival/rope_leash
	name = "rope leash (1 rope)"
	result = /obj/item/leash
	reqs = list(/obj/item/rope = 1)
	tools = list(/obj/item/needle)
	verbage_simple = "sew"
	verbage = "sews"
	category = "General"
	always_availible = TRUE

/datum/crafting_recipe/roguetown/survival/chain_leash
	name = "chain leash (1 chain)"
	result = /obj/item/leash/chain
	reqs = list(/obj/item/rope/chain = 1)
	verbage_simple = "craft"
	verbage = "crafts"
	category = "General"
	always_availible = TRUE

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

/datum/crafting_recipe/roguetown/sewing/grenzelpants_chain
	name = "grenzelhoftian paumpers with chain chausses"
	result = /obj/item/clothing/under/roguetown/chainlegs/grenzelpants
	reqs = list(/obj/item/clothing/under/roguetown/chainlegs = 1,
				/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/sewing/grenzelshirt_chain
	name = "grenzelhoftian hip-shirt with hauberk"
	result = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/grenzelhoft
	reqs = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk = 1,
				/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft = 1)
	craftdiff = 0
