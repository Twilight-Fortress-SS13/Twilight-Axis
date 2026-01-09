/datum/reagent/erpjuice/cum
	name = "Erotic Fluid"
	description = "A thick, sticky, cream like fluid, produced during an orgasm."
	reagent_state = LIQUID
	color = "#ebebeb"
	taste_description = "salty and tangy"
	metabolizing = TRUE

/datum/reagent/erpjuice/cum/on_mob_add(mob/living/carbon/carbon) //cum additional effect on nymphos and baotha's worshippers
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

/datum/reagent/consumable/milk/erp/on_mob_add(mob/living/carbon/carbon) //milk additional effect on nymphos and baotha's worshippers
	if(ishuman(carbon))
		if(HAS_TRAIT(carbon, TRAIT_CRACKHEAD))
			to_chat(carbon, "<span class='love_mid'>Она радуется, глядя на меня...</span>")
			carbon.add_stress(/datum/stressevent/nympho_taste/baotha)
		else if(carbon.has_flaw(/datum/charflaw/addiction/lovefiend))
			to_chat(carbon, "<span class='love_mid'>Как же мне нравится этот вкус...</span>")
			carbon.add_stress(/datum/stressevent/nympho_taste)

// /obj/item/reagent_containers/attackby(obj/item/I, mob/living/user, params) // add cook time to containers & salted milk for butter churning
// 	..()
// 	update_cooktime(user)

// 	if(istype(I, /obj/item/reagent_containers/powder/salt))
// 		var/normal_milk = reagents.get_reagent_amount(/datum/reagent/consumable/milk)
// 		var/erp_milk = reagents.get_reagent_amount(/datum/reagent/consumable/milk/erp)
// 		var/total_milk = normal_milk + erp_milk
// 		if(total_milk < 15)
// 			to_chat(user, span_warning("Not enough milk."))
// 			return

// 		to_chat(user, span_warning("Adding salt to the milk."))
// 		playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)

// 		if(do_after(user, short_cooktime, target = src))
// 			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)

// 			var/remaining = 15
// 			var/used_normal = 0
// 			var/used_erp = 0
// 			if(normal_milk > 0)
// 				var/to_remove_normal = min(normal_milk, remaining)
// 				if(to_remove_normal > 0)
// 					reagents.remove_reagent(/datum/reagent/consumable/milk, to_remove_normal)
// 					used_normal = to_remove_normal
// 					remaining -= to_remove_normal

// 			if(remaining > 0 && erp_milk > 0)
// 				var/to_remove_erp = min(erp_milk, remaining)
// 				if(to_remove_erp > 0)
// 					reagents.remove_reagent(/datum/reagent/consumable/milk/erp, to_remove_erp)
// 					used_erp = to_remove_erp
// 					remaining -= to_remove_erp

// 			var/yield_normal = used_normal
// 			var/yield_erp = round(used_erp / 3)
// 			var/total_yield = yield_normal + yield_erp
// 			if(total_yield <= 0)
// 				total_yield = 1

// 			reagents.add_reagent(/datum/reagent/consumable/milk/salted, total_yield)
// 			qdel(I)
