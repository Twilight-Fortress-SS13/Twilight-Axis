/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic
	name = "\"Penance\""
	desc = "Forged in the workshops of Otava from silver-blessed steel, these brutal knuckles were carried by an inquisitor \
	who made a practice of delivering judgement without drawing a blade. The three crowned studs bear the mark of Psydon, \
	and each blow is said to serve as a reminder that faith need not wield a sword to break the bones of the wicked."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/unarmed32.dmi'
	unarmed_bonus = 10

/obj/item/clothing/gloves/roguetown/knuckles/psydon/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
	)
