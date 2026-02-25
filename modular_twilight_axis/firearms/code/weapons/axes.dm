/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick/jager
	name = "Arbeitsklinge"
	desc = "The Arbeitsklinge, or 'work blade' in simplified Imperial, is way less infamous than the Jägerbüchse as far as the Freikorps tools of the trade go, but it is arguably a more important one, acting as an all-in-one tool for both resource gathering and scouting duties."
	icon_state = "wardenpax_jager"
	icon = 'modular_twilight_axis/firearms/icons/axes32.dmi'
	detail_color = "#FFFFFF"
	var/picked = FALSE

/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick/jager/attack_right(mob/user)
	..()
	if(!picked)
		var/choice = input(user, "Choose a color.", "Grenzelhoft colors") as anything in COLOR_MAP
		var/playerchoice = COLOR_MAP[choice]
		picked = TRUE
		detail_color = playerchoice
		detail_tag = "_det"
		update_icon()

/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick/jager/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)