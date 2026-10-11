/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe
	name = "\"Equipoise\""
	desc = "Often wielded by the Necran Immortals, this silver scythe is claimed to be capable of bypassing all protection, striking directly at the enemy's soul."
	icon = 'modular_twilight_axis/icons/roguetown/weapons/polearms64.dmi'
	icon_state = "necrascythe"
	possible_item_intents = list(/datum/intent/spear/cut/oneh, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/spear/cut/bardiche, /datum/intent/rend/reach, /datum/intent/axe/chop/scythe, SPEAR_BASH)
	force_wielded = 35
	max_integrity = 300
	wdefense = 4
	is_silver = TRUE

/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
	)

/obj/item/rogueweapon/halberd/bardiche/twilight_necrascythe/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
	)

/obj/item/rogueweapon/spear/boar/kazengun
	name = "jūmonji yari"
	icon = 'modular_twilight_axis/icons/roguetown/weapons/polearms64.dmi'
	icon_state = "jumonjiyari"
	desc = "A spear with a long, straight head and a pair of curved blades pointing upward. A Kazengunese design, the side-blades parallel an Aavnic partizan. Its function is certainly similar, tearing the flesh of any unfortunate enough to be pierced by it."
	gripped_intents = list(/datum/intent/spear/thrust, /datum/intent/spear/cut/naginata, /datum/intent/rend/reach/partizan)
	wdefense = 7
