/*
 * Darkling Trickery variety adapted from Scarlet-Reach/Scarlet-Reach#1616.
 */

/datum/coven_power/fae_trickery/darkling_trickery
	desc = "Подвергнуть жертву одной из нескольких прихотливых проделок фей."

/datum/coven_power/fae_trickery/darkling_trickery/activate(mob/living/target)
	. = ..()

	switch(rand(1, 6))
		if(1)
			target.visible_message(span_warning("[target] открывает рот и мяукает!"))
			playsound(get_turf(target), 'sound/vo/mobs/cat/cat_meow4.ogg', 40, FALSE)
		if(2)
			target.visible_message(span_warning("Глаза [target] начинают беспокойно метаться!"))
			playsound(get_turf(target), 'sound/magic/mockery.ogg', 40, FALSE)
			target.confused += 10
			target.dizziness += 10
			target.jitteriness += 10
		if(3)
			target.visible_message(span_warning("Глаза [target] на мгновение широко раскрываются."))
			playsound(get_turf(target), 'sound/magic/mockery.ogg', 40, FALSE)
			target.psydo_nyte()
			target.Immobilize(3 SECONDS)
		if(4)
			target.visible_message(
				span_warning("Глаза [target] захлопываются!"),
				span_boldwarning("Темно!"),
			)
			playsound(get_turf(target), 'sound/magic/mockery.ogg', 40, FALSE)
			target.eyesclosed = TRUE
			target.become_blind("eyelids")
		if(5)
			target.visible_message(
				span_warning("[target] неуклюже падает!"),
				span_boldwarning("Кто-то дёргает меня за ногу!"),
			)
			playsound(get_turf(target), 'sound/magic/mockery.ogg', 40, FALSE)
			target.Knockdown(1 SECONDS)
		if(6)
			target.visible_message(
				span_warning("[target] роняет оружие!"),
				span_boldwarning("Кто-то хватает меня за руку!"),
			)
			playsound(get_turf(target), 'sound/magic/mockery.ogg', 40, FALSE)
			var/turnangle = prob(50) ? 270 : 90
			var/turndir = turn(target.dir, turnangle)
			var/dist = rand(1, max(owner.get_vampire_generation(), 1))
			var/target_turf = get_ranged_target_turf(get_turf(target), turndir, dist)
			target.throw_item(target_turf, FALSE)
			target.apply_status_effect(/datum/status_effect/debuff/clickcd, max(owner.get_vampire_generation() - 1, 1) SECONDS)
