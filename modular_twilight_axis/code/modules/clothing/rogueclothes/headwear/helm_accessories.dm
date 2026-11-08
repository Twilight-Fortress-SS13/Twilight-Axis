/obj/item/clothing/head/roguetown/onhelm
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP|ITEM_SLOT_MASK
	flags_inv = HIDEEARS

/obj/item/clothing/head/roguetown/onhelm/tw_d_horns
	name = "horns helmkleinod"
	desc = "A pair of imposing iron horns designed to be mounted atop a helmet, giving the wearer a beastly silhouette to strike fear into the hearts of their enemies."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_horns"
	item_state = "d_horns"

/obj/item/clothing/head/roguetown/onhelm/tw_d_basic
	name = "helm's chaperon"
	desc = "A simple but elegant cloth burlet worn over a helmet. It serves both to deflect the beating sun and to display the wearer's heraldic colors with pride."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_basic"
	item_state = "d_basic"

/obj/item/clothing/head/roguetown/onhelm/tw_d_castle_red
	name = "castle helmkleinod"
	desc = "A finely crafted crest shaped like a castle turret. Fastened atop a helm, it symbolizes the wearer's steadfast resolve and unyielding defense."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_castle_red"
	item_state = "d_castle_red"
	var/picked = FALSE
	var/towavid = list("red", "white")
	var/towers_final_icon = null

/obj/item/clothing/head/roguetown/onhelm/tw_d_castle_red/attack_right(mob/user)
	..()
	if(!picked)
		var/chooseA = input(user, "What will you choose?", "Which colour?") as anything in towavid
		if(chooseA == "red")
			icon_state = "d_castle_red"
			towers_final_icon = "d_castle_red"
		if(chooseA == "white")
			icon_state = "d_castle_white"
			towers_final_icon = "d_castle_white"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your burlet?", "Burlet", "Yes", "No") != "Yes")
			icon_state = "d_castle_red"
			towers_final_icon = "d_castle_red"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/onhelm/tw_d_castle_red/equipped(mob/user, slot)
	. = ..()
	if(towers_final_icon)
		icon_state = towers_final_icon
		item_state = towers_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/onhelm/tw_d_castle_red/dropped(mob/user, slot)
	. = ..()
	if(towers_final_icon)
		icon_state = towers_final_icon
		item_state = towers_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/onhelm/tw_d_graggar
	name = "bloodied star helmkleinod"
	desc = "A jagged, multi-pointed star stained with dried blood. This macabre ornament signifies a warrior who revels in the brutal chaos of the battlefield."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_graggar"
	item_state = "d_graggar"

/obj/item/clothing/head/roguetown/onhelm/tw_d_efreet
	name = "afreet helmkleinod"
	desc = "A fearsome crest forged in the likeness of an afreet. Its menacing visage seems to dance with the fury of a roaring flame, warding off cowardly foes."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_efreet"
	item_state = "d_efreet"

/obj/item/clothing/head/roguetown/onhelm/tw_d_sun
	name = "sun helmkleinod"
	desc = "A gilded sunburst designed to crown a knight's helm. It catches the light beautifully, radiating an aura of hope and righteous glory."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_sun"
	item_state = "d_sun"

/obj/item/clothing/head/roguetown/onhelm/tw_d_peace
	name = "astrata's eye helmkleinod"
	desc = "An elegant crest depicting Astrata's eye. It serves as a pious reminder of the divine gaze, guiding the wearer towards peace and protecting them from malice."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_peace"
	item_state = "d_peace"

/obj/item/clothing/head/roguetown/onhelm/tw_d_feathers
	name = "feathers accessory"
	desc = "A cluster of vibrant plumage meant to be affixed to a helmet. Such grand feathers often denote a warrior of high status and noble bearing."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_feathers"
	item_state = "d_feathers"

/obj/item/clothing/head/roguetown/onhelm/tw_d_lion
	name = "lion helmkleinod"
	desc = "A roaring lion sculpted from metal, serving as a proud helm ornament. It embodies courage, royalty, and the fierce heart of its wearer."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_lion"
	item_state = "d_lion"

/obj/item/clothing/head/roguetown/onhelm/tw_d_dragon_red
	name = "dragon's dread"
	desc = "A terrifying helm ornament depicting a legendary wyrm. To bear the dragon's dread is to cast a long, draconic shadow over the battlefield, inspiring awe and terror."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_dragon_red"
	item_state = "d_dragon_red"
	var/picked = FALSE
	var/drvid = list("red", "green")
	var/dragon_final_icon = null

/obj/item/clothing/head/roguetown/onhelm/tw_d_dragon_red/attack_right(mob/user)
	..()
	if(!picked)
		var/chooseB = input(user, "What will you choose?", "Which colour?") as anything in drvid
		if(chooseB == "red")
			icon_state = "d_dragon_red"
			dragon_final_icon = "d_dragon_red"
		if(chooseB == "green")
			icon_state = "d_dragon_green"
			dragon_final_icon = "d_dragon_green"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		if(alert("Are you pleased with your burlet?", "Burlet", "Yes", "No") != "Yes")
			icon_state = "d_dragon_red"
			dragon_final_icon = "d_dragon_red"
			update_icon()
			if(loc == user && ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
			return
		picked = TRUE

/obj/item/clothing/head/roguetown/onhelm/tw_d_dragon_red/equipped(mob/user, slot)
	. = ..()
	if(dragon_final_icon)
		icon_state = dragon_final_icon
		item_state = dragon_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/onhelm/tw_d_dragon_red/dropped(mob/user, slot)
	. = ..()
	if(dragon_final_icon)
		icon_state = dragon_final_icon
		item_state = dragon_final_icon
		update_icon()

/obj/item/clothing/head/roguetown/onhelm/tw_d_swan
	name = "swan on lake"
	desc = "An intricate crest portraying a graceful swan resting upon gentle waters. It is a symbol of purity, elegance, and unwavering calm amidst the storm of war."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_swan"
	item_state = "d_swan"

/obj/item/clothing/head/roguetown/onhelm/tw_d_fish
	name = "gold fish helmkleinod"
	desc = "A meticulously gilded fish meant to sit atop a knight's helm. Often worn by lords of the riverlands, it represents prosperity and adaptability."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_fish"
	item_state = "d_fish"

/obj/item/clothing/head/roguetown/onhelm/tw_d_windmill
	name = "windmill helmkleinod"
	desc = "A peculiar windmill crest. Though humble in origin, it shows a proud connection to the homeland's sweeping plains and tireless industry."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_windmill"
	item_state = "d_windmill"

/obj/item/clothing/head/roguetown/onhelm/tw_d_oathtaker
	name = "oathkeeper's symbol"
	desc = "An elegant helm accessory. Fashioned from cold iron, it is a heavy burden that reminds the wearer of the unbreakable vows they have sworn."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_oathtaker"
	item_state = "d_oathtaker"

/obj/item/clothing/head/roguetown/onhelm/tw_d_skull
	name = "gold skull helmkleinod"
	desc = "A macabre yet opulent golden skull. It is a morbid memento mori, daring death to claim the wealthy and arrogant warrior who wears it."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/onhelm.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/onhelm.dmi'
	icon_state = "d_skull"
	item_state = "d_skull"

/datum/anvil_recipe/armor/tw_d_horns
	name = "horns helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_horns
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_castle_red
	name = "castle helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_castle_red
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_graggar
	name = "bloodied star helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_graggar
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_sun
	name = "sun helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_sun
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_swan
	name = "swan on lake"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/feather = 2, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_swan
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_fish
	name = "gold fish helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_fish
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_windmill
	name = "windmill helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_windmill
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_oathtaker
	name = "oathtaker symbol"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_oathtaker
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_skull
	name = "gold skull helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_skull
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_lion
	name = "lion helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_lion
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_peace
	name = "astrata's eye helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/gold = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_peace
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_dragon_red
	name = "dragon's dread"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_dragon_red
	craftdiff = 4

/datum/anvil_recipe/armor/tw_d_efreet
	name = "afreet helmkleinod"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/ingot/iron = 1, /obj/item/natural/cloth = 1)
	created_item = /obj/item/clothing/head/roguetown/onhelm/tw_d_efreet
	craftdiff = 4

/datum/crafting_recipe/roguetown/survival/tw_d_basic
	name = "helmkleinod chaperon"
	result = /obj/item/clothing/head/roguetown/onhelm/tw_d_basic
	reqs = list(/obj/item/natural/cloth = 3)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/tw_d_feathers
	name = "swan helmkleinod"
	result = /obj/item/clothing/head/roguetown/onhelm/tw_d_feathers
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/feather = 4)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 3
