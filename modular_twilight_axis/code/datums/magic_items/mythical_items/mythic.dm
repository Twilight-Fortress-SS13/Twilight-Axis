#define CHAOS_COOLDOWN 20 SECONDS

/datum/magic_item/mythic/chaos_storm/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	.=..()
	if(!proximity_flag)
		return
	if(world.time < (src.last_used + CHAOS_COOLDOWN))
		return
	if(isliving(target))
		var/mob/living/L = target
		switch(rand(1,7))
			if(1)
				L.apply_damage(15, BURN)
				L.adjust_fire_stacks(3)
				L.ignite_mob()
				to_chat(L, span_warning("Chaotic flames engulf you!"))
			if(2)
				L.apply_damage(10, BRUTE)
				L.Knockdown(10)
				to_chat(L, span_warning("Chaotic force slams into you!"))
			if(3)
				L.electrocute_act(1, source, 1, SHOCK_NOSTUN)
				to_chat(L, span_warning("Chaotic lightning courses through you!"))
			if(4)
				L.OffBalance(2.5 SECONDS)
				to_chat(L, span_warning("Chaotic energy disrupts your coordination!"))
			if(5)
				L.confused += 2 SECONDS
				to_chat(L, span_warning("Chaotic energy scrambles your thoughts!"))
			if(6, 7)
				to_chat(user, span_warning("Chaotic energy unstable, no effect!"))
		src.last_used = world.time

#undef CHAOS_COOLDOWN
