/obj/machinery/auto_stonecutter
	name = "Stone cutter"
	desc = "Автоматическая машина для резки камня, работает на пружинах и шестернях."
	icon = 'icons/roguetown/misc/auto.dmi'
	icon_state = "autochisel"
	density = TRUE
	anchored = TRUE
	var/active = FALSE
	var/idle_ticks = 0
	var/max_idle_ticks = 5
	
/obj/machinery/auto_stonecutter/update_icon()
	icon_state = active ? "autochisel" : "autochisel"

/obj/machinery/auto_stonecutter/attack_hand(mob/user)
	active = !active
	if(active)
		to_chat(user, span_notice("The [src] starts clanking as the mechanical chisels move."))
		START_PROCESSING(SSmachines, src)
	else
		to_chat(user, span_notice("The [src] falls silent."))
		STOP_PROCESSING(SSmachines, src)
	update_icon()

/obj/machinery/auto_stonecutter/Destroy()
	STOP_PROCESSING(SSmachines, src)
	return ..()

/obj/machinery/auto_stonecutter/process()
	if(!active)
		return

	var/obj/item/natural/stone/target_stone = null
	
	for(var/obj/item/natural/stone/S in range(1, src))
		if(istype(S, /obj/item/natural/stoneblock) || !isturf(S.loc))
			continue
		target_stone = S
		break

	if(target_stone)
		idle_ticks = 0
		target_stone.forceMove(src.loc)
		playsound(src.loc, pick('sound/combat/hits/onrock/onrock (1).ogg', 'sound/combat/hits/onrock/onrock (2).ogg'), 80, TRUE)
		
		new /obj/item/natural/stoneblock(src.loc)
		new /obj/effect/decal/cleanable/debris/stony(src.loc)
		qdel(target_stone)
	else
		idle_ticks++
		if(idle_ticks >= max_idle_ticks)
			active = FALSE
			update_icon()
			visible_message(span_warning("[src] stops clanking as there are no more stones to cut."))
			STOP_PROCESSING(SSmachines, src)

/obj/machinery/auto_stonecutter/examine(mob/user)
	. = ..()
	. += span_info("Status: [active ? "Running" : "Idle"].")
	. += span_info("It will process any raw stones lying nearly on its floor.")

/datum/crafting_recipe/roguetown/engineering/auto_stonecutter
	name = "Камнерезка"
	category = "Machines"
	result = /obj/machinery/auto_stonecutter
	reqs = list(
		/obj/item/natural/stoneblock = 4,
		/obj/item/roguegear = 1,
		/obj/item/rogueweapon/chisel = 1,
	)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3
	verbage_simple = "engineer"
	verbage = "engineers"
