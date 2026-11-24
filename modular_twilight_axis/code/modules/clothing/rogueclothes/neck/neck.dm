/obj/item/clothing/neck/roguetown/collar/bell_collar
	icon = 'modular_twilight_axis/icons/obj/leashes_collars.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/mob/collars_leashes.dmi'

/obj/item/clothing/neck/roguetown/gorget/cursed_collar
	leashable = TRUE

// Crafting recipes for collars and leashes

/datum/crafting_recipe/roguetown/leather/neck/catbell_collar
	name = "catbell collar"
	result = /obj/item/clothing/neck/roguetown/collar/bell/catbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE

/datum/crafting_recipe/roguetown/leather/neck/cowbell_collar
	name = "cowbell collar"
	result = /obj/item/clothing/neck/roguetown/collar/bell/cowbell
	reqs = list(/obj/item/natural/hide/cured = 1, /obj/item/catbell/cow = 1)
	tools = list(/obj/item/needle)
	time = 10 SECONDS
	category = "Leatherwork"
	subcategory = CAT_NONE
	always_availible = TRUE


/datum/crafting_recipe/roguetown/leather/neck/leather_leash
	name = "leather leash"
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
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(istype(H.patron, /datum/patron/inhumen/matthios))
			desc = "A recognizible charm of Matthios' own - a coin shattered, a symbol the pure rejection of wealth by those who would be oppressed with it. The amulet contains no power of its own, yet as you hold it in the palm of your hand, you can feel the promise of freedom empowering you. A tiny inscription upon the amulet's edge reads: «All tyrants will die alone.»"
		else
			desc = "A simple luck charm - a zenny, pierced by a blade and hanging on a thin iron chain. A tiny inscription upon the amulet's edge reads: «All tyrants will die alone.»"
	. = ..()

/obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/moneta/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ODD, "Strange luck charm")

/obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/spider
	name = "carved talisman" //rising spider
	desc = "'Sacrifice, purification through pain, healing through suffering, duty and fate woven together. If you reach out for every perishing soul, the web will tear, and everyone will drown.'  </br>  </br>The Rising Spider stands apart from the other Beasts of Gronn. Her Priestesses preach that the world is sick, and the sickness cannot be burned away without pain. She demands that suffering be accepted as the price of salvation: part of the tree must rot so that the trunk may survive. Due to alarming similarities between these teachings and the outsider Cult of Salvation, most Gronnic harbors and settlements barely tolerate the followers of the Spider: they are allowed to set up small shrines outside the walls, but are rarely accepted into a clan."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/neck.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/neck.dmi'
	icon_state = "gronnspider"
	item_state = "gronnspider"

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/bloodraider
	name = "raider's chain mantle"
	desc = "A thicker and more durable piece of neck protection that also covers the mouth when pulled up."
	icon_state = "bloodchainmantle"
	item_state = "bloodchainmantle"
	icon = 'modular_twilight_axis/icons/clothing/bloodraider.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/bloodraider.dmi'

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/bloodraider/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

/obj/item/clothing/neck/roguetown/chaincoif/chainmantle/bloodraider/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_ZIZO_ARMOR)

/obj/item/clothing/neck/roguetown/psicross/silver/dendor
	name = "silver amulet of Dendor"
	desc = "The wilds know no undeath. What lies down must feed the roots."
	icon_state = "dendor"
	item_state = "dendor"

/obj/item/clothing/neck/roguetown/psicross/silver/abyssor
	name = "silver amulet of Abyssor"
	desc = "Even the deep gives back its drowned. It does not let them walk."
	icon_state = "abyssor"
	item_state = "abyssor"

/obj/item/clothing/neck/roguetown/psicross/silver/ravox
	name = "silver amulet of Ravox"
	desc = "The blood of the innocent calls for a verdict, and the verdict is silver."
	icon_state = "ravox"
	item_state = "ravox"

/obj/item/clothing/neck/roguetown/psicross/silver/xylix
	name = "silver amulet of Xylix"
	desc = "The joke is old, the punchline is silver."
	icon_state = "xylix"
	item_state = "xylix"

/obj/item/clothing/neck/roguetown/psicross/silver/pestra
	name = "silver amulet of Pestra"
	desc = "Vampirism is a disease. Every disease has its cure."
	icon_state = "pestra"
	item_state = "pestra"

/obj/item/clothing/neck/roguetown/psicross/silver/malum
	name = "silver amulet of Malum"
	desc = "Forged pure, so that what is impure might break upon it."
	icon_state = "malum"
	item_state = "malum"

/obj/item/clothing/neck/roguetown/psicross/silver/eora
	name = "silver amulet of Eora"
	desc = "A heart that does not beat cannot love. Let it rest."
	icon_state = "eora"
	item_state = "eora"

/obj/item/clothing/neck/roguetown/psicross/silver/zizo
	name = "silver inverted psycross"
	desc = "Undeath is Her gift. The thieves of it shall be taught who owns the grave."
	icon_state = "zcross_iron"
	item_state = "zcross_iron"

/obj/item/clothing/neck/roguetown/psicross/silver/zizo/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_ZIZO_ICON)

/obj/item/clothing/neck/roguetown/psicross/silver/graggar
	name = "silver amulet of Graggar"
	desc = "Strong prey makes for a worthy kill, and nothing is stronger than the dead that refuse to lie down."
	icon_state = "graggar"
	item_state = "graggar"

/obj/item/clothing/neck/roguetown/psicross/silver/graggar/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_GRAGGAR_ICON)

/obj/item/clothing/neck/roguetown/psicross/silver/matthios
	name = "silver amulet of Matthios"
	desc = "No lord owns the blood of free men, least of all an undying one."
	icon_state = "matthios"
	item_state = "matthios"

/obj/item/clothing/neck/roguetown/psicross/silver/matthios/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_MATTHIOS_ICON)

/obj/item/clothing/neck/roguetown/psicross/silver/baotha
	name = "silver amulet of Baotha"
	desc = "Cold lips know neither wine nor bliss. They only drink, and drink, and drink."
	icon_state = "baotha"
	item_state = "baotha"

/obj/item/clothing/neck/roguetown/psicross/silver/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_BAOTHA_ICON)

/datum/action/cooldown/spell/ravox
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/ravox, /obj/item/clothing/neck/roguetown/psicross/silver/ravox, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/datum/action/cooldown/spell/projectile/ravox_tug
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/ravox, /obj/item/clothing/neck/roguetown/psicross/silver/ravox, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/datum/action/cooldown/spell/malum
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/malum, /obj/item/clothing/neck/roguetown/psicross/silver/malum, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/datum/action/cooldown/spell/miracle/ignition/malum
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/malum, /obj/item/clothing/neck/roguetown/psicross/silver/malum, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/datum/action/cooldown/spell/mending/malum
	required_items = list(/obj/item/clothing/neck/roguetown/psicross/malum, /obj/item/clothing/neck/roguetown/psicross/silver/malum, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)
