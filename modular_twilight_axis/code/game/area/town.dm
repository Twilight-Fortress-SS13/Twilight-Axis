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

/area/rogue/indoors/town/fire_chamber/helly
	name = "Another Place"
	first_time_text = "Another Place"
	ambientsounds = list('sound/ambience/hell1.ogg')
	droning_sound = 'sound/music/area/dwarf.ogg'
	town_area = FALSE

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
