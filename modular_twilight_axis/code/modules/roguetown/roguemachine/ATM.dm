/obj/structure/roguemachine/atm/rockhill
	desc = "A magitech apparatus with a mouth that stores and withdraws currency for accounts managed by the Kingdom of Enigma."

/obj/structure/roguemachine/atm/rockhill/drill(obj/structure/roguemachine/atm)
	if(!drilling)
		return
	if(SStreasury.discretionary_fund.balance <50)
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("The Crown grinds to a halt as the last of the treasury spills from the meister!"))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "atm"
		drilling = FALSE
		has_reported = FALSE
		return
	if(mammonsiphoned >199) // The cap variable for siphoning. 
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("Maximum withdrawal reached! The meister weeps."))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "meister_broken"
		drilled = TRUE
		drilling = FALSE
		has_reported = FALSE
		return
	else
		loc.visible_message(span_warning("A horrible scraping sound emanates from the Crown as it does its work..."))
		if(!has_reported)
			send_ooc_note("A parasite of the Freefolk is draining a Meister! Location: [location_tag ? location_tag : "Unknown"]", job = list("Grand Duke", "Steward", "Clerk"))
			has_reported = TRUE
		playsound(src, 'sound/misc/TheDrill.ogg', 70, TRUE)
		spawn(100) // The time it takes to complete an interval. If you adjust this, please adjust the sound too. It's 'about' perfect at 100. Anything less It'll start overlapping.
			loc.visible_message(span_warning("The meister spills its bounty!"))
			SStreasury.burn(SStreasury.discretionary_fund, 28, "ATM drill - Freefolk")
			mammonsiphoned += 28
			budget2change(28, null, "GOLD")
			playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
			drill(src)
