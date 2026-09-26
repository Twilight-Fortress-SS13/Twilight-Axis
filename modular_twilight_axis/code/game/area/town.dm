/area/rogue/indoors/town/Academy
	name = "Academy"
	icon_state = "magician"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "THE ACADEMY OF ENIGMA"
	deathsight_message = "the rustle of heavy books"
	keep_area = TRUE
	detail_text = DETAIL_TEXT_UNIVERSITY_OF_AZURIA

/area/rogue/indoors/town/dwarfin/rockhill
	first_time_text = "Rockhill Guild of Crafts"

/area/rogue/indoors/town/grove
	name = "Druids grove"
	icon_state = "rtfield"
	first_time_text = "Druids grove"
	droning_sound = list('sound/ambience/riverday (1).ogg','sound/ambience/riverday (2).ogg','sound/ambience/riverday (3).ogg')
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = list ('sound/ambience/rivernight (1).ogg','sound/ambience/rivernight (2).ogg','sound/ambience/rivernight (3).ogg' )
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "A sacred place of dendor, beneath the tree of Aeons.."
	warden_area = TRUE
	town_area = FALSE

/area/rogue/indoors/town/manor/rockhill
	first_time_text = "Rockhill Keep"
	deathsight_message = "those sequestered amongst Astrata's favor"

/area/rogue/indoors/town/warden
	name = "Warden Fort"
	warden_area = TRUE
	deathsight_message = "a moss covered stone redoubt, guarding against the wilds"

/area/rogue/outdoors/town/rockhill
	name = "outdoors rockhill"
	first_time_text = "The Town of Rockhill"
	deathsight_message = "the city of Rockhill and all its bustling souls"

/area/rogue/outdoors/town/roofs/rockhillroofs
	name = "roofs"
	first_time_text = "The Town of Rockhill"
	deathsight_message = "the city of Rockhill and all its bustling souls"

/area/rogue/under/town/basement/tavern
	name = "tavern basement"
	icon_state = "basement"
	tavern_area = TRUE
	town_area = TRUE
	ceiling_protected = TRUE
	deathsight_message = "a room full of aging ales"

/area/rogue/outdoors/town/grovercout
	name = "Druid's Grove"
	first_time_text = "Druid's Grove"
	icon_state = "rtfield"
	color = "#b8b5c9"
	ambientsounds = 'sound/ambience/forestday.ogg'
	ambientnight = 'sound/ambience/forestnight.ogg'
	droning_sound = 'modular_twilight_axis/sound/music/area/druid.ogg'
	droning_sound_dawn = null
	converted_type = /area/rogue/indoors/town/grove
	deathsight_message = "A sacred place of dendor, near the tree of Aeons.."
	droning_sound_dusk = null
	droning_sound_night = null
	warden_area = TRUE
	town_area = FALSE

/area/rogue/indoors/town/grovercin
	name = "Druid's Grove indoors"
	icon_state = "indoors"
	color = "#b8b5c9"
	ambientsounds = list('sound/ambience/indoorgen.ogg')
	ambientnight = list('sound/ambience/indoorgen.ogg')
	droning_sound = 'modular_twilight_axis/sound/music/area/druid.ogg'
	converted_type = /area/rogue/indoors/town/grove
	deathsight_message = "A sacred place of dendor, near the tree of Aeons.."
	droning_sound_dusk = null
	droning_sound_night = null
	warden_area = TRUE
	town_area = FALSE

/area/rogue/indoors/town/grovercunder
	name = "Under Druid's Grove"
	icon_state = "cave"
	color = "#b8b5c9"
	ambientsounds = list('sound/ambience/cavewater (1).ogg','sound/ambience/cavewater (2).ogg','sound/ambience/cavewater (3).ogg')
	ambientnight = list('sound/ambience/cavewater (1).ogg','sound/ambience/cavewater (2).ogg','sound/ambience/cavewater (3).ogg')
	droning_sound = 'modular_twilight_axis/sound/music/area/druid.ogg'
	converted_type = /area/rogue/indoors/town/grove
	deathsight_message = "A sacred place of dendor, under the tree of Aeons.."
	droning_sound_dusk = null
	droning_sound_night = null
	warden_area = FALSE
	town_area = FALSE

/area/rogue/outdoors/mountains/decap/somewhere
	name = "Mountains"
	first_time_text = "Somewhere High"
	deathsight_message = "a twisted tangle of soaring peaks"
	warden_area = FALSE

/area/rogue/indoors/town/fire_chamber/helly
	name = "Another Place"
	first_time_text = "Another Place"
	ambientsounds = list('sound/ambience/hell1.ogg')
	droning_sound = 'sound/music/area/dwarf.ogg'
	town_area = FALSE
	warden_area = FALSE

/area/rogue/indoors/inq/shipwardroom
	name = "The Inquisition ship wardroom"
	droning_sound = 'sound/music/area/sargoth.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/inq/office/shipoffice
	name = "The Inquisitor's cabin"
	droning_sound = 'sound/music/area/sargoth.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/inq/basement/shipshold
	name = "The Inquisition's ship hold"
	ambientsounds = list('sound/music/area/catacombs.ogg')
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/magician/tower
	first_time_text = "Magician Tower"
	name = "Magician Tower"

/area/rogue/rockharbor
	name = "Harbor"
	icon_state = "beach"
	ambientsounds = list('sound/ambience/lake (1).ogg','sound/ambience/lake (2).ogg','sound/ambience/lake (3).ogg')
	ambientnight = list('sound/ambience/lake (1).ogg','sound/ambience/lake (2).ogg','sound/ambience/lake (3).ogg')
	droning_sound = 'modular_twilight_axis/sound/music/area/harbor.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	spookysounds = list('sound/ambience/noises/birds (1).ogg','sound/ambience/noises/birds (2).ogg','sound/ambience/noises/birds (3).ogg','sound/ambience/noises/birds (4).ogg','sound/ambience/noises/birds (5).ogg','sound/ambience/noises/birds (6).ogg','sound/ambience/noises/birds (7).ogg')
	warden_area = FALSE
	town_area = TRUE
	outdoors = TRUE
	soundenv = 16

/area/rogue/indoors/town/harborcowered
	name = "Harbor"
	first_time_text = "Rockhill Harbor"
	icon_state = "beach"
	ambientsounds = list('sound/ambience/lake (1).ogg','sound/ambience/lake (2).ogg','sound/ambience/lake (3).ogg')
	ambientnight = list('sound/ambience/lake (1).ogg','sound/ambience/lake (2).ogg','sound/ambience/lake (3).ogg')
	droning_sound = 'modular_twilight_axis/sound/music/area/harbor.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	spookysounds = list('sound/ambience/noises/birds (1).ogg','sound/ambience/noises/birds (2).ogg','sound/ambience/noises/birds (3).ogg','sound/ambience/noises/birds (4).ogg','sound/ambience/noises/birds (5).ogg','sound/ambience/noises/birds (6).ogg','sound/ambience/noises/birds (7).ogg')
	warden_area = FALSE
	town_area = TRUE
	outdoors = TRUE
	soundenv = 16

/area/rogue/outdoors/beach/inqshipout
	name = "The Inquisition ship"
	first_time_text = "ZEALOUS"
	droning_sound = 'sound/music/area/sargoth.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	warden_area = FALSE
	town_area = FALSE

/area/rogue/karnfels_map

/area/rogue/karnfels_map/karnfels_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Die Zitadelle von Karnfels"
	first_time_text = "DIE ZITADELLE VON KARNFELS"
	town_area = TRUE
	deathsight_message = "the streets of Karnfels, pulsing with the breath of the living"
	converted_type = /area/rogue/karnfels_map/karnfels_indoors

/area/rogue/karnfels_map/karnfels_indoors
	parent_type = /area/rogue/indoors/shelter/town
	name = "Die Zitadelle von Karnfels (indoors)"
	first_time_text = "Die Zitadelle von Karnfels"
	town_area = TRUE


/area/rogue/karnfels_map/adventure_guild
	parent_type = /area/rogue/indoors/town
	name = "Adventure Guild"
	first_time_text = "Adventure Guild"
	droning_sound = 'sound/music/area/townstreets.ogg'
	town_area = TRUE
	keep_area = TRUE

/area/rogue/karnfels_map/kerker
	parent_type = /area/rogue/under/cave
	name = "Kerker der Verdammten"
	first_time_text = "KERKER DER VERDAMMTEN"
	icon_state = "cave"
	ceiling_protected = TRUE
	deathsight_message = "the forgotten deeps of the dungeon of the damned"
	ambientsounds = list('sound/ambience/cavewater (1).ogg','sound/ambience/cavewater (2).ogg')
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 40,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 20,
	)

/area/rogue/karnfels_map/schmutzbezirk_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Der Schmutzbezirk"
	first_time_text = "DER SCHMUTZBEZIRK"
	icon_state = "town"
	town_area = TRUE
	converted_type = /area/rogue/karnfels_map/schmutzbezirk_indoors
	deathsight_message = "the forgotten gutters of the filthy quarter"
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 20
	)

/area/rogue/karnfels_map/schmutzbezirk_indoors
	parent_type = /area/rogue/indoors/shelter/town
	name = "Der Schmutzbezirk (indoors)"
	town_area = TRUE


/area/rogue/karnfels_map/church_of_eleven
	parent_type = /area/rogue/indoors/town
	name = "Church of the Eleven"
	first_time_text = "CHURCH OF THE ELEVEN"
	icon_state = "magician"
	holy_area = TRUE
	town_area = TRUE
	droning_sound = 'sound/music/area/magiciantower.ogg'
	deathsight_message = "the hollow echo of silent prayers to the Eleven"

/area/rogue/karnfels_map/wechselstube
	parent_type = /area/rogue/indoors/town
	name = "Wechselstube"
	first_time_text = "WECHSELSTUBE"
	town_area = TRUE
	keep_area = TRUE

/area/rogue/karnfels_map/masons_guild_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Mason's Guild Yards"
	first_time_text = "MASON'S GUILD"
	town_area = TRUE
	converted_type = /area/rogue/karnfels_map/masons_guild_indoors

/area/rogue/karnfels_map/masons_guild_indoors
	parent_type = /area/rogue/indoors/shelter/town
	name = "Mason's Guild"
	first_time_text = "MASON'S GUILD"
	town_area = TRUE

/area/rogue/karnfels_map/miners_guild
	parent_type = /area/rogue/indoors/town
	name = "Miner's Guild"
	first_time_text = "MINER'S GUILD"
	town_area = TRUE

/area/rogue/karnfels_map/marktplatz_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Marktplatz"
	first_time_text = "MARKTPLATZ"
	town_area = TRUE
	converted_type = /area/rogue/karnfels_map/marktplatz_indoors

/area/rogue/karnfels_map/marktplatz_indoors
	parent_type = /area/rogue/indoors/shelter/town
	name = "Marktplatz (shops)"
	town_area = TRUE

/area/rogue/karnfels_map/graveyard
	parent_type = /area/rogue/outdoors
	name = "Graveyard"
	first_time_text = "THE GRAVEYARD"
	icon_state = "bog"
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	deathsight_message = "the cold soil of the final resting place"

/area/rogue/karnfels_map/rattengasse
	parent_type = /area/rogue/outdoors/town
	name = "Rattengasse"
	first_time_text = "RATTENGASSE"
	town_area = TRUE
	deathsight_message = "a dark alleyway, where only vermin watch your passing"
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 100
	)

/area/rogue/karnfels_map/dreckwacht_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Dreckwacht Outpost"
	first_time_text = "DRECKWACHT"
	warden_area = TRUE
	town_area = FALSE
	converted_type = /area/rogue/karnfels_map/dreckwacht_indoors

/area/rogue/karnfels_map/dreckwacht_indoors
	parent_type = /area/rogue/indoors/shelter/town
	name = "Dreckwacht Barracks"
	warden_area = TRUE
	town_area = FALSE

/area/rogue/karnfels_map/kolosseum_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Kolosseum von Karnfels"
	first_time_text = "KOLOSSEUM VON KARNFELS"
	deathsight_message = "the blood-soaked sands of the grand amphitheatre"
	converted_type = /area/rogue/karnfels_map/kolosseum_indoors

/area/rogue/karnfels_map/kolosseum_outdoors/can_craft_here()
	return FALSE

/area/rogue/karnfels_map/kolosseum_indoors
	parent_type = /area/rogue/indoors/town
	name = "Kolosseum Chambers"
	first_time_text = "Kolosseum von Karnfels"
	deathsight_message = "the shadowy holding cells beneath the coliseum"

/area/rogue/karnfels_map/kolosseum_indoors/can_craft_here()
	return FALSE

/area/rogue/karnfels_map/schwarzwassergraben
	parent_type = /area/rogue/outdoors
	name = "Schwarzwassergraben"
	first_time_text = "SCHWARZWASSERGRABEN"
	icon_state = "river"
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	deathsight_message = "the dark, stagnant waters of the city moat"

/area/rogue/karnfels_map/endlose_mauer
	parent_type = /area/rogue/outdoors/town/roofs
	name = "Endlose Mauer"
	first_time_text = "ENDLOSE MAUER"
	icon_state = "roofs"
	warden_area = TRUE
	town_area = TRUE
	deathsight_message = "the dizzying heights of the endless fortifications"

/area/rogue/karnfels_map/oberstadt_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Oberstadt"
	first_time_text = "OBERSTADT"
	town_area = TRUE
	converted_type = /area/rogue/karnfels_map/oberstadt_indoors
	deathsight_message = "the pristine, well-guarded stone paths of the high quarter"

/area/rogue/karnfels_map/oberstadt_indoors
	parent_type = /area/rogue/indoors/shelter/town
	name = "Oberstadt (indoors)"
	town_area = TRUE

/area/rogue/karnfels_map/ueberzauberturm
	parent_type = /area/rogue/indoors/town
	name = "Der Überzauberturm"
	first_time_text = "DER ÜBERZAUBERTURM"
	icon_state = "magician"
	droning_sound = 'sound/music/area/magiciantower.ogg'
	deathsight_message = "the heavy scent of ozone and forgotten spells"
	keep_area = TRUE

/area/rogue/karnfels_map/diebesgilde
	parent_type = /area/rogue/indoors/town
	name = "Diebesgilde"
	first_time_text = "DIEBESGILDE"
	icon_state = "basement"
	ceiling_protected = TRUE
	deathsight_message = "the hidden shadows where secrets are traded"


/area/rogue/karnfels_map/burggrafensitz
	parent_type = /area/rogue/indoors/town
	name = "Burggrafensitz"
	first_time_text = "BURGGRAFENSITZ"
	icon_state = "manor"
	keep_area = TRUE
	town_area = TRUE
	deathsight_message = "the luxurious halls of Astrata's direct representative"

/area/rogue/karnfels_map/dwarffortress
	parent_type = /area/rogue/under/cave
	name = "Dwarf Fortress"
	first_time_text = "DWARF FORTRESS"
	icon_state = "under"
	ceiling_protected = TRUE
	droning_sound = 'sound/music/area/dwarf.ogg'
	deathsight_message = "the deep, root-bound halls carved from solid granite"

/area/rogue/karnfels_map/outlands
	parent_type = /area/rogue/outdoors/woodsrat
	name = "Outlands"
	first_time_text = "THE OUTLANDS"
	icon_state = "woods"
	warden_area = TRUE
	deathsight_message = "the untamed, lawless wilds beyond Karnfels"
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 35,
		/mob/living/carbon/human/species/skeleton/npc/medium = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/fox = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/boar = 20
	)

/area/rogue/karnfels_map/crimsonlands_outdoors
	parent_type = /area/rogue/outdoors
	name = "Crimsonlands"
	first_time_text = "THE CRIMSONLANDS"
	icon_state = "decap"
	ambientsounds = list('sound/ambience/hell1.ogg')
	droning_sound = 'sound/music/area/sargoth.ogg'
	deathsight_message = "blood-soaked earth beneath a stagnant sky"
	converted_type = /area/rogue/karnfels_map/crimsonlands_indoors

/area/rogue/karnfels_map/crimsonlands_indoors
	parent_type = /area/rogue/indoors/shelter
	name = "Crimsonlands (shelter)"
	first_time_text = "Crimsonlands Shelter"
	droning_sound = 'sound/music/area/sargoth.ogg'

/area/rogue/karnfels_map/hagmoor
	parent_type = /area/rogue/outdoors/bograt
	name = "Hagmoor"
	first_time_text = "HAGMOOR"
	icon_state = "bog"
	deathsight_message = "the murky, rotting waters of the Hagmoor"
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 50,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 35,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10
	)

/area/rogue/karnfels_map/rotland_outdoors
	parent_type = /area/rogue/outdoors
	name = "Rotland"
	first_time_text = "THE ROTLAND"
	icon_state = "bog"
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	deathsight_message = "blighted soil choked with marrow and decaying bone"
	converted_type = /area/rogue/karnfels_map/rotland_indoors
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/easy = 30,
		/mob/living/carbon/human/species/skeleton/npc/medium = 25,
		/mob/living/carbon/human/species/skeleton/npc/hard = 15,
		/mob/living/carbon/human/species/skeleton/npc/ambush = 20,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 15
	)

/area/rogue/karnfels_map/rotland_indoors
	parent_type = /area/rogue/indoors/shelter
	name = "Rotland Crypt"
	first_time_text = "Rotland Crypt"
	droning_sound = 'sound/music/area/catacombs.ogg'


/area/rogue/karnfels_map/hollow_quarter_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Hollow Quarter"
	first_time_text = "THE HOLLOW QUARTER"
	icon_state = "town"
	town_area = TRUE
	deathsight_message = "desolate streets where cutthroats wait in every alcove"
	converted_type = /area/rogue/karnfels_map/hollow_quarter_indoors
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 40,
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 35
	)

/area/rogue/karnfels_map/hollow_quarter_indoors
	parent_type = /area/rogue/indoors/shelter/town
	name = "Hollow Quarter (dens)"
	town_area = TRUE


/area/rogue/karnfels_map/boblins_domain_outdoors
	parent_type = /area/rogue/outdoors
	name = "Boblin's Domain"
	first_time_text = "BOBLIN'S DOMAIN"
	icon_state = "under"
	droning_sound = 'modular_twilight_axis/sound/music/area/gobcamp.ogg'
	deathsight_message = "a chaotic territory claimed by squabbling goblin broods"
	converted_type = /area/rogue/karnfels_map/boblins_domain_indoors
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 25,
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 25,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 15,
		/mob/living/carbon/human/species/goblin/npc/hell = 10
	)

/area/rogue/karnfels_map/boblins_domain_indoors
	parent_type = /area/rogue/indoors/shelter
	name = "Boblin's Encampment"
	first_time_text = "Boblin's Encampment"
	droning_sound = 'modular_twilight_axis/sound/music/area/gobcamp.ogg'

/area/rogue/karnfels_map/ueberzauberturm_outdoors
	parent_type = /area/rogue/outdoors/town
	name = "Der Überzauberturm Grounds"
	first_time_text = "TOWER APPROACH"
	icon_state = "magician"
	droning_sound = 'sound/music/area/magiciantower.ogg'
	town_area = TRUE
	converted_type = /area/rogue/karnfels_map/ueberzauberturm

/area/rogue/karnfels_map/haunted_manor
	parent_type = /area/rogue/indoors/vampire_manor
	name = "Haunted Manor"
	first_time_text = "THE HAUNTED MANOR"
	icon_state = "spidercave"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/ambience/creepywind.ogg'
	deathsight_message = "cold corridors haunted by unseen whispers"


/area/rogue/karnfels_map/abandoned_estate_outdoors
	parent_type = /area/rogue/outdoors
	name = "Abandoned Estate Grounds"
	first_time_text = "ABANDONED ESTATE"
	icon_state = "manor"
	deathsight_message = "overgrown gardens and overgrown ruins"
	converted_type = /area/rogue/karnfels_map/abandoned_estate_indoors
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 35,
		/mob/living/carbon/human/species/human/northern/highwayman/archer = 35,
		/mob/living/simple_animal/hostile/retaliate/rogue/fox = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/boar = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 10
	)

/area/rogue/karnfels_map/abandoned_estate_indoors
	parent_type = /area/rogue/indoors/shelter
	name = "Abandoned Estate Interior"
	first_time_text = "Abandoned Estate"
	icon_state = "indoors"

/area/rogue/outdoors/town/karnfels
	name = "Die Zitadelle von Karnfels"
	first_time_text = "DIE ZITADELLE VON KARNFELS"
	town_area = TRUE
	deathsight_message = "the streets of Karnfels, pulsing with the breath of the living"
	converted_type = /area/rogue/indoors/shelter/town/karnfels

/area/rogue/indoors/shelter/town/karnfels
	name = "Die Zitadelle von Karnfels (indoors)"
	first_time_text = "Die Zitadelle von Karnfels"
	town_area = TRUE

/area/rogue/indoors/town/adventure_guild
	name = "Adventure Guild"
	first_time_text = "Adventure Guild"
	droning_sound = 'sound/music/area/townstreets.ogg'
	town_area = TRUE
	keep_area = TRUE

/area/rogue/under/cave/kerker
	name = "Kerker der Verdammten"
	first_time_text = "KERKER DER VERDAMMTEN"
	icon_state = "cave"
	ceiling_protected = TRUE
	deathsight_message = "the forgotten deeps of the dungeon of the damned"
	ambientsounds = list('sound/ambience/cavewater (1).ogg','sound/ambience/cavewater (2).ogg')
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 40,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 20,
	)

/area/rogue/outdoors/town/schmutzbezirk
	name = "Der Schmutzbezirk"
	first_time_text = "DER SCHMUTZBEZIRK"
	icon_state = "town"
	town_area = TRUE
	converted_type = /area/rogue/indoors/shelter/town/schmutzbezirk
	deathsight_message = "the forgotten gutters of the filthy quarter"
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 20
	)

/area/rogue/indoors/shelter/town/schmutzbezirk
	name = "Der Schmutzbezirk (indoors)"
	town_area = TRUE

/area/rogue/indoors/town/church_of_eleven
	name = "Church of the Eleven"
	first_time_text = "CHURCH OF THE ELEVEN"
	icon_state = "magician"
	holy_area = TRUE
	town_area = TRUE
	droning_sound = 'sound/music/area/magiciantower.ogg'
	deathsight_message = "the hollow echo of silent prayers to the Eleven"

/area/rogue/indoors/town/wechselstube
	name = "Wechselstube"
	first_time_text = "WECHSELSTUBE"
	town_area = TRUE
	keep_area = TRUE

/area/rogue/outdoors/town/masons_guild
	name = "Mason's Guild Yards"
	first_time_text = "MASON'S GUILD"
	town_area = TRUE
	converted_type = /area/rogue/indoors/shelter/town/masons_guild

/area/rogue/indoors/shelter/town/masons_guild
	name = "Mason's Guild"
	first_time_text = "MASON'S GUILD"
	town_area = TRUE

/area/rogue/indoors/town/miners_guild
	name = "Miner's Guild"
	first_time_text = "MINER'S GUILD"
	town_area = TRUE

/area/rogue/outdoors/town/marktplatz
	name = "Marktplatz"
	first_time_text = "MARKTPLATZ"
	town_area = TRUE
	converted_type = /area/rogue/indoors/shelter/town/marktplatz

/area/rogue/indoors/shelter/town/marktplatz
	name = "Marktplatz (shops)"
	town_area = TRUE

/area/rogue/outdoors/graveyard
	name = "Graveyard"
	first_time_text = "THE GRAVEYARD"
	icon_state = "bog"
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	deathsight_message = "the cold soil of the final resting place"

/area/rogue/outdoors/town/rattengasse
	name = "Rattengasse"
	first_time_text = "RATTENGASSE"
	town_area = TRUE
	deathsight_message = "a dark alleyway, where only vermin watch your passing"
	ambush_times = list("night", "dawn", "dusk", "day")
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 100
	)

/area/rogue/outdoors/town/dreckwacht
	name = "Dreckwacht Outpost"
	first_time_text = "DRECKWACHT"
	warden_area = TRUE
	town_area = FALSE
	converted_type = /area/rogue/indoors/shelter/town/dreckwacht

/area/rogue/indoors/shelter/town/dreckwacht
	name = "Dreckwacht Barracks"
	warden_area = TRUE
	town_area = FALSE

/area/rogue/outdoors/town/kolosseum
	name = "Kolosseum von Karnfels"
	first_time_text = "KOLOSSEUM VON KARNFELS"
	deathsight_message = "the blood-soaked sands of the grand amphitheatre"
	converted_type = /area/rogue/indoors/town/kolosseum

/area/rogue/outdoors/town/kolosseum/can_craft_here()
	return FALSE

/area/rogue/indoors/town/kolosseum
	name = "Kolosseum Chambers"
	first_time_text = "Kolosseum von Karnfels"
	deathsight_message = "the shadowy holding cells beneath the coliseum"

/area/rogue/indoors/town/kolosseum/can_craft_here()
	return FALSE

/area/rogue/outdoors/schwarzwassergraben
	name = "Schwarzwassergraben"
	first_time_text = "SCHWARZWASSERGRABEN"
	icon_state = "river"
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	deathsight_message = "the dark, stagnant waters of the city moat"

/area/rogue/outdoors/town/roofs/endlose_mauer
	name = "Endlose Mauer"
	first_time_text = "ENDLOSE MAUER"
	icon_state = "roofs"
	warden_area = TRUE
	town_area = TRUE
	deathsight_message = "the dizzying heights of the endless fortifications"


/area/rogue/outdoors/town/oberstadt
	name = "Oberstadt"
	first_time_text = "OBERSTADT"
	town_area = TRUE
	converted_type = /area/rogue/indoors/shelter/town/oberstadt
	deathsight_message = "the pristine, well-guarded stone paths of the high quarter"

/area/rogue/indoors/shelter/town/oberstadt
	name = "Oberstadt (indoors)"
	town_area = TRUE

/area/rogue/indoors/town/ueberzauberturm
	name = "Der Überzauberturm"
	first_time_text = "DER ÜBERZAUBERTURM"
	icon_state = "magician"
	droning_sound = 'sound/music/area/magiciantower.ogg'
	deathsight_message = "the heavy scent of ozone and forgotten spells"
	keep_area = TRUE

/area/rogue/indoors/town/diebesgilde
	name = "Diebesgilde"
	first_time_text = "DIEBESGILDE"
	icon_state = "basement"
	ceiling_protected = TRUE
	deathsight_message = "the hidden shadows where secrets are traded"

/area/rogue/indoors/town/burggrafensitz
	name = "Burggrafensitz"
	first_time_text = "BURGGRAFENSITZ"
	icon_state = "manor"
	keep_area = TRUE
	town_area = TRUE
	deathsight_message = "the luxurious halls of Astrata's direct representative"

/area/rogue/under/cave/dwarffortress
	name = "Dwarf Fortress"
	first_time_text = "DWARF FORTRESS"
	icon_state = "under"
	ceiling_protected = TRUE
	droning_sound = 'sound/music/area/dwarf.ogg'
	deathsight_message = "the deep, root-bound halls carved from solid granite"
