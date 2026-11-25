/datum/crafting_recipe/roguetown/alchemy/hag/boned_moss
	name = "moss boned"
	result = list(/obj/item/alch/hag_moss/enchanted/boned = 1)
	reqs = list(/obj/item/alch/hag_moss/envy = 1, /obj/item/natural/bone = 2)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/altered_moss
	name = "moss altered"
	result = list(/obj/item/alch/hag_moss/enchanted/altered = 1)
	reqs = list(/obj/item/alch/hag_moss/sorrow = 1, /obj/item/reagent_containers/food/snacks/rogue/meat = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/forest_moss
	name = "moss forest"
	result = list(/obj/item/alch/hag_moss/enchanted/forest = 1)
	reqs = list(/obj/item/alch/hag_moss/mercy = 1, /obj/item/alch/mentha = 1, /obj/item/alch/rosa = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/secret_moss
	name = "moss secret"
	result = list(/obj/item/alch/hag_moss/enchanted/secret = 1)
	reqs = list(/obj/item/alch/hag_moss/lullaby = 1, /obj/item/alch/manabloompowder = 1)
	craftdiff = 6

/datum/crafting_recipe/roguetown/alchemy/hag/rage_moss
	name = "moss rage"
	result = list(/obj/item/alch/hag_moss/enchanted/rage = 1)
	reqs = list(/obj/item/alch/hag_moss/fury = 1, /obj/item/natural/thorn = 1)

/datum/crafting_recipe/roguetown/alchemy/hag/power_moss
	name = "moss power"
	result = list(/obj/item/alch/hag_moss/enchanted/power = 1)
	reqs = list(/obj/item/alch/hag_moss/fury = 1, /obj/item/alch/hag_moss/envy = 1)

/obj/item/alch/hag_moss/enchanted/boned
	name = "Boned Moss"
	boon_path = /datum/hag_boon/buff/skeleton
	desc = "This moss is grey. Smells and feels like bones."
	color = "#596d7a"

/obj/item/alch/hag_moss/enchanted/altered
	name = "Altered Moss"
	boon_path = /datum/hag_boon/spell/rat_form
	desc = "This moss is dark-brown, and smells like... Ew-w... That's DISGUSTING!!!"
	color = "#534734"

/obj/item/alch/hag_moss/enchanted/altered/Initialize(mapload)
	. = ..()
	var/probability = rand(1, 2)
	switch(probability)
		if(1)
			boon_path = /datum/hag_boon/spell/rat_form
			name = "Rat Moss"
		if(2)
			boon_path = /datum/hag_boon/spell/troll_form
			name = "Troll Moss"

/obj/item/alch/hag_moss/enchanted/forest
	name = "Forest Moss"
	boon_path = /datum/hag_boon/spell/blesscrop
	desc = "This moss is brown, touching it feels so fruitful!"
	color = "#9e7b43"

/obj/item/alch/hag_moss/enchanted/secret
	name = "Secret Moss"
	boon_path = /datum/hag_boon/buff/arcyne_affinity
	desc = "This moss is strange, touching it makes you feel closer to arcyne, music and devotee..."
	color = "#43589e"

/obj/item/alch/hag_moss/enchanted/secret/Initialize(mapload)
	. = ..()
	var/probability = rand(1, 3)
	switch(probability)
		if(1)
			boon_path = /datum/hag_boon/buff/devotee
			name = "Devotee Moss"
		if(2)
			boon_path = /datum/hag_boon/buff/arcyne_affinity
			name = "Arcyne Moss"
		if(3)
			boon_path = /datum/hag_boon/buff/bard_initiate
			name = "Musical Moss"

/obj/item/alch/hag_moss/enchanted/rage
	name = "Rage Moss"
	boon_path = /datum/hag_boon/spell/berserker_rage
	desc = "This moss is RED, filled with RAGE and BLOOD. Touching this makes you EVIL!"
	color = "#ff0000"

/obj/item/alch/hag_moss/enchanted/power
	name = "Power Moss"
	boon_path = /datum/hag_boon/stats/str
	desc = "This moss is filled with everything!"
	color = "#0099ff"

/obj/item/alch/hag_moss/enchanted/power/Initialize(mapload)
	. = ..()
	var/probability = rand(1, 7)
	switch(probability)
		if(1)
			boon_path = /datum/hag_boon/stats/str
			name = "Strength Moss"
		if(2)
			boon_path = /datum/hag_boon/stats/int
			name = "Intellect Moss"
		if(3)
			boon_path = /datum/hag_boon/stats/per
			name = "Perception Moss"
		if(4)
			boon_path = /datum/hag_boon/stats/con
			name = "Constitution Moss"
		if(5)
			boon_path = /datum/hag_boon/stats/spd
			name = "Speed Moss"
		if(6)
			boon_path = /datum/hag_boon/stats/wil
			name = "Willpower Moss"
		if(7)
			boon_path = /datum/hag_boon/stats/lck
			name = "Lucky Moss"
