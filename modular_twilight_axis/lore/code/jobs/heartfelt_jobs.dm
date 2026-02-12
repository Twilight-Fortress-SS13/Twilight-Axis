
/datum/job/roguetown/heartfelt/lord
	tutorial = "You are the Lord of Heartfelt, once a ruler of a prosperous realm under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you chose to seek refuge in the distant land of Azuria."

/datum/advclass/heartfelt/lord/lord
	tutorial = "You are the Lord of Heartfelt, once a ruler of a prosperous realm under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you chose to seek refuge in the distant land of Azuria."

/datum/outfit/job/heartfelt/lord/lord/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/kronas/veryrich = 2,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		)

/datum/advclass/heartfelt/lord/archmage
	tutorial = "You are the Archmagos of Heartfelt, once the head of a world-famous arcyne studies institution under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you chose to seek refuge in the distant land of Azuria."

/datum/outfit/job/heartfelt/lord/archmage/pre_equip(mob/living/carbon/human/H)
	. = ..()
	neck = /obj/item/storage/belt/rogue/pouch/kronas/veryrich

/datum/advclass/heartfelt/lord/chief
	name = "Chieftain of Heartfelt"
	tutorial = "You are the Chieftain of Heartfelt, once the leader of one of the Dendorite tribes under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you chose to seek refuge in the distant land of Azuria."

/datum/outfit/job/heartfelt/lord/chief/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/kronas/veryrich = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		)

/datum/job/roguetown/heartfelt/knight
	tutorial = "You are a Knight of Heartfelt, part of a brotherhood in service to your Lord. \
	Now, alone and committed to safeguarding what remains of your court, you ride to Azuria, resolved to ensure their safe arrival."

/datum/advclass/heartfelt/knight
	tutorial = "You are a Knight of Heartfelt, once part of a brotherhood in service to your Lord. \
	Now, alone and committed to safeguarding what remains of your court, you ride to Azuria, resolved to ensure their safe arrival."

/datum/outfit/job/heartfelt/knight/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/kronas/rich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
	)

/datum/advclass/heartfelt/retinue/prior
	tutorial = "The Priest of Heartfelt, you were destined for ascension within the Church. \
	Still guided by the blessings of Astrata, you journey to Azuria, determined to offer what aid and solace you can."

/datum/outfit/job/roguetown/heartfelt/prior/pre_equip(mob/living/carbon/human/H)
	. = ..()
	beltr = /obj/item/storage/belt/rogue/pouch/kronas/veryrich

/datum/advclass/heartfelt/retinue/servant	
	tutorial = "You are Servant of Heartfelt, originating from a once-prosperous realm under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you now follow your ruler to the distant land of Azuria."

/datum/outfit/job/roguetown/heartfelt/retinue/servant/pre_equip(mob/living/carbon/human/H)
	. = ..()
	neck = /obj/item/storage/belt/rogue/pouch/kronas/poor


/datum/advclass/heartfelt/retinue/armorer
	tutorial = "You are the Heartfeltian Armorer, originating from a once-prosperous realm under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you now follow your ruler to the distant land of Azuria."

/datum/outfit/job/roguetown/heartfelt/retinue/armorer/pre_equip(mob/living/carbon/human/H)
	. = ..()
	neck = /obj/item/storage/belt/rogue/pouch/kronas/rich

/datum/advclass/heartfelt/retinue/courtier
	tutorial = "You are a Courtier of Heartfelt, originating from a once-prosperous realm under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you now follow your ruler to the distant land of Azuria."

/datum/outfit/job/roguetown/heartfelt/retinue/courtier/pre_equip(mob/living/carbon/human/H)
	. = ..()
	neck = /obj/item/storage/belt/rogue/pouch/kronas/veryrich

/datum/advclass/heartfelt/retinue/jester
	tutorial = "You are the Jester of Heartfelt, originating from a once-prosperous realm under the de Lovett royal dynasty. \
	Though grief weighs heavy beneath your painted smile, you turn your steps towards Azuria—hoping your wit, charm, and cunning may yet carve out a place for joy."

/datum/outfit/job/roguetown/heartfelt/retinue/jester/pre_equip(mob/living/carbon/human/H)
	. = ..()
	beltl = /obj/item/storage/belt/rogue/pouch/kronas/rich

/datum/advclass/heartfelt/retinue/magos
	tutorial = "You are the Magos of Heartfelt, originating from a once-prosperous realm under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you now follow your ruler to the distant land of Azuria."

/datum/outfit/job/roguetown/heartfelt/retinue/magos/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/recipe_book/alchemy,
		/obj/item/roguegem/amethyst,
		/obj/item/spellbook_unfinished/pre_arcyne,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne,
		/obj/item/scrying,
		/obj/item/storage/belt/rogue/pouch/kronas/rich = 1,
		)

/datum/advclass/heartfelt/retinue/physician
	tutorial = "You are the Physician of Heartfelt, originating from a once-prosperous realm under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you now follow your ruler to the distant land of Azuria."

/datum/outfit/job/roguetown/heartfelt/retinue/physician/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/natural/worms/leech/cheele = 1, //little buddy
		/obj/item/reagent_containers/glass/bottle/waterskin = 1,
		/obj/item/storage/belt/rogue/pouch/kronas/rich = 1,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/bedroll = 1,
	)

/datum/advclass/heartfelt/retinue/houseguard
	tutorial = "You are a House Guard for the Lord of Heartfelt, a valiant defender of their once-prosperous realm. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you now follow your ruler to the distant land of Azuria."

/datum/outfit/job/roguetown/heartfelt/retinue/houseguard/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/kronas/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)

/datum/advclass/heartfelt/retinue/housearb
	tutorial = "You are a Missilite for the Lord of Heartfelt, a valiant defender of their once-prosperous realm. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you now follow your ruler to the distant land of Azuria."

/datum/outfit/job/roguetown/heartfelt/retinue/housearb/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/kronas/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)

/datum/advclass/heartfelt/retinue/squire
	tutorial = "You are a Squire for the Knights of Heartfelt, originating from a once-prosperous realm under the de Lovett royal dynasty. \
	However, with the civil war continuing to ravage your homeland without an end in sight, you now follow your ruler to the distant land of Azuria."

/datum/outfit/job/roguetown/heartfelt/retinue/squire/pre_equip(mob/living/carbon/human/H)
	. = ..()
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger = 1,  
		/obj/item/storage/belt/rogue/pouch/kronas/mid = 1,
		/obj/item/rogueweapon/hammer/iron = 1, // Failed Squire Virtue Items
		/obj/item/polishing_cream = 1,
		/obj/item/armor_brush = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	) 

