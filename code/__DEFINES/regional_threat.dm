// Danger levels. Each danger level is defined as an ambush that can happen. Every time this fire, this number iterates.
#define DANGER_LEVEL_SAFE "Safe"
#define DANGER_LEVEL_LOW "Low"
#define DANGER_LEVEL_MODERATE "Moderate"
#define DANGER_LEVEL_DANGEROUS "Dangerous"
#define DANGER_LEVEL_BLEAK "Bleak"

#define THREAT_REGION_AZURE_BASIN "Azure Basin"
#define THREAT_REGION_AZURE_GROVE "Azure Grove"
#define THREAT_REGION_AZUREAN_COAST "Azurean Coast"
#define THREAT_REGION_MOUNT_DECAP "Mount Decapitation"
#define THREAT_REGION_TERRORBOG "Terrorbog"
#define THREAT_REGION_UNDERDARK "Underdark"

// Rockhill versions
#define THREAT_REGION_ROCKHILL_BASIN "Rockhill Basin"
#define THREAT_REGION_ROCKHILL_BOG_NORTH "Northern Terrorbog"
#define THREAT_REGION_ROCKHILL_BOG_WEST "Western Terrorbog"
#define THREAT_REGION_ROCKHILL_BOG_SOUTH "Southern Terrorbog"
#define THREAT_REGION_ROCKHILL_BOG_SUNKMIRE "Terrorbog Sunken Mire"
#define THREAT_REGION_ROCKHILL_WOODS_NORTH "Murderwood North"
#define THREAT_REGION_ROCKHILL_WOODS_SOUTH "Murderwood South"
#define THREAT_REGION_ROCKHILL_OUTER_GROVE "Rockhill Outer Grove"

//Deserttown versions
#define THREAT_REGION_DESERT_NEAR "Al-Ashur Dunes"
#define THREAT_REGION_DESERT_DEEP "The Deep Dunes"
#define THREAT_REGION_AL_ASHUR_OASIS "Al-Ashur Oasis"
#define THREAT_REGION_AL_ASHUR_CARAVAN_ROAD "Al-Ashur Caravan Road"
#define THREAT_REGION_AL_ASHUR_SPICE_DUNES "Spice Dunes"
#define THREAT_REGION_AL_ASHUR_DEEP_DUNES "The Deep Dunes"
#define THREAT_REGION_AL_ASHUR_SUNKEN_RUINS "Sunken Ashurian Ruins"
#define THREAT_REGION_DESERTDARK "Desert Underdark"
#define THREAT_REGION_DESERTDARK_DEEP "Deep Desert Underdark"


#define LOWPOP_THRESHOLD 30 // When do we give highpop tick?

/// Threat Point tiers for ambush mobs. Base unit: 10 = one wolf.
#define THREAT_TRASH 8       // Fox, raccoon, bigrat, mire crawler, all goblins — trivial critters
#define THREAT_LOW 10        // Wolf, bobcat, badger, honeyspider, supereasy skeleton, medium skeleton
#define THREAT_MODERATE 14   // Mossback, mole, easy/pirate/bogguard skeleton, highwayman, searaider, militia deserter, basic bog deserter
#define THREAT_HIGH 20       // Bog deserter (basic), deepone, orc footsoldier, mutated spider
#define THREAT_TOUGH 25      // Upgraded bog deserter, hard skeleton, orc berserker/marauder, drow raider, deepone spit/wiz
#define THREAT_DANGEROUS 30  // Troll, bog troll, minotaur, direbear, drider
#define THREAT_ELITE 50      // mirespider lurker/paralytic, dwarf skeleton — boss-tier mobs

/// Conversion: one "band" in the Noticeboard IC description equals this many threat points.
#define THREAT_POINTS_PER_BAND 50
