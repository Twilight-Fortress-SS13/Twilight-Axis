/obj/item/gun/ballistic/revolver/grenadelauncher/bow
	icon = 'modular_twilight_axis/icons/roguetown/weapons/ranged64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	var/datum/special_intent/special
	var/used = FALSE
	var/list/selection = list(
		/datum/special_intent/ranged/doubleshot,
		/datum/special_intent/ranged/longshot,
		/datum/special_intent/ranged/backstep,
		)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/Initialize(mapload)
	. = ..()
	if(ispath(special))
		special = new special()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/attack_right(mob/user)
	. = ..()
	if(used)
		return

	var/list/special_options = list()
	for(var/intent in selection)
		var/datum/special_intent/S = intent // Hate this DM quirk.
		special_options[S::name] = S

	var/choice = input(user, "Choose the Manoeuvre", "MANOEUVRE") as anything in special_options
	if(choice)
		qdel(special)
		var/datum/special_intent/S = special_options[choice]
		special = new S()
		used = TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	accfactor = 1.15
	dropshrink = 0.8

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -3,
					"sy" = 0,
					"nx" = 6,
					"ny" = 1,
					"wx" = -1,
					"wy" = 1,
					"ex" = -2,
					"ey" = 1,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 9,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 10,
					"nflip" = 1,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 1,
					)
			if("onbelt")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = -3,
					"nx" = 3,
					"ny" = -5,
					"wx" = -7,
					"wy" = -5,
					"ex" = 2,
					"ey" = -5,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = -1,
					"sy" = 0,
					"nx" = 0,
					"ny" = 1,
					"wx" = -2,
					"wy" = 0,
					"ex" = 0,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	dropshrink = 0.8

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.6,
					"sx" = -3,
					"sy" = 0,
					"nx" = 6,
					"ny" = 1,
					"wx" = -1,
					"wy" = 0,
					"ex" = -2,
					"ey" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0,
					"nturn" = 9,
					"sturn" = -100,
					"wturn" = -102,
					"eturn" = 10,
					"nflip" = 1,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 1,
					)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = 0,
					"sy" = 1,
					"nx" = 0,
					"ny" = 0,
					"wx" = -1,
					"wy" = 1,
					"ex" = 0,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 8,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/watchman
	desc = "A robust composite recurve bow issued to professional guards and sworn retainers. \
    Reinforced with horn and backed with sinew, it offers a deadly balance of power and maneuverability \
    suited for the harsh realities of skirmish warfare."
	icon_state = "recurve_bow_watchman"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/watchman/update_icon()
	..()
	if(detail_overlay)
		cut_overlay(detail_overlay)
		detail_overlay = null
	if(altdetail_overlay)
		cut_overlay(altdetail_overlay)
		altdetail_overlay = null
	if(get_detail_tag())
		var/detail_state = "[icon_state][detail_tag]"
		if(!icon_exists(icon, detail_state))
			detail_state = "[initial(icon_state)][detail_tag]"
		var/mutable_appearance/pic = mutable_appearance(icon(icon, detail_state))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)
		detail_overlay = pic
	if(get_altdetail_tag())
		var/altdetail_state = "[icon_state][altdetail_tag]"
		if(!icon_exists(icon, altdetail_state))
			altdetail_state = "[initial(icon_state)][altdetail_tag]"
		var/mutable_appearance/pic2 = mutable_appearance(icon(icon, altdetail_state))
		pic2.appearance_flags = RESET_COLOR
		if(get_altdetail_color())
			pic2.color = get_altdetail_color()
		add_overlay(pic2)
		altdetail_overlay = pic2

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/watchman/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary, GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/watchman/lordcolor(primary, secondary)
	detail_tag = "_detail"
	altdetail_tag = "_detailalt"
	detail_color = primary
	altdetail_color = secondary
	update_icon()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/watchman/Destroy()
	GLOB.lordcolor -= src
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden
	name = "blackhorn recurve bow"
	desc = "When a northern black-horned saiga is old enough, it will shed its two-metre long antlers. As time passes, they harden progressively more but keep a degree of flexibility that can outdo even yew.\
		Wardens often collect such antlers in the rare occasion they are found and send them to be filed, strung and treated by a master bowyer. Such tradition carries merit even todae, \
		and thus one can see Azurian wardens carrying their endemic blackhorn bows with pride."
	icon_state = "recurve_bow_warden"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/autumn
	name = "autumnwoad recurve bow"
	desc = "A medium length composite bow of glued horn, wood, and sinew with good shooting \
	characteristics. Hewn from an Azurian elk tree branch, it still feels as if it is one \
	with nature; unsullied by the cruder butcherments of Man. </br>'The summer sun is fading \
	as the year grows old, and darker days are drawing near..'"
	icon_state = "recurve_bow_autumned"
