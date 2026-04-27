/obj/item/reagent_containers/powder/alchemical
	name = "alchemical powder"
	desc = "A finely ground substance, heavily infused with alchemical essences. Its purpose depends entirely on its composition."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "flour"
	volume = 15
	possible_transfer_amounts = list()
	spillable = FALSE

/obj/item/reagent_containers/powder/alchemical/Initialize()
	. = ..()
	pixel_x = rand(-8, 8)
	pixel_y = rand(-8, 8)

/obj/item/reagent_containers/powder/alchemical/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !target.reagents)
		return
	
	if(istype(target, /obj/item/reagent_containers/food) || istype(target, /obj/item/reagent_containers/glass))

		if(target.reagents.total_volume + 0.1 > target.reagents.maximum_volume)
			target.reagents.remove_any(5)

		var/list/poison_data = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.volume > 0)
				poison_data[R.type] = R.volume

		if(!poison_data.len)
			to_chat(user, span_warning("Этот порошок пуст и бесполезен."))
			return

		target.reagents.add_reagent(/datum/reagent/advanced/hidden_dust, 0.1, poison_data)
		
		var/datum/reagent/check = target.reagents.get_reagent(/datum/reagent/advanced/hidden_dust)
		
		if(check)
			to_chat(user, span_notice("Я аккуратно подмешиваю порошок в [target]..."))
			qdel(src) 
		else
			to_chat(user, span_warning("[target] слишком полон, порошок не растворился!"))
			
		return

/obj/item/reagent_containers/powder/alchemical/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	var/mob/living/thrower = thrownthing?.thrower
	if(isliving(hit_atom))
		var/mob/living/C = hit_atom
		if(thrower)
			thrower.visible_message(span_warning("[thrower] швыряет [src.name] в [C]! Пыль безвредно осыпается на землю."), \
									span_notice("Я бросаю [src.name] в [C]. Пыль просто осыпается."))
		else
			C.visible_message(span_warning("[src.name] ударяется об [C] и рассыпается в прах."))

		if(prob(30))
			C.emote("cough")

	else
		if(thrower)
			thrower.visible_message(span_warning("[src.name] ударяется об [hit_atom] и рассеивается в воздухе."))
	qdel(src)

/datum/reagent/advanced/hidden_dust
	name = "осадок"
	color = "#FFFFFF"
	alpha = 255
	metabolization_rate = 0
	var/list/payload_reagents = list()

/datum/reagent/advanced/hidden_dust/on_new(list/data)
	if(islist(data))
		payload_reagents = data.Copy()

/datum/reagent/advanced/hidden_dust/on_merge(list/data)
	if(islist(data))
		for(var/reag_type in data)
			payload_reagents[reag_type] += data[reag_type]

/datum/reagent/advanced/hidden_dust/on_mob_add(mob/living/carbon/M)
	if(!istype(M) || !payload_reagents || !length(payload_reagents))
		return ..()

	for(var/reag_type in payload_reagents)
		var/vol = payload_reagents[reag_type]
		M.reagents.add_reagent(reag_type, vol)

	spawn(1)
		if(holder)
			holder.del_reagent(type)
	
	return ..()
