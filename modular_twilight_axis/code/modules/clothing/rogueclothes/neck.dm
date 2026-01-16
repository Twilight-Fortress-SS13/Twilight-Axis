/obj/item/clothing/neck/roguetown/collar/bell_collar
	icon = 'modular_twilight_axis/icons/obj/leashes_collars.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/mob/collars_leashes.dmi'

/obj/item/clothing/neck/roguetown/gorget/cursed_collar
	leashable = TRUE

// Crafting recipes for collars and leashes

/datum/crafting_recipe/roguetown/leather/neck/catbell_collar
	name = "catbell collar (1 cured leather, catbell)"
	result = /obj/item/clothing/neck/roguetown/collar/bell/catbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/cowbell_collar
	name = "cowbell collar (1 curedleather, cowbell)"
	result = /obj/item/clothing/neck/roguetown/collar/bell/cowbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell/cow = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE


/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	name = "leather leash (1 leather)"
	result = /obj/item/leash/leather
	reqs = list(/obj/item/natural/hide/cured = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/obj/item/clothing/neck/roguetown/loveamulet
	name = "tears of love amulet"
	desc = "This amulet is made in the southern county of the Black Empire called Sudstal. Faceted with black diamonds, this piece of jewelry symbolizes the pain and sadness that lies beneath the surface of happiness and tranquility."
	icon_state = "loveamulet"
	item_state = "loveamulet"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/neck.dmi'

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/moneta
	name = "pierced coin amulet"
	desc = "A simple luck charm - a zenny, pierced by a blade and hanging on a thin iron chain. A tiny inscription upon the amulet's edge reads: «All tyrants will die alone.»"
	icon_state = "matthios"
	item_state = "matthios"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/neck.dmi'

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/moneta/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(H.patron, /datum/patron/inhumen/matthios))
			desc = "A recognizible charm of Matthios' own - a coin shattered, a symbol the pure rejection of wealth by those who would be oppressed with it. The amulet contains no power of its own, yet as you hold it in the palm of your hand, you can feel the promise of freedom empowering you. A tiny inscription upon the amulet's edge reads: «All tyrants will die alone.»"
		else
			desc = "A simple luck charm - a zenny, pierced by a blade and hanging on a thin iron chain. A tiny inscription upon the amulet's edge reads: «All tyrants will die alone.»"
