/datum/outfit/job/roguetown/monk/basic/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(istype(H.patron, /datum/patron/divine/noc))
		var/clothestype = list("Classic", "Zybantian")
		var/clothestypechoice = input(H,"Choose your covering", "TAKE UP FASHION") as anything in clothestype
		switch(clothestypechoice)
			if("Classic")
				head = /obj/item/clothing/head/roguetown/roguehood/nochood
				neck = /obj/item/clothing/neck/roguetown/psicross/noc
				wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
				shoes = /obj/item/clothing/shoes/roguetown/sandals
				armor = /obj/item/clothing/suit/roguetown/shirt/robe/noc
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black

			if("Zybantian")
				head = /obj/item/clothing/head/roguetown/roguehood/stargazer
				neck = /obj/item/clothing/neck/roguetown/psicross/noc
				wrists = /obj/item/clothing/wrists/roguetown/nocwrappings
				shoes = /obj/item/clothing/shoes/roguetown/sandals
				armor = /obj/item/clothing/suit/roguetown/shirt/robe/noc/stargazer
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
				mask = /obj/item/clothing/mask/rogue/owlmask
				pants = /obj/item/clothing/under/roguetown/tights/black
				belt = /obj/item/storage/belt/rogue/leather/cloth/lady
				H.cmode_music = 'sound/music/combat_desertrider.ogg'
