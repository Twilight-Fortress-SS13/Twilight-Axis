/obj/item/roguekey/butcher
	name = "butcher key"
	desc = "This is a rusty key that'll open butcher doors."
	icon_state = "rustkey"
	lockid = "butcher"

/obj/item/roguekey/sheriff
	name = "sheriff's key"
	desc = "This key belongs to the sheriff of town guard."
	icon_state = "cheesekey"
	lockid = "sheriff"

/obj/item/roguekey/roomvii
	name = "room VII key"
	desc = "The key to the seventh room."
	icon_state = "brownkey"
	lockid = "roomvii"

/obj/item/roguekey/roomviii
	name = "room VIII key"
	desc = "The key to the eighth room."
	icon_state = "brownkey"
	lockid = "roomviii"

/obj/item/roguekey/mansion
	name = "Rockhill Mansion"
	desc = "This fancy key opens the doors of the Rockhill mansion."
	icon_state = "cheesekey"
	lockid = "rockhill_mansion"

/obj/item/roguekey/garrison/Initialize()
	. = ..()
	if(SSmapping.config.map_name == "Rockhill")
		name = "garisson key"
		desc = "This key opens many garrison doors in manor."

/obj/item/roguekey/walls/Initialize()
	. = ..()
	if(SSmapping.config.map_name == "Rockhill")
		name = "citywatch key"
		desc = "This key opens the walls and gatehouse of the city."
		lockid = "walls"

/obj/item/roguekey/university/Initialize()
	. = ..()
	if(SSmapping.config.map_name == "Rockhill")
		name = "magician tower key"
		desc = "This key should open anything within the Magician tower."

/obj/item/roguekey/warden/Initialize()
	. = ..()
	if(SSmapping.config.map_name == "Rockhill")
		name = "vanguard key"
		desc = "This key opens doors in vanguard stronghold."

/obj/item/roguekey/inquisitionmanor/Initialize()
	. = ..()
	if(SSmapping.config.map_name == "Rockhill")
		name = "inquisition ship key"
		desc = "This key opens doors in inquisition ship."

/obj/item/roguekey/townsheriff
	name = "Sheriff key"
	desc = "This key opens the Sheriff office."
	icon_state = "spikekey"
	lockid = "townsheriff"

/obj/item/roguekey/courtphysician
	name = "Court Physician key"
	desc = "This key opens the Court Physician office."
	icon_state = "ekey"
	lockid = "courtphysician"

/obj/item/roguekey/mayor
	name = "Mayor key"
	desc = "This key opens the Mayor office."
	icon_state = "cheesekey"
	lockid = "mayor"
	
/obj/item/roguekey/bailiff
	name = "Mayor mansion key"
	desc = "This key opens doors in Mayor mansion."
	icon_state = "brownkey"
	lockid = "mayorh"

/obj/item/roguekey/watcharmory
	name = "Town Watch armory key"
	desc = "This key opens the Town Watch armory."
	icon_state = "spikekey"
	lockid = "watcharmory"
