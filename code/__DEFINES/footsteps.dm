#define FOOTSTEP_WOOD "wood"
#define FOOTSTEP_FLOOR "floor"
#define FOOTSTEP_PLATING "plating"
#define FOOTSTEP_CARPET "carpet"
#define FOOTSTEP_SAND "sand"
#define FOOTSTEP_GRASS "grass"
#define FOOTSTEP_WATER "water"
#define FOOTSTEP_LAVA "lava"
#define FOOTSTEP_MUD "mud"
#define FOOTSTEP_STONE "stone"
#define FOOTSTEP_SHALLOW "shallow"
#define HEELSTEP_SNOW "heel_snow" // TA EDIT

//barefoot sounds
#define FOOTSTEP_WOOD_BAREFOOT "woodbarefoot"
#define FOOTSTEP_WOOD_CLAW "woodclaw"
#define FOOTSTEP_HARD_BAREFOOT "hardbarefoot"
#define FOOTSTEP_SOFT_BAREFOOT "softbarefoot"
#define FOOTSTEP_HARD_CLAW "hardclaw"
#define FOOTSTEP_CARPET_BAREFOOT "carpetbarefoot"
//misc footstep sounds
#define FOOTSTEP_GENERIC_HEAVY "heavy"

//footstep mob defines
#define FOOTSTEP_MOB_CLAW 1
#define FOOTSTEP_MOB_BAREFOOT 2
#define FOOTSTEP_MOB_HEAVY 3
#define FOOTSTEP_MOB_SHOE 4
#define FOOTSTEP_MOB_HUMAN 5 //Warning: Only works on /mob/living/carbon/human
#define FOOTSTEP_MOB_SLIME 6

//priority defines for the footstep_override element
#define STEP_SOUND_NO_PRIORITY 0
#define STEP_SOUND_CONVEYOR_PRIORITY 1
#define STEP_SOUND_TABLE_PRIORITY 2

///the key to a list of override sounds to replace with. Same format as the global lists.
#define STEP_SOUND_SHOE_OVERRIDE "step_sound_shoe_override"

///the name of the index key for priority
#define STEP_SOUND_PRIORITY "step_sound_priority"
/*

id = list(
list(sounds),
base volume,
extra range addition
)


*/

GLOBAL_LIST_INIT(footstep, list(
	FOOTSTEP_WOOD = list(list(
		'sound/foley/footsteps/FTWOO_A1.ogg',
		'sound/foley/footsteps/FTWOO_A2.ogg',
		'sound/foley/footsteps/FTWOO_A3.ogg',
		'sound/foley/footsteps/FTWOO_A4.ogg'), 42, 0),
	FOOTSTEP_FLOOR = list(list(
		'sound/foley/footsteps/FTTIL_A1.ogg',
		'sound/foley/footsteps/FTTIL_A2.ogg',
		'sound/foley/footsteps/FTTIL_A3.ogg',
		'sound/foley/footsteps/FTTIL_A4.ogg'), 50, 0),
	FOOTSTEP_PLATING = list(list(
		'sound/foley/footsteps/FTMET_A1.ogg',
		'sound/foley/footsteps/FTMET_A2.ogg',
		'sound/foley/footsteps/FTMET_A3.ogg',
		'sound/foley/footsteps/FTMET_A4.ogg'), 40, 0),
	FOOTSTEP_CARPET = list(list(
		'sound/foley/footsteps/FTCAR_A1.ogg',
		'sound/foley/footsteps/FTCAR_A2.ogg',
		'sound/foley/footsteps/FTCAR_A3.ogg',
		'sound/foley/footsteps/FTCAR_A4.ogg'), 12, 0),
	FOOTSTEP_SAND = list(list(
		'sound/foley/footsteps/FTDIR_A1.ogg',
		'sound/foley/footsteps/FTDIR_A2.ogg',
		'sound/foley/footsteps/FTDIR_A3.ogg',
		'sound/foley/footsteps/FTDIR_A4.ogg'), 10, 0),
	FOOTSTEP_GRASS = list(list(
		'sound/foley/footsteps/FTGRA_A1.ogg',
		'sound/foley/footsteps/FTGRA_A2.ogg',
		'sound/foley/footsteps/FTGRA_A3.ogg',
		'sound/foley/footsteps/FTGRA_A4.ogg'), 15, 0),
	FOOTSTEP_WATER = list(list(
		'sound/foley/footsteps/FTWAT_1.ogg',
		'sound/foley/footsteps/FTWAT_2.ogg',
		'sound/foley/footsteps/FTWAT_3.ogg',
		'sound/foley/footsteps/FTWAT_4.ogg'), 80, 0),
	FOOTSTEP_SHALLOW = list(list(
		'sound/foley/footsteps/FTSHAL (1).ogg',
		'sound/foley/footsteps/FTSHAL (2).ogg',
		'sound/foley/footsteps/FTSHAL (3).ogg',
		'sound/foley/footsteps/FTSHAL (4).ogg',
		'sound/foley/footsteps/FTSHAL (5).ogg'), 80, 0),
	FOOTSTEP_LAVA = list(list(
		'sound/blank.ogg'), 100, 0),
	FOOTSTEP_STONE = list(list(
		'sound/foley/footsteps/FTROC_A1.ogg',
		'sound/foley/footsteps/FTROC_A2.ogg',
		'sound/foley/footsteps/FTROC_A3.ogg',
		'sound/foley/footsteps/FTROC_A4.ogg'), 40, 0),
	FOOTSTEP_MUD = list(list(
		'sound/foley/footsteps/FTMUD (1).ogg',
		'sound/foley/footsteps/FTMUD (2).ogg',
		'sound/foley/footsteps/FTMUD (3).ogg',
		'sound/foley/footsteps/FTMUD (4).ogg',
		'sound/foley/footsteps/FTMUD (5).ogg'), 50, 0),
))
//bare footsteps lists
GLOBAL_LIST_INIT(barefootstep, list(
	FOOTSTEP_HARD_BAREFOOT = list(list(
		'sound/foley/footsteps/hardbarefoot (1).ogg',
		'sound/foley/footsteps/hardbarefoot (2).ogg',
		'sound/foley/footsteps/hardbarefoot (3).ogg'), 25, 0),
	FOOTSTEP_SOFT_BAREFOOT = list(list(
		'sound/foley/footsteps/softbarefoot (1).ogg',
		'sound/foley/footsteps/softbarefoot (2).ogg',
		'sound/foley/footsteps/softbarefoot (3).ogg'), 25, 0),
	FOOTSTEP_WATER = list(list(
		'sound/foley/footsteps/FTWAT_1.ogg',
		'sound/foley/footsteps/FTWAT_2.ogg',
		'sound/foley/footsteps/FTWAT_3.ogg',
		'sound/foley/footsteps/FTWAT_4.ogg'), 100, 0),
	FOOTSTEP_SHALLOW = list(list(
		'sound/foley/footsteps/FTSHAL (1).ogg',
		'sound/foley/footsteps/FTSHAL (2).ogg',
		'sound/foley/footsteps/FTSHAL (3).ogg',
		'sound/foley/footsteps/FTSHAL (4).ogg',
		'sound/foley/footsteps/FTSHAL (5).ogg'), 100, 0),
	FOOTSTEP_LAVA = list(list(
		'sound/blank.ogg',
		'sound/blank.ogg',
		'sound/blank.ogg'), 100, 0),
	FOOTSTEP_MUD = list(list(
		'sound/foley/footsteps/FTMUD (1).ogg',
		'sound/foley/footsteps/FTMUD (2).ogg',
		'sound/foley/footsteps/FTMUD (3).ogg',
		'sound/foley/footsteps/FTMUD (4).ogg',
		'sound/foley/footsteps/FTMUD (5).ogg'), 100, 0),
))

//claw footsteps lists
GLOBAL_LIST_INIT(clawfootstep, list(
	FOOTSTEP_WOOD_CLAW = list(list(
		'sound/blank.ogg'), 90, 1),
	FOOTSTEP_HARD_CLAW = list(list(
		'sound/blank.ogg'), 90, 1),
	FOOTSTEP_CARPET_BAREFOOT = list(list(
		'sound/blank.ogg'), 25, -2),
	FOOTSTEP_SAND = list(list(
		'sound/blank.ogg'), 25, 0),
	FOOTSTEP_GRASS = list(list(
		'sound/blank.ogg'), 25, 0),
	FOOTSTEP_WATER = list(list(
		'sound/blank.ogg'), 50, 1),
	FOOTSTEP_LAVA = list(list(
		'sound/blank.ogg'), 50, 0),
))

//heavy footsteps list
GLOBAL_LIST_INIT(heavyfootstep, list(
	FOOTSTEP_GENERIC_HEAVY = list(list(
		'sound/foley/footsteps/bigwalk (1).ogg',
		'sound/foley/footsteps/bigwalk (2).ogg',
		'sound/foley/footsteps/bigwalk (3).ogg',
		'sound/foley/footsteps/bigwalk (4).ogg'), 100, 0),
	FOOTSTEP_WATER = list(list(
		'sound/foley/footsteps/FTWAT_1.ogg',
		'sound/foley/footsteps/FTWAT_2.ogg',
		'sound/foley/footsteps/FTWAT_3.ogg',
		'sound/foley/footsteps/FTWAT_4.ogg'), 100, 0),
	FOOTSTEP_SHALLOW = list(list(
		'sound/foley/footsteps/FTSHAL (1).ogg',
		'sound/foley/footsteps/FTSHAL (2).ogg',
		'sound/foley/footsteps/FTSHAL (3).ogg',
		'sound/foley/footsteps/FTSHAL (4).ogg',
		'sound/foley/footsteps/FTSHAL (5).ogg'), 100, 0),
	FOOTSTEP_LAVA = list(list(
		'sound/blank.ogg'), 100, 0),
	FOOTSTEP_MUD = list(list(
		'sound/foley/footsteps/FTMUD (1).ogg',
		'sound/foley/footsteps/FTMUD (2).ogg',
		'sound/foley/footsteps/FTMUD (3).ogg',
		'sound/foley/footsteps/FTMUD (4).ogg',
		'sound/foley/footsteps/FTMUD (5).ogg'), 100, 0),
))

GLOBAL_LIST_INIT(heelstep, list( // TA EDIT START
	FOOTSTEP_WOOD = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/wood1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/wood2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/wood3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/wood4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/wood5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/wood6.ogg'), 84, 0),
	FOOTSTEP_FLOOR = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile6.ogg'), 100, 0),
	FOOTSTEP_PLATING = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile6.ogg'), 100, 0),
	FOOTSTEP_CARPET = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/carpet1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/carpet2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/carpet3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/carpet4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/carpet5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/carpet6.ogg'), 24, 0),
	FOOTSTEP_SAND = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/sand1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/sand2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/sand3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/sand4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/sand5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/sand6.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/sand7.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/sand8.ogg'), 20, 0),
	FOOTSTEP_GRASS = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/grass1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/grass2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/grass3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/grass4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/grass5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/grass6.ogg'), 30, 0),
	FOOTSTEP_WATER = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water6.ogg'), 100, 0),
	FOOTSTEP_SHALLOW = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/water6.ogg'), 100, 0),
	FOOTSTEP_STONE = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/tile6.ogg'), 100, 0),
	FOOTSTEP_MUD = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/dirt1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/dirt2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/dirt3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/dirt4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/dirt5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/dirt6.ogg'), 80, 0),
	HEELSTEP_SNOW = list(list(
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/snow1.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/snow2.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/snow3.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/snow4.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/snow5.ogg',
		'modular_twilight_axis/sound/foley/footsteps/heelsteps/snow6.ogg'), 80, 0),
)) // TA EDIT END
