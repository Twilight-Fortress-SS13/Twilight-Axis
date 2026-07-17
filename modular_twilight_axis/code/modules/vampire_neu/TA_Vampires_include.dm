/*
	Twilight Axis vampire module include aggregator.

	Usage:
	- Include this file below upstream vampire includes.

	Notes:
	- Order mostly follows upstream roguetown.dme.
	- THRALLS_* are loaded from vampires_defines.dm and cleared at the bottom
	  via TA_Vampires_uniclude.dm.
*/

// Early define slot and shared cross-module vampire hooks.
#include "./vampires_defines.dm"

#include "./overrides/vagabond_vampire.dm"
#include "./overrides/bloodsuck.dm"
#include "./overrides/bloodstarvation.dm"
#include "./overrides/portal.dm"
#include "./overrides/vampire_forms.dm"
#include "./overrides/discipline_balance.dm"
#include "./overrides/celerity_costs.dm"
#include "./overrides/quietus.dm"
#include "./overrides/bloodacid_balance.dm"
#include "./overrides/misc_balance.dm"
#include "./overrides/presence_balance.dm"
#include "./overrides/fae_balance.dm"
#include "./overrides/siren_balance.dm"
#include "./ascended_covens.dm"
#include "./coven_level_purchases.dm"
#include "./crimson_crucible_ru_i18n.dm"
#include "./rockhill_masquerade.dm"
#include "./overrides/pallid_addiction.dm"
#include "./overrides/death_gifts.dm"
#include "./overrides/pallid_spells.dm"
#include "./overrides/quicksilver.dm"
#include "./overrides/transfix.dm"
#include "./overrides/vampire.dm"
#include "./overrides/vampire_lord_title.dm"
#include "./overrides/crucible_access.dm"
#include "./overrides/thinblood_restrictions.dm"

// Local defines
#include "./TA_Vampires_uniclude.dm"
