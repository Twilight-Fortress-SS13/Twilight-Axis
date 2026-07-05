#define DETAIL_TEXT_BIZZARE_BAZAARE "Известный в узкий кругах подземный рынок-порт контрабандистов, разместившийся в древней гробнице. Товары и рабы, в основном, доставляются с помощью секретной сети подземных рек. Местным рейдерам всё равно, кого выставлять на продажу, что часто приводит к бедам."
//desert areas

/area/rogue/outdoors/desert
	name = "Inner Dunes"
	icon_state = "desert"
	// TA EDIT BEGIN: Added for deserttown contracts
	threat_region = THREAT_REGION_DESERT_NEAR
	// TA EDIT END
	soundenv = 19
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	ambush_times = list("night")
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/badger  = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/raccoon = 25,
		/mob/living/simple_animal/hostile/retaliate/rogue/bobcat = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/fox = 30,
		/mob/living/carbon/human/species/skeleton/npc/supereasy = 30)
	first_time_text = "Al-Ashur Dunes"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	deathsight_message = "somewhere in the dunes, next to towering walls"
	warden_area = TRUE
	
/area/rogue/outdoors/desert/river
	name = "river"
	icon_state = "river"
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_FOREST

/area/rogue/outdoors/desertdeep
	name = "Deep Dunes"
	icon_state = "desertdeep"
	// TA EDIT BEGIN: Added for deserttown contracts
	threat_region = THREAT_REGION_DESERT_DEEP
	// TA EDIT END
	warden_area = TRUE
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	first_time_text = "Deep Dunes"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	ambush_times = list("night","dawn","dusk","day")	
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/ambush = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 60,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 50,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 10,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/lamia = 10,
		/mob/living/simple_animal/hostile/rogue/dragger = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 15)
	converted_type = /area/rogue/indoors/shelter/desertdeep
	deathsight_message = "an empty, parched desert"


/area/rogue/indoors/shelter/desertdeep
	name = "Deep Desert (shelter)"
	icon_state = "desertdeep"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'

/area/rogue/indoors/shelter/desertdeepfortnoc
	name = "Deep Desert (Fort Noc)"
	icon_state = "desertdeep"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	first_time_text = "Fort Noc"

/area/rogue/outdoors/desertdeep/safe
	name = "Desert Pass"
	ambush_times = null
	ambush_mobs = null

/area/rogue/outdoors/desertdeep/above
	name = "deep desert above"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

/area/rogue/outdoors/desert/above
	name = "desert above"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

//

/area/rogue/outdoors/town/desert
	name = "desert town outdoors"
	icon_state = "town"
	soundenv = 16
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	first_time_text = "The City of Al-Ashur"
	town_area = TRUE

/area/rogue/outdoors/town/roofs/desert
	name = "desert roofs"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	first_time_text = null


/area/rogue/indoors/shelter/town/desert
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'

/area/rogue/outdoors/town/manor/desert
	name = "Al-Ashur Palace exterior"
	icon_state = "manor"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/desert/Iberia2.ogg'
	first_time_text = "Al-Ashur Palace"
	keep_area = TRUE

/area/rogue/outdoors/town/manor/roofs/desert
	name = "Palace roofs"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	first_time_text = null
///

/area/rogue/indoors/town/desert/warden
	name = "Warden Fort"
	warden_area = TRUE

/area/rogue/outdoors/banditcamp/desert
	name = "Bandit Camp"
	droning_sound = 'sound/music/area/desert/stronghold.ogg'
	droning_sound_dusk = 'sound/music/area/desert/stronghold.ogg'
	droning_sound_night = 'sound/music/area/desert/stronghold.ogg'
	first_time_text = "A Gathering of Thieves"
	deathsight_message = "hidden among thieves, in the hoard of a dragon"

/area/rogue/indoors/banditcamp/desert
	name = "Bandit Camp"
	droning_sound = 'sound/music/area/desert/stronghold.ogg'
	droning_sound_dusk = 'sound/music/area/desert/stronghold.ogg'
	droning_sound_night = 'sound/music/area/desert/stronghold.ogg'
	deathsight_message = "hidden among thieves, in the hoard of a dragon"

/area/rogue/outdoors/town/desert
	name = "desert town outdoors"
	icon_state = "town"
	soundenv = 16
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	first_time_text = "The City of Al-Ashur"
	town_area = TRUE

/area/rogue/outdoors/town/roofs/desert
	name = "desert roofs"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	first_time_text = null
//////////////////////////////////////////////////////////////////

/area/rogue/indoors/shelter/town/desert
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'

/area/rogue/outdoors/town/manor/desert
	name = "Al-Ashur Palace exterior"
	icon_state = "manor"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/desert/Iberia2.ogg'
	first_time_text = "Al-Ashur Palace"
	keep_area = TRUE

/area/rogue/outdoors/town/manor/desert/roofs
	name = "Palace roofs"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	first_time_text = null
///

/area/rogue/indoors/town/desert
	name = "desert town indoors"
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	converted_type = /area/rogue/outdoors/exposed/town
	deathsight_message = "the city of Al-Ashur and all its bustling souls"

/area/rogue/indoors/town/manor/desert
	name = "Al-Ashur Palace interior"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/desert/Iberia2.ogg'
	first_time_text = "Al-Ashur Palace"
	keep_area = TRUE

/area/rogue/indoors/town/manor/desert/toilet
	name = "Sultan Shithole"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/desert/Iberia2.ogg'
	first_time_text = "Sultan Shithole"
	keep_area = TRUE

/area/rogue/indoors/town/magician/desert
	name = "Wizard's Tower"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/magiciantower.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	keep_area = TRUE
	first_time_text = "Al-Fajr al-Thani Tower"

/area/rogue/indoors/town/shop/desert
	name = "Bazaar"
	droning_sound = 'sound/music/area/desert/Caravan.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/dwarfin/desert
	name = "Guild Smithy"
	droning_sound = 'sound/music/area/desert/Sandal.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/physician/desert
	name = "Physician"
// droning_sound = 'sound/music/area/academy.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/academy/desert

/area/rogue/indoors/town/bath/desert
	name = "Baths"
	droning_sound = 'sound/music/area/desert/TenThousandDelights.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/garrison/desert
	name = "Al-Ashur Garrison"
	droning_sound = 'sound/music/area/desert/DarMeshq.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	
/area/rogue/indoors/town/garrison/desert/cell
	name = "dungeon cell"
	icon_state = "cell"
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/garrison/desert/cell/outdoor
	name = "dungeon cell"
	icon_state = "cell"
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	ceiling_protected = FALSE
	keep_area = TRUE
	cell_area = TRUE

/area/rogue/indoors/town/tavern/desert
	name = "tavern"
	icon_state = "tavern"
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	tavern_area = TRUE

/area/rogue/indoors/town/desert/warden
	name = "Azeb Fort"
	warden_area = TRUE

/area/rogue/under/town/basement/desert
	name = "basement"
	town_area = FALSE
	ceiling_protected = TRUE

/area/rogue/under/town/basement/desert/town
	town_area = TRUE

/area/rogue/under/town/basement/desert/keep
	name = "palace basement"
	keep_area = TRUE
	town_area = TRUE

/area/rogue/indoors/town/desert/arenaview
	name = "Grand Arena"

/area/rogue/indoors/town/church/cavebasement
	icon_state = "church"
	first_time_text = "THE CRYPT OF THE TEN"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'

/area/rogue/indoors/town/church/psy
	name = "church"
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	holy_area = TRUE
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	converted_type = /area/rogue/outdoors/exposed/church
	deathsight_message = "a hallowed place, sworn to the One"
	first_time_text = "THE HOUSE OF THE ONE"

/area/rogue/under/dungeon/desert

/area/rogue/outdoors/town/roofs/desert/tavern
	color = "#00ff33"
	tavern_area = TRUE

/area/rogue/outdoors/town/roofs/desert/pink
	color = "#fa00f1"

/area/rogue/indoors/town/physician/desert/keep
	keep_area = TRUE

/area/rogue/under/town/basement/desert/town/tavern
	tavern_area = TRUE

/area/rogue/indoors/town/cell/desert_warden
	warden_area = TRUE

/area/rogue/under/desertdark
	name = "Desert Underdark"
	loot_budget = LOOT_BUDGET_DESERTDARK
	loot_pool_key = "underdark"
	icon_state = "cavewet"
	warden_area = FALSE
	drow_area = TRUE
	first_time_text = "The Underdark"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 20,
				/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 25,
				/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15,
				/mob/living/simple_animal/hostile/retaliate/rogue/drider = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob = 20
	)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "an acid-scarred depths"
	detail_text = DETAIL_TEXT_UNDERDARK
	threat_region = THREAT_REGION_DESERTDARK

/area/rogue/under/desertdark/north
	name = "Melted Undercity"
	loot_budget = LOOT_BUDGET_MELTED_UNDERCITY
	loot_pool_key = "melted_undercity"
	first_time_text = "MELTED UNDERCITY"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	detail_text = DETAIL_TEXT_MELTED_UNDERCITY
	threat_region = THREAT_REGION_DESERTDARK_DEEP

/area/rogue/under/cave/bizbaz
	name = "Bizzare Bazaare"
	loot_budget = LOOT_BUDGET_BIZZARE_BAZAARE
	icon_state = "under"
	first_time_text = "BIZZARE BAZAARE"
	droning_sound = 'sound/music/freedive_2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	detail_text = DETAIL_TEXT_BIZZARE_BAZAARE

/area/rogue/under/dungeon/desert_pyramid
	name = "Desert Pyramid"
	loot_budget = LOOT_BUDGET_DESERT_PYRAMID
	icon_state = "under"
	first_time_text = "Old Tombs"
	droning_sound = 'sound/music/area/tombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/cave/dtsanctum
	name = "The Crimson Sanctum"
	loot_budget = LOOT_BUDGET_NECRAN_LABYRINTH
	icon_state = "spidercave"
	first_time_text = "The Crimson Sanctum"
	droning_sound = 'sound/music/area/dungeon2.ogg'
	droning_sound_dusk = 'sound/music/area/dungeon2.ogg'
	droning_sound_night = 'sound/music/area/dungeon2.ogg'
	ceiling_protected = TRUE

/area/rogue/under/dungeon/desertgraggar
	name = "Graggar Sanctuary"
	loot_budget = LOOT_BUDGET_MINOTAUR_FORT
	icon_state = "under"
	first_time_text = "Graggar's Sanctuary"
	droning_sound = 'sound/music/area/dungeon2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
