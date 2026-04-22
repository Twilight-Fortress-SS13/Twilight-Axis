/// Read-only TAT preset definition used by UI to load authored builds into the current draft.
/datum/tat_preset
	var/id = "base"
	var/name = "Preset"
	var/list/build_data = list()

/datum/tat_preset/New()
	. = ..()
	if(!istext(id) || !length(id))
		id = "[type]"
	if(!istext(name) || !length(name))
		name = "Preset"
	if(!islist(build_data))
		build_data = list()

/datum/tat_preset/proc/export_to_ui_payload(datum/tat_build/build_owner)
	var/list/summary = list(
		"stats" = 0,
		"skills" = 0,
		"traits" = 0,
		"items" = 0,
	)
	if(istype(build_owner, /datum/tat_build))
		summary = build_owner.build_slot_summary_from_data(build_data)
	return list(
		"id" = id,
		"name" = name,
		"summary" = summary,
	)

/datum/tat_preset/proc/get_build_data()
	return islist(build_data) ? build_data.Copy() : list()

/datum/tat_preset/sample/knight
	id = "knight"
	name = "Лыцарь"
	build_data = list(
		"stats" = list(
			STATKEY_STR = 11,
			STATKEY_CON = 11,
			STATKEY_WIL = 11,
		),

		"skills" = list(
			/datum/skill/combat/swords = 4,
			/datum/skill/misc/athletics = 2,
			/datum/skill/misc/climbing = 1,
			/datum/skill/misc/swimming = 1,
		),

		"traits" = list(
			TAT_TRAIT_WARRIOR_EXPERT = TRUE,
			TRAIT_HEAVYARMOR = TRUE,
			TAT_TRAIT_STEEL_SUPPLIER = TRUE,
			TAT_TRAIT_PLATE_SUPPLIER = TRUE,
			TRAIT_OUTLANDER = TRUE,
		),

		"items" = list(
			/obj/item/rogueweapon/sword = 1,
			/obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron = 1,
			/obj/item/clothing/mask/rogue/facemask/steel = 1,
			/obj/item/clothing/neck/roguetown/bevor/iron = 1,
			/obj/item/clothing/suit/roguetown/armor/plate/full/iron = 1,
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = 1,
			/obj/item/clothing/gloves/roguetown/plate/iron = 1,
			/obj/item/clothing/under/roguetown/platelegs/iron = 1,
			/obj/item/clothing/shoes/roguetown/boots/armor = 1,
			/obj/item/clothing/wrists/roguetown/bracers = 1,
			/obj/item/storage/belt/rogue/leather/steel/tasset = 1,
		),

		"item_loadout" = list(
			/obj/item/rogueweapon/sword = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/mask/rogue/facemask/steel = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/neck/roguetown/bevor/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/armor/plate/full/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/suit/roguetown/shirt/undershirt/black = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/gloves/roguetown/plate/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/under/roguetown/platelegs/iron = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/shoes/roguetown/boots/armor = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/clothing/wrists/roguetown/bracers = list(
				"equip" = 1,
				"bag" = 0,
			),
			/obj/item/storage/belt/rogue/leather/steel/tasset = list(
				"equip" = 1,
				"bag" = 0,
			),
		),

		"magic_config" = list(),
	)
