// Чтобы не плодить подклассы на каждый рескин, мы просто храним их как текст в табличке.
#define STAFF_SKIN(_name, _desc, _icon, _state_base) list("name" = _name, "desc" = _desc, "icon" = _icon, "state_base" = _state_base)

// Наборы рескинов по ключу skin_set посоха
GLOBAL_LIST_INIT(staff_skins, list(
	"wooden" = list(
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
		"allmighty" = STAFF_SKIN( \
			"allmighty staff", \
			"Holding this regal staff, you feel answerable to no one. Its crown holds a focus-gem that returns a share of spent spell energy to the wielder.", \
			'modular_twilight_axis/icons/obj/items/staffs.dmi', \
			"allmight" \
		),
	),
))

#undef STAFF_SKIN

// Набор скинов этого посоха или null
/obj/item/rogueweapon/woodstaff/implement/proc/get_skin_set()
	if(!gem_socketable || !skin_set)
		return null
	return GLOB.staff_skins[skin_set]

// Заменяет описание и спрайт посоха по ключу из его набора скинов
/obj/item/rogueweapon/woodstaff/implement/proc/apply_staff_skin(key)
	var/list/skins = get_skin_set()
	var/list/skin = skins?[key]
	if(!skin)
		return FALSE

	implement_noun = skin["name"] || initial(implement_noun)
	desc = skin["desc"] || initial(desc)
	icon = skin["icon"] || initial(icon)
	gem_state_base = skin["state_base"] || initial(gem_state_base)
	update_gem_state()

	return TRUE

/proc/get_staff_skin_choices(set_key)
	var/static/list/choices_by_set = list()

	var/list/choices = choices_by_set[set_key]
	if(!choices)
		choices = list()
		for(var/key in GLOB.staff_skins[set_key])
			choices["[capitalize(key)] staff"] = key

		choices_by_set[set_key] = choices

	return choices

// Мы не можем присвоить скины в поле backr аутфита,
// поэтому мы сразу создаём посох с гемом gem_type и пытаемся надеть его в slot.
/proc/choose_staff(mob/living/carbon/human/H, gem_type, slot = SLOT_BACK_R)
	var/obj/item/rogueweapon/woodstaff/implement/staff = new(H)
	var/list/choices = get_staff_skin_choices(staff.skin_set)

	// Диалоговое окно с выбором скина при спавне
	var/choice = tgui_input_list(H, "Choose your staff.", "STAFF", choices)

	// От греха подальше, если админы удалят моба или посох среди диалогового окна
	if(QDELETED(staff))
		return

	if(gem_type != staff.starting_gem_type)
		QDEL_NULL(staff.socketed_gem)
		if(gem_type)
			staff.socketed_gem = new gem_type(staff)
		staff.update_gem_state()

	if(choice)
		staff.apply_staff_skin(choices[choice])

	// Обычно этот слот никогда не занят при спавне, но добавил проверку на всякий случай
	if(!H.get_item_by_slot(slot))
		H.equip_to_slot_or_del(staff, slot, TRUE)
	else
		H.put_in_hands(staff)

// Рескин уже существующего посоха

/obj/item/rogueweapon/woodstaff/implement/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/alch/transisdust) && get_skin_set() != null)
		change_skin_with(I, user)
		return TRUE
	return ..()

/obj/item/rogueweapon/woodstaff/implement/proc/change_skin_with(obj/item/dust, mob/living/user)
	var/list/choices = get_staff_skin_choices(skin_set)
	var/choice = tgui_input_list(user, "Choose the staff's new appearance.", "STAFF", choices)
	if(!choice || QDELETED(src) || QDELETED(dust) || dust.loc != user || !user.Adjacent(src))
		return

	user.visible_message(
		span_notice("[user] starts working [dust] into [src]..."),
		span_notice("I start working [dust] into [src]...")
	)
	if(!do_after(user, 3 SECONDS, target = src))
		return
	if(QDELETED(dust) || dust.loc != user)
		return

	qdel(dust)
	apply_staff_skin(choices[choice])
	user.visible_message(
		span_notice("[user] finishes reshaping the staff into \a [src]."),
		span_notice("I finish reshaping the staff into \a [src].")
	)

/obj/item/rogueweapon/woodstaff/implement/get_mechanics_examine(mob/user)
	. = ..()
	if(get_skin_set() != null)
		. += span_info("Its appearance can be changed by applying sui dust to it.")
