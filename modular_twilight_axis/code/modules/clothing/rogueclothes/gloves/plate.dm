/obj/item/clothing/gloves/roguetown/plate/legion
	name = "elyrian manica"
	desc = "Segmented steel guards crafted to shield the arms. Once considered the armor of pit-fighters and gladiators, its status shifted drastically during the Twilight War, when soldiers desperately needed defense against the devastating zweihander strikes of the Grenzelhoft barbarians."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/gloves.dmi'
	icon_state = "legiongloves"

/obj/item/clothing/gloves/roguetown/plate/zizo/bloodraider
	name = "raider's gauntlets"
	desc = "Clawed plate gauntlets, capable of tormenting N'wah with their tips."
	icon = 'modular_twilight_axis/icons/clothing/bloodraider.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/bloodraider.dmi'
	icon_state = "bloodgauntlets"
	item_state = "bloodgauntlets"
	armor_class = ARMOR_CLASS_LIGHT
	unenchantable = FALSE

/obj/item/clothing/gloves/roguetown/knuckles/silver/psy/relic
	name = "\"Penance\""
	desc = "Forged in the workshops of Otava from silver-blessed steel, these brutal knuckles were carried by an inquisitor \
	who made a practice of delivering judgement without drawing a blade. The three crowned studs bear the mark of Psydon, \
	and each blow is said to serve as a reminder that faith need not wield a sword to break the bones of the wicked."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
	icon_state = "psyknuckle"
	unarmed_bonus = 10

/obj/item/clothing/gloves/roguetown/knuckles/silver/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
	)
