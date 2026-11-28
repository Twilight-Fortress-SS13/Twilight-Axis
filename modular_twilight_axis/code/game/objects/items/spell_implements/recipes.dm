/datum/crafting_recipe/roguetown/survival/unfitted_staff
	name = "unfitted mage staff"
	display_category = ITEM_CAT_WEAPONS_POLEARMS
	category = "Tools"
	result = list(/obj/item/rogueweapon/woodstaff/implement/empty)
	reqs = list(/obj/item/grown/log/tree = 1)
	tools = list(/obj/item/rogueweapon/huntingknife)
	skillcraft = /datum/skill/craft/carpentry  // Пустые посохи используют Carpentry по аналогии с квотерстаффами
	craftdiff = 1

/datum/crafting_recipe/roguetown/arcana/tome/empty
	name = "unfitted tome"
	result = /obj/item/rogueweapon/spellbook/empty
	reqs = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/paper = 3,
	)
	tools = list(/obj/item/needle)
	subtype_reqs = FALSE
