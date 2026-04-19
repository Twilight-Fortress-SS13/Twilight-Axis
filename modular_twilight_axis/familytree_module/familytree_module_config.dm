// === FAMILYTREE MODULE ===
// #include "modular_twilight_axis\familytree_module\familytree_module_config.dm"
//
// --- FILE MAP ---
// familytree_prefs_ui.dm            - vars, savefile prefs, display panel datum, family_options TGUI backend
// familytree_mob_procs.dm           - MarryTo, verbs, known families, UI toggles
// familytree_heritage_core.dm       - heritage datum: house, members, marriage, species calc, UI
// familytree_member.dm              - family_member traversal, gendered terms, GetRelationshipTo
// familytree_social.dm              - estates, role tiers, polygamy
// familytree_storytellers.dm        - storyteller influence, karma
// familytree_rituals.dm             - rituals, relative search, family_curse datum
// familytree_holy_verbs.dm          - holy skill spells
// familytree_lifecycle.dm           - royal job hooks, enigma, noble dynasty, notifications, confirmation
// familytree_subsystem_core.dm      - SSfamilytree: init, signals, lifecycle, queue
// familytree_subsystem_helpers.dm   - pronouns/species/anatomy compat, job helpers, age checks
// familytree_subsystem_matching.dm  - AssignToHouse/Family/NewlyWed matching
// familytree_subsystem_royal.dm     - royal partner jobs, lineage generation
// familytree_graph_support.dm       - graph: edges, nodes, cache, validation, debug
// familytree_graph_api.dm           - graph: SSfamilytree graph facade + hooks + relation cache
// familytree_debug.dm               - debug verbs
// familytree_debug_populate.dm      - "populate my house" debug panel with granular logs
//
// TGUI: tgui/packages/tgui/interfaces/FamilySettingsPanel.tsx
//       tgui/packages/tgui/interfaces/FamilyDisplayPanel/*.tsx
// Assets: relations.dmi

//#define FAMILYTREE_DEBUG_LOGGING //UNDEFINE IT FOR THE LOCAL TESTING

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

#define ANY_GENDER 1
#define SAME_GENDER 2
#define DIFFERENT_GENDER 3

#define FAMILY_FATHER "Father"
#define FAMILY_MOTHER "Mother"
#define FAMILY_PROGENY "Progeny"
#define FAMILY_OMMER "Parents Sibling"
#define FAMILY_INLAW "In Law"

#define POLYGAMY_DISABLED 0
#define POLYGAMY_ALLOW_MULTIPLE 1
#define POLYGAMY_ALLOW_BE_SECOND 2
#define POLYGAMY_ALLOW_BOTH 3

#define RELATIVE_ANY 0
#define RELATIVE_SIBLING 1
#define RELATIVE_PARENT 2
#define RELATIVE_CHILD 3
#define RELATIVE_UNCLE_AUNT 4
#define RELATIVE_SPOUSE 5

// --- Reject-reason bitmasks for subsystem matching diagnostics ---
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
#include "familytree_storytellers.dm"
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
