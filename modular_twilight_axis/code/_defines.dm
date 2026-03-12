#define TROPHY_EFFECT_ARMOR "armor"

#define TROPHY_GROUP_ARMOR "armor"
#define TROPHY_GROUP_STRONG "strong"
#define TROPHY_GROUP_PERCEPTION "perception"
#define TROPHY_GROUP_RAGE "rage"

#define TROPHY_EFFECT_STR "str"
#define TROPHY_EFFECT_PER "per"
#define TROPHY_EFFECT_RAGE_PACKAGE "rage_package"

//COMBO-CORE - BEGIN//
#define COMPONENT_COMBO_ACCEPTED (1<<0)
#define COMPONENT_COMBO_FIRED    (1<<1)
//COMBO-CORE - END //

//SOUNDBREAKER - BEGIN//
#define SOUNDBREAKER_NOTE_BEND	1
#define SOUNDBREAKER_NOTE_BARE	2
#define SOUNDBREAKER_NOTE_SHED	3
#define SOUNDBREAKER_NOTE_RIFF	4

#define SB_COMBO_ICON_ECHO			"combo_echo"
#define SB_COMBO_ICON_BASSDROP		"combo_bass"
#define SB_COMBO_ICON_REVERBCUT		"combo_reverb"
#define SB_COMBO_ICON_SYNCOPATION	"combo_sync"
#define SB_COMBO_ICON_HARMONIC		"combo_harmonic"
#define SB_COMBO_ICON_CRESCENDO		"combo_crescendo"
#define SB_COMBO_ICON_OVERTURE		"combo_overture"

#define SB_COMBO_WINDOW (8 SECONDS)
#define SB_MAX_HISTORY 5
#define SB_BASE_COOLDOWN 0
#define SB_PREP_WINDOW (5 SECONDS)
#define SB_CRESCENDO_STAM_DRAIN_PCT 0.10        

#define SB_MAX_VISIBLE_NOTES 5
//SOUNDBREAKER - END //

/// Rune trigger flags
#define RUNE_TRIGGER_ON_HIT (1<<0)
#define RUNE_TRIGGER_ON_PERSIST (1<<1)

#define RUNE_ELEMENT_FIRE "fire"
#define RUNE_ELEMENT_WATER "water"
#define RUNE_ELEMENT_EARTH "earth"
#define RUNE_ELEMENT_AIR "air"

//#define TRAIT_RUNE_MASTER "rune_master"

#define RUNE_LIST_FIRE list( \
	"Возгорание" = /datum/rune/fire/ignition, \
	"Пепел" = /datum/rune/fire/ash, \
	"Клеймо" = /datum/rune/fire/brand, \
	"Плавление" = /datum/rune/fire/melting \
)

#define RUNE_LIST_WATER list( \
	"Иней" = /datum/rune/water/rime, \
	"Морось" = /datum/rune/water/drizzle, \
	"Глубина" = /datum/rune/water/depth, \
	"Лёд" = /datum/rune/water/ice \
)

#define RUNE_LIST_EARTH list( \
	"Разлом" = /datum/rune/earth/fracture, \
	"Гравий" = /datum/rune/earth/gravel, \
	"Гейзер" = /datum/rune/earth/geyser, \
	"Оползень" = /datum/rune/earth/landslide \
)

#define RUNE_LIST_AIR list( \
	"Порыв" = /datum/rune/air/gust, \
	"Гром" = /datum/rune/air/thunder, \
	"Разрежение" = /datum/rune/air/thinning, \
	"Молния" = /datum/rune/air/lightning \
)

#define RUNE_LIST_FIRE_LOW list( \
	"Горн" = /datum/rune/fire/forge, \
	"Костёр" = /datum/rune/fire/bonfire \
)

#define RUNE_LIST_WATER_LOW list( \
	"Прилив" = /datum/rune/water/tide, \
	"Туман" = /datum/rune/water/mist \
)

#define RUNE_LIST_EARTH_LOW list( \
	"Камень" = /datum/rune/earth/stone, \
	"Порода" = /datum/rune/earth/bedrock \
)

#define RUNE_LIST_AIR_LOW list( \
	"Ветер" = /datum/rune/air/wind, \
	"Эхо" = /datum/rune/air/echo \
)

#define RUNE_LIST_FIRE_MASTER list( \
	"Павший волк" = /datum/rune/fire/fallen_volf, \
	"Пламя магии" = /datum/rune/fire/spellflame \
)

#define RUNE_LIST_WATER_MASTER list( \
	"Режущий лед" = /datum/rune/water/razorice, \
	"Пресыщение" = /datum/rune/water/vampirism \
)

#define RUNE_LIST_EARTH_MASTER list( \
	"Каменная кожа" = /datum/rune/earth/stoneskin, \
	"Конец времен" = /datum/rune/earth/apocalypse \
)

#define RUNE_LIST_AIR_MASTER list( \
	"Лезвие" = /datum/rune/air/blade, \
	"Казнь" = /datum/rune/air/execution \
)

#define RUNE_LIST_LOW list( \
	"Огонь" = RUNE_LIST_FIRE_LOW, \
	"Вода" = RUNE_LIST_WATER_LOW, \
	"Земля" = RUNE_LIST_EARTH_LOW, \
	"Воздух" = RUNE_LIST_AIR_LOW \
)

#define RUNE_LIST_BASIC list( \
	"Огонь" = RUNE_LIST_FIRE, \
	"Вода" = RUNE_LIST_WATER, \
	"Земля" = RUNE_LIST_EARTH, \
	"Воздух" = RUNE_LIST_AIR \
)

#define RUNE_LIST_MASTER list( \
	"Огонь" = RUNE_LIST_FIRE_MASTER, \
	"Вода" = RUNE_LIST_WATER_MASTER, \
	"Земля" = RUNE_LIST_EARTH_MASTER, \
	"Воздух" = RUNE_LIST_AIR_MASTER \
)
