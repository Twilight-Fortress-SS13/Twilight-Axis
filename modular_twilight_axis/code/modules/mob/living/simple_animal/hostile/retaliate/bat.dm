
/mob/living/simple_animal/hostile/retaliate/bat/Initialize()
	. = ..()
	verbs += list(/mob/living/simple_animal/proc/fly_up,
	/mob/living/simple_animal/proc/fly_down,
	/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/emote_caw,
	/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/change_stance)


/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/change_stance()
	set category = "Winged Form"
	set name = "Change Stance"
	sitting = !sitting
	update_icon()

/mob/living/simple_animal/hostile/retaliate/bat/crow/update_icon_state()
	icon_state = sitting ? "crow" : "crow_flying"

/mob/living/simple_animal/hostile/retaliate/bat/crow/Move()
	if(sitting)
		return FALSE
	return ..()


/mob/living/simple_animal/hostile/retaliate/bat/crow/proc/emote_caw()
	set category = "Winged Form"
	set name = "Caw"
	emote("caw", intentional = TRUE, animal = TRUE)

/mob/living/simple_animal/hostile/retaliate/bat/crow/get_sound(input)
	if(input == "caw")
		return pick('sound/vo/mobs/bird/CROW_01.ogg', 'sound/vo/mobs/bird/CROW_02.ogg', 'sound/vo/mobs/bird/CROW_03.ogg')

/mob/living/simple_animal/hostile/retaliate/bat/crow
	name = "zad"
	desc = ""
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	icon_state = "crow_flying"
	icon_living = "crow_flying"
	icon_dead = "crow1"
	icon_gib = "crow1"
	speak_emote = list("caws")
	base_intents = list(/datum/intent/unarmed/help)
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	remains_type = /obj/effect/decal/remains/crow
	fly_time = 10 // slowing down crow for witches, но слишком медленно поэтому просто в два раза медленее мышки (TA edit)
	sight = 0
	var/sitting = FALSE
