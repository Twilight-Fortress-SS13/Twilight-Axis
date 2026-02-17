GLOBAL_LIST_EMPTY(loadout_items)
GLOBAL_LIST_EMPTY(loadout_items_by_name)
GLOBAL_LIST_EMPTY(loadout_items_by_category)

/datum/loadout_item
	var/name = "Parent loadout datum"
	var/desc
	var/atom/movable/path
	var/donoritem			//autoset on new if null
	var/donatitem = FALSE
	var/donat_tier = 0
	var/list/ckeywhitelist
	var/triumph_cost = 0
	var/category = "Разное"

/datum/loadout_item/New()
	if(isnull(donoritem))
		if(ckeywhitelist)
			donoritem = TRUE
	var/obj/targetitem = path
	desc = targetitem.desc
	if (triumph_cost)
		desc += "<b>Стоит [triumph_cost] ТРИУМФОВ.</b>"
	if(donat_tier > 0)
		desc += "<b>Доступно для меценатов уровня: [donat_tier]</b>"

/datum/loadout_item/proc/donator_ckey_check(key)
	if(ckeywhitelist && ckeywhitelist.Find(key))
		return TRUE
	return

//Miscellaneous

/datum/loadout_item/card_deck
	name = "Card Deck"
	category = "Разное"
	path = /obj/item/toy/cards/deck

/datum/loadout_item/farkle_dice
	name = "Farkle Dice Container"
	category = "Разное"
	path = /obj/item/storage/pill_bottle/dice/farkle

/datum/loadout_item/tarot_deck
	name = "Tarot Deck"
	category = "Разное"
	path = /obj/item/toy/cards/deck/tarot

/datum/loadout_item/custom_book
	name = "Custom Book"
	category = "Разное"
	path = /obj/item/book/rogue/loadoutbook

//TOOLS
/datum/loadout_item/paper_parasol
	name = "Paper Parasol"
	path = /obj/item/rogueweapon/mace/parasol

/datum/loadout_item/fine_parasol
	name = "Fine Parasol"
	path = /obj/item/rogueweapon/mace/parasol/noble

//HATS
/datum/loadout_item/shalal
	name = "Keffiyeh"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal

/datum/loadout_item/tricorn
	name = "Tricorn Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/helmet/tricorn

/datum/loadout_item/nurseveil
	name = "Nurse Veil"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/veiled

/datum/loadout_item/archercap
	name = "Archer's cap"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/archercap

/datum/loadout_item/strawhat
	name = "Straw Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/strawhat

/datum/loadout_item/eaststrawhat
	name = "Worn rice hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/eaststrawhat

/datum/loadout_item/antlers
	name = "Old antlers"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/antlers

/datum/loadout_item/tengai
	name = "tengai"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/tengai

/datum/loadout_item/burgerhood
	name = "Noble Hood"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/roguehood/burgerhood

/datum/loadout_item/gasa
	name = "gasa"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/gasa

/datum/loadout_item/torioigasa
	name = "torioigasa"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/torioigasa

/datum/loadout_item/roningasa
	name = "roningasa"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/roningasa

/datum/loadout_item/witchhat
	name = "Witch Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/witchhat

/datum/loadout_item/bardhat
	name = "Bard Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/bardhat

/datum/loadout_item/fancyhat
	name = "Fancy Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/fancyhat

/datum/loadout_item/furhat
	name = "Fur Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/hatfur

/datum/loadout_item/smokingcap
	name = "Smoking Cap"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/smokingcap

/datum/loadout_item/headband
	name = "Headband"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/headband

/datum/loadout_item/buckled_hat
	name = "Buckled Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/puritan

/datum/loadout_item/folded_hat
	name = "Folded Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/bucklehat

/datum/loadout_item/duelist_hatc
	name = "Duelist's Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/duelhat

/datum/loadout_item/hood
	name = "Hood"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/roguehood

/datum/loadout_item/hijab
	name = "Hijab"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab

/datum/loadout_item/heavyhood
	name = "Heavy Hood"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood

/datum/loadout_item/nunveil
	name = "Nun Veil"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/nun

/datum/loadout_item/papakha
	name = "Papakha"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/papakha

/datum/loadout_item/rosa_crown
	name = "Rosa Crown"
	category = "Головные уборы"
	path = /obj/item/flowercrown/rosa

/datum/loadout_item/salvia_crown
	name = "Salvia Crown"
	category = "Головные уборы"
	path = /obj/item/flowercrown/salvia

/datum/loadout_item/matricaria_crown
	name = "Matricaria Crown"
	category = "Головные уборы"
	path = /obj/item/flowercrown/matricaria

/datum/loadout_item/calendula_crown
	name = "Calendula Crown"
	category = "Головные уборы"
	path = /obj/item/flowercrown/calendula

/datum/loadout_item/manabloom_crown
	name = "Manabloom Crown"
	category = "Головные уборы"
	path = /obj/item/flowercrown/manabloom

/datum/loadout_item/briar_crown
	name = "Briar Thorn Crown"
	category = "Головные уборы"
	path = /obj/item/flowercrown/briar

/datum/loadout_item/briarthorns
	name = "Briar Thorns"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/briarthorns

//CLOAKS
/datum/loadout_item/tabard
	name = "Tabard"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard

/datum/loadout_item/surcoat
	name = "Surcoat"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard/stabard

/datum/loadout_item/jupon
	name = "Jupon"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard/stabard/surcoat

/datum/loadout_item/jupon_short
	name = "Short Jupon"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard/stabard/surcoat/short

/datum/loadout_item/cape
	name = "Cape"
	category = "Плащи"
	path = /obj/item/clothing/cloak/cape

/datum/loadout_item/halfcloak
	name = "Halfcloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/half

/datum/loadout_item/ridercloak
	name = "Rider Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/half/rider

/datum/loadout_item/raincloak
	name = "Rain Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/raincloak

/datum/loadout_item/furcloak
	name = "Fur Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/raincloak/furcloak

/datum/loadout_item/direcloak
	name = "direbear cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/darkcloak/bear

/datum/loadout_item/lightdirecloak
	name = "light direbear cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/darkcloak/bear/light

/datum/loadout_item/volfmantle
	name = "Volf Mantle"
	category = "Плащи"
	path = /obj/item/clothing/cloak/volfmantle

/datum/loadout_item/eastcloak2
	name = "Leather Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/eastcloak2

/datum/loadout_item/thief_cloakc
	name = "Rapscallion's Shawl"
	category = "Плащи"
	path = /obj/item/clothing/cloak/thief_cloak

/datum/loadout_item/tabardscarlet
	name = "Tabard, Scarlet"
	category = "Плащи"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardscarlet

/datum/loadout_item/shroudscarlet
	name = "Tabard Shroud, Scarlet"
	category = "Плащи"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudscarlet

/datum/loadout_item/tabardblack
	name = "Tabard, Black"
	category = "Плащи"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardblack

/datum/loadout_item/shroudblack
	name = "Tabard Shroud, Black"
	category = "Плащи"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudblack

/datum/loadout_item/tabardwhite
	name = "Tabard, White"
	category = "Плащи"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/tabardwhite

/datum/loadout_item/shroudwhite
	name = "Tabard's Shroud, White"
	category = "Плащи"
	path = /obj/item/clothing/head/roguetown/roguehood/shroudwhite

/datum/loadout_item/aproncook
	name = "Apron, Cooking"
	category = "Плащи"
	path = /obj/item/clothing/cloak/apron/cook

//SHOES
/datum/loadout_item/darkboots
	name = "Dark Boots"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/boots

/datum/loadout_item/babouche
	name = "Babouche"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/shalal

/datum/loadout_item/nobleboots
	name = "Noble Boots"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/boots/nobleboot

/datum/loadout_item/sandals
	name = "Sandals"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/sandals

/datum/loadout_item/shortboots
	name = "Short Boots"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/shortboots

/datum/loadout_item/gladsandals
	name = "Gladiatorial Sandals"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/gladiator

/datum/loadout_item/ridingboots
	name = "Riding Boots"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/ridingboots

/datum/loadout_item/ankletscloth
	name = "Cloth Anklets"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/boots/clothlinedanklets

/datum/loadout_item/ankletsfur
	name = "Fur Anklets"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/boots/furlinedanklets

/datum/loadout_item/exoticanklets
	name = "Exotic Anklets"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/anklets

/datum/loadout_item/rumaclanshoes
	name = "Raised Sandals"
	path = /obj/item/clothing/shoes/roguetown/armor/rumaclan/shitty
	category = "Обувь"



//SHIRTS
/datum/loadout_item/longcoat
	name = "Longcoat"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat

/datum/loadout_item/robe
	name = "Robe"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/robe

/datum/loadout_item/phys_robe
	name = "Physicker's Robe"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/phys

/datum/loadout_item/feld_robe
	name = "Feldsher's Robe"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/feld

/datum/loadout_item/formalsilks
	name = "Formal Silks"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/puritan

/datum/loadout_item/longshirt
	name = "Shirt"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/black

/datum/loadout_item/shortshirt
	name = "Short-sleeved Shirt"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/shortshirt

/datum/loadout_item/sailorshirt
	name = "Striped Shirt"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/sailor

/datum/loadout_item/sailorjacket
	name = "Leather Jacket"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/armor/leather/vest/sailor

/datum/loadout_item/priestrobe
	name = "Undervestments"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest

/datum/loadout_item/exoticsilkbra
	name = "Exotic Silk Bra"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/exoticsilkbra

/datum/loadout_item/desertbra
	name = "Desert Bra"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/desertbra

/datum/loadout_item/kimono2
	name = "Long Sleeved Kimono"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/kimono2

/datum/loadout_item/haori
	name = "Haori"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/haori

/datum/loadout_item/yoroihitatare
	name = "Yoroihitatare"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/yoroihitatare

/datum/loadout_item/kamishimo
	name = "Kamishimo"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/kamishimo

/datum/loadout_item/kazengun_jacket
	name = "Kazengun Jacket"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/kazengun_jacket

/datum/loadout_item/deserthood
	name = "Desert Hood"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/deserthood

/datum/loadout_item/desertskirt
	name = "Desert Skirt"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/skirt/desert

/datum/loadout_item/explorerhat
	name = "Explorer Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/explorerhat

/datum/loadout_item/explorervest
	name = "Explorer Vest"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/explorer

/datum/loadout_item/fancycoat
	name = "Fancy Coat"
	category = "Одежда"
	path = /obj/item/clothing/cloak/poncho/fancycoat

/datum/loadout_item/explorerpants
	name = "Explorer Pants"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/tights/explorerpants

/datum/loadout_item/bottomtunic
	name = "Low-cut Tunic"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/lowcut

/datum/loadout_item/tunic
	name = "Tunic"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic

/datum/loadout_item/stripedtunic
	name = "Striped Tunic"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/armor/workervest

/datum/loadout_item/dress
	name = "Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen

/datum/loadout_item/bardress
	name = "Bar Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress

/datum/loadout_item/chemise
	name = "Chemise"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkdress

/datum/loadout_item/sexydress
	name = "Sexy Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/sexy

/datum/loadout_item/straplessdress
	name = "Strapless Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless

/datum/loadout_item/straplessdress/alt
	name = "Strapless Dress, alt"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/strapless/alt

/datum/loadout_item/gown
	name = "Spring Gown"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown

/datum/loadout_item/gown/summer
	name = "Summer Gown"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown

/datum/loadout_item/gown/fall
	name = "Fall Gown"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/fallgown

/datum/loadout_item/gown/winter
	name = "Winter Gown"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown

/datum/loadout_item/gown/silkydress
	name = "Silky Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress

/datum/loadout_item/noblecoat
	name = "Fancy Coat"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/noblecoat

/datum/loadout_item/leathervest
	name = "Leather Vest"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/armor/leather/vest

/datum/loadout_item/nun_habit
	name = "Nun Habit"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/nun

/datum/loadout_item/eastshirt1
	name = "Black Foreign Shirt"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1

/datum/loadout_item/eastshirt2
	name = "White Foreign Shirt"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2

//PANTS
/datum/loadout_item/tights
	name = "Cloth Tights"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/tights/black

/datum/loadout_item/leathertights
	name = "Leather Tights"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/trou/leathertights

/datum/loadout_item/hakama
	name = "Hakama Pants"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/trou/leather/hakama

/datum/loadout_item/trou
	name = "Work Trousers"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/trou

/datum/loadout_item/leathertrou
	name = "Leather Trousers"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/trou/leather

/datum/loadout_item/leathershorts
	name = "Leather Shorts"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/heavy_leather_pants/shorts

/datum/loadout_item/sailorpants
	name = "Seafaring Pants"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/tights/sailor

/datum/loadout_item/skirt
	name = "Skirt"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/skirt

//ACCESSORIES
/datum/loadout_item/wrappings
	name = "Handwraps"
	category = "Аксессуары"
	path = /obj/item/clothing/wrists/roguetown/wrappings

/datum/loadout_item/allwrappings
	name = "Cloth Wrappings"
	category = "Аксессуары"
	path = /obj/item/clothing/wrists/roguetown/allwrappings

/datum/loadout_item/loincloth
	name = "Loincloth"
	category = "Аксессуары"
	path = /obj/item/clothing/under/roguetown/loincloth

/datum/loadout_item/spectacles
	name = "Spectacles"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/spectacles

/datum/loadout_item/fingerless
	name = "Fingerless Gloves"
	category = "Аксессуары"
	path = /obj/item/clothing/gloves/roguetown/fingerless

/datum/loadout_item/bandages
	name = "Bandages, Gloves"
	category = "Аксессуары"
	path = /obj/item/clothing/gloves/roguetown/bandages

/datum/loadout_item/exoticsilkbelt
	name = "Exotic Silk Belt"
	category = "Аксессуары"
	path = /obj/item/storage/belt/rogue/leather/exoticsilkbelt

/datum/loadout_item/ragmask
	name = "Rag Mask"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/ragmask

/datum/loadout_item/halfmask
	name = "Halfmask"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/shepherd

/datum/loadout_item/dendormask
	name = "Briar Mask"
	category = "Аксессуары"
	path = /obj/item/clothing/head/roguetown/dendormask

/datum/loadout_item/eorahood
	name = "Opera Mask - Eoran Hood"
	category = "Аксессуары"
	donatitem = TRUE
	path = /obj/item/clothing/head/roguetown/roguehood/eorahood

/datum/loadout_item/exoticsilkmask
	name = "Exotic Silk Mask"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/exoticsilkmask

/datum/loadout_item/duelmaskc
	name = "Duelist's Mask"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/duelmask

/datum/loadout_item/pipe
	name = "Pipe"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/cigarette/pipe

/datum/loadout_item/pipewestman
	name = "Westman Pipe"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/cigarette/pipe/westman

/datum/loadout_item/feather
	name = "Feather"
	category = "Аксессуары"
	path = /obj/item/natural/feather

/datum/loadout_item/collar
	name = "Collar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/collar/leather

/datum/loadout_item/forlon_collar
	name = "Light Forlorn Collar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/collar/forlorn

/datum/loadout_item/catbell_collar
	name = "Catbell Collar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/collar/bell/catbell

/datum/loadout_item/bell_collar
	name = "Cowbell Collar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/collar/bell/cowbell

/datum/loadout_item/cursed_collar
	name = "Cursed Collar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/gorget/cursed_collar

/datum/loadout_item/rope_leash
	name = "Rope Leash"
	category = "Аксессуары"
	path = /obj/item/leash

/datum/loadout_item/leather_leash
	name = "Leather Leash"
	category = "Аксессуары"
	path = /obj/item/leash/leather

/datum/loadout_item/chain_leash
	name = "Chain Leash"
	category = "Аксессуары"
	path = /obj/item/leash/chain

/datum/loadout_item/cloth_blindfold
	name = "Cloth Blindfold"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/blindfold

/datum/loadout_item/fake_blindfold
	name = "Fake Blindfold"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/blindfold/fake

/datum/loadout_item/bases
	name = "Cloth military skirt"
	category = "Аксессуары"
	path = /obj/item/storage/belt/rogue/leather/battleskirt

/datum/loadout_item/fauldedbelt
	name = "Belt with faulds"
	category = "Аксессуары"
	path = /obj/item/storage/belt/rogue/leather/battleskirt/faulds

/datum/loadout_item/psicross
	name = "Psydonian Cross"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross

/datum/loadout_item/psicross/reform
	name = "Reformist Psydonian Cross"
	path = /obj/item/clothing/neck/roguetown/psicross/reform

/datum/loadout_item/psicross/astrata
	name = "Amulet of Astrata"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata

/datum/loadout_item/psicross/noc
	name = "Amulet of Noc"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/noc

/datum/loadout_item/psicross/abyssor
	name = "Amulet of Abyssor"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor

/datum/loadout_item/psicross/xylix
	name = "Amulet of Xylix"
	path = /obj/item/clothing/neck/roguetown/psicross/xylix

/datum/loadout_item/psicross/dendor
	name = "Amulet of Dendor"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/dendor

/datum/loadout_item/psicross/necra
	name = "Amulet of Necra"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/necra

/datum/loadout_item/psicross/pestra
	name = "Amulet of Pestra"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/pestra

/datum/loadout_item/psicross/ravox
	name = "Amulet of Ravox"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/ravox

/datum/loadout_item/psicross/malum
	name = "Amulet of Malum"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/malum

/datum/loadout_item/psicross/eora
	name = "Amulet of Eora"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/eora

/datum/loadout_item/psicross/undivided
	name = "Amulet of Ten"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/undivided

/datum/loadout_item/psicross/zizo
	name = "Decrepit Zcross"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

/datum/loadout_item/zcross_iron
	name = "Iron Zcross"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/iron

/datum/loadout_item/psicross/matthios
	name = "Amulet of Matthios"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios

/datum/loadout_item/psicross/graggar
	name = "Amulet of Graggar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar

/datum/loadout_item/psicross/gronnzizo
	name = "Wolf Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn

/datum/loadout_item/psicross/gronnbaotha
	name = "Leopard Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn

/datum/loadout_item/psicross/gronnmatthios
	name = "Bear Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn

/datum/loadout_item/psicross/gronngraggar
	name = "Moose Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn

/datum/loadout_item/psicross/gronndendor
	name = "Volfskinned Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn

/datum/loadout_item/psicross/gronnabyssor
	name = "Hadal Talisman"
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn

/datum/loadout_item/wedding_band
	name = "silver wedding band"
	category = "Аксессуары"
	path = /obj/item/clothing/ring/band

/datum/loadout_item/chaperon
    name = "Chaperon (Normal)"
    category = "Головные уборы"
    path = /obj/item/clothing/head/roguetown/chaperon

/datum/loadout_item/chaperon/alt
    name = "Chaperon (Alt)"
    category = "Головные уборы"
    path = /obj/item/clothing/head/roguetown/chaperon/greyscale

/datum/loadout_item/chaperon/burgherc
    name = "Noble's Chaperon"
    category = "Головные уборы"
    path = /obj/item/clothing/head/roguetown/chaperon/noble

/datum/loadout_item/jesterhatc
    name = "Jester's Hat"
    category = "Головные уборы"
    path = /obj/item/clothing/head/roguetown/jester

/datum/loadout_item/jestertunickc
    name = "Jester's Tunick"
    category = "Одежда"
    path = /obj/item/clothing/suit/roguetown/shirt/jester

/datum/loadout_item/jestershoess
    name = "Jester's Shoes"
    category = "Обувь"
    path = /obj/item/clothing/shoes/roguetown/jester

/datum/loadout_item/cotehardie
	name = "Fitted Coat"
	category = "Одежда"
	path = /obj/item/clothing/cloak/cotehardie

//CAPARISONS

/datum/loadout_item/caparison
	name = "Caparison"
	path = /obj/item/caparison

/datum/loadout_item/caparison/psy
	name = "Psydonite Caparison"
	path = /obj/item/caparison/psy

/datum/loadout_item/caparison/astrata
	name = "Astratan Caparison"
	path = /obj/item/caparison/astrata

/datum/loadout_item/caparison/eora
	name = "Eoran Caparison"
	path = /obj/item/caparison/eora


//////////////////
//  TRIUMPHS !  //
//////////////////

//Everything in this section costs TRI. Very rudimentary, but it should help us gradually realign some sense of value to this otherwise-neglected system.
//When it comes to equipment, avoid adding anything that an Adventurer - or non-combative Noble - couldn't spawn with, or otherwise acquire within the first dae of the week.
//If adding more items, ensure they're a Triumph-exclusive child. If they can be smelted down, reduce the sum to one ingot. If they can be sold, blacklist it from the Stockpile.

// -3 TRI Minisection.
// Nearly all characters can comfortably earn +3-5 TRI per week, assuming they sleep ever-so-often.

/datum/loadout_item/triumph_knife
	name = "Laborer's Knife (-3 TRI)"
	path = /obj/item/rogueweapon/huntingknife/throwingknife/triumph
	category = list("Триумфы")
	triumph_cost = 3

/datum/loadout_item/triumph_heavygloves
	name = "Heavy Leather Gloves (-6 TRI)"
	path = /obj/item/clothing/gloves/roguetown/angle
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_heavyboots
	name = "Heavy Leather Boots (-6 TRI)"
	path = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_necklace
	name = "Golden Necklace, Ornate (-6 TRI)"
	path = /obj/item/clothing/neck/roguetown/ornateamulet/noble/triumph
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_ring
	name = "Golden Ring, Ornate (-6 TRI)"
	path = /obj/item/clothing/ring/gold/triumph
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_circlet
	name = "Golden Circlet, Ornate (-6 TRI)"
	path = /obj/item/clothing/head/roguetown/circlet/triumph
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkitaxe
	name = "Morphing Elixir, 'Valorian Axe' (-3 TRI)"
	path = /obj/item/enchantingkit/triumph_weaponkit_axe
	triumph_cost = 3

// -5 TRI Minisection.

/datum/loadout_item/triumph_shortsatchel
	name = "Short Satchel (-5 TRI)"
	path = /obj/item/storage/backpack/rogue/satchel/short
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_bedroll
	name = "Waterskin (-5 TRI)"
	path = /obj/item/reagent_containers/glass/bottle/waterskin
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_messkit
	name = "Mess Kit (-5 TRI)"
	path = /obj/item/storage/gadget/messkit
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_foldtable
	name = "Folding Table (-5 TRI)"
	path = /obj/structure/table/wood/folding
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_bedroll
	name = "Bedroll (-5 TRI)"
	path = /obj/item/bedroll
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_scabbardnoble
	name = "Decorated Scabbard, Silver (-10 TRI)"
	path = /obj/item/rogueweapon/scabbard/sword/noble
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_sheathnoble
	name = "Decorated Sheath, Silver (-10 TRI)"
	path = /obj/item/rogueweapon/scabbard/sheath/noble
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_psycross
	name = "Golden Psycross, Ornate (-10 TRI)"
	path = /obj/item/clothing/neck/roguetown/psicross/g/triumph
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_zcross
	name = "Golden Zizote Amulet, Ornate (-10 TRI)"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/g/triumph
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_astcross
	name = "Golden Astratan Amulet, Ornate (-10 TRI)"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata/g/triumph
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_signet
	name = "Golden Signet Ring, Ornate (-10 TRI)"
	path = /obj/item/clothing/ring/signet/triumph
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_gildedshirt
	name = "Gilded Dress Shirt (-5 TRI)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_pristinedress
	name = "Pristine Dress (-5 TRI)"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_royalsleeves
	name = "Royal Sleeves (-5 TRI)"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_goldhalfmask
	name = "Golden Halfmask, Ornate (-10 TRI)"
	path = /obj/item/clothing/mask/rogue/lordmask/triumph
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_goldfullmask
	name = "Golden Mask, Ornate (-10 TRI)"
	path = /obj/item/clothing/mask/rogue/facemask/goldmask/triumph
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_goldfullmaskc
	name = "Crestless Golden Mask, Ornate (-10 TRI)"
	path = /obj/item/clothing/mask/rogue/facemask/goldmaskc/triumph
	category = list("Триумфы")
	triumph_cost = 10

// -7 TRI Minisection.
/*
/datum/loadout_item/triumph_buttpack
	name = "Belted Satchel (-7 TRI)"
	path = /obj/item/storage/backpack/rogue/satchel/beltpack
	category = list("Триумфы")
	triumph_cost = 7
*/
/datum/loadout_item/triumph_lunchpouch
	name = "Pouch of Luncheons (-7 TRI)"
	path = /obj/item/storage/belt/rogue/pouch/triumphlunch
	category = list("Триумфы")
	triumph_cost = 7

/* /datum/loadout_item/triumph_grenzhat
	name = "Grenzelhoftian Beret (-7 TRI)"
	path = /obj/item/clothing/head/roguetown/grenzelhofthat/triumph
	category = list("Триумфы")
	triumph_cost = 7 */

/datum/loadout_item/triumph_lordcloak
	name = "Lordly Cloak (-7 TRI)"
	path = /obj/item/clothing/cloak/lordcloak
	category = list("Триумфы")
	triumph_cost = 7

/datum/loadout_item/triumph_ladycloak
	name = "Ladylike Cloak (-15 TRI)"
	path = /obj/item/clothing/cloak/lordcloak/ladycloak
	category = list("Триумфы")
	triumph_cost = 15

/datum/loadout_item/triumph_gdorpelring
	name = "Golden Dorpel Ring, Ornate (-15 TRI)"
	path = /obj/item/clothing/ring/diamond/triumph
	category = list("Триумфы")
	triumph_cost = 15

// Beyond.

/datum/loadout_item/triumph_buffpot
	name = "Vial of Distilled Triumphance (-100 TRI)"
	path = /obj/item/reagent_containers/glass/bottle/alchemical/tripot
	category = list("Триумфы")
	triumph_cost = 100

//Donator Section
//All these items are stored in the donator_fluff.dm in the azure modular folder for simplicity.
//All should be subtypes of existing weapons/clothes/armor/gear, whatever, to avoid balance issues I guess. Idk, I'm not your boss.

// Энчант киты
/datum/loadout_item/donator_plex
	name = "Donator Kit - Rapier di Aliseo - Required: Rapier"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/plexiant
	donatitem = TRUE

/datum/loadout_item/donator_sru
	name = "Donator Kit - Emerald Dress - Required: Dress(No Small Races)"
	category = list("Одежда", "Донат")
	path = /obj/item/enchantingkit/srusu
	donatitem = TRUE


/datum/loadout_item/donator_strudel
	name = "Donator Kit - Grenzelhoftian Mage Vest - Required: Robe(No Small Races)"
	category = list("Одежда", "Донат")
	path = /obj/item/enchantingkit/strudel1
	donatitem = TRUE

/datum/loadout_item/donator_strudel2
	name = "Donator Kit - Xylixian Fasching Leotard - Required: Xylixian Cloak(Only woman, no small races)"
	category = list("Плащи", "Донат")
	path = /obj/item/enchantingkit/strudel2
	donatitem = TRUE

/datum/loadout_item/donator_bat
	name = "Donator Kit - Handcarved Harp - Required: Harp"
	category = list("Разное", "Донат")
	path = /obj/item/enchantingkit/bat
	donatitem = TRUE

/datum/loadout_item/donator_mansa
	name = "Donator Kit - Wortträger - Required: Estoc"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/ryebread
	donatitem = TRUE

/datum/loadout_item/donator_rebel
	name = "Donator Kit - Gilded Sallet - Required: Visored Sallet"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/rebel
	donatitem = TRUE

/datum/loadout_item/donator_bigfoot
	name = "Donator Kit - Gilded Knight Helm - Required: Knight Helmet"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/bigfoot
	donatitem = TRUE

/datum/loadout_item/donator_ravoxhelm_oldrw
	name = "Donator Kit - Plumed Ravox Helmet - Required: Heavy Helmet"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/ravoxhelm_oldrw
	donatitem = TRUE

/datum/loadout_item/donator_necranhelm_oldrw
	name = "Donator Kit - Hooded Necra Helmet - Required: Heavy Helmet"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/necranhelm_oldrw
	donatitem = TRUE

/datum/loadout_item/donator_eoran_helm
	name = "Donator Kit - Flower Eora Helmet - Required: Heavy Helmet"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/eoran_helm_resprite
	donatitem = TRUE

/datum/loadout_item/donator_astratanhelm_oldrw
	name = "Donator Kit - Plumed Astrata Helmet - Required: Heavy Helmet"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/astratanhelm_oldrw
	donatitem = TRUE

/datum/loadout_item/donator_dakken
	name = "Donator Kit - Armoured Avantyne Barbute - Required: Armet or Hounskull Bascinet"
	path = /obj/item/enchantingkit/dakken_zizhelm
	category = list("Броня", "Донат")
	donatitem = TRUE
 
/datum/loadout_item/donator_bigfoot_axe
	name = "Donator Kit - Gilded GreatAxe - Required: Steel Greataxe"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/bigfoot_axe
	donatitem = TRUE


/datum/loadout_item/donator_zydrasiconocrown
	name = "Donator Kit - Iconoclast Crown - Required: Barred Helmet(Only men, no small races)"
	path = /obj/item/enchantingkit/zydrasiconocrown
	category = list("Броня", "Донат")
	donatitem = TRUE
	
/datum/loadout_item/donator_zydrasiconopauldrons
	name = "Donator Kit - Iconoclast Pauldrons - Required: Lightweight Brigandine(Only men, no small races)"
	path = /obj/item/enchantingkit/zydrasiconopauldrons
	category = list("Броня", "Донат")
	donatitem = TRUE
	
/datum/loadout_item/donator_eiren4
	name = "Donator Kit - Darkwood's Embrace"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat/eiren
	category = list("Одежда", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_zydrasiconosash
	name = "Donator Kit - Iconoclast Sash - Required: Hauberk(Only men, no small races)"
	path = /obj/item/enchantingkit/zydrasiconosash
	category = list("Броня", "Донат")
	donatitem = TRUE
	
/datum/loadout_item/donator_zydras
	name = "Donator Kit - Padded silky dress - Required: Silky Dress(No Small Races)"
	category = list("Одежда", "Донат")
	path = /obj/item/enchantingkit/zydras
	donatitem = TRUE

/datum/loadout_item/donator_eiren
	name = "Donator Kit - Regret - Required: Any Zweihander"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/eiren
	donatitem = TRUE

/datum/loadout_item/donator_eiren2
	name = "Donator Kit - Lunae - Required: Sabre"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/eirensabre
	donatitem = TRUE

/datum/loadout_item/donator_eiren3
	name = "Donator Kit - Cinis - Required: Sabre"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/eirensabre2
	donatitem = TRUE

/datum/loadout_item/donator_waff
	name = "Donator Kit - Weeper Lathe - Required: Greatsword"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/waff
	donatitem = TRUE

/datum/loadout_item/donator_inverserun
	name = "Donator Kit - Votive Thorns - Required: Any Zweihander"
	path = /obj/item/enchantingkit/inverserun
	category = list("Оружие", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_zoe
	name = "Donator Kit - Shroud of the Undermaiden - Required: Direbear Cloak"
	category = list("Плащи", "Донат")
	path = /obj/item/enchantingkit/zoe
	donatitem = TRUE

/datum/loadout_item/donator_zoe_shovel
	name = "Donator Kit - Silence - Required: Shovel"
	path = /obj/item/enchantingkit/zoe_shovel
	category = list("Разное", "Донат")
	donatitem = TRUE

/datum/loadout_item/donat_scabbardroyal
	name = "Decorated Scabbard, Golden"
	path = /obj/item/rogueweapon/scabbard/sword/royal/donat
	category = list("Оружие", "Донат")
	donatitem = TRUE

/datum/loadout_item/donat_sheathroyal
	name = "Decorated Sheath, Golden"
	path = /obj/item/rogueweapon/scabbard/sheath/royal/donat
	category = list("Оружие", "Донат")
	donatitem = TRUE

/datum/loadout_item/donat_gildedshirt
	name = "Gilded Dress Shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	category = list("Одежда", "Донат")
	donatitem = TRUE

/datum/loadout_item/donat_pristinedress
	name = "Pristine Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	category = list("Одежда", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_willmbrink
	name = "Royal Gown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal
	category = list("Одежда", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_willmbrink/sleeves
	name = "Donator Item - Royal Sleeves"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves
	category = list("Одежда", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_dasfox
	name = "Donator Kit - Archaic Ceremonial Valkyrhelm - Required: Armet"
	path = /obj/item/enchantingkit/dasfox_helm
	category = list("Броня", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_dasfox/cuirass
	name = "Donator Kit - Archaic Ceremonial Cuirass - Required: Fluted Cuirass(No Small Races)"
	path = /obj/item/enchantingkit/dasfox_cuirass
	category = list("Броня", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_dasfox/lance
	name = "Donator Item - Decorated Lance - Required: Lance"
	path = /obj/item/enchantingkit/dasfox_lance
	category = list("Оружие", "Донат")
	donatitem = TRUE

/datum/loadout_item/donat_armorkit
	name = "Donator Kit - 'Valorian Steel Armor' - Required: Steel Cuirass, Steel Halfplate, Steel Plate Armor or Fluted Plate Armor"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/triumph_armorkit
	donatitem = TRUE

/datum/loadout_item/donat_weaponkittri
	name = "Donator Kit - 'Valorian Longsword' - Required: Longsword"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/triumph_weaponkit_tri
	donatitem = TRUE

/datum/loadout_item/donat_weaponkitwide
	name = "Donator Kit - 'Wideguard Longsword' - Required: Longsword or Rapier"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/triumph_weaponkit_wide
	donatitem = TRUE

/datum/loadout_item/donat_weaponkitrock
	name = "Donator Kit - 'Rockhillian Longsword' - Required: Longsword, Broadsword or Executioner Sword"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/triumph_weaponkit_rock
	donatitem = TRUE

/datum/loadout_item/donat_weaponkitsabre
	name = "Donator Kit - 'Sabreguard Longsword' - Required: Longsword or Kriegmesser"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/triumph_weaponkit_sabre
	donatitem = TRUE

/datum/loadout_item/donat_weaponkitpsy
	name = "Donator Kit - 'Psycrucifix Longsword' - Required: Psydonic or default longsword"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/triumph_weaponkit_psy
	donatitem = TRUE

/datum/loadout_item/donator_dasfox/periapt
	name = "Donator Item - Defiled Astratan Periapt"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata/dasfox
	category = list("Аксессуары", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_ryan
	name = "Donator Item - Western Estates Caparison"
	path = /obj/item/caparison/ryan
	category = list("Разное", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_ryan/psy_helm
	name = "Donator Kit - Unorthodoxist Psydonite Helm - Required: Psydonic Helmet(Armet,Barbute,Bucket Helmet or Sallet)"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/ryan_psyhelm
	donatitem = TRUE

/datum/loadout_item/donator_koruu
	name = "Donator Kit - Well-Worn Bamboo Hat"
	path = /obj/item/clothing/head/roguetown/mentorhat/koruu
	category = list("Головные уборы", "Донат")
	donatitem = TRUE

/datum/loadout_item/donator_kumie
	name = "Donator Kit - Aristocratic Boots - Required: Heavy Leather Boots or Noble Boots"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/kumie_boots
	donatitem = TRUE

/datum/loadout_item/donator_kumie2
	name = "Donator Kit - Aristocratic Gloves - Required: Fingerless Leather Gloves or Heavy Leather Gloves"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/kumie_gloves
	donatitem = TRUE

/datum/loadout_item/donator_kumie3
	name = "Donator Kit - Aristocratic Shirt - Required: Gambeson or Padded Gambeson(No Small Races)"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/kumie_shirt
	donatitem = TRUE

/datum/loadout_item/donator_kumie4
	name = "Donator Kit - Aristocratic Coat - Required: Hardened Leather Coat or Lightweight Brigandine(No Small Races)"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/kumie_coat
	donatitem = TRUE

/datum/loadout_item/donator_hammerhold_robe
	name = "Donator Kit - Hammerhold Robe - Required: Gambeson or Padded Gambeson(No Small Races)"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/hammerhold_robe
	donatitem = TRUE

/datum/loadout_item/donator_hammerhold_coat
	name = "Donator Kit - Hammerhold Mage Coat - Required: Hardened Leather Coat(No Small Races)"
	category = list("Броня", "Донат")
	path = /obj/item/enchantingkit/hammerhold_coat
	donatitem = TRUE

/datum/loadout_item/donator_jagerrifle
	name = "Donator Kit - Jägerbüchse - Required: Arquebus"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/jagerrifle
	donatitem = TRUE

/datum/loadout_item/donator_stinketh_shashka
	name = "Donator Kit - Fencer's Shashka - Required: Szöréndnížine Sabre Or Aavnic Shashka"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/stinketh_shashka
	donatitem = TRUE

/datum/loadout_item/donator_stinketh_pike
	name = "Donator Kit - Kindness of Ravens Standard - Required: Banner Of Szöréndnížina"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/stinketh_pike
	donatitem = TRUE

/datum/loadout_item/donator_koruu_glaive
	name = "Donator Kit - Sixty Five Yils - Required: Glaive Or Naginata"
	category = list("Оружие", "Донат")
	path = /obj/item/enchantingkit/koruu_glaive
	donatitem = TRUE

// Разное
/datum/loadout_item/donat
	name = "Музыкальная коробка"
	category = list("Разное", "Донат")
	path = /obj/item/dmusicbox
	donatitem = TRUE

/datum/loadout_item/donat/lute
	name = "Музыкальный инструмент: Лютня"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/lute
	donatitem = TRUE

/datum/loadout_item/donat/accord
	name = "Музыкальный инструмент: Аккордеон"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/accord
	donatitem = TRUE

/datum/loadout_item/donat/guitar
	name = "Музыкальный инструмент: Гитара"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/guitar
	donatitem = TRUE

/datum/loadout_item/donat/harp
	name = "Музыкальный инструмент: Арфа"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/harp
	donatitem = TRUE

/datum/loadout_item/donat/flute
	name = "Музыкальный инструмент: Флейта"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/flute
	donatitem = TRUE

/datum/loadout_item/donat/drum
	name = "Музыкальный инструмент: Барабан"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/drum
	donatitem = TRUE

/datum/loadout_item/donat/shamisen
	name = "Музыкальный инструмент: Сямисэн"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/shamisen
	donatitem = TRUE

/datum/loadout_item/donat/vocals
	name = "Музыкальный инструмент: Талисман Вокалиста"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/vocals
	donatitem = TRUE

/datum/loadout_item/donat/viola
	name = "Музыкальный инструмент: Виола"
	category = list("Разное", "Донат")
	path = /obj/item/rogue/instrument/viola
	donatitem = TRUE

// Одежда для донатеров

/datum/loadout_item/stargazer
	name = "Мантия звездочета"
	category = list ("Донат", "Одежда")
	path = /obj/item/clothing/suit/roguetown/shirt/robe/noc/stargazer
	donatitem = TRUE

/datum/loadout_item/donat/corset
	name = "Корсет"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/armor/corset
	donatitem = TRUE

/datum/loadout_item/donat/elven_suit
	name = "Эльфийский костюм"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_elven
	donatitem = TRUE

/datum/loadout_item/donat/hammerhold_shirt
	name = "Хаммерхолдская рубашка"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold
	donatitem = TRUE

/datum/loadout_item/donat/hammerhold_dress
	name = "Хаммерхолдское платье"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress
	donatitem = TRUE

/datum/loadout_item/donat/elven_coat
	name = "Эльфийское пальто"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat
	donatitem = TRUE

/datum/loadout_item/donat/hammerhold_coat
	name = "Боярское пальто"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/coat
	donatitem = TRUE

/datum/loadout_item/donat/elven_coat_alt
	name = "Эльфийское меховое пальто"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_elven/coat/alt
	donatitem = TRUE

/datum/loadout_item/donat/hammerhold_furcoat
	name = "Одеяние хаммерхолдского мага"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/furcoat
	donatitem = TRUE

/datum/loadout_item/donat/hammerhold_robe
	name = "Роба хаммерхолдского мага"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/robe
	donatitem = TRUE

/datum/loadout_item/donat/maid_dress
	name = "Платье горничной"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/dress/maid
	donatitem = TRUE

/datum/loadout_item/donat/nun_dress
	name = "Роба монашки (только для женщин)"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/robe/nunTA
	donatitem = TRUE

/datum/loadout_item/donat/kimono
	name = "Кимоно (только для женщин)"
	category = list("Одежда", "Донат")
	path = /obj/item/clothing/suit/roguetown/shirt/kimono
	donatitem = TRUE

// Табарды и плащи

/datum/loadout_item/donat/matron
	name = "Плащ матроны"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/matron
	donatitem = TRUE

/datum/loadout_item/donat/capeblkknight
	name = "Кровавая мантия"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/cape/blkknight
	donatitem = TRUE

/datum/loadout_item/donat/xylixiancloak
	name = "Ксайликситский плащ"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/templar/xylixian
	donatitem = TRUE

/datum/loadout_item/donat/furcloak
	name = "Меховой плащ"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/raincloak/furcloak
	donatitem = TRUE

/datum/loadout_item/donat/snowcloak
	name = "Снежный плащ"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/forrestercloak/snow
	donatitem = TRUE

/datum/loadout_item/donat/tabard/astata
	name = "Табард-плащ Астраты"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/templar/astratan
	donatitem = TRUE

/datum/loadout_item/donat/tabard/crusader/noc
	name = "Табард-плащ Нок"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/tabard/crusader/noc
	donatitem = TRUE

/datum/loadout_item/donat/tabard/crusader/dendor
	name = "Табард-плащ Дендора"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/tabard/crusader/dendor
	donatitem = TRUE

/datum/loadout_item/donat/tabard/pestra
	name = "Табард-плащ Пестры"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/templar/pestran
	donatitem = TRUE

/datum/loadout_item/donat/tabard/malum
	name = "Табард-плащ Малума"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/templar/malumite
	donatitem = TRUE

/datum/loadout_item/donat/tabard/abyssor
	name = "Табард-плащ Абиссора"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/tabard/abyssortabard
	donatitem = TRUE

/datum/loadout_item/donat/tabard/crusader/ravox
	name = "Табард-плащ Равокса(старый)"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/cleric/ravox
	donatitem = TRUE

/datum/loadout_item/donat/tabard/templar/ravox
	name = "Табард-плащ Равокса(новый)"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/templar/ravox
	donatitem = TRUE

/datum/loadout_item/donat/tabard/crusader/eora
	name = "Табард-плащ Эоры(старый)"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/tabard/crusader/eora
	donatitem = TRUE

/datum/loadout_item/donat/tabard/crusader/eora/resprite
	name = "Табард-плащ Эоры(респрайт)"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/templar/eoran/alt
	donatitem = TRUE

/datum/loadout_item/donat/tabard/eora
	name = "Табард-плащ Эоры"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/templar/eoran
	donatitem = TRUE

/datum/loadout_item/donat/tabard/crusader/necra
	name = "Табард Некры"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/templar/necran
	donatitem = TRUE
	
/datum/loadout_item/donat/tabard/crusader/psydon
	name = "Табард Псайдона"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/tabard/psydontabard
	donatitem = TRUE

/datum/loadout_item/poncho
	name = "Пончо"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/poncho
	donatitem = TRUE

/datum/loadout_item/donat/hammerholdcape
	name = "Хаммерхолдская накидка"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/twilight_cape
	donatitem = TRUE

/datum/loadout_item/donat/elvencloak
	name = "Эльфийский плащ"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/twilight_elven
	donatitem = TRUE

/datum/loadout_item/donat/elvencloak_short
	name = "Короткий эльфийский плащ"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/twilight_elven/short
	donatitem = TRUE

/datum/loadout_item/donat/maid_apron
	name = "Фартук горничной"
	category = list("Плащи", "Донат")
	path = /obj/item/clothing/cloak/apron/waist/maid
	donatitem = TRUE

/datum/loadout_item/donat/scarf
	name = "Шарф"
	category = list("Аксессуары", "Донат")
	path = /obj/item/clothing/cloak/twilight_scarf
	donatitem = TRUE

/datum/loadout_item/donat/elven_burka
	name = "Эльфийская бурка"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/twilight_elven_hat

/datum/loadout_item/donat/loveamulet
	name = "Амулет Слез Любви"
	category = list("Аксессуары", "Донат")
	path = /obj/item/clothing/neck/roguetown/loveamulet
	donatitem = TRUE

/datum/loadout_item/donat/matthios_moneta
	name = "Амулет из проколотой монеты"
	category = list("Аксессуары", "Донат")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/moneta
	donatitem = TRUE
	ckeywhitelist = list("imony", "uedhighcommand")

// Маски

/datum/loadout_item/donat/naledimask
	name = "Маска Наледи"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/mask/rogue/lordmask/naledi/decorated
	donatitem = TRUE

/datum/loadout_item/donat/eoramask
	name = "Эоранская маска"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/eoramask
	donatitem = TRUE

/datum/loadout_item/donat/eyepatchfake
	name = "Повязка на правый глаз(ненастоящая)"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/mask/rogue/eyepatch/fake
	donatitem = TRUE

/datum/loadout_item/donat/eyepatchfakeleft
	name = "Повязка на левый глаз(ненастоящая)"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/mask/rogue/eyepatch/left/fake
	donatitem = TRUE

/datum/loadout_item/owlmask
	name = "Совиная маска"
	category = list ("Донат", "Головные уборы")
	path = /obj/item/clothing/mask/rogue/owlmask
	donatitem = TRUE

// Шляпы

/datum/loadout_item/stargazerhood
	name = "Капюшон звездочета"
	category = list ("Донат", "Головные уборы")
	path = /obj/item/clothing/head/roguetown/roguehood/stargazer
	donatitem = TRUE

/datum/loadout_item/donat/grenzelhofthat_decorated
	name = "Грензельхофтская шляпа(без брони, декоративная)"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/grenzelhofthat/decorated
	donatitem = TRUE

/datum/loadout_item/donat/wizhat
	name = "Шляпа мага(синяя)"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/wizhat
	donatitem = TRUE

/datum/loadout_item/donat/wizhatred
	name = "Шляпа мага(красная)"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/wizhat/red
	donatitem = TRUE

/datum/loadout_item/donat/wizhatyellow
	name = "Шляпа мага(желтая)"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/wizhat/yellow
	donatitem = TRUE

/datum/loadout_item/donat/wizhatgreen
	name = "Шляпа мага(зеленая)"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/wizhat/green
	donatitem = TRUE

/datum/loadout_item/donat/wizhatblack
	name = "Шляпа мага(черная)"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/wizhat/black
	donatitem = TRUE

/datum/loadout_item/donat/maid_headdress
	name = "Чепчик горничной"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/maidhead
	donatitem = TRUE

/datum/loadout_item/donat/kokoshnik
	name = "Кокошник"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/twilight_hammerhold_hat
	donatitem = TRUE

/datum/loadout_item/donat/hammerhold_hat
	name = "Хаммерхолдская шляпа"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/twilight_hammerhold_hat/peasant
	donatitem = TRUE

/datum/loadout_item/donat/nun_hood
	name = "Капюшон монашки"
	category = list("Головные уборы", "Донат")
	path = /obj/item/clothing/head/roguetown/nunTA
	donatitem = TRUE

/datum/loadout_item/donat/flowers_crown_eora
	name = "Корона из цветов Эоры"
	category = list("Головные уборы", "Донат")
	path = /obj/item/flowercrown/rosa/resprite
	donatitem = TRUE

// Пояса

/datum/loadout_item/donat/hammerhold_sash
	name = "Хаммерхолдский кушак"
	category = list("Аксессуары", "Донат")
	path = /obj/item/storage/belt/rogue/leather/hammerhold_sash
	donatitem = TRUE

// Обувь

/datum/loadout_item/hammerhold_shoes
	name = "Хаммерхолдская обувка"
	category = list("Обувь", "Донат")
	path = /obj/item/clothing/shoes/roguetown/hammerhold_shoes
	donatitem = TRUE

/datum/loadout_item/hammerhold_boots
	name = "Хаммерхолдские сапоги"
	category = list("Обувь", "Донат")
	path = /obj/item/clothing/shoes/roguetown/boots/hammerhold_boots
	donatitem = TRUE


// Aria Mrix Start

/datum/loadout_item/aria_bikini
	name = "Aria bikini"
	category = list("Донат")
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/aria
	donatitem = TRUE
	ckeywhitelist = list("mrix")

/datum/loadout_item/aria_pants
	name = "Aria pants"
	category = list("Донат")
	path = /obj/item/clothing/under/roguetown/trou/leather/aria
	donatitem = TRUE
	ckeywhitelist = list("mrix")

/datum/loadout_item/aria_wrists
	name = "Aria wrists"
	category = list("Донат")
	path = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk/aria
	donatitem = TRUE
	ckeywhitelist = list("mrix")

/datum/loadout_item/aria_necklace
	name = "Aria necklace"
	category = list("Донат")
	path = /obj/item/clothing/neck/roguetown/leather/aria
	donatitem = TRUE
	ckeywhitelist = list("mrix")

/datum/loadout_item/aria_gloves
	name = "Aria bondaged gloves"
	category = list("Донат")
	path = /obj/item/clothing/gloves/roguetown/bandages/pugilist/aria
	donatitem = TRUE
	ckeywhitelist = list("mrix")

/datum/loadout_item/aria_belt
	name = "Aria belt"
	category = list("Донат")
	path = /obj/item/storage/belt/rogue/leather/aria
	donatitem = TRUE
	ckeywhitelist = list("mrix")

/datum/loadout_item/aria_bondage
	name = "Aria feet bondage"
	category = list("Донат")
	path = /obj/item/clothing/shoes/roguetown/boots/leather/aria
	donatitem = TRUE
	ckeywhitelist = list("mrix")

// Aria Mrix End
