/obj/item/rogueweapon/scabbard/sheath/royal/donat
	sellprice = 0

/obj/item/rogueweapon/scabbard/sword/royal/donat
	sellprice = 0

/obj/item/rogueweapon/scabbard/sword/kazengun/Initialize()
	. = ..()
	max_integrity = 0

/obj/item/rogueweapon/scabbard/sword/kazengun/miaodao
	name = "lacquered kazengun scabbard"
	desc = "An elongated wooden scabbard coated in dark lacquer, designed to protect and balance a heavy curved two-handed blade."
	icon = 'modular_twilight_axis/icons/obj/items/gwstrap.dmi'
	icon_state = "odscabbard"
	item_state = "odscabbard"
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = 1
	valid_blade = /obj/item/rogueweapon/greatsword/miaodao
	max_integrity = 200
	wlength = WLENGTH_GREAT

/obj/item/rogueweapon/scabbard/sword/kazengun/miaodao/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("onbelt")
				return list(
					"shrink" = 0.6,
					"sx" = -1,
					"sy" = -3,
					"nx" = 2,
					"ny" = -3,
					"wx" = -4,
					"wy" = -2,
					"ex" = 3,
					"ey" = -2,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					"nturn" = 34,
					"sturn" = -26,
					"wturn" = -16,
					"eturn" = 20,
					"nflip" = 0,
					"sflip" = 8,
					"wflip" = 8,
					"eflip" = 0,
				)
			if("onback")
				return list(
					"shrink" = 0.6,
					"sx" = 4,
					"sy" = 6,
					"nx" = -6,
					"ny" = 5,
					"wx" = 5,
					"wy" = 5,
					"ex" = -5,
					"ey" = 5,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 4,
				)
