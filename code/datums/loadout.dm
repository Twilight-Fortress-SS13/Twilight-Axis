GLOBAL_LIST_EMPTY(loadout_items)
GLOBAL_LIST_EMPTY(loadout_items_by_name)
GLOBAL_LIST_EMPTY(loadout_items_by_category)

/datum/loadout_item
	var/name = "Parent loadout datum"
	var/save_key // TA EDIT - Keep saved selections independent of display names.
	var/desc
	var/atom/movable/path
	var/donoritem			//autoset on new if null
	var/donatitem = FALSE
	var/donat_tier = 0
	var/list/ckeywhitelist
	var/list/donat_ignore
	var/triumph_cost = 0
	var/category = "Разное"

/datum/loadout_item/New()
	if(isnull(donoritem))
		if(ckeywhitelist)
			donoritem = TRUE

	if(!path)
		desc = desc || ""
		return

	var/obj/targetitem = path
	desc = targetitem?.desc || desc || ""
	if(donat_tier > 0)
		if(length(desc))
			desc += " "
		desc += "<b>Доступно для меценатов уровня: [donat_tier]</b>"

/datum/loadout_item/proc/get_loadout_save_key() // TA EDIT
	return save_key || name

/datum/loadout_item/proc/donator_ckey_check(key)
	key = ckey(key)
	if(ckeywhitelist && ckeywhitelist.Find(key))
		return TRUE
	return FALSE

/datum/loadout_item/proc/donat_ignore_ckey_check(key)
	key = ckey(key)
	if(donat_ignore && donat_ignore.Find(key))
		return TRUE
	return FALSE

/datum/loadout_item/proc/get_loadout_lock_reason(mob/user)
	if(!user?.ckey)
		return "Недоступно."

	if(ckeywhitelist && !donator_ckey_check(user.ckey))
		return "Недоступно."

	if(donat_ignore_ckey_check(user.ckey))
		return null

	var/donat_level = check_patreon_lvl(user.ckey)

	if(donatitem && !donat_level)
		return "Требуется донат-статус."

	if(donat_tier > 0 && donat_level < donat_tier)
		return "Требуется уровень мецената: [donat_tier]."

	return null

/proc/get_donator_triumph_discount(key)
	key = ckey(key)
	if(!key)
		return 0

	switch(check_patreon_lvl(key))
		if(1)
			return 3
		if(2)
			return 5
		if(3)
			return 7
		if(4)
			return 10
		if(5)
			return 15

	if(is_donator(key))
		return 3

	return 0

//Miscellaneous
/datum/loadout_item/card_deck
	name = "Card Deck"
	category = "Разное"
	path = /obj/item/deck/playing_cards

/datum/loadout_item/farkle_dice
	name = "Farkle Dice Container"
	category = "Разное"
	path = /obj/item/storage/pill_bottle/dice/farkle

/datum/loadout_item/tarot_deck
	name = "Tarot Deck"
	category = "Разное"
	path = /obj/item/deck/tarot/includes_minor_arcana

/datum/loadout_item/tarot_deck_majorarcana
	name = "Tarot Deck (Major Arcana)"
	category = "Разное"
	path = /obj/item/deck/tarot

/datum/loadout_item/bibble
	name = "The Verses and Acts of the Ten"
	category = "Разное"
	path = /obj/item/book/rogue/bibble

/datum/loadout_item/bibble_psy
	name = "Psy Bible"
	category = "Разное"
	path = /obj/item/book/rogue/bibble/psy

/datum/loadout_item/custom_book
	name = "Custom Book"
	category = "Разное"
	path = /obj/item/book/rogue/loadoutbook

//TOOLS
/datum/loadout_item/paper_parasol
	name = "Paper Parasol"
	category = "Разное"
	path = /obj/item/rogueweapon/mace/parasol

/datum/loadout_item/broom
	name = "Broom"
	category = list("Разное", "Триумфы")
	path = /obj/item/broom
	triumph_cost = 3

/datum/loadout_item/bucket
	name = "Bucket"
	category = list("Разное", "Триумфы")
	path = /obj/item/reagent_containers/glass/bucket
	triumph_cost = 3

/datum/loadout_item/needle
	name = "Sewing Needle"
	category = list("Разное", "Триумфы")
	path = /obj/item/needle/thorn
	triumph_cost = 2

/datum/loadout_item/whetstone
	name = "Whetstone"
	category = list("Разное", "Триумфы")
	path = /obj/item/natural/whetstone
	triumph_cost = 2

/datum/loadout_item/hammer
	name = "Wood Mallet"
	category = list("Разное", "Триумфы")
	path = /obj/item/rogueweapon/hammer/wood
	triumph_cost = 4

/datum/loadout_item/axe
	name = "Stone Axe"
	category = list("Разное", "Триумфы")
	path = /obj/item/rogueweapon/stoneaxe
	triumph_cost = 4

/datum/loadout_item/knife
	name = "Stone Knife"
	category = list("Разное", "Триумфы")
	path = /obj/item/rogueweapon/huntingknife/stoneknife
	triumph_cost = 3

/datum/loadout_item/hoe
	name = "Stone Hoe"
	category = list("Разное", "Триумфы")
	path = /obj/item/rogueweapon/hoe/stone
	triumph_cost = 4

/datum/loadout_item/spade
	name = "Wood Spade"
	category = list("Разное", "Триумфы")
	path = /obj/item/rogueweapon/shovel/small
	triumph_cost = 4

/datum/loadout_item/mirror
	name = "Hand Mirror"
	category = list("Разное", "Триумфы")
	path = /obj/item/handmirror
	triumph_cost = 6

//HATS

/datum/loadout_item/chaperon
	name = "Chaperon (Normal)"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/chaperon

/datum/loadout_item/chaperon/alt
	name = "Chaperon (Alt)"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/chaperon/greyscale

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
	name = "Archer's Cap"
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

/datum/loadout_item/tw_d_horns
	name = "Horns Helmkleinod"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_horns
	triumph_cost = 20

/datum/loadout_item/tw_d_basic
	name = "Helm's Chaperon"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_basic

/datum/loadout_item/tw_d_castle_red
	name = "Castle Helmkleinod"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_castle_red
	triumph_cost = 20

/datum/loadout_item/tw_d_graggar
	name = "Bloodied Star Helmkleinod"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_graggar
	triumph_cost = 20

/datum/loadout_item/tw_d_efreet
	name = "Afreet Helmkleinod"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_efreet
	triumph_cost = 15

/datum/loadout_item/tw_d_feathers
	name = "Feathers Accessory"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_feathers
	triumph_cost = 15

/datum/loadout_item/tw_d_oathtaker
	name = "Oathtaker Symbol"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_oathtaker
	triumph_cost = 15

/datum/loadout_item/tw_d_windmill
	name = "Windmill Helmkleinod"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_windmill
	triumph_cost = 15

/datum/loadout_item/tw_d_swan
	name = "Swan on Lake"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_swan
	triumph_cost = 15

/datum/loadout_item/tw_d_dragon_red
	name = "Dragon's Dread"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/onhelm/tw_d_dragon_red
	triumph_cost = 15

/datum/loadout_item/antlers
	name = "Old Antlers"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/antlers

/datum/loadout_item/headscarf
	name = "Head Scarf"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/hscarf

/datum/loadout_item/tengai
	name = "Tengai"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/tengai

/datum/loadout_item/burgerhood
	name = "Noble Hood"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/roguehood/burgerhood

/datum/loadout_item/gasa
	name = "Gasa"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/gasa

/datum/loadout_item/torioigasa
	name = "Torioigasa"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/torioigasa

/datum/loadout_item/roningasa
	name = "Roningasa"
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

/datum/loadout_item/loudmouth_headgear
	name = "Loudmouth's Headcover"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/veiled/loudmouth
	donat_tier = 2

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

/datum/loadout_item/bandolier
	name = "Bandolier"
	category = "Плащи"
	path = /obj/item/clothing/cloak/bandolier

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

/datum/loadout_item/wickercloak
	name = "Wicker Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/wickercloak

/datum/loadout_item/direcloak
	name = "Direbear Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/darkcloak/bear

/datum/loadout_item/lightdirecloak
	name = "Light Direbear Cloak"
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

/datum/loadout_item/surcoatheavy
	name = "Surcoat, Overvestments"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/tabard/stabard/overvestments
	triumph_cost = 3

/datum/loadout_item/surcoatgoldenorder
	name = "Surcoat, Golden Order"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/tabard/stabard/crusader
	triumph_cost = 3

/datum/loadout_item/surcoatsilverorder
	name = "Surcoat, Silver Order"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t
	triumph_cost = 3

/datum/loadout_item/surcoatgoldenorderast
	name = "Surcoat, Golden Order, Astratan"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/astrata
	triumph_cost = 3

/datum/loadout_item/surcoatsilverorderast
	name = "Surcoat, Silver Order, Astratan"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t/astrata
	triumph_cost = 3

/datum/loadout_item/surcoatgoldenorderuni
	name = "Surcoat, Golden Order, Undivided"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/undivided
	triumph_cost = 3

/datum/loadout_item/surcoatsilverorderuni
	name = "Surcoat, Silver Order, Undivided"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/tabard/stabard/crusader/t/undivided
	triumph_cost = 3

/datum/loadout_item/ranger_cloak
	name = "Ranger Cloak, Forest Green"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/rangercloak
	triumph_cost = 5

/datum/loadout_item/ranger_cloak_gray
	name = "Ranger Cloak, Neutral Gray"
	category = list("Плащи", "Триумфы")
	path = /obj/item/clothing/cloak/rangercloak/gray
	triumph_cost = 5

/datum/loadout_item/scaledcloak
	name = "Scaled Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/scaledcloak

/datum/loadout_item/sleevedtabard
	name = "Tabard, Sleeved"
	category = "Плащи"
	path = /obj/item/clothing/cloak/sleevedtabard

/datum/loadout_item/toga
	name = "Toga, Robed"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard/toga

/datum/loadout_item/toga_dress
	name = "Toga, Dress"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard/toga/dress

//SHOES
/datum/loadout_item/leatherboots
	name = "Leather Boots"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/boots/leather

/datum/loadout_item/classicsandals
	name = "Classical Sandals"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/sandals/toga

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

/datum/loadout_item/silkanklets
	name = "Silk Anklets"
	category = list("Обувь", "Триумфы")
	path = /obj/item/clothing/shoes/roguetown/anklets
	triumph_cost = 4

/datum/loadout_item/rumaclanshoes
	name = "Raised Sandals"
	path = /obj/item/clothing/shoes/roguetown/armor/rumaclan/shitty
	category = "Обувь"

//SHIRTS
/datum/loadout_item/longcoat
	name = "Longcoat"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/armor/longcoat

/datum/loadout_item/slit_dress
	name = "Slitted dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/slit

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

/datum/loadout_item/silkbra
	name = "Giltsilk Bra"
	category = list("Одежда", "Триумфы")
	path = /obj/item/clothing/suit/roguetown/shirt/silkbra
	triumph_cost = 4

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

/datum/loadout_item/bandithood
	name = "Bandit Hood"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/menacing/bandit

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

/datum/loadout_item/formalskirt
	name = "Knee-High Skirt"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/skirt/formal

/datum/loadout_item/eastshirt2
	name = "White Foreign Shirt"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2

/datum/loadout_item/baredrobe
	name = "Bared Robe"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/bared

/datum/loadout_item/tights
	name = "Cloth Tights"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/tights/black

/datum/loadout_item/hosen
	name = "Cloth Hosen"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/tights/hose

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

/datum/loadout_item/belt_trousers
	name = "Belt-Buckled Trousers"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/trou/beltpants

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

/datum/loadout_item/thinspectacles
	name = "Thin Spectacles"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/spectacles/thin

/datum/loadout_item/fingerless
	name = "Fingerless Gloves"
	category = "Аксессуары"
	path = /obj/item/clothing/gloves/roguetown/fingerless

/datum/loadout_item/bandages
	name = "Bandages, Gloves"
	category = "Аксессуары"
	path = /obj/item/clothing/gloves/roguetown/bandages

/datum/loadout_item/silkbelt
	name = "Giltsilk Belt"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/storage/belt/rogue/leather/silkbelt
	triumph_cost = 5

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

/datum/loadout_item/tutorialbook
	name = "A Tutorialeer's Handbook"
	category = "Аксессуары"
	path = /obj/item/recipe_book/survival

/datum/loadout_item/ball
	name = "Ball"
	category = "Аксессуары"
	path = /obj/item/ball

/datum/loadout_item/silkmask
	name = "Giltsilk Mask"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/clothing/mask/rogue/silkmask
	triumph_cost = 4

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
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/storage/belt/rogue/leather/battleskirt
	triumph_cost = 3

/datum/loadout_item/fauldedbelt
	name = "Belt with faulds"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/storage/belt/rogue/leather/battleskirt/faulds
	triumph_cost = 3

/datum/loadout_item/doublebelt
	name = "Paired belts"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/storage/belt/rogue/leather/double
	triumph_cost = 4

/datum/loadout_item/knifebelt // comes empty
	name = "Tossblade Belt"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/storage/belt/rogue/leather/tossbelt/blade/black
	triumph_cost = 4

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

/datum/loadout_item/psicross/baotha
	name = "Amulet of Baotha"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha

/datum/loadout_item/psicross/gronnzizo
	name = "Wolf Talisman"
	category = list("Аксессуары")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn

/datum/loadout_item/psicross/gronnspider
	name = "Spider Talisman"
	category = list("Аксессуары")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/spider

/datum/loadout_item/psicross/gronnbaotha
	name = "Leopard Talisman"
	category = list("Аксессуары")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn

/datum/loadout_item/psicross/gronnmatthios
	name = "Bear Talisman"
	category = list("Аксессуары")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn

/datum/loadout_item/psicross/gronngraggar
	name = "Moose Talisman"
	category = list("Аксессуары")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn

/datum/loadout_item/psicross/gronndendor
	name = "Volfskinned Talisman"
	category = list("Аксессуары")
	path = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn

/datum/loadout_item/psicross/gronnabyssor
	name = "Hadal Talisman"
	category = list("Аксессуары")
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn

/datum/loadout_item/wedding_band
	name = "silver wedding band"
	category = "Аксессуары"
	path = /obj/item/clothing/ring/band

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
	category = "Разное"
	path = /obj/item/caparison

/datum/loadout_item/triumph_knife
	name = "Laborer's Knife"
	path = /obj/item/rogueweapon/huntingknife/throwingknife/triumph
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_necklace
	name = "Golden Necklace, Ornate"
	path = /obj/item/clothing/neck/roguetown/ornateamulet/noble/triumph
	category = list("Триумфы")
	triumph_cost = 7

/datum/loadout_item/triumph_ring
	name = "Golden Ring, Ornate"
	path = /obj/item/clothing/ring/gold/triumph
	category = list("Триумфы")
	triumph_cost = 7

/datum/loadout_item/triumph_circlet
	name = "Golden Circlet, Ornate"
	path = /obj/item/clothing/head/roguetown/circlet/triumph
	category = list("Триумфы")
	triumph_cost = 7

/datum/loadout_item/triumph_weaponkit_fancymace
	name = "Triumph Kit - Rungu-Shishpar Mace - Required: Iron Mace, an Iron Warhammer, a Steel Mace, a Steel Warhammer, or a Silver Mace"
	path = /obj/item/enchantingkit/triumph_weaponkit_fancymace
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_krisdagger
	name = "Triumph Kit - Kris - Required: Bauernwehr, a Combat Knife, an Iron Dagger, or a Steel Dagger"
	path = /obj/item/enchantingkit/triumph_weaponkit_kris
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_njoradagger
	name = "Triumph Kit - Njora - Required: Steel Dagger, an Iron Dagger, a Hunting Knife, or a Combat Knife"
	path = /obj/item/enchantingkit/triumph_weaponkit_njora
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_alloywhip
	name = "Triumph Kit - Alloytip Whip - Required: Bronze Whip, a Whip, or a Silver Whip"
	path = /obj/item/enchantingkit/triumph_weaponkit_whip
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_kaskara
	name = "Triumph Kit - Kaskara - Required: Iron Arming Sword, a Steel Arming Sword, or a Rapier"
	path = /obj/item/enchantingkit/weapon/triumph_weaponkit_kaskara
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_ida
	name = "Triumph Kit - Ida - Required: Iron Shortsword or a Steel Shortsword"
	path = /obj/item/enchantingkit/weapon/triumph_weaponkit_ida
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_hwi
	name = "Triumph Kit - Hwi - Required: Iron Hunting Sword, an Iron Dueling Messer, a Steel Messer, a Steel Hunting Sword, or a Falchion"
	path = /obj/item/enchantingkit/weapon/triumph_weaponkit_hwi
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_ngombe
	name = "Triumph Kit - Ngombe - Required: Iron Hunting Sword, an Iron Dueling Messer, a Steel Messer, a Steel Hunting Sword, or a Falchion"
	path = /obj/item/enchantingkit/weapon/triumph_weaponkit_ngombe
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_ada
	name = "Triumph Kit - Ada - Required: Iron Sabre, a Steel Sabre, a Falx, or a Falchion"
	path = /obj/item/enchantingkit/weapon/triumph_weaponkit_ada
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_sengese
	name = "Triumph Kit - Sengese - Required: Iron Sabre, a Steel Sabre, a Falx, or a Falchion"
	path = /obj/item/enchantingkit/weapon/triumph_weaponkit_sengese
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_clericsword
	name = "Triumph Kit - Clerical Longsword - Required: Long Sword"
	path = /obj/item/enchantingkit/weapon/triumph_weaponkit_clericsword
	category = list("Триумфы")
	triumph_cost = 6

// -5 TRI Minisection.

/datum/loadout_item/triumph_shortsatchel
	name = "Short Satchel"
	path = /obj/item/storage/backpack/rogue/satchel/short
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_waterskin
	name = "Waterskin"
	path = /obj/item/reagent_containers/glass/bottle/waterskin
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_messkit
	name = "Mess Kit"
	path = /obj/item/storage/gadget/messkit
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_foldtable
	name = "Folding Table"
	path = /obj/item/folding_table_stored
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_bedroll
	name = "Bedroll"
	path = /obj/item/bedroll
	category = list("Триумфы")
	triumph_cost = 5

/datum/loadout_item/triumph_scabbardnoble
	name = "Decorated Scabbard, Silver"
	path = /obj/item/rogueweapon/scabbard/sword/noble
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_sheathnoble
	name = "Decorated Sheath, Silver"
	path = /obj/item/rogueweapon/scabbard/sheath/noble
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_psycross
	name = "Golden Psycross, Ornate"
	path = /obj/item/clothing/neck/roguetown/psicross/g/triumph
	category = list("Триумфы")
	triumph_cost = 11

/datum/loadout_item/triumph_zcross
	name = "Golden Zizote Amulet, Ornate"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/g/triumph
	category = list("Триумфы")
	triumph_cost = 12

/datum/loadout_item/triumph_astcross
	name = "Golden Astratan Amulet, Ornate"
	path = /obj/item/clothing/neck/roguetown/psicross/astrata/g/triumph
	category = list("Триумфы")
	triumph_cost = 13

/datum/loadout_item/triumph_signet
	name = "Golden Signet Ring, Ornate"
	path = /obj/item/clothing/ring/signet/triumph
	category = list("Триумфы")
	triumph_cost = 13

/datum/loadout_item/triumph_gildedshirt
	name = "Gilded Dress Shirt"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_pristinedress
	name = "Pristine Dress"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_royalsleeves
	name = "Royal Sleeves"
	path = /obj/item/clothing/wrists/roguetown/royalsleeves
	category = list("Триумфы")
	triumph_cost = 6

/datum/loadout_item/triumph_goldhalfmask
	name = "Golden Halfmask, Ornate"
	path = /obj/item/clothing/mask/rogue/lordmask/triumph
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_goldfullmask
	name = "Golden Mask, Ornate"
	path = /obj/item/clothing/mask/rogue/facemask/goldmask/triumph
	category = list("Триумфы")
	triumph_cost = 13

/datum/loadout_item/triumph_goldfullmaskc
	name = "Crestless Golden Mask, Ornate"
	path = /obj/item/clothing/mask/rogue/facemask/goldmaskc/triumph
	category = list("Триумфы")
	triumph_cost = 13

/datum/loadout_item/triumph_weaponkit_estoc
	name = "Triumph Kit - Azurian Estoc - Required: Estoc or Stecher"
	path = /obj/item/enchantingkit/triumph_weaponkit_estoc
	category = list("Триумфы")
	triumph_cost = 6

//////////////////
//  PERFUMES !  //
//////////////////

/datum/loadout_item/triumph_perfume_lavender
	name = "Lavender Perfume"
	path = /obj/item/perfume/lavender
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_cherry
	name = "Cherry Perfume"
	path = /obj/item/perfume/cherry
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_rose
	name = "Rose Perfume"
	path = /obj/item/perfume/rose
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_jasmine
	name = "Jasmine Perfume"
	path = /obj/item/perfume/jasmine
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_mint
	name = "Mint Perfume"
	path = /obj/item/perfume/mint
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_vanilla
	name = "Vanilla Perfume"
	path = /obj/item/perfume/vanilla
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_pear
	name = "Pear Perfume"
	path = /obj/item/perfume/pear
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_strawberry
	name = "Strawberry Perfume"
	path = /obj/item/perfume/strawberry
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_cinnamon
	name = "Cinnamon Perfume"
	path = /obj/item/perfume/cinnamon
	category = list("Триумфы")
	triumph_cost = 2

/datum/loadout_item/triumph_perfume_frankincense
	name = "Frankincense Perfume"
	path = /obj/item/perfume/frankincense
	category = list("Триумфы")
	triumph_cost = 3

/datum/loadout_item/triumph_perfume_sandalwood
	name = "Sandalwood Perfume"
	path = /obj/item/perfume/sandalwood
	category = list("Триумфы")
	triumph_cost = 3

/datum/loadout_item/triumph_perfume_myrrh
	name = "Myrrh Perfume"
	path = /obj/item/perfume/myrrh
	category = list("Триумфы")
	triumph_cost = 3

/datum/loadout_item/triumph_fermented_crab
	name = "Fermented Crab"
	path = /obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab
	category = list("Триумфы")
	triumph_cost = 5

// -7 TRI Minisection.
/*
/datum/loadout_item/triumph_buttpack
	name = "Belted Satchel"
	path = /obj/item/storage/backpack/rogue/satchel/beltpack
	category = list("Триумфы")
	triumph_cost = 7
*/
/datum/loadout_item/triumph_lunchpouch
	name = "Pouch of Luncheons"
	path = /obj/item/storage/belt/rogue/pouch/triumphlunch
	category = list("Триумфы")
	triumph_cost = 8

/* /datum/loadout_item/triumph_grenzhat
	name = "Grenzelhoftian Beret"
	path = /obj/item/clothing/head/roguetown/grenzelhofthat/triumph
	category = list("Триумфы")
	triumph_cost = 7 */

/datum/loadout_item/triumph_lordcloak
	name = "Lordly Cloak"
	path = /obj/item/clothing/cloak/lordcloak
	category = list("Триумфы")
	triumph_cost = 10

/datum/loadout_item/triumph_ladycloak
	name = "Ladylike Cloak"
	path = /obj/item/clothing/cloak/lordcloak/ladycloak
	category = list("Триумфы")
	triumph_cost = 12

/datum/loadout_item/triumph_gdorpelring
	name = "Golden Dorpel Ring, Ornate"
	path = /obj/item/clothing/ring/diamond/triumph
	category = list("Триумфы")
	triumph_cost = 16


/datum/loadout_item/triumph_metalrepairkit
	name = "Repair Kit, Metal"
	path = /obj/item/repair_kit/metal/bad
	category = list("Триумфы")
	triumph_cost = 15

/datum/loadout_item/triumph_clothrepairkit
	name = "Repair Kit, Cloth"
	path = /obj/item/repair_kit/bad
	category = list("Триумфы")
	triumph_cost = 15

/datum/loadout_item/shawl
	name = "Shawl"
	path = /obj/item/clothing/head/roguetown/shawl
	category = "Головные уборы"

/* /datum/loadout_item/maidband
	name = "Maid Headdress"
	path = /obj/item/clothing/head/roguetown/maidhead
	category = list("Головные уборы", "Донат")
	donatitem = TRUE */

/* /datum/loadout_item/maidbandfancy
	name = "Valorian Maid Headband"
	path = /obj/item/clothing/head/roguetown/maidband
	category = list("Головные уборы", "Донат")
	donatitem = TRUE */

// Обувь

/datum/loadout_item/leathergloves
	name = "Leather Gloves"
	category = "Аксессуары"
	path = /obj/item/clothing/gloves/roguetown/leather

/datum/loadout_item/shadowmask
	name = "Purple Halfmask"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/shepherd/shadowmask

/datum/loadout_item/collar/collar
	name = "Collar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/collar

/datum/loadout_item/bell_collar/collar
	name = "Bell Collar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/collar/bell_collar

/datum/loadout_item/faceveil
	name = "Face Veil"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/faceveil

/datum/loadout_item/breechclothbelt
	name = "Belt with Breechcloth"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth
	triumph_cost = 3

/datum/loadout_item/greatplumestandalone
	name = "Helmet Decoration, Greatplume"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/clothing/head/roguetown/decoration/greatplume
	triumph_cost = 3

/datum/loadout_item/breechclothbeltalt
	name = "Black Belt with Breechcloth"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/blackbelt
	triumph_cost = 3

/datum/loadout_item/blackbelt
	name = "Black Belt"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/storage/belt/rogue/leather/black
	triumph_cost = 3

/datum/loadout_item/darkcloak
	name = "Dark Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/darkcloak

/datum/loadout_item/crusadercloak
	name = "Desert Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/cape/crusader

/datum/loadout_item/toga
	name = "Toga"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard/toga

/datum/loadout_item/cap
	name = "Cap"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/cap

/datum/loadout_item/tiyon
	name = "Tiyon"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/tiyon

/datum/loadout_item/longveil
	name = "Long Veil"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/longveil

/datum/loadout_item/durag
	name = "Durag"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/durag

/datum/loadout_item/chefhat
	name = "Chef's Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/chef

/datum/loadout_item/psicross/decrepit
	name = "Decrepit Psycross"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/aalloy

/datum/loadout_item/psicross/naledi
	name = "Naledian Psy-Bracelet"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/naledi

/datum/loadout_item/psicross/tooth_necklace
	name = "Tooth Necklace"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn/generic

/datum/loadout_item/triumph_satchel
	name = "Satchel"
	category = list("Разное", "Триумфы")
	path = /obj/item/storage/backpack/rogue/satchel
	triumph_cost = 7

/datum/loadout_item/triumph_satchelalt
	name = "Black Satchel"
	category = list("Разное", "Триумфы")
	path = /obj/item/storage/backpack/rogue/satchel/black
	triumph_cost = 7

/datum/loadout_item/cloth
	name = "Cloth"
	category = list("Разное", "Триумфы")
	path = /obj/item/natural/cloth
	triumph_cost = 2

/datum/loadout_item/psicross/noc/bronze
	name = "Bronze Amulet of Noc"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/noc/bronze
	triumph_cost = 2

/datum/loadout_item/psicross/ravox/bronze
	name = "Bronze Amulet of Ravox"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/ravox/bronze
	triumph_cost = 2

/datum/loadout_item/psicross/astrata/bronze
	name = "Bronze Amulet of Astrata"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/astrata/bronze
	triumph_cost = 2

/datum/loadout_item/psicross/malum/bronze
	name = "Bronze Amulet of Malum"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/malum/bronze
	triumph_cost = 2

/datum/loadout_item/psicross/inhumen/graggar/bronze
	name = "Bronze Amulet of Graggar"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	triumph_cost = 2

/datum/loadout_item/psicross/bronze
	name = "Bronze Psycross"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/bronze
	triumph_cost = 2

/datum/loadout_item/psicross/inhumen/bronze
	name = "Bronze Inverted Psycross"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/bronze
	triumph_cost = 2

/datum/loadout_item/psicross/paalloy
	name = "Ancient Psycross"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/paalloy
	triumph_cost = 2

/datum/loadout_item/psicross/inhumen/paalloy
	name = "Ancient Inverted Psycross"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/paalloy
	triumph_cost = 2

/datum/loadout_item/psicross/noc/paalloy
	name = "Ancient Amulet of Noc"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/noc/paalloy
	triumph_cost = 2

/datum/loadout_item/triumph_winterdress
	name = "Winter Dress"
	category = list("Триумфы")
	path = /obj/item/clothing/suit/roguetown/armor/armordress/winterdress
	triumph_cost = 4

/datum/loadout_item/triumph_steelbelt
	name = "Belt of Steel"
	category = list("Триумфы")
	path = /obj/item/storage/belt/rogue/leather/steel
	triumph_cost = 5

/datum/loadout_item/triumph_plaquesilverbelt
	name = "Belt of Plaque, Silver"
	category = list("Триумфы")
	path = /obj/item/storage/belt/rogue/leather/plaquesilver
	triumph_cost = 5

/datum/loadout_item/triumph_reformpsycross
	name = "Golden Reformist Psycross, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/reform/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_noccross
	name = "Golden Noccian Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/noc/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_abyssorcross
	name = "Golden Abyssorian Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/abyssor/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_dendorcross
	name = "Golden Dendorian Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/dendor/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_necracross
	name = "Golden Necran Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/necra/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_pestracross
	name = "Golden Pestran Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/pestra/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_ravoxcross
	name = "Golden Ravoxian Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/ravox/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_malumcross
	name = "Golden Malum Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/malum/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_eoracross
	name = "Golden Eoran Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/eora/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_xylixcross
	name = "Golden Xylixian Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/xylix/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_graggarcross
	name = "Golden Graggarite Amulet, Ornate"
	category = list("Триумфы")
	path = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/g/triumph
	triumph_cost = 13

/datum/loadout_item/triumph_tassetsteelbelt
	name = "Belt of Steel, Tasseted"
	category = list("Триумфы")
	path = /obj/item/storage/belt/rogue/leather/steel/tasset
	triumph_cost = 7

/datum/loadout_item/triumph_plaquegoldenbelt
	name = "Belt of Plaque, Golden"
	category = list("Триумфы")
	path = /obj/item/storage/belt/rogue/leather/plaquegold
	triumph_cost = 7

/datum/loadout_item/triumph_scabbardroyal
	name = "Decorated Scabbard, Golden"
	category = list("Триумфы")
	path = /obj/item/rogueweapon/scabbard/sword/royal
	triumph_cost = 13

/datum/loadout_item/triumph_sheathroyal
	name = "Decorated Sheath, Golden"
	category = list("Триумфы")
	path = /obj/item/rogueweapon/scabbard/sheath/royal
	triumph_cost = 13

/datum/loadout_item/beltshawl
	name = "Belt Shawl"
	category = "Аксессуары"
	path = /obj/item/storage/belt/rogue/leather/beltshawl

/datum/loadout_item/pouched_suspenders
	name = "Pouched Suspenders"
	category = "Плащи"
	path = /obj/item/clothing/cloak/suspenders

/datum/loadout_item/sash
	name = "Sash"
	category = "Плащи"
	path = /obj/item/clothing/cloak/sash

/datum/loadout_item/thorn_rosa_crown
	name = "Rosa Crown with Thorns"
	category = "Головные уборы"
	path = /obj/item/flowercrown/rosa/thorns

/datum/loadout_item/dyeable_crown
	name = "Gray Flower Crown"
	category = "Головные уборы"
	path = /obj/item/flowercrown/rosa/dyecrown

/datum/loadout_item/dhoti
	name = "Dhoti"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/tights/dhoti

/datum/loadout_item/saree
	name = "Saree"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/saree

/datum/loadout_item/furboots
	name = "Fur Boots"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/boots/furlinedboots

/datum/loadout_item/triumph_plaquegoldenbeltfancy
	name = "Belt of Plaque, Golden, Fancy"
	category = list("Триумфы")
	path = /obj/item/storage/belt/rogue/leather/plaquegold/noble
	triumph_cost = 7

/datum/loadout_item/triumph_armorkit_slimmedsteel
	name = "Triumph Kit - Slimfitted Steel Armor - Required: Steel Halfplate, Fluted Halfplate, Steel Plate Armor or Fluted Plate Armor"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_armorkit_slimmedsteel
	triumph_cost = 8

/datum/loadout_item/triumph_weaponkit_classicdaggers
	name = "Triumph Kit - Classic Daggers - Required: Iron Dagger or Steel Dagger"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_weaponkit_classicdaggers
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_psyswords
	name = "Triumph Kit - Slimguarded Psydonic Longsword - Required: Psydonic Longsword or Enduring Longsword"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_weaponkit_psyswords
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_clasiscbeakhelm
	name = "Triumph Kit - Valorian Beak Helmet - Required: Sugarloaf Helmet or Ravoxian Templar Helmet"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_armorkit_classicbeakhelm
	triumph_cost = 6

/datum/loadout_item/triumph_weaponkit_classicpsymace
	name = "Triumph Kit - Classic Psydonic Handmace - Required: Psydonic Handmace or Enduring Handmace"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_weaponkit_psymace
	triumph_cost = 6

/datum/loadout_item/featherplumestandalone
	name = "Standalone Decoration, Featherplume"
	category = list("Триумфы")
	path = /obj/item/clothing/head/roguetown/decoration/featherplume
	triumph_cost = 7

/datum/loadout_item/crestplumestandalone
	name = "Standalone Decoration, Crestplume"
	category = list("Триумфы")
	path = /obj/item/clothing/head/roguetown/decoration/crestplume
	triumph_cost = 7

/datum/loadout_item/orlestandalone
	name = "Standalone Decoration, Orle"
	category = list("Триумфы")
	path = /obj/item/clothing/head/roguetown/decoration/orle/donator_dyeable
	triumph_cost = 7

/datum/loadout_item/flimsy_visor
	name = "Helmetless Visor"
	category = "Аксессуары"
	category = list("Аксессуары", "Триумфы")
	path = /obj/item/clothing/mask/rogue/facemask/steel/visor/flimsy
	triumph_cost = 4

/datum/loadout_item/furcollar
	name = "Fur Collar"
	category = "Аксессуары"
	path = /obj/item/clothing/neck/roguetown/collar/fur

/datum/loadout_item/scoutcloak
	name = "Scout Cloak"
	category = "Плащи"
	path = /obj/item/clothing/cloak/scout

/datum/loadout_item/traditionaltabard
	name = "Traditional Tabard, Psydonic"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard/psydontabard/white

/datum/loadout_item/fancycoattrimmed
	name = "Trimmed Fancy Coat"
	category = "Плащи"
	path = /obj/item/clothing/cloak/poncho/fancycoat/trimmed


/datum/loadout_item/shawlhood
	name = "Shawl (Hijab Variant)"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/roguehood/shawlhood


/datum/loadout_item/shortskirt
	name = "Short Skirt"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/skirt/short


/datum/loadout_item/silkshirt
	name = "Silk Shirt"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/shadowshirt

/datum/loadout_item/darkjacket
	name = "Dark Jacket"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/fancyjacket/triumph_padded

/datum/loadout_item/shalwarpants
	name = "Shalwar Pants"
	category = "Одежда"
	path = /obj/item/clothing/under/roguetown/tights/shalwar

/datum/loadout_item/greendress
	name = "Light Green Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/green

/datum/loadout_item/bluedress
	name = "Light Blue Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/blue

/datum/loadout_item/taverndress
	name = "Tavern Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/tavern

/datum/loadout_item/courtesandress
	name = "Courtesan Dress"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/courtesan

/datum/loadout_item/nightgown
	name = "Nightgown"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/nightgown

/datum/loadout_item/wintercoat
	name = "Winter Coat"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/winter

/datum/loadout_item/blouse
	name = "Blouse"
	category = "Одежда"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/blouse

/datum/loadout_item/triumph_armorkit_pleather
	name = "Triumph Kit - Padded Leather Armor - Required: Leather Armor, Leather Cuirass, Studded Leather Armor or Hardened Leather Armor"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_armorkit_pleather
	triumph_cost = 12

/datum/loadout_item/triumph_weaponkit_khanda
	name = "Triumph Kit - Khanda - Required: Iron Arming Sword, Steel Arming Sword, Silver Arming Sword or Bronze Arming Sword"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_weaponkit_khanda
	triumph_cost = 12

/datum/loadout_item/triumph_weaponkit_urumi
	name = "Triumph Kit - Urumi - Required: Whip, Bronze Whip, Silver Whip or Blacksteel Whip"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_weaponkit_urumi
	triumph_cost = 12

/datum/loadout_item/triumph_weaponkit_pata
	name = "Triumph Kit - Pata - Required: Steel Katar, Silver Katar or Bronze Katar"
	category = list("Триумфы")
	path = /obj/item/enchantingkit/triumph_weaponkit_pata
	triumph_cost = 12

/datum/loadout_item/triumph_thinwinterdress
	name = "Thin Winter Dress"
	category = list("Одежда", "Триумфы")
	path = /obj/item/clothing/suit/roguetown/shirt/tunic/thinwinterdress/triumph
	triumph_cost = 6

/datum/loadout_item/taur_plate
	name = "Tauric Plate Armor Morphing Elixir - Required: Any Full Plate Armor"
	category = "Броня"
	path = /obj/item/enchantingkit/taur_armor_plate

/datum/loadout_item/taur_gambeson
	name = "Tauric Gambeson Morphing Elixir - Required: Heavy Padded Gambeson"
	category = "Броня"
	path = /obj/item/enchantingkit/taur_armor_gambeson

/datum/loadout_item/taur_tabard
	name = "feline taur tabard"
	category = "Плащи"
	path = /obj/item/clothing/cloak/t_tabard/taur

/datum/loadout_item/taur_t_tabard
	name = "feline tightened taur tabard"
	category = "Плащи"
	path = /obj/item/clothing/cloak/t_tabard/taur/tightened

/datum/loadout_item/taur_hauberk
	name = "Feline Taur Hauberk Morphing Elixir - Required: Any Hauberk"
	category = "Броня"
	path = /obj/item/enchantingkit/taur_armor_hauberk

/datum/loadout_item/taur_footwraps
	name = "feline taur footwraps"
	category = "Обувь"
	path = /obj/item/clothing/shoes/roguetown/felinetaur


/datum/loadout_item/donator/dragontea_hat
	name = "Greathat, Dyeable"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/duelhat/dragontea
	triumph_cost = 5

/datum/loadout_item/donator/dragontea_featherhat
	name = "Etruscan Design Hat"
	category = list("Головные уборы", "Триумфы")
	path = /obj/item/clothing/head/roguetown/duelisthat/dragontea

/datum/loadout_item/clothloincloth
	name = "Belt with Loincloth"
	category = "Аксессуары"
	path = /obj/item/storage/belt/rogue/leather/battleskirt/loincloth

/datum/loadout_item/carapacedmask
	name = "Ceramic Mask"
	category = "Аксессуары"
	path = /obj/item/clothing/mask/rogue/xylixmask/ceramic

/datum/loadout_item/belthooks
	name = "Belt Hooks"
	category = "Аксессуары"
	path = /obj/item/storage/belt/rogue/leather/belthooks

/datum/loadout_item/sash_dupatta
	name = "Sash, Dupatta"
	category = "Плащи"
	path = /obj/item/clothing/cloak/sash/dupatta

/datum/loadout_item/duelistscloak
	name = "Duelist's Cape"
	category = "Плащи"
	path = /obj/item/clothing/cloak/half/duelcape

/datum/loadout_item/furheadband
	name = "Fur Headband"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/headband/fur

/datum/loadout_item/turban
	name = "Turban"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/turban

/datum/loadout_item/duelisthat
	name = "Dashing Feathered Hat"
	category = "Головные уборы"
	path = /obj/item/clothing/head/roguetown/duelisthat

/datum/loadout_item/card_deck_triple
	name = "Card Deck (3x Cards)"
	category = "Разное"
	path = /obj/item/deck/playing_cards/triple

/datum/loadout_item/triumph_satcheltail
	name = "Tail Satchel"
	category = "Разное"
	path = /obj/item/storage/backpack/rogue/satchel/tailchel

/datum/loadout_item/triumph_blackshortsatchel
	name = "Short Satchel, Black"
	category = "Триумфы"
	path = /obj/item/storage/backpack/rogue/satchel/short/black
	triumph_cost = 5

//ЧАСЫ БЛЯДЬ

/datum/loadout_item/clock_g
	name = "gold handclock"
	category = list("Триумфы")
	path = /obj/item/clock_capped
	triumph_cost = 5

/datum/loadout_item/clock_s
	name = "silver handclock"
	category = list("Триумфы")
	path = /obj/item/clock_capped/silver
	triumph_cost = 5

/datum/loadout_item/clock_br
	name = "bronze handclock"
	category = list("Триумфы")
	path = /obj/item/clock
	triumph_cost = 2

/datum/loadout_item/clock_i
	name = "iron handclock"
	category = list("Триумфы")
	path = /obj/item/clock/iron
	triumph_cost = 2

/datum/loadout_item/saigatabard
	name = "Saiga Tabard"
	category = "Плащи"
	path = /obj/item/clothing/cloak/tabard/saiga
