/obj/structure/roguemachine/atm/rockhill
	desc = "A magitech apparatus with a mouth that stores and withdraws currency for accounts managed by the Kingdom of Enigma."
	
/obj/structure/roguemachine/atm/rockhill/attack_hand(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		to_chat(H, span_warning("The machine rejects you, sensing your status as an outlaw in these lands."))
		return
	if(drilled)
		if(HAS_TRAIT(H, TRAIT_NOBLE))
			if(!HAS_TRAIT(H, TRAIT_FREEMAN))
				var/def_zone = "[(H.active_hand_index == 2) ? "r" : "l" ]_arm"
				playsound(src, 'sound/items/beartrap.ogg', 100, TRUE)
				to_chat(user, "<font color='red'>The meister craves my Noble blood!</font>")
				loc.visible_message(span_warning("The meister snaps onto [H]'s arm!"))
				H.Stun(80)
				H.apply_damage(50, BRUTE, def_zone)
				H.emote("agony")
				spawn(5)
				say("Blueblood for the Freefolk!")
				playsound(src, 'sound/vo/mobs/ghost/laugh (5).ogg', 100, TRUE)
				return	
	if(H in SStreasury.bank_accounts)
		var/amt = SStreasury.bank_accounts[H]
		if(!amt)
			say("Your balance is nothing.")
			return
		if(amt < 0)
			say("Your balance is NEGATIVE.")
			return
		var/list/choicez = list()
		if(amt > 14)
			choicez += "GOLD"
		choicez += "BRONZE"
		var/selection = input(user, "Make a Selection", src) as null|anything in choicez
		if(!selection)
			return
		amt = SStreasury.bank_accounts[H]
		var/mod = 1
		if(selection == "GOLD")
			mod = 14
		var/coin_amt = input(user, "There is [SStreasury.treasury_value] mammon in the treasury. You may withdraw [floor(amt/mod)] [selection] COINS from your account.", src) as null|num
		coin_amt = round(coin_amt)
		if(coin_amt < 1)
			return
		// checks the maximum coin limit before deducting balance; prevents stacks of >=20
		var/max_coins = 20
		if(coin_amt > max_coins)
			to_chat(user, span_warning("Maximum withdrawal limit exceeded. You can only withdraw up to [max_coins] coins at once."))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		amt = SStreasury.bank_accounts[H]
		if(!Adjacent(user))
			return
		if((coin_amt*mod) > amt)
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(!SStreasury.withdraw_money_account(coin_amt*mod, H))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		record_round_statistic(STATS_MAMMONS_WITHDRAWN, coin_amt * mod)
		budget2change(coin_amt*mod, user, selection)
	else
		to_chat(user, span_warning("The machine bites my finger."))
		if(!drilled)
			icon_state = "atm-b"
		if(H.show_redflash())
			H.flash_fullscreen("redflash3")
		playsound(H, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
		SStreasury.create_bank_account(H)
		if(H.mind)
			var/datum/job/target_job = SSjob.GetJob(H.mind.assigned_role)
			if(target_job && target_job.noble_income)
				SStreasury.noble_incomes[H] = target_job.noble_income
		spawn(5)
			say("New account created.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)


/obj/structure/roguemachine/atm/rockhill/drill(obj/structure/roguemachine/atm)
	if(!drilling)
		return
	if(SStreasury.treasury_value <50)
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
			SStreasury.treasury_value -= 28 // Takes from the treasury
			mammonsiphoned += 28
			budget2change(28, null, "GOLD")
			playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
			SStreasury.log_to_steward("-[28] exported mammon to the Freefolks!")
			drill(src)
