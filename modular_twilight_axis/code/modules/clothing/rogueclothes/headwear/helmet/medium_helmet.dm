/obj/item/clothing/head/roguetown/helmet/sallet/visored/grenzelhoft
	name = "visored sallet w/plume hat"
	desc = "A Grenzelhoftian plume hat placed atop a steel sallet with an adjustable visor, staying fashionable while guarding the wearer's head with refined practicality. Away with you, vile beggar!"
	icon_state = "grenzelsallet_visor"
	item_state = "grenzelsallet_visor"
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/head.dmi'
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	resistance_flags = FIRE_PROOF
	var/picked = FALSE
	color = "#FFFFFF"
	detail_color = "#262927"
	altdetail_color = "#FFFFFF"
	max_integrity = ARMOR_INT_HELMET_STEEL + 15

/obj/item/clothing/head/roguetown/helmet/sallet/visored/grenzelhoft/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

	if(get_altdetail_tag())
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, "[icon_state][altdetail_tag]"))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)

/obj/item/clothing/head/roguetown/helmet/raneshi_jarhelmet
	name = "raneshi jar helmet"
	desc = "a jar-shaped helmet used by Empire light warriors."
	icon = 'modular_twilight_axis/icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/32х48/helmets.dmi'
	icon_state = "jar_helmet"
	item_state = "jar_helmet"
	adjustable = CAN_CADJUST
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES
	block2add = FOV_BEHIND
	armor = ARMOR_PLATE
	stack_fovs = TRUE
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_HELMET_STEEL + 20 //В стандартном шлеме юзается ARMOR_INT_HELMET_STEEL, дающий 300 очков ХП, но поскольку тут крафт 1 сталь 1 бронза, то 20 интегрити сверху так же вряд-ли сильно повлияют на баланс.

/obj/item/clothing/head/roguetown/helmet/raneshi_jarhelmet/ComponentInitialize()
	AddComponent(/datum/component/adjustable_clothing, (HEAD|EARS|HAIR), (HIDEEARS|HIDEHAIR), null, 'sound/items/visor.ogg', null, UPD_HEAD)

/obj/item/clothing/head/roguetown/helmet/raneshi_jarhelmet/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Orle") as anything in COLOR_MAP
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/raneshi_jarhelmet/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
