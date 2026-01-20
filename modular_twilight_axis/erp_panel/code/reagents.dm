#define REAGENT_FLAG_ERP_SENSITIVE (1<<0)

/proc/erp_note_sensitive_turf(turf/T)
	if(!T)
		return
	GLOB_erp_recent_sensitive_turf_tick[REF(T)] = world.time
	if(length(GLOB_erp_recent_sensitive_turf_tick) > 512)
		for(var/k in GLOB_erp_recent_sensitive_turf_tick)
			var/v = GLOB_erp_recent_sensitive_turf_tick[k]
			if(!isnum(v) || v < world.time - 10)
				GLOB_erp_recent_sensitive_turf_tick -= k

/proc/erp_note_sensitive_mob(mob/M)
	if(!M)
		return
	GLOB_erp_recent_sensitive_mob_tick[REF(M)] = world.time
	if(length(GLOB_erp_recent_sensitive_mob_tick) > 256)
		for(var/k in GLOB_erp_recent_sensitive_mob_tick)
			var/v = GLOB_erp_recent_sensitive_mob_tick[k]
			if(!isnum(v) || v < world.time - 10)
				GLOB_erp_recent_sensitive_mob_tick -= k

/proc/erp_inherit_if_context(obj/item/I)
	if(!I || I.erp_sensitive_origin)
		return FALSE
	if(I.reagents && I.reagents.has_erp_sensitive())
		I.erp_sensitive_origin = TRUE
		return TRUE
	if(ismob(I.loc))
		var/mob/M = I.loc
		var/tick = GLOB_erp_recent_sensitive_mob_tick[REF(M)]
		if(isnum(tick) && tick == world.time)
			I.erp_sensitive_origin = TRUE
			return TRUE
	var/turf/T = get_turf(I)
	if(T)
		var/tick2 = GLOB_erp_recent_sensitive_turf_tick[REF(T)]
		if(isnum(tick2) && tick2 == world.time)
			I.erp_sensitive_origin = TRUE
			return TRUE
	return FALSE

/datum/reagent
	var/reagent_flags = 0

/datum/reagents
	var/tmp/erp_sensitive_removed_tick = 0

/datum/reagents/proc/has_erp_sensitive()
	if(!reagent_list || !reagent_list.len)
		return FALSE
	for(var/datum/reagent/R as anything in reagent_list)
		if(R?.reagent_flags & REAGENT_FLAG_ERP_SENSITIVE)
			return TRUE
	return FALSE

/datum/reagents/proc/get_reagent_datum(typepath)
	if(!reagent_list || !reagent_list.len)
		return null
	for(var/datum/reagent/R as anything in reagent_list)
		if(R && R.type == typepath)
			return R
	return null

/atom/proc/is_erp_sensitive_payload()
	if(reagents && reagents.has_erp_sensitive())
		return TRUE
	if(istype(src, /obj/item))
		var/obj/item/I = src
		if(I.erp_sensitive_origin)
			return TRUE
	return FALSE

/obj/item
	var/erp_sensitive_origin = FALSE
	var/tmp/erp_spawn_tick = 0

/obj/item/Initialize(mapload)
	. = ..()
	erp_spawn_tick = world.time
	if(reagents && reagents.has_erp_sensitive())
		erp_sensitive_origin = TRUE
		return .
	erp_inherit_if_context(src)
	return .

/obj/item/Destroy()
	if(src.is_erp_sensitive_payload())
		if(ismob(loc))
			erp_note_sensitive_mob(loc)
		var/turf/T = get_turf(src)
		if(T)
			erp_note_sensitive_turf(T)
	return ..()

/datum/reagents/remove_reagent(reagent, amount, safety = FALSE)
	if(isnull(amount))
		amount = 0
		. = FALSE
		CRASH("null amount passed to reagent code")
	if(!isnum(amount))
		return FALSE
	if(amount < 0)
		return FALSE
	var/list/cached_reagents = reagent_list
	for(var/A in cached_reagents)
		var/datum/reagent/R = A
		if(R.type == reagent)
			amount = CLAMP(amount, 0, R.volume)
			if(amount <= 0)
				return FALSE
			var/was_sensitive = (R.reagent_flags & REAGENT_FLAG_ERP_SENSITIVE)
			R.volume -= amount
			update_total()
			if(was_sensitive)
				erp_sensitive_removed_tick = world.time
				if(my_atom)
					if(ismob(my_atom))
						erp_note_sensitive_mob(my_atom)
					var/turf/T = get_turf(my_atom)
					if(T)
						erp_note_sensitive_turf(T)
			if(!safety)
				handle_reactions()
			if(my_atom)
				my_atom.on_reagent_change(REM_REAGENT)
			return TRUE
	return FALSE

/datum/reagents/add_reagent(reagent, amount, list/data=null, reagtemp = 300, no_react = 0)
	if(!isnum(amount) || !amount)
		return FALSE
	if(amount <= 0)
		return FALSE
	var/datum/reagent/D = GLOB.chemical_reagents_list[reagent]
	if(!D)
		WARNING("[my_atom] attempted to add a reagent called '[reagent]' which doesn't exist. ([usr])")
		return FALSE
	if(D.reagent_flags & REAGENT_FLAG_ERP_SENSITIVE)
		if(ishuman(my_atom))
			var/mob/living/carbon/human/H = my_atom
			if(H.is_erp_defiant())
				to_chat(H, span_warning("Я не могу проглотить это сейчас."))
				return FALSE
	update_total()
	var/cached_total = total_volume
	if(cached_total + amount > maximum_volume)
		amount = (maximum_volume - cached_total)
		if(amount <= 0)
			return FALSE
	var/new_total = cached_total + amount
	var/cached_temp = chem_temp
	var/list/cached_reagents = reagent_list
	var/specific_heat = 0
	var/thermal_energy = 0
	for(var/i in cached_reagents)
		var/datum/reagent/R = i
		specific_heat += R.specific_heat * (R.volume / new_total)
		thermal_energy += R.specific_heat * R.volume * cached_temp
	specific_heat += D.specific_heat * (amount / new_total)
	thermal_energy += D.specific_heat * amount * reagtemp
	chem_temp = thermal_energy / (specific_heat * new_total)
	for(var/A in cached_reagents)
		var/datum/reagent/R = A
		if(R.type == reagent)
			R.volume += amount
			update_total()
			if(my_atom)
				my_atom.on_reagent_change(ADD_REAGENT)
			R.on_merge(data, amount)
			if(erp_sensitive_removed_tick == world.time)
				R.reagent_flags |= REAGENT_FLAG_ERP_SENSITIVE
			if(!no_react)
				handle_reactions()
			if(istype(my_atom, /obj/item))
				var/obj/item/I = my_atom
				if(src.has_erp_sensitive())
					I.erp_sensitive_origin = TRUE
			return TRUE
	var/datum/reagent/R = new D.type(data)
	cached_reagents += R
	R.holder = src
	R.volume = amount
	if(data)
		R.data = data
		R.on_new(data)
	if(erp_sensitive_removed_tick == world.time)
		R.reagent_flags |= REAGENT_FLAG_ERP_SENSITIVE
	if(isliving(my_atom))
		R.on_mob_add(my_atom)
	update_total()
	if(my_atom)
		my_atom.on_reagent_change(ADD_REAGENT)
	if(!no_react)
		handle_reactions()
	if(istype(my_atom, /obj/item))
		var/obj/item/I2 = my_atom
		if(src.has_erp_sensitive())
			I2.erp_sensitive_origin = TRUE
	return TRUE

/obj/item/reagent_containers/canconsume(mob/eater, mob/user, silent = FALSE)
	if(!iscarbon(eater))
		return FALSE
	if(ishuman(eater))
		var/mob/living/carbon/human/H0 = eater
		if(H0.is_erp_defiant() && src.is_erp_sensitive_payload())
			if(!silent)
				to_chat(user ? user : eater, span_warning("Сейчас нельзя употреблять это."))
			return FALSE
	var/mob/living/carbon/C = eater
	var/obj/item/bodypart/head/dullahan/eaterrelay
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!H.get_bodypart_shallow(BODY_ZONE_HEAD))
			if(isdullahan(H))
				var/datum/species/dullahan/dullahan = H.dna.species
				eaterrelay = dullahan.my_head
			else
				return FALSE
	var/covered = ""
	if(C.is_mouth_covered(head_only = 1))
		covered = "headgear"
	else if(C.is_mouth_covered(mask_only = 1))
		covered = "mask"
	if(C != user)
		if((C.mobility_flags & MOBILITY_STAND) && eaterrelay)
			if(get_dir(eater, user) != eater.dir)
				to_chat(user, span_warning("I must stand in front of [C.p_them()]."))
				return FALSE
		else if(eaterrelay && (get_turf(eaterrelay) != get_turf(user) && !user.is_holding(eaterrelay)))
			return FALSE
	if(covered)
		if(!silent)
			var/who = (isnull(user) || eater == user) ? "my" : "[eater.p_their()]"
			to_chat(user, span_warning("I have to remove [who] [covered] first!"))
		return FALSE
	return TRUE

/datum/reagent/erpjuice/cum
	name = "Erotic Fluid"
	description = "A thick, sticky, cream like fluid, produced during an orgasm."
	reagent_state = LIQUID
	color = "#ebebeb"
	taste_description = "salty and tangy"
	metabolizing = TRUE
	reagent_flags = REAGENT_FLAG_ERP_SENSITIVE

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
	reagent_flags = REAGENT_FLAG_ERP_SENSITIVE

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

/obj/item/reagent_containers/food/snacks/slice(obj/item/W, mob/user)
	if((slices_num <= 0 || !slices_num) || !slice_path) //is the food sliceable?
		return FALSE

	if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/structure/table/optable) in src.loc) && \
			!(locate(/obj/item/storage/bag/tray) in src.loc) \
		)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE

	if(slice_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/slicing.ogg', 60, TRUE, -1) // added some choppy sound
	if(chopping_sound)
		playsound(get_turf(user), 'modular/Neu_Food/sound/chopping_block.ogg', 60, TRUE, -1) // added some choppy sound
	if(slice_batch)
		var/cd = get_cooktime_divisor(user.get_skill_level(/datum/skill/craft/cooking))
		if(!do_after(user, 1 SECONDS / cd, target = src))
			return FALSE
		var/reagents_per_slice = reagents.total_volume/slices_num
		if (istype(src,/obj/item/reagent_containers/food/snacks/grown/onion/rogue))
			if (ishuman(user))
				var/mob/living/carbon/H = user
				var/obj/item/organ/eyes/E = H.getorganslot(ORGAN_SLOT_EYES) //FIXME: getorganslot() and getorgan() don't actually differentiate organ types! This means that transplanted eyes, regardless of type, will still cry, but I need to mess with all of the organ checking code to unfuck this!
				if (E && !(H.eyesclosed || HAS_TRAIT(H,TRAIT_NOPAIN) || H.is_eyes_covered() || HAS_TRAIT(H,TRAIT_BLIND) || H.get_skill_level(/datum/skill/craft/cooking) > SKILL_LEVEL_JOURNEYMAN)) //The painless will not be irritated by onions. Golems, skellies, meth-heads, etc. Expert+ chefs will also be unaffected.
					to_chat(user,span_warning("The onion's juices sting my eyes!"))
					user.blur_eyes(4)
					if (prob(50))
						user.emote("cry",forced=TRUE)
		for(var/i in 1 to slices_num)
			var/obj/item/reagent_containers/food/snacks/slice = new slice_path(loc)
			if(erp_sensitive_origin)
				slice.erp_sensitive_origin = TRUE
			initialize_slice(slice, reagents_per_slice)
		qdel(src)
	else
		var/reagents_per_slice = reagents.total_volume/slices_num
		var/obj/item/reagent_containers/food/snacks/slice = new slice_path(loc)
		if(erp_sensitive_origin)
			slice.erp_sensitive_origin = TRUE
		initialize_slice(slice, reagents_per_slice)
		slices_num--
		if(slices_num == 1)
			slice = new slice_path(loc)
			if(erp_sensitive_origin)
				slice.erp_sensitive_origin = TRUE
			initialize_slice(slice, reagents_per_slice)
			qdel(src)
			return TRUE
		if(slices_num <= 0)
			qdel(src)
			return TRUE
		update_icon()
	return TRUE

#undef REAGENT_FLAG_ERP_SENSITIVE
