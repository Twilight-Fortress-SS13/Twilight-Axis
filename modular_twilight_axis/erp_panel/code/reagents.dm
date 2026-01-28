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

#define LOVE_POTION_DURATION (48 MINUTES)

/datum/reagent/consumable/love_potion
	name = "Love Potion"
	metabolizing = TRUE

/datum/reagent/consumable/love_potion/on_mob_add(mob/living/carbon/human/H)
	. = ..()
	if(!H)
		return

	var/datum/component/relationships/R = H.GetComponent(/datum/component/relationships)
	if(!R)
		R = H.AddComponent(/datum/component/relationships)

	var/mob/living/carbon/human/target
	var/best_dist = 100

	for(var/mob/living/carbon/human/M in view(7, H))
		if(M == H)
			continue
		var/d = get_dist(H, M)
		if(d < best_dist)
			best_dist = d
			target = M

	if(!target)
		return

	if(R.has_relation(target, REL_LOVE_POTION))
		R.remove_relation(target, REL_LOVE_POTION)
		H.remove_status_effect(/datum/status_effect/love_potion)
		return

	R.add_relation(target, REL_LOVE_POTION)
	var/datum/status_effect/love_potion/SE = H.has_status_effect(/datum/status_effect/love_potion)
	if(!SE)
		SE = H.apply_status_effect(/datum/status_effect/love_potion)
	if(SE)
		SE.set_target(target)

	addtimer(CALLBACK(R, /datum/component/relationships/proc/remove_relation, target, REL_LOVE_POTION), LOVE_POTION_DURATION)

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
		/obj/item/reagent_containers/food/snacks/rogue/honey = 2,
		/obj/item/natural/head/troll = 1,
		/datum/reagent/consumable/ethanol/beer/emberwine = 30,
	)

	craftdiff = 6

#undef LOVE_POTION_DURATION
