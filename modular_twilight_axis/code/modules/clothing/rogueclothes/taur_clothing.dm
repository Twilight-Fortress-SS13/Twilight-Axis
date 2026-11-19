// Full 64x32 worn replacements for supported clothing and taur bodies.
// Subtypes without a matching state keep their ordinary sprites and clipping.

// Armor: half/full plate and their supported variants.
/obj/item/clothing/suit/roguetown/armor/plate
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi'

/obj/item/clothing/suit/roguetown/armor/plate/full
	taur_sprite_types = list("feline", "arachne", "spider")
	taur_mob_overlay_icon = list(
		"feline" = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi',
		"arachne" = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi',
		"spider" = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi',
	)

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	taur_sprite_types = list("feline")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'

/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	taur_sprite_types = list("feline", "arachne", "spider")
	taur_mob_overlay_icon = list(
		"feline" = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi',
		"arachne" = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi',
		"spider" = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi',
	)

// The supplied gambesonpold artwork is used when the traditional style is selected.
/obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	taur_sprite_types = list("feline", "arachne", "spider")
	taur_mob_overlay_icon = list(
		"feline" = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi',
		"arachne" = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi',
		"spider" = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi',
	)

/obj/item/clothing/suit/roguetown/armor/basiceast
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi'

/obj/item/clothing/suit/roguetown/armor/brigandine/light
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi'

/obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi'

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/triumph
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_armor.dmi'

// Cloaks and tabards. The supplied stabard_quad artwork is the quadrant overlay
// for the supplied surcoat shape, so it uses surcoat_taur_[m/f]_[arachne/spider]_quad.
/obj/item/clothing/cloak/tabard
	taur_sprite_types = list("feline")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'

/obj/item/clothing/cloak/templar
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_cloaks.dmi'

/obj/item/clothing/cloak/tabard/abyssorite
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_cloaks.dmi'

/obj/item/clothing/cloak/tabard/stabard/surcoat
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_cloaks.dmi'

// Legwear uses the same supplied artwork for both clothing cuts.
/obj/item/clothing/under/roguetown/splintlegs
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_pants.dmi'

/obj/item/clothing/under/roguetown/chainlegs/iron
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_pants.dmi'

/obj/item/clothing/under/roguetown/heavy_leather_pants
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_pants.dmi'

/obj/item/clothing/under/roguetown/trou/leather
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_pants.dmi'

/obj/item/clothing/under/roguetown/platelegs
	taur_sprite_types = list("arachne", "spider")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/arachne_pants.dmi'

// Normal footwear fits a taur only when its exact replacement state exists.
/obj/item/clothing/shoes/roguetown/footwraps
	taur_sprite_types = list("feline")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'

/obj/item/clothing/shoes/roguetown/boots/armor
	taur_sprite_types = list("feline")
	taur_mob_overlay_icon = 'modular_twilight_axis/icons/clothing/onmob/feline_taur_armor.dmi'
