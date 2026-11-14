/datum/supply_pack/rogue/Mage/studded_bikini
	name = "Studded Leather Corslet"
	cost = 40
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/studded/bikini)

/datum/supply_pack/rogue/Mage/leather_bikini
	name = "Leather Corslet"
	cost = 10
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/bikini)

/datum/supply_pack/rogue/Mage/hide_bikini
	name = "Hide Corslet"
	cost = 35
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini)

/datum/supply_pack/rogue/Mage/cinnabar
	name = "Cinnabar Ore"
	cost = 30
	contains = list(/obj/item/rogueore/cinnabar = 1)

// Оверрайдим и дополняем оффовские имплементы для Hedge Mage, цены сфорированы как "(база + гем) * 0.67"
/datum/supply_pack/rogue/Mage/lesser_implement
	name = "Amythortz Staff"
	cost = 35
	contains = list(/obj/item/rogueweapon/woodstaff/implement/amethyst)

/datum/supply_pack/rogue/Mage/greater_implement
	name = "Gemerald Staff"
	cost = 65
	contains = list(/obj/item/rogueweapon/woodstaff/implement/greater)

/datum/supply_pack/rogue/Mage/grand_implement
	name = "Dorpel Staff"
	cost = 145
	contains = list(/obj/item/rogueweapon/woodstaff/implement/grand)

/datum/supply_pack/rogue/Mage/book
	name = "Amythortz Tome"
	cost = 50
	contains = list(/obj/item/rogueweapon/spellbook)

/datum/supply_pack/rogue/Mage/book/gemerald
	name = "Gemerald Tome"
	cost = 80
	contains = list(/obj/item/rogueweapon/spellbook/greater)

/datum/supply_pack/rogue/Mage/book/dorpel
	name = "Dorpel Tome"
	cost = 160
	contains = list(/obj/item/rogueweapon/spellbook/grand)
