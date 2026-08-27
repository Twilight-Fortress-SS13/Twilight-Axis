// === BONDS MODULE ===
// Directed social-bond graph for Twilight-Axis. Include this file from the DME compile section;
// pair it with bonds_module_deinclude.dm to clean up macros after the section.
// #include "modular_twilight_axis\bonds_module\bonds_module_config.dm"
//
// --- FILE MAP ---
// bonds_config_maps.dm  - TUNING: per-map lens over faction impact
// bonds_config_roles.dm - TUNING: how loudly each job echoes between factions, plus the
//                         archetype masks that decide which dream may name which pair of jobs
// bonds_config_gods.dm  - TUNING: storyteller gods bending faction relations
// bonds_stance_file.dm - the reader for strings/bonds/*.txt, where the declared standing of every
//                         one of the 91 mortal and 15 clan pairs actually lives. Leaving a pair out
//                         is not neutrality, it is a hole: an undeclared pair sits at flat zero and
//                         the first brawl decides it, so keep the tables complete
// bonds_config_vices.dm - TUNING: how a recipient's vices reshape what was done to them
// bonds_core.dm       - the graph itself: /datum/bond_actor identity, /datum/bond_node buckets,
//                       /datum/social_bond axes and history, /datum/social_bond/kin kinship, graph API
// bonds_events.dm     - identity gate, event definitions (hostile / friendly / roundstart seeds),
//                       stage table, recipient dispositions, sanctioned duels, signal listener
// bonds_factions.dm   - faction taxonomy and index, declared baselines, live stance matrix,
//                       vampire clans as a second axis, house-to-house standing
// bonds_context.dm    - everything that scales an incident: template shares and the normalised
//                       blend, role weight, zone and map lenses, map rosters, storyteller lenses,
//                       origins and their inherited lore, influence pool, the impact pipeline
// bonds_round.dm      - SUBSYSTEM_DEF(bonds), rank hierarchy, character prefs and their savefile
//                       hooks, per-ckey round prefs and ledger, roundstart seeding
// bonds_dream_file.dm - the reader for strings/bonds/dreams_*.txt, where every memory's text,
//                       numbers and archetype gates live. DM keeps only the type declarations,
//                       because the engine keys events by type path and a config cannot mint types
// bonds_dreams.dm     - role archetypes, the 20 baseline memories, echo application and the
//                       sleep hook: one sleep rolls at most one memory, gated on what both
//                       sides plausibly are; the sleeper gets it whole, the other side at half
// bonds_dreams_gods.dm - CONTENT: five memories per god storyteller, keyed on their domains.
//                        Gated on SSgamemode.ruling_god - the deity holding the town's patrons,
//                        re-crowned hourly - NOT on current_storyteller, which is the gamemode
//                        antagonist preset and is never a god
// bonds_dreams_maps.dm - CONTENT: six memories per map, keyed on /datum/map_adjustment type,
//                        so mountain passes stay out of the sands and the sands out of Enigma
// bonds_panels.dm     - every tgui backend: bonds list, bond tree, faction map and standing,
//                       faction roster, seeding prefs, admin editor, player verbs, family bridge
// bonds_admin.dm      - the one admin inspector: faction stances, a person's whole node (bonds,
//                       kin, archetypes, influence), arbitrary bond and kin editing between any
//                       two people, and the family graph caches with dirty/drop controls.
//                       Backs the BondsAdmin tgui; every mutation goes through log_admin
// bonds_debug.dm      - admin load bench: synthetic population, event storm, dream and panel
//                       passes, simulated time skip, and a wave-by-wave degradation run.
//                       Phases measure without CHECK_TICK on purpose, so they block. Admin only
// bonds_unit_tests.dm - CI unit tests for the bond chains; runs under UNIT_TESTS

//#define BONDS_DEBUG_LOGGING //UNDEFINE IT FOR THE LOCAL TESTING

// TEMPORARY. Stops the graph evolving during a round while the family side is fixed:
// the four gameplay signals are never bound and no dream ever rolls.
// Everything else stays: kinship, seeding, panels, and the qdel cleanup signal,
// which must keep firing or the graph would hoard deleted mobs.
// Delete this define to thaw.
#define BONDS_EVOLUTION_FROZEN

#define BOND_WARMTH_MIN -100
#define BOND_WARMTH_MAX 100
#define BOND_WEIGHT_MIN 0
#define BOND_WEIGHT_MAX 100

// Cap on outgoing bonds per mind. Beyond this the weakest untagged bond is evicted, so a
// crowded round cannot grow the graph quadratically.
#define BOND_MAX_PER_MIND 40
// Minimum gap between two permanent commits of the same category on one bond.
#define BOND_COMMIT_COOLDOWN (90 SECONDS)
// Hard cap on stored history entries per bond. This is a reminder of what happened lately,
// not a round-long journal: unpinned entries drop first, then the oldest pinned ones.
#define BOND_MAX_HISTORY 5
// Bonds below this weight are noise and stay hidden from the player.
#define BOND_VISIBLE_WEIGHT 10

// Each further commit of the same category on the same bond is scaled by
// 1 / (1 + count * BOND_COMMIT_FALLOFF), so grinding one interaction saturates.
#define BOND_COMMIT_FALLOFF 0.55
// A death counts as murder by the last aggressor only inside this window.
#define BOND_KILL_ATTRIBUTION_WINDOW (2 MINUTES)

#define BOND_TAG_NONE 0
#define BOND_TAG_SHED_BLOOD (1<<0)
#define BOND_TAG_KILLED_ME (1<<1)
#define BOND_TAG_KILLED_THEM (1<<2)
#define BOND_TAG_COMFORTED (1<<3)
#define BOND_TAG_SERVED_TOGETHER (1<<4)
#define BOND_TAG_OWES_DEBT (1<<5)
// Only an actual death between the two of you survives cap pressure. Everything else - blood drawn,
// comfort given, a shared past, a debt - is memorable but evictable, because a fighter tags almost
// every bond they make and a tag that blocks eviction silently turns the cap off.
#define BOND_TAG_PROTECTED (BOND_TAG_KILLED_ME | BOND_TAG_KILLED_THEM)

// Roundstart seeding. A seed is an ordinary event applied at t=0, so backstory and
// in-round development share one code path.
#define BOND_MAX_SEEDS 3
#define BOND_SEED_DELAY (90 SECONDS)
#define BOND_SEED_RETRY (45 SECONDS)

#define BOND_CATEGORY_VIOLENCE "violence"
#define BOND_CATEGORY_KINDNESS "kindness"
#define BOND_CATEGORY_DEATH "death"
#define BOND_CATEGORY_SEED "seed"
#define BOND_CATEGORY_DREAM "dream"

// Decision counters for the bench. Off by default and gated at the call site, so a normal round
// pays one var read per tally. They answer the question raw timings never do: not "how slow", but
// "how many attempts died, and at which gate".
#define BONDS_TALLY(key) if(SSbonds.instrumented) { SSbonds.tallies[key] = (SSbonds.tallies[key] || 0) + 1 }

// Once a blow puts someone into critical, every further hit on them inside this window is
// read as finishing them off rather than as an ordinary strike. The window refreshes on each
// hit, so a sustained beating stays an attempt for as long as it lasts.
#define BOND_MURDER_WINDOW (1 MINUTES)

// Dreams. Every sleep that opens the dream menu rolls ONE memory at most: the four chances
// below are summed into a single gate, and only if that gate passes is one bucket drawn,
// weighted by its own chance. Storyteller lenses scale the two valences independently.
#define BOND_DREAM_CHANCE_OWN_NEGATIVE 10
#define BOND_DREAM_CHANCE_FOREIGN_NEGATIVE 5
#define BOND_DREAM_CHANCE_OWN_POSITIVE 10
#define BOND_DREAM_CHANCE_FOREIGN_POSITIVE 5

#define BOND_DREAM_POSITIVE 1
#define BOND_DREAM_NEGATIVE 2

// A memory has two ends. The sleeper gets the full event; the other side gets the same
// event at this scale, applied straight to the permanent axes and announced in chat, so
// being remembered well is something you can notice while awake.
#define BOND_DREAM_ECHO_SCALE 0.5

#define BOND_DREAM_VAMPIRE_NONE 0
#define BOND_DREAM_VAMPIRE_OTHER 1
#define BOND_DREAM_VAMPIRE_DREAMER 2

#define BOND_DREAM_SCOPE_OWN (1<<0)
#define BOND_DREAM_SCOPE_FOREIGN (1<<1)
#define BOND_DREAM_SCOPE_ANY (BOND_DREAM_SCOPE_OWN | BOND_DREAM_SCOPE_FOREIGN)

// Role archetypes. A dream is gated on what both sides plausibly are, so a priest never
// wakes up remembering the shield wall. Masks are unioned per job in bonds_config_roles.dm
// and resolved through the job type path, walking up the parent chain for subtypes.
#define BOND_ARCH_WARRIOR (1<<0)
#define BOND_ARCH_LAWMAN (1<<1)
#define BOND_ARCH_DEVOUT (1<<2)
#define BOND_ARCH_NOBLE (1<<3)
#define BOND_ARCH_SCHOLAR (1<<4)
#define BOND_ARCH_HEALER (1<<5)
#define BOND_ARCH_CRAFTER (1<<6)
#define BOND_ARCH_MERCHANT (1<<7)
#define BOND_ARCH_OUTLAW (1<<8)
#define BOND_ARCH_SERVILE (1<<9)
#define BOND_ARCH_WANDERER (1<<10)
#define BOND_ARCH_UNDEAD (1<<11)

// Faction ids. The taxonomy is roguetown-local and lives in bonds_factions_defs.dm as data;
// each faction points at one GLOB.*_positions list. Bathhouse and tavern are deliberately NOT
// factions - they are venues, and treating them as factions was the sole source of title
// collisions (Bathmaster, Innkeeper, Bathhouse Attendant, Cook, Tapster).
#define BOND_STANCE_DIRECTORY "strings/bonds"

#define BOND_LOOSE_BLOC "loose"

#define BOND_FACTION_NOBLE "noble"
#define BOND_FACTION_COURT "court"
#define BOND_FACTION_RETINUE "retinue"
#define BOND_FACTION_GARRISON "garrison"
#define BOND_FACTION_CITYWATCH "citywatch"
#define BOND_FACTION_VANGUARD "vanguard"
#define BOND_FACTION_CHURCH "church"
#define BOND_FACTION_INQUISITION "inquisition"
#define BOND_FACTION_BURGHER "burgher"
#define BOND_FACTION_ATC "atc"
#define BOND_FACTION_PEASANT "peasant"
#define BOND_FACTION_SIDEFOLK "sidefolk"
#define BOND_FACTION_WANDERER "wanderer"
#define BOND_FACTION_SLAVE "slave"
#define BOND_FACTION_OUTLAW "outlaw"

// Vampire clans: a second faction axis, indexed by clan type instead of job title, sharing
// the same stance matrix. A vampire belongs to one of each.
#define BOND_CLAN_CAITIFF "clan_caitiff"
#define BOND_CLAN_ABYSS "clan_abyss"
#define BOND_CLAN_CRIMSON "clan_crimson"
#define BOND_CLAN_EORAN "clan_eoran"
#define BOND_CLAN_NOSFERATU "clan_nosferatu"
#define BOND_CLAN_THRONLEER "clan_thronleer"

// Implicit warmth between two members of the same faction; never stored as a pair.
#define BOND_STANCE_SAME_FACTION_WARMTH 35
// Absolute stance warmth above which two factions are considered entangled enough that
// their members plausibly share a past - allies AND rivals both qualify.
#define BOND_STANCE_AFFINITY_THRESHOLD 25
// Below this weight an unremarkable faction pair is left off the map to keep it readable.
#define BOND_MAP_MIN_WEIGHT 5
// Template shares for the impact blend. They MUST sum to 1: at rest every modifier is 1.0 and
// the blend returns 1.0, so a neutral incident is unchanged. Multiplying them instead would
// let a knight striking a bishop in a public square stack to a tenfold swing.
#define BOND_SHARE_ROLE "role"
#define BOND_SHARE_LORE "lore"
#define BOND_SHARE_STORYTELLER "storyteller"
#define BOND_SHARE_ZONE "zone"
#define BOND_SHARE_MAP "map"
// Cap on how far one pair's permanent warmth may travel inside one window, so a bad first
// minute cannot land two characters at maximum hatred before they have said a word.
#define BOND_MAX_SWING 25
#define BOND_SWING_WINDOW (10 MINUTES)
// Fraction of a personal event's permanent commit that bleeds into the two houses involved.
// House feuds are meant to be the accumulated residue of many incidents, never one fight.
#define BOND_HOUSE_PROPAGATION 0.25
// Influence pool: how many faction-moving acts one character is worth before the wider world
// stops counting them, how long that mute lasts, and how often the pool refills.
#define BOND_INFLUENCE_POOL 3
#define BOND_INFLUENCE_BAN (3 MINUTES)
#define BOND_INFLUENCE_REFILL (5 MINUTES)

// Kinship link kinds. A kin link is directed and always written as a reciprocal pair:
// A holding PARENT to B implies B holds CHILD to A. Spouse-like kinds mirror themselves.
// Kin links are /datum/social_bond/kin - structurally a bond, but unscored and unevictable,
// because kinship is a path fact, not a sentiment.
#define BOND_KIN_PARENT "parent"
#define BOND_KIN_CHILD "child"
#define BOND_KIN_SPOUSE "spouse"
#define BOND_KIN_FORMER_SPOUSE "former_spouse"
#define BOND_KIN_SWORN_SIBLING "sworn_sibling"
// Not a kinship in itself: remembers the term two people kept using for each other after the
// relative who linked them left. Each direction carries its own label.
#define BOND_KIN_PRESERVED "preserved"

#define BOND_GROUP_FAMILY "family"
#define BOND_GROUP_KNOWN "known"
#define BOND_GROUP_WARM "warm"
#define BOND_GROUP_COLD "cold"
#define BOND_GROUP_HOSTILE "hostile"

#define BONDLOG_DEBUG "DEBUG"
#define BONDLOG_INFO "INFO"
#define BONDLOG_WARN "WARN"
#define BONDLOG_ERROR "ERROR"

#include "bonds_config_maps.dm"
#include "bonds_config_roles.dm"
#include "bonds_config_gods.dm"
#include "bonds_config_vices.dm"
#include "bonds_core.dm"
#include "bonds_events.dm"
#include "bonds_stance_file.dm"
#include "bonds_factions.dm"
#include "bonds_context.dm"
#include "bonds_round.dm"
#include "bonds_dreams.dm"
#include "bonds_dream_file.dm"
#include "bonds_probe.dm"
#include "bonds_probe_deep.dm"
#include "bonds_dreams_gods.dm"
#include "bonds_dreams_maps.dm"
#include "bonds_panels.dm"
#include "bonds_admin.dm"
#include "bonds_debug.dm"
#include "bonds_unit_tests.dm"
