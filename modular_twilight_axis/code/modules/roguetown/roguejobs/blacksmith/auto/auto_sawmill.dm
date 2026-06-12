/obj/machinery/auto_sawmill
	name = "Sawmill"
	desc = "Простая конструкция с неизвестной внутренней частью и острым лезвием."
	icon = 'icons/roguetown/misc/auto.dmi'
	icon_state = "autosawoff"
	density = TRUE
	anchored = TRUE
	var/active = FALSE
	var/idle_ticks = 0
	var/max_idle_ticks = 5

/obj/machinery/auto_sawmill/update_icon()
	if(active)
		icon_state = "autosaw"
	else
		icon_state = "autosawoff"

/obj/machinery/auto_sawmill/attack_hand(mob/user)
	active = !active
	if(active)
		to_chat(user, span_notice("You switch the [src] on. It begins to hum and vibrate."))
		START_PROCESSING(SSmachines, src)
	else
		to_chat(user, span_notice("You switch the [src] off."))
		STOP_PROCESSING(SSmachines, src)
	update_icon()


/obj/machinery/auto_sawmill/Destroy()
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/auto_sawmill/process()
	if(!active)
		return
	
	var/obj/item/grown/log/tree/small/target_log = null
	
	for(var/obj/item/grown/log/tree/small/L in range(1, src))
		if(!isturf(L.loc))
			continue
		target_log = L
		break

	if(target_log)
		idle_ticks = 0
		target_log.forceMove(src.loc)
		playsound(src.loc, 'sound/foley/sawing.ogg', 80, TRUE)
		
		var/woodtotal = pick(1, 2, 2, 3)
		for(var/i=1, i<=woodtotal, ++i)
			new /obj/item/natural/wood/plank(src.loc)
		
		new /obj/effect/decal/cleanable/debris/woody(src.loc)
		qdel(target_log)
	else
		idle_ticks++
		if(idle_ticks >= max_idle_ticks)
			active = FALSE
			update_icon()
			visible_message(span_warning("[src] clatters to a halt as it runs out of material."))
			STOP_PROCESSING(SSmachines, src)


/obj/machinery/auto_sawmill/examine(mob/user)
	. = ..()
	. += span_info("It is currently [active ? "active" : "inactive"].")
	. += span_info("Place small logs on the tile nearly and turn it on to produce planks.")

/datum/crafting_recipe/roguetown/engineering/auto_sawmill
	name = "Лесопилка"
	category = "Machines"
	result = /obj/machinery/auto_sawmill
	reqs = list(
		/obj/item/natural/wood/plank = 4,
		/obj/item/roguegear = 1,
		/obj/item/rogueweapon/handsaw = 1,
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3
	verbage_simple = "engineer"
	verbage = "engineers"
