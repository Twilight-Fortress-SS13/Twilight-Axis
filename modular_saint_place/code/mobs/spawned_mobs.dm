// modular_saint_place/code/modules/mob/living/simple_animal/hostile/retaliate/rogue/werewolf_spawned.dm

/mob/living/simple_animal/hostile/retaliate/rogue/werewolf_npc/spawned
	name = "WEREWOLF"
	desc = "THE HOWL OF A MAD GOD SHAKES YOUR BONES! FLESH SHORN INTO VISCERA SPRAYS THE WALLS! RIP AND TEAR!"

/mob/living/simple_animal/hostile/retaliate/rogue/werewolf_npc/spawned/death(gibbed)
	. = ..()
	gib(FALSE, FALSE, TRUE)
