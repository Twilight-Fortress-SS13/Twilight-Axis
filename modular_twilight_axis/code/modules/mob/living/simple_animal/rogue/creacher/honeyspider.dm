/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock
	icon = 'modular_twilight_axis/icons/roguetown/mob/monster/spider.dmi'
	icon_state = "spiderrock"
	icon_living = "spiderrock"
	icon_dead = "spiderrock-dead"
	name = "rockspider"
	desc = "These beasts, native to rockhill, are similar in behaviour and tenacity to the beespider, differing in their recessed heads and hairy brown bodies."

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 1,
							/obj/item/natural/silk = 2, 
							/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1,
							/obj/item/alch/viscera = 1)
	perfect_butcher_results = list (/obj/item/reagent_containers/food/snacks/rogue/meat/spider = 2,
							/obj/item/natural/silk = 3, 
							/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1, 
							/obj/item/alch/viscera = 1)
