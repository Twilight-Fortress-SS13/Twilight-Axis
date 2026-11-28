// Чтобы не плодить подклассы на каждый рескин, мы просто храним их как текст в табличке.
#define STAFF_SKIN(_name, _desc, _icon, _state_base) list("name" = _name, "desc" = _desc, "icon" = _icon, "state_base" = _state_base)

GLOBAL_LIST_INIT(staff_skins, list(
	"plain" = STAFF_SKIN(null, null, null, null),
	"bronze" = STAFF_SKIN( \
		"bronze staff", \
		"A staff made of polished wood and bronze, modeled after Grenzelhoftian fashion. Its crown holds a focus-gem that returns a share of spent spell energy to the wielder.", \
		'modular_twilight_axis/icons/obj/items/staffs.dmi', \
		"bronze" \
	),
	"bone" = STAFF_SKIN( \
		"bone staff", \
		"Knuckles and vertebrae threaded along a bleached femur. Its crown holds a focus-gem that returns a share of spent spell energy to the wielder.", \
		'modular_twilight_axis/icons/obj/items/staffs.dmi', \
		"bone_staff" \
	),
	"wilted" = STAFF_SKIN( \
		"wilted staff", \
		"A tree branch that somehow grew into a perfect staff. Its crown holds a focus-gem that returns a share of spent spell energy to the wielder.", \
		'modular_twilight_axis/icons/obj/items/staffs.dmi', \
		"wilted" \
	),
	"druid" = STAFF_SKIN( \
		"druid staff", \
		"Living wood that never stopped growing, fresh leaves still budding along its length. Its crown holds a focus-gem that returns a share of spent spell energy to the wielder.", \
		'modular_twilight_axis/icons/obj/items/staffs.dmi', \
		"druid" \
	),
	"allmight" = STAFF_SKIN( \
		"allmight staff", \
		"Holding this regal staff, you feel answerable to no one. Its crown holds a focus-gem that returns a share of spent spell energy to the wielder.", \
		'modular_twilight_axis/icons/obj/items/staffs.dmi', \
		"allmight" \
	),
))

#undef STAFF_SKIN

// Заменяет описание и спрайт посоха по ключу из GLOB.staff_skins
/obj/item/rogueweapon/woodstaff/implement/proc/apply_staff_skin(key)
	var/list/skin = GLOB.staff_skins[key]
	if(!skin)
		return FALSE
	implement_noun = skin["name"] || initial(implement_noun)
	desc = skin["desc"] || initial(desc)
	icon = skin["icon"] || initial(icon)
	gem_state_base = skin["state_base"] || initial(gem_state_base)
	update_gem_state()
	return TRUE


/datum/outfit
	var/skinned_staff_type  // Посох для рескина после экипировки
	var/staff_skin

// Диалоговое окно с выбором скина при спавне
/datum/outfit/proc/choose_staff(mob/living/carbon/human/H, staff_type)
	var/static/list/choices

	if(!choices)
		choices = list()
		for(var/key in GLOB.staff_skins)
			choices["[capitalize(key)] staff"] = key

	var/choice = tgui_input_list(H, "Choose your staff.", "STAFF", choices)
	if(choice)
		skinned_staff_type = staff_type
		staff_skin = choices[choice]

	return staff_type

/datum/outfit/equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	. = ..()
	if(!staff_skin)
		return

	for(var/obj/item/rogueweapon/woodstaff/implement/staff in H.get_all_contents())
		if(staff.type == skinned_staff_type)
			staff.apply_staff_skin(staff_skin)
			break
