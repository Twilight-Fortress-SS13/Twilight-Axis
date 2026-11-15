/*
			< ATTENTION >
	If you need to add more map_adjustment, check 'map_adjustment_include.dm'
	These 'map_adjustment.dm' files shouldn't be included in 'dme'
*/

#define NON_INHUMEN_PATRONS list(/datum/patron/divine/undivided, /datum/patron/divine/astrata, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/necra, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/old_god) // TA ADDITION

/datum/map_adjustment/template/karnfels
	map_file_name = "via_world2.dmm"
	realm_name = "Twilight Axis"
	blacklist = list(
		/datum/job/roguetown/royal_guard,
		/datum/job/roguetown/sheriff,
		/datum/job/roguetown/town_watch,
		/datum/job/roguetown/vanguard,
		/datum/job/roguetown/courtphysician,
		/datum/job/roguetown/knight_enigma,
		/datum/job/roguetown/royal_sergeant,
		/datum/job/roguetown/overseer,
		/datum/job/roguetown/mayor,
		/datum/job/roguetown/bailiff,
		/datum/job/roguetown/cataphract,
		/datum/job/roguetown/vizier,
		/datum/job/roguetown/headslave,
		/datum/job/roguetown/sheikh,
		/datum/job/roguetown/janissary,
		/datum/job/roguetown/janissarysergeant,
		/datum/job/roguetown/azeb,
		/datum/job/roguetown/azebagha,
		/datum/job/roguetown/slavemaster,
		/datum/job/roguetown/sultan,
		/datum/job/roguetown/slave,
		/datum/job/roguetown/warden,
		/datum/job/roguetown/hand,
		/datum/job/roguetown/councillor,
		/datum/job/roguetown/marshal,
		/datum/job/roguetown/orthodoxist,
		/datum/job/roguetown/absolver
	)
	title_adjust = list(
		/datum/job/roguetown/lord = list(display_title = "Burggraf", f_title = "Burggrafin"),
		/datum/job/roguetown/priest = list(display_title = "Erzpriester", f_title = "Erzpriesterin"),
		/datum/job/roguetown/steward = list(display_title = "Geldwechsler", f_title = "Geldwechslerin"),
		/datum/job/roguetown/guildmaster = list(display_title = "Worshipful Master", f_title = "Worshipful Master"),
		/datum/job/roguetown/magician = list(display_title = "Übermagier", f_title = "Übermagier"),
		/datum/job/roguetown/prince = list(display_title = "Erbe", f_title = "Erbin"),
		/datum/job/roguetown/veteran = list(display_title = "Guild Master", f_title = "Guild Master"),
	)
	trait_adjust = list(
		/datum/job/roguetown/priest = list(TRAIT_CHOSEN, TRAIT_RITUALIST, TRAIT_GRAVEROBBER, TRAIT_HOMESTEAD_EXPERT, TRAIT_MEDICINE_EXPERT, TRAIT_CLERGY, TRAIT_MARRIAGE_CAPABLE, TRAIT_NOPAINSTUN)
	)
	tutorial_adjust = list()
	species_adjust = list(/datum/job/roguetown/lord = list(RACES_CONSTRUCT, RACES_SHUNNED, RACES_OOZE, RACES_ANTHRAX, /datum/species/anthromorph))
	sexes_adjust = list()
	slot_adjust = list(/datum/job/roguetown/prince = 1)
	additional_item_adjust = list(/datum/job/roguetown/veteran = /obj/item/roguekey/guildmasterkey)
	subclass_adjust = list(
		/datum/job/roguetown/vagabond = list(
			/datum/advclass/vagabond_original,
			/datum/advclass/vagabond_beggar,
			/datum/advclass/vagabond_courier,
			/datum/advclass/vagabond_excommunicated,
			/datum/advclass/vagabond_goatherd,
			/datum/advclass/vagabond_mage,
			/datum/advclass/vagabond_runner,
			/datum/advclass/vagabond_scholar,
			/datum/advclass/vagabond_wanted,
			/datum/advclass/vagabond_unraveled,
			/datum/advclass/vagabond_thrall,
			/datum/advclass/vagabond_accursed,
			/datum/advclass/vagabond_gassenratte
		))
	patron_adjust = list(
		/datum/job/roguetown/monk = NON_INHUMEN_PATRONS,
		/datum/job/roguetown/templar = NON_INHUMEN_PATRONS,
		)
	//Threat regions is used for displaying specific regions on notice boards
	threat_regions = list(
		THREAT_REGION_AZURE_BASIN,
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP
	)

#undef NON_INHUMEN_PATRONS
