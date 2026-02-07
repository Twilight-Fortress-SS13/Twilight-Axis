
/datum/outfit/job/roguetown/mercenary/rumaclan/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/shucoin/poor,
		)

/datum/advclass/mercenary/rumaclan/sasu
	tutorial = "A band of foreign outcast Kazengunites, the Ruma Clan were exiled from the Shogunate on charges of conspiring with the rebels some hundered years ago. It is no organized group of soldiers, but rather a loose collection of experienced fighters."

/datum/outfit/job/roguetown/mercenary/rumaclan_sasu/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/storage/belt/rogue/pouch/shucoin/poor,
		/obj/item/rogueweapon/huntingknife/idagger,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)

/datum/advclass/mercenary/seonjang //shitcode approved by free
	tutorial = "The respected leader and singular representative of the Ruma clan, you're an experienced swordsman. It matters not where the coin comes from, so long as you can make enough to support the clan in its survival from the exile."

/datum/outfit/job/roguetown/mercenary/seonjang/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/shucoin/rich,
		)

/datum/outfit/job/roguetown/adventurer/foreigner/pre_equip(mob/living/carbon/human/H)
	. = ..()
	neck = /obj/item/storage/belt/rogue/pouch/shucoin/poor

/datum/outfit/job/roguetown/adventurer/yoruku/pre_equip(mob/living/carbon/human/H)
	. = ..()
	neck = /obj/item/storage/belt/rogue/pouch/shucoin/poor

/datum/outfit/job/roguetown/mercenary/hangyaku/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/shucoin/poor,
		/obj/item/rogueweapon/scabbard/sheath/kazengun
		)

/datum/outfit/job/roguetown/mercenary/chonin/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/shucoin/poor,
		)
