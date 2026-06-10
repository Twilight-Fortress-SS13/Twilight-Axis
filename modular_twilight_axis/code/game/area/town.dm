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
