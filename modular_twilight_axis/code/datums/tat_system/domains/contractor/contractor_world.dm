



/obj/item/contractor_loose_lux
	name = "loose Lux"
	desc = "Condensed loose Lux, suitable for infernal absorption."
	w_class = WEIGHT_CLASS_TINY
	var/lux_power = 100

/obj/item/contractor_loose_lux/examine(mob/user)
	. = ..()
	. += span_notice("Lux power: [lux_power].")

















































