#define ARMOR_NEWMOON_HOOD list("blunt" = 50, "slash" = 85, "stab" = 97, "piercing" = 93, "fire" = 0, "acid" = 0)
#define ARMOR_NEWMOON_JACKET list("blunt" = 70, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 0, "acid" = 0)
#define ARMOR_NEWMOON_MASK list("blunt" = 5, "slash" = 15, "stab" = 15, "piercing" = 15, "fire" = 0, "acid" = 0)

/obj/item/clothing/head/roguetown/roguehood/newmoon
	name = "newmoon hood"
	desc = "Сотканный из плотного материала капюшон Новолунья. Достаточно крепок на разрыв и ощущается теплым за счет подкладки. Секрет изготовления ткани остается загадкой даже для самих Новолунцев."
	color = "#78a3c9"
	armor = ARMOR_NEWMOON_HOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	body_parts_covered = HEAD|HAIR|EARS|NOSE|NECK
	max_integrity = 230
	armor_class = ARMOR_CLASS_MEDIUM
	alternate_worn_layer = HOOD_LAYER

/obj/item/clothing/suit/roguetown/armor/leather/newmoon_jacket
	name = "newmoon jacket"
	desc = "Увесистое, нарядное, но при этом достаточно защищенное пальто из плотной и крепкой ткани. Является отличительным знаком Священного Ордена Новолуния с амулетом Нок в центре нагрудника. Кричащий символ радикального Ноктизма."
	icon = 'modular_twilight_axis/church_classes/icons/spellblade_clothes.dmi'
	mob_overlay_icon = 'modular_twilight_axis/church_classes/icons/spellblade_clothes.dmi'
	icon_state = "newmoon_jacket"
	item_state = "newmoon_jacket"
	blocksound = SOFTHIT
	armor = ARMOR_NEWMOON_JACKET
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP)
	nodismemsleeves = TRUE
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	max_integrity = 300
	armor_class = ARMOR_CLASS_MEDIUM

/obj/item/clothing/mask/rogue/ragmask/newmoon 
	name = "newmoon mask"
	desc = "Маска сотканная из шелковистого хорошодышащего материала."
	color = "#78a3c9"
	armor = ARMOR_NEWMOON_MASK
	body_parts_covered = FACE
	alternate_worn_layer = NECK_LAYER

/obj/item/clothing/mask/rogue/ragmask/newmoon/MiddleClick(mob/user) 
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear \the [src] under my hair" : "wear \the [src] over my hair"]."))
	if(overarmor)
		alternate_worn_layer = NECK_LAYER //Below Hair Layer
	else
		alternate_worn_layer = BACK_LAYER //Above Hair Layer
	user.update_inv_wear_mask()


/obj/item/clothing/suit/roguetown/shirt/tunic/newmoon
	name = "newmoon tunic"
	color = "#78a3c9"

/obj/item/clothing/cloak/half/newmoon
	name = "newmoon cloak"
	color = "#78a3c9"
