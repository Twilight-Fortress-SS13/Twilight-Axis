/datum/reagent/erpjuice/cum
	name = "Erotic Fluid"
	description = "A thick, sticky, cream like fluid, produced during an orgasm."
	reagent_state = LIQUID
	color = "#ebebeb"
	taste_description = "salty and tangy"
	metabolizing = TRUE

/datum/reagent/erpjuice/cum/on_mob_add(mob/living/carbon/carbon)
	if(ishuman(carbon))
		if(istype(carbon.patron, /datum/patron/inhumen/baotha))
			to_chat(carbon, "<span class='love_mid'>Она радуется, глядя на меня...</span>")
			carbon.add_stress(/datum/stressevent/nympho_taste/baotha)
		else if(carbon.has_flaw(/datum/charflaw/addiction/lovefiend))
			to_chat(carbon, "<span class='love_mid'>Как же мне нравится этот вкус...</span>")
			carbon.add_stress(/datum/stressevent/nympho_taste)
	..()

/datum/reagent/consumable/milk/erp
	name = "Breast Milk"
	description = "A thick, transparent milk that clearly doesn't come from a cow."
	reagent_state = LIQUID
	color = "#eee4e4"
	taste_description = "sweet and tart"
	nutriment_factor = 0
	metabolizing = TRUE
	metabolization_rate = 0.1

/datum/reagent/consumable/milk/erp/on_mob_add(mob/living/carbon/carbon)
	if(ishuman(carbon))
		if(HAS_TRAIT(carbon, TRAIT_CRACKHEAD))
			to_chat(carbon, "<span class='love_mid'>Она радуется, глядя на меня...</span>")
			carbon.add_stress(/datum/stressevent/nympho_taste/baotha)
		else if(carbon.has_flaw(/datum/charflaw/addiction/lovefiend))
			to_chat(carbon, "<span class='love_mid'>Как же мне нравится этот вкус...</span>")
			carbon.add_stress(/datum/stressevent/nympho_taste)

/obj/item/reagent_containers/attackby(obj/item/I, mob/living/user, params)
	..()
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/salt))
		var/normal_milk = reagents.get_reagent_amount(/datum/reagent/consumable/milk)
		var/erp_milk = reagents.get_reagent_amount(/datum/reagent/consumable/milk/erp)
		var/total_milk = normal_milk + erp_milk
		if(total_milk < 15)
			to_chat(user, span_warning("Not enough milk."))
			return
		to_chat(user, span_warning("Adding salt to the milk."))
		playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		if(do_after(user, short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			var/remaining = 15
			if(normal_milk > 0)
				var/to_remove_normal = min(normal_milk, remaining)
				if(to_remove_normal > 0)
					reagents.remove_reagent(/datum/reagent/consumable/milk, to_remove_normal)
					remaining -= to_remove_normal
			if(remaining > 0 && erp_milk > 0)
				var/to_remove_erp = min(erp_milk, remaining)
				if(to_remove_erp > 0)
					reagents.remove_reagent(/datum/reagent/consumable/milk/erp, to_remove_erp)
					remaining -= to_remove_erp
			reagents.add_reagent(/datum/reagent/consumable/milk/salted, 15)
			qdel(I)
			return

/datum/reagent/erpjuice/lube
	name = "Lubricant"
	description = "A slick, translucent fluid that helps things go smoothly."
	reagent_state = LIQUID
	color = "#e6f0ff"
	taste_description = "slippery"
	metabolizing = TRUE
	metabolization_rate = 0.05

#define LOVE_POTION_DURATION (48 MINUTES)

/datum/reagent/consumable/love_potion
	name = "Love Potion"
	metabolizing = TRUE

/datum/reagent/consumable/love_potion/proc/get_anchor_mob()
	var/datum/weakref/W = data?["anchor_ref"]
	if(!W)
		return null

	var/mob/living/A = W.resolve()
	if(!A || QDELETED(A))
		data -= "anchor_ref"
		if(!length(data))
			data = null
		return null
	return A

/datum/reagent/consumable/love_potion/proc/set_anchor_mob(mob/living/anchor)
	if(!anchor || QDELETED(anchor))
		return FALSE
	if(!data)
		data = list()
	data["anchor_ref"] = WEAKREF(anchor)
	return TRUE

/datum/reagent/consumable/love_potion/proc/clear_anchor_mob()
	if(!data)
		return
	data -= "anchor_ref"
	if(!length(data))
		data = null

/datum/reagent/consumable/love_potion/on_mob_add(mob/living/carbon/human/H)
	. = ..()
	if(!H || QDELETED(H))
		return

	var/mob/living/anchor = get_anchor_mob()
	if(!anchor || anchor == H)
		return

	if(!H.has_status_effect(/datum/status_effect/love_potion))
		H.apply_status_effect(/datum/status_effect/love_potion)

	var/datum/status_effect/love_potion/SE = H.has_status_effect(/datum/status_effect/love_potion)
	if(SE)
		SE.set_target(anchor)

#undef LOVE_POTION_DURATION

/obj/item/reagent_containers/glass/bottle/alchemical/love_potion
	name = "love potion"
	desc = "A shimmering draught sealed in glass."
	volume = 30

/obj/item/reagent_containers/glass/bottle/alchemical/love_potion/Initialize(mapload)
	. = ..()
	if(reagents)
		reagents.add_reagent(/datum/reagent/consumable/love_potion, 30)

/datum/crafting_recipe/roguetown/alchemy/love_potion
	name = "love potion"
	category = "Transmutation"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/love_potion = 1)

	reqs = list(
		/obj/item/reagent_containers/glass/bottle/alchemical = 1,
		/obj/item/roguegem/ruby = 1,
		/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals = 3,
		/datum/reagent/consumable/ethanol/beer/emberwine = 30,
	)

	craftdiff = 6
