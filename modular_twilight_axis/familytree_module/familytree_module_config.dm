// === FAMILYTREE MODULE ===
// Include/config hub for the familytree module. Include this file from the DME compile section;
// pair it with familytree_module_deinclude.dm to clean up macros after the section.
// #include "modular_twilight_axis\familytree_module\familytree_module_config.dm"
//
// --- FILE MAP ---
// familytree_prefs_ui.dm            - prefs vars, runtime mirrors, character savefile load/save/sanitize, family_options TGUI backend
// familytree_mob_procs.dm           - MarryTo, player verbs, known families, UI toggles, open-preferences entry
// familytree_heritage_core.dm       - /datum/heritage: house, members, marriage, species calc, display build
// familytree_member.dm              - /datum/family_member: graph-facing accessors, relation terms, GetRelationshipTo, phantom links
// familytree_social.dm              - estates, role tiers, polygamy, lore-based polygyny/polyandry
// familytree_rituals.dm             - clergy helpers, desired-role search, ritual_adopt, vampire_bind, family_curse
// familytree_holy_verbs.dm          - holy skill verbs: establish_bond, dissolve_marriage (manual marriage/adoption/sibling)
// familytree_lifecycle.dm           - royal job hooks, enigma, noble dynasty, notifications, confirmation sessions, setspouse reset
// familytree_subsystem_core.dm      - SUBSYSTEM_DEF(familytree): init, signals, queue, local/royal runners
// familytree_subsystem_helpers.dm   - species/anatomy/gender compat, job helpers, age checks, DetermineAppropriateRole
// familytree_subsystem_matching.dm  - AddLocal, AssignToHouse/Family, NewlyWed/Family matching, favorite, wedding ring
// familytree_subsystem_royal.dm     - royal partner jobs, AddRoyal, lineage generation, royal hand offer
// familytree_graph_support.dm       - /datum/family_node, /datum/family_edge, /datum/family_graph_cache, validation
// familytree_graph_api.dm           - SSfamilytree graph facade + hooks + relation/display cache (source of truth for parent/spouse)
// familytree_debug.dm               - admin/debug scenarios (stress/royal/favorite/roles/isolated/edge/lifecycle)
// familytree_debug_populate.dm      - admin "populate my house" panel (ftpop_*). Admin/debug only
//
// TGUI: tgui/packages/tgui/interfaces/FamilySettingsPanel.tsx
//       tgui/packages/tgui/interfaces/FamilyDisplayPanel.tsx
//       tgui/packages/tgui/interfaces/FamilyDisplayPanel/*.tsx (FamilyTree, FamilyTreeBranch, FamilyTreeCard, FamilyListSections, types)
// Assets: relations.dmi
//
// Notes:
// - Debug files (familytree_debug.dm, familytree_debug_populate.dm) are optional admin/debug tooling; do not invoke without user request.
// - Any new #define here MUST be mirrored by a matching #undef in familytree_module_deinclude.dm.
// - When adding a new file, update this FILE MAP, the #include order below, and ai_navigation/AI_NAVIGATION.md.

//#define FAMILYTREE_DEBUG_LOGGING //UNDEFINE IT FOR THE LOCAL TESTING

// FAMILY_* are saved/global compatibility values used in savefiles and prefs.
// Not a strict enum: FAMILY_NEWLYWED = 4, FAMILY_FULL = 3 - do not assume order implies behavior.
// Runtime matching uses FAMILYTREE_MODE_* masks below, not these values directly.
#ifndef FAMILY_NONE
#define FAMILY_NONE 1
#define FAMILYTREE_MODULE_DEFINED_FAMILY_NONE
#endif

#ifndef FAMILY_PARTIAL
#define FAMILY_PARTIAL 2
#define FAMILYTREE_MODULE_DEFINED_FAMILY_PARTIAL
#endif

#define FAMILY_NEWLYWED 4

#ifndef FAMILY_FULL
#define FAMILY_FULL 3
#define FAMILYTREE_MODULE_DEFINED_FAMILY_FULL
#endif

// Runtime masks applied after prefs are loaded (load_familytree_runtime_preferences).
// OR'd in matching helpers; not saved to savefile. Saved/global FAMILY_* values stay unchanged for compatibility.
#define FAMILYTREE_MODE_DISABLED 0
#define FAMILYTREE_MODE_JOIN (1<<8)
#define FAMILYTREE_MODE_CREATE (1<<9)
#define FAMILYTREE_MODE_LEGACY_SPOUSE (1<<10)
#define FAMILYTREE_MODE_ALL (FAMILYTREE_MODE_JOIN | FAMILYTREE_MODE_CREATE | FAMILYTREE_MODE_LEGACY_SPOUSE)
// Phase gates for join/create matching. Do not bypass without updating AI_NAVIGATION.md gotchas.
#define FAMILYTREE_JOIN_CREATE_DELAY (2 MINUTES)
#define FAMILYTREE_RELATIVE_JOIN_DELAY (5 MINUTES)
#define FAMILYTREE_PREFERRED_MIN_HOUSE_SIZE 3
#define FAMILYTREE_PLAYERS_PER_TARGET_HOUSE 10
#define FAMILYTREE_MAX_RANDOM_RELATIVES 3
#define FAMILYTREE_DONATOR_RELATIVES_TIER 1

#define ANY_GENDER 1
#define SAME_GENDER 2
#define DIFFERENT_GENDER 3

#define FAMILY_FATHER "Father"
#define FAMILY_MOTHER "Mother"
#define FAMILY_PROGENY "Progeny"
#define FAMILY_OMMER "Parents Sibling"
#define FAMILY_INLAW "In Law"

// Polygamy flags consumed by familytree_social.dm and matching filters.
#define POLYGAMY_DISABLED 0
#define POLYGAMY_ALLOW_MULTIPLE 1
#define POLYGAMY_ALLOW_BE_SECOND 2
#define POLYGAMY_ALLOW_BOTH 3

// Desired-relative-role values. Used by prefs, TGUI FamilySettingsPanel, and matching for forced role assignment.
// Sanitized to RELATIVE_ANY for modes other than FAMILY_PARTIAL / FAMILY_NEWLYWED.
#define RELATIVE_ANY 0
#define RELATIVE_SIBLING 1
#define RELATIVE_PARENT 2
#define RELATIVE_CHILD 3
#define RELATIVE_UNCLE_AUNT 4
#define RELATIVE_SPOUSE 5

// --- Reject-reason bitmasks for subsystem matching diagnostics ---
// Read by familytree_debug.dm and log output; not used for control flow.
// AssignToHouse / HasSuitableHouseForRelative
#define FTREJ_H_CLOSED       (1<<0)
#define FTREJ_H_NONAME       (1<<1)
#define FTREJ_H_RELATIVES    (1<<2)
#define FTREJ_H_RACE         (1<<3)
#define FTREJ_H_AGE          (1<<4)
#define FTREJ_H_EMPTY        (1<<5)
#define FTREJ_H_OFFLINE      (1<<6)

// FindNewlyWedMatch
#define FTREJ_N_POLY         (1<<0)
#define FTREJ_N_OPTOUT       (1<<1)
#define FTREJ_N_BLOCK        (1<<2)
#define FTREJ_N_PRONOUNS     (1<<3)
#define FTREJ_N_SPECIES      (1<<4)
#define FTREJ_N_ESTATE       (1<<5)
#define FTREJ_N_TIER         (1<<6)
#define FTREJ_N_SETSPOUSE    (1<<7)

// FindFamilyMatch
#define FTREJ_F_CLOSED       (1<<0)
#define FTREJ_F_RACE         (1<<1)
#define FTREJ_F_POLY         (1<<2)
#define FTREJ_F_OFFLINE      (1<<3)
#define FTREJ_F_SETSPOUSE    (1<<4)
#define FTREJ_F_PRONOUNS     (1<<5)
#define FTREJ_F_SPECIES      (1<<6)
#define FTREJ_F_ESTATE       (1<<7)
#define FTREJ_F_TIER         (1<<8)
#define FTREJ_F_PARTIAL      (1<<9)
#define FTREJ_F_OPTOUT       (1<<10)

#include "familytree_prefs_ui.dm"
#include "familytree_mob_procs.dm"
#include "familytree_heritage_core.dm"
#include "familytree_member.dm"
#include "familytree_social.dm"
#include "familytree_rituals.dm"
#include "familytree_holy_verbs.dm"
#include "familytree_lifecycle.dm"
#include "familytree_subsystem_core.dm"
#include "familytree_subsystem_helpers.dm"
#include "familytree_subsystem_matching.dm"
#include "familytree_subsystem_royal.dm"
#include "familytree_graph_support.dm"
#include "familytree_graph_api.dm"
#include "familytree_debug.dm"
#include "familytree_debug_populate.dm"
