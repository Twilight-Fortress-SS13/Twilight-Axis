/obj/item/clothing/suit/roguetown/armor/plate/full/fluted/ornate/ordinator
	desc = "A relic that is said to have survived the Bastonian-Otavan war, refurbished and repurposed to slay the arch-enemy in the name of Psydon. <br> A fluted cuirass that has been reinforced with thick padding and an additional shoulder piece. You will endure."

/obj/item/rogueweapon/halberd/psyhalberd/relic
	desc = "It is said that stigmatas - wounds that mirror Psydon's own - appear without cause upon the bodies of All-Father's most devout. These silver-tipped poleaxes, wielded by Saint Eora's paladins in the last daes of the War in Heaven, were forged to cause a similar type of wound, striking directly at the hearts of those who threaten peace."

/obj/item/flashlight/flare/torch/lantern/psycenser
	desc = "A masterfully-crafted thurible that, when opened, emits a ghastly perfume that reinvigorates the flesh-and-steel of Psydonites. Named after the mountain which was struck by the Comet Syon at the Dawn of Otava, it is said to contain a volatile fragment of this holiest of relics, which - if mishandled - can lead to unforeseen consequences."

/obj/item/rogueweapon/greatsword/psygsword
	desc = "It is said that a Psydonian smith was guided by Archangel Uriel himself to forge such a formidable blade, and given the task to slay a daemon preying on the Otavan farmlands. The design was retrieved, studied, and only a few replicas made - for they believe it dulls its edge."

/obj/item/rogueweapon/greatsword/bsword/psy/relic
	desc = "Psydonian prayers and Tennite smiths, working as one to craft a weapon fit for a Golden Crusader. A heavy and large blade, favored by Archangel Uriel, to lay waste to those who threaten His flock. The crossguard's psycross reflects even the faintest of Noc's light. You're the light - show them the way."

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/easttats
	desc = "A mystic style of tattoos adopted by the Ruma Clan, emulating a practice performed by warrior monks that once made the Clan so valuable to the Shogunate. They are your way of identifying fellow clan members, an sign of companionship and secretive brotherhood. These are styled into the shape of clouds, created by a mystical ink which shifts and moves in ripples like a pond to harden where your skin is struck. It's movement causes you to shudder."

/obj/item/rogueweapon/greatsword/bsword/psy/unforgotten
	desc = "It is said that this weapon once belonged to one Magister Laruelle, an Ordinator who led an expedition into the Underdark, intending to root out the Archenemy's evil. It is said that he held on for seven daes and seven nights against darksteel-clad heretics before Psydon acknowledged his endurance. Nothing but his blade remained - his psycross wrapped around its hilt in rememberance."

/obj/structure/globe
	desc = "A wooden globe representing the world. Key landmarks are indicated by adjacent \
	annotations; at a glance you can pick out 'Otava', 'Grenzelhoft', 'Kazengun', 'Zybantu', \
	and on the northern half of the western continent, a modest valley marked as 'Azuria'."

/obj/structure/globe/attack_hand(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/random_message = pick("You spin the globe!", "You land on Azuria!", "You land on Raneshen!", "You land on Grenzelhoft!", "You land on Otava!", "You land on Naledi!", "You land on Kazengun!", "You land on Valoria!", "You land on Gronn!", "You land on the Fjalls!", "You land on Lirvas!", "You land on Zybantu!", "You land on Hammerhold!", "You land on Etruscea!", "You land on Aavnr!", "You land on Port Izekyube!", "You land on Port Thornvale!", "You land on Syon's Rest!", "You land on Mount Decapitation!", "You land on Rockhill!", "You land on an unmarked squiggle of land - perhaps another spin?", "You land on an unmarked patch of sea - perhaps another spin?")
	to_chat(H, span_notice("[random_message]"))
