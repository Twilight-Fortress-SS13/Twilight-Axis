/obj/item/branding_letters
	name = "branding letter kit"
	desc = "A wooden box with a set of metal letters. Used to change the text on a branding iron."
	icon = 'modular_twilight_axis/icons/obj/items/brand/Brand.dmi'
	icon_state = "brand_letter"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE


/obj/item/branding_iron
	name = "branding iron"
	desc = "A heavy metal tool for searing marks. It is currently cold."
	icon = 'modular_twilight_axis/icons/obj/items/brand/Brand.dmi'
	icon_state = "brand_cold"
	
	
	item_state = "mace_greyscale" 
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	
	
	force = 8
	damtype = BURN
	w_class = WEIGHT_CLASS_NORMAL
	hitsound = list('sound/combat/hits/pick/genpick (2).ogg')
	
	possible_item_intents = list(/datum/intent/hit)
	
	
	var/current_text = "X"
	
	
	var/hott = 0

/obj/item/branding_iron/update_icon_state()
	
	if(hott)
		icon_state = "brand_hot"
		force = 12
		damtype = BURN
		desc = "A heavy metal tool. It radiates heat!"
		hitsound = list('sound/items/steamrelease.ogg') 
	else
		icon_state = "brand_cold"
		force = 8
		damtype = BRUTE
		desc = "A heavy metal tool. It is currently cold."
		hitsound = list('sound/combat/hits/pick/genpick (2).ogg')
	return ..()


/obj/item/branding_iron/proc/make_unhot()
	hott = 0
	update_icon()
	visible_message(span_notice("[src] hisses as it cools down."))

/obj/item/branding_iron/examine(mob/user)
	. = ..()
	. += span_notice("The set symbols read: <b>'[current_text]'</b>.")
	if(hott)
		. += span_danger("IT IS RED-HOT!")


/obj/item/branding_iron/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/branding_letters))
		if(hott)
			to_chat(user, span_warning("I cannot change the letters while the branding iron is hot! I must let it cool down first."))
			return
		
		var/new_text = tgui_input_text(user, "Enter the brand text (max 6 characters):", "Branding Iron Setup", current_text, 6)
		if(new_text)
			current_text = new_text
			to_chat(user, span_notice("I carefully change the metal letters in the branding iron. It now reads: '[current_text]'."))
			playsound(src, 'sound/items/pickgood1.ogg', 50, 1)
		return
	
	return ..()


/obj/item/branding_iron/attack(mob/living/M, mob/user)
	if(!isliving(M))
		return ..()

	
	if(!hott)
		return ..()
	
	
	
	var/target_zone = check_zone(user.zone_selected)
	

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/bodypart/affecting = H.get_bodypart(target_zone)
		
		if(!affecting)
			to_chat(user, span_warning("There is nothing to brand there!"))
			return
		
		
		if(!get_location_accessible(H, target_zone))
			to_chat(user, span_warning("The clothing is in the way!"))
			return

		
		user.visible_message(span_warning("[user] starts pressing the red-hot branding iron against [H]'s [affecting.name]..."), \
						     span_warning("I take aim to brand [H]'s [affecting.name]..."))
		
	
		if(!do_after(user, 2.5 SECONDS, target = H))
			return 

		
		user.do_attack_animation(H)
		user.visible_message(span_danger("[user] presses the red-hot branding iron against [H]'s [affecting.name] with a loud hiss!"), \
						     span_userdanger("I forcefully press the branding iron against [H]'s [affecting.name], searing the mark!"))
		
		playsound(H, 'sound/items/steamrelease.ogg', 60, 1)
		H.emote("scream")
		
		
		affecting.receive_damage(0, 20)
	
		
		
		affecting.brand_text = current_text
		
		log_combat(user, M, "branded", src, "text: [current_text]")
		user.changeNext_move(CLICK_CD_MELEE * 1.5)
		return

	
	else
		user.visible_message(span_warning("[user] starts pressing the red-hot branding iron against [M]..."), \
						     span_warning("I take aim to sear [M]..."))
		
		if(!do_after(user, 2.5 SECONDS, target = M))
			return
			
		user.do_attack_animation(M)
		user.visible_message(span_danger("[user] jabs the red-hot branding iron into [M]!"), \
						     span_userdanger("I sear [M]!"))
		
		playsound(M, 'sound/items/steamrelease.ogg', 60, 1)
		M.emote("scream")
		
		M.adjustFireLoss(15)

		user.changeNext_move(CLICK_CD_MELEE * 1.5)
		return



/datum/anvil_recipe/blacksmithing/branding_iron
	name = "Branding Iron (+1 Plank)"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/natural/wood/plank)
	created_item = /obj/item/branding_iron
	craftdiff = 2
	i_type = "Tools"

/datum/anvil_recipe/blacksmithing/branding_letters
	name = "Branding Letter Kit (+1 Plank)"
	req_bar = /obj/item/ingot/tin
	additional_items = list(/obj/item/natural/wood/plank)
	created_item = /obj/item/branding_letters
	craftdiff = 2
	i_type = "Tools"
