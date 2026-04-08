/datum/virtue/combat/combat_virtue
	name = "Trained & Ready"
	desc = "There are many facets of lyfe that can end it. I've taken to learning some of them, and kept the tools for them close."
	max_choices = 5
	choice_costs = list(0, 0, 0, 2, 4, 4)
	extra_choices = list(
		"Swords Skill (JMAN)" = /datum/skill/combat/swords,
		"Shield Skill (JMAN)" = /datum/skill/combat/shields,
		"Dagger Skill (JMAN)" = /datum/skill/combat/knives,
		"Unarmed Skill (JMAN)" = /datum/skill/combat/unarmed,
        "Wrestling Skill (JMAN)" = /datum/skill/combat/wrestling,
		"Sling Skill (JMAN)" = /datum/skill/combat/slings,
		"Axe Skill (JMAN)" = /datum/skill/combat/axes,
		"Whip Skill (JMAN)" = /datum/skill/combat/whipsflails,
		"Mace Skill (JMAN)" = /datum/skill/combat/maces,
		"Polearm Skill (JMAN)" = /datum/skill/combat/polearms,
		"Staves Skill (JMAN)" = /datum/skill/combat/staves,
        "Archery Skill (APPRE)" = /datum/skill/combat/bows,
        "Crossbows Skill (APPRE)" = /datum/skill/combat/crossbows,
		"Stashed Messer & Parrying Dagger" = list(/obj/item/rogueweapon/sword/short/messer/iron/virtue, /obj/item/rogueweapon/huntingknife/idagger/virtue),
		"Stashed Shield & Arming Sword" = list(/obj/item/rogueweapon/shield/wood, /obj/item/rogueweapon/sword/iron),
		"Stashed Quarterstaff & Sling" = list(/obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/gun/ballistic/revolver/grenadelauncher/sling, /obj/item/quiver/sling/iron),
		"Stashed Spear & Mace" = list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/mace),
		"Stashed Katar & Knuckles" = list(/obj/item/rogueweapon/katar/bronze, /obj/item/clothing/gloves/roguetown/knuckles/bronze),
		"Stashed Axe & Whip" = list(/obj/item/rogueweapon/stoneaxe/woodcut, /obj/item/rogueweapon/whip)
	)
    

/datum/virtue/combat/combat_virtue/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(triumph_check(recipient))
		for(var/choice in picked_choices)
			if(ispath(extra_choices[choice], /datum/skill/combat/bows))
				recipient.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_APPRENTICE, silent = TRUE)
			else if(ispath(extra_choices[choice], /datum/skill/combat/crossbows))
				recipient.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_APPRENTICE, silent = TRUE)
			else if(ispath(extra_choices[choice], /datum/skill))
				recipient.adjust_skillrank_up_to(extra_choices[choice], SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
			else if(islist(extra_choices[choice]))	//stashed items
				var/list/stash = extra_choices[choice]
				for(var/stuff in stash)
					var/obj/item/I = stuff
					recipient.mind?.special_items[capitalize(I::name)] = I
