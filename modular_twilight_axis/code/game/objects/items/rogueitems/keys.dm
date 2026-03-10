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

// goblincave
/obj/item/roguekey/goblinchiefkey
	name = "Goblin Chief's Key"
	desc = "A simple rusty iron key that opens the chief's personal room and goblin treasury."
	icon_state = "cheesekey"
	lockid = "gobbo-chief"

/obj/item/roguekey/goblinshamankey
	name = "Goblin Shaman's Key"
	desc = "A simple worn iron key, covered in old scratches and faint green stains, used by the goblin shaman to secure his ritual room."
	icon_state = "birdkey"
	lockid = "gobbo-shaman"

/obj/item/roguekey/goblinkey
	name = "Goblin's Key"
	desc = "A small, crude iron key, heavily rusted and slightly bent from years of use by an ordinary goblin."
	icon_state = "toothkey"
	lockid = "gobbo"
