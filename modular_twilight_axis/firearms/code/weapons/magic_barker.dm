#define BARKER_TOPER_CAST_TIME_REDUCTION 0.05
#define BARKER_EMERALD_CAST_TIME_REDUCTION 0.10
#define BARKER_SAPPHIRE_CAST_TIME_REDUCTION 0.15
#define BARKER_RUBY_CAST_TIME_REDUCTION 0.25

//magic boys

/obj/item/gun/ballistic/twilight_firearm/barker/barker_staff
	var/cast_time_reduction = null
	light_system = MOVABLE_LIGHT
	light_outer_range = 2
	light_power = 1
	light_color = "#f5a885"
	possible_item_intents = list(/datum/intent/mace/strike/wood, /datum/intent/special/magicarc)

/obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 6,"nx" = 7,"ny" = 6,"wx" = -2,"wy" = 3,"ex" = 1,"ey" = 3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -43,"sturn" = 43,"wturn" = 30,"eturn" = -30, "nflip" = 0, "sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -5,"ny" = -1,"wx" = -8,"wy" = 2,"ex" = 8,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 1,"nturn" = -45,"sturn" = 45,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = -15,"eturn" = -70,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 6,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/examine(mob/user)
	.=..()
	if(cast_time_reduction)
		. += span_notice("This weapon has been augmented with a gem, reducing a mage's spell casting time by [cast_time_reduction * 100]% when they hold it in their hand.")
	else
		return

/obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/toper
	name = "toper focused barker"
	desc = "An amber focus-gem hewn by pressure immense sits nestled in metal of this weapon."
	icon = 'modular_twilight_axis/firearms/icons/magic/barker_toper.dmi'
	icon_state = "barker_toper"
	item_state = "barker_toper"
	cast_time_reduction = BARKER_TOPER_CAST_TIME_REDUCTION

/obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/gemerald
	name = "gemerald focused barker"
	desc = "An amber focus-gem hewn by pressure immense sits nestled in metal of this weapon."
	icon = 'modular_twilight_axis/firearms/icons/magic/barker_gemerald.dmi'
	icon_state = "barker_gemerald"
	item_state = "barker_gemerald"
	cast_time_reduction = BARKER_EMERALD_CAST_TIME_REDUCTION

/obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/sapphire
	name = "sapphire focused barker"
	desc = "An amber focus-gem hewn by pressure immense sits nestled in metal of this weapon."
	icon = 'modular_twilight_axis/firearms/icons/magic/barker_sapphire.dmi'
	icon_state = "barker_sapphire"
	item_state = "barker_sapphire"
	cast_time_reduction = BARKER_SAPPHIRE_CAST_TIME_REDUCTION

/obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/rontz
	name = "rontz focused barker"
	desc = "An amber focus-gem hewn by pressure immense sits nestled in metal of this weapon."
	icon = 'modular_twilight_axis/firearms/icons/magic/barker_rontz.dmi'
	icon_state = "barker_rontz"
	item_state = "barker_rontz"
	cast_time_reduction = BARKER_RUBY_CAST_TIME_REDUCTION

/obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/amethyst
	name = "amythortz focused barker"
	desc = "An amber focus-gem hewn by pressure immense sits nestled in metal of this weapon."
	icon = 'modular_twilight_axis/firearms/icons/magic/barker_amethyst.dmi'
	icon_state = "barker_amethyst"
	item_state = "barker_amethyst"
	cast_time_reduction = BARKER_TOPER_CAST_TIME_REDUCTION

/datum/crafting_recipe/roguetown/survival/gemsbarker/rontz
	name = "rontz focused barker"
	result = /obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/rontz
	reqs = list(/obj/item/gun/ballistic/twilight_firearm/barker = 1,
				/obj/item/magic/manacrystal = 1,
				/obj/item/candle/yellow = 3,
				/obj/item/roguegem/ruby = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/gemsbarker/gemerald
	name = "gemerald focused barker"
	result = /obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/gemerald
	reqs = list(/obj/item/gun/ballistic/twilight_firearm/barker = 1,
				/obj/item/magic/manacrystal = 1,
				/obj/item/candle/yellow = 3,
				/obj/item/roguegem/green = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/gemsbarker/sapphire
	name = "sapphire focused barker"
	result = /obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/sapphire
	reqs = list(/obj/item/gun/ballistic/twilight_firearm/barker = 1,
				/obj/item/magic/manacrystal = 1,
				/obj/item/candle/yellow = 3,
				/obj/item/roguegem/violet = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/gemsbarker/toper
	name = "toper focused barker"
	result = /obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/toper
	reqs = list(/obj/item/gun/ballistic/twilight_firearm/barker = 1,
				/obj/item/magic/manacrystal = 1,
				/obj/item/candle/yellow = 3,
				/obj/item/roguegem/yellow = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/gemsbarker/amethyst
	name = "amythortz focused barker"
	result = /obj/item/gun/ballistic/twilight_firearm/barker/barker_staff/toper
	reqs = list(/obj/item/gun/ballistic/twilight_firearm/barker = 1,
				/obj/item/magic/manacrystal = 1,
				/obj/item/candle/yellow = 3,
				/obj/item/roguegem/amethyst = 1)
	craftdiff = 0

#undef BARKER_TOPER_CAST_TIME_REDUCTION
#undef BARKER_EMERALD_CAST_TIME_REDUCTION
#undef BARKER_SAPPHIRE_CAST_TIME_REDUCTION
#undef BARKER_RUBY_CAST_TIME_REDUCTION

// T1 and T2 dendor barkers

/obj/item/gun/ballistic/twilight_firearm/barker/barker_light/dendor1
	name = "hermit's barker"
	desc = "Один из первых образцов огнестрельного оружия, созданный отавийскими мастерами в начале позапрошлого века. Этот оброс костями и кожей словно друидский посох, что дало ему чуть больше прочности"
	icon = 'modular_twilight_axis/firearms/icons/magic/dendor1.dmi'
	icon_state = "dendor1"
	item_state = "dendor1"
	wdefense = 4
	max_integrity = 200

/obj/item/gun/ballistic/twilight_firearm/barker/barker_light/dendor2
	name = "guiding light"
	desc = "Потрёпанное оружие, что явно повидало достаточно за свою жизнь, после всего став вместилищем частички безумного бога, чьё сияние теперь направляет владельца."
	icon = 'modular_twilight_axis/firearms/icons/magic/dendor2.dmi'
	icon_state = "dendor2"
	item_state = "dendor2"
	light_color = "#57c179"
	light_outer_range = 5
	wdefense = 6
	max_integrity = 230

/obj/item/gun/ballistic/twilight_firearm/barker/barker_light/dendor2/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	ADD_TRAIT(user, TRAIT_WOODSMAN, TRAIT_GENERIC)
	user.apply_status_effect(/datum/status_effect/buff/wardenbuff)

/obj/item/gun/ballistic/twilight_firearm/barker/barker_light/dendor2/dropped(mob/living/carbon/human/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_WOODSMAN, TRAIT_GENERIC)
	user.remove_status_effect(/datum/status_effect/buff/wardenbuff)

/datum/crafting_recipe/roguetown/survival/dendor_barker/dendor1
	name = "boned barker"
	result = /obj/item/gun/ballistic/twilight_firearm/barker/barker_light/dendor1
	reqs = list(/obj/item/gun/ballistic/twilight_firearm/barker/barker_light = 1,
				/obj/item/alch/bone = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/hide/cured = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/dendor_barker/dendor2
	name = "empowered barker(guiding light)"
	result = /obj/item/gun/ballistic/twilight_firearm/barker/barker_light/dendor2
	reqs = list(/obj/item/gun/ballistic/twilight_firearm/barker/barker_light/dendor1 = 1,
				/obj/item/natural/cured/essence = 2,
				/obj/item/grown/log/tree/stick = 2)
	craftdiff = 0

// artificer's upgrades

/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker1
	name = "ignited barker"
	desc = "Один из первых образцов огнестрельного оружия, созданный отавийскими мастерами в начале позапрошлого века. Данный образец оснащён поворотной ручкой с тлеющим углём, что за вас подожжёт фитиль."
	icon = 'modular_twilight_axis/firearms/icons/magic/barti.dmi'
	icon_state = "barti"
	item_state = "barti"
	match_delay = 1

/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker2
	name = "hunter's barker"
	desc = "Извращённый вариант одного из первых образцов огнестрельного оружия, предназначенный для охотников, что прыгают по высоким склонам."
	icon = 'modular_twilight_axis/firearms/icons/magic/barti1.dmi'
	icon_state = "barti2"
	item_state = "barti2"
	slot_flags = NONE
	match_delay = 1
	gripped_intents = list(/datum/intent/shoot/twilight_firearm/flintgonne, /datum/intent/arc/twilight_firearm/flintgonne, /datum/intent/mace/smash, INTENT_GENERIC)

/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker2/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	ADD_TRAIT(user, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)

/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker2/dropped(mob/living/carbon/human/user, slot)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)

/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker3
	name = "shepherd's barker"
	desc = "Старая палка, что может плеваться огнём в дичь и служить хорошим шестом дабы спускаться и подыматься на целые горы."
	icon = 'modular_twilight_axis/firearms/icons/magic/barti2.dmi'
	icon_state = "barti3"
	item_state = "barti3"
	slot_flags = NONE
	match_delay = 1
	force = 15
	force_wielded = 20
	gripped_intents = list(/datum/intent/shoot/twilight_firearm/flintgonne, /datum/intent/arc/twilight_firearm/flintgonne, /datum/intent/sword/thrust/zwei)

/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker3/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	ADD_TRAIT(user, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(user, TRAIT_ZJUMP, TRAIT_GENERIC)

/obj/item/gun/ballistic/twilight_firearm/barker/arti_barker3/dropped(mob/living/carbon/human/user, slot)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	REMOVE_TRAIT(user, TRAIT_ZJUMP, TRAIT_GENERIC)

/obj/item/sharpener/ignited
	name = "ignited stone"
	desc = "simple whetstone with sparks from fire essentia"
	icon = 'modular_twilight_axis/firearms/icons/magic/bstuff.dmi'
	icon_state = "istone"  //16 century iphone

/datum/crafting_recipe/roguetown/alchemy/ignited
	name = "ignited stone"
	result = list(/obj/item/sharpener/ignited)
	reqs = list(/obj/item/natural/whetstone = 1, /obj/item/alch/firedust = 1)
	craftdiff = 2
