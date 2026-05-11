/datum/virtue/utility/mastercraftsman
	name = "Master Craftsman"
	desc = "Years of practice have made me a true master of my craft. I can create and repair items with greater skill, and know how to salvage materials from anything."
	custom_text = "+3 to Crafting, Up to Legendary, Minimum Journeman. Stash low-quality repair kits, two pouches with iron and steel bars for stake-break to scrap"
	added_stashed_items = list("scrap pack (iron)" = /obj/item/storage/belt/rogue/pouch/i_scrap,
								"scrap pack (steel)" = /obj/item/storage/belt/rogue/pouch/s_scrap,
								"stake" = /obj/item/grown/log/tree/stake,
								"cloth repair kit" = /obj/item/repair_kit/bad,
								"metal repair kit" = /obj/item/repair_kit/metal/bad
	)
	added_skills = list(list(/datum/skill/craft/crafting, 3, 6))

/datum/virtue/utility/mastercraftsman/proc/reset_skills()
	added_skills = list(list(/datum/skill/craft/crafting, 3, 6))

/datum/virtue/utility/mastercraftsman/on_load()
	added_skills.Cut()
	reset_skills()

/datum/virtue/utility/mastercraftsman/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	reset_skills()
