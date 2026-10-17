#define TAT_TRAIT_SOURCE	"tat_build"
#define TAT_ITEM_SOURCE_PAID "tat"
#define TAT_ITEM_SOURCE_TRAIT "trait"
#define TAT_ITEM_SOURCE_DONOR_LOADOUT "donor_loadout"


#define TAT_PARTY_LEADER_AURA_RANGE 7
#define TAT_PARTY_LEADER_REFRESH_INTERVAL (2 SECONDS)
#define TAT_PARTY_LEADER_BONUS_CON 1
#define TAT_PARTY_LEADER_BONUS_WIL 1
#define TAT_PARTY_LEADER_MEMBER_CON 1
#define TAT_PARTY_LEADER_LUCK_PER_MEMBER 0.5

#define TAT_STAT_ENTRY(_name, _cost, _base, _min, _max) list("name" = (_name), "cost" = (_cost), "base" = (_base), "min" = (_min), "max" = (_max))
#define TAT_TRAIT_ENTRY(_name, _cost, _desc) list("name" = (_name), "cost" = (_cost), "desc" = (_desc))
#define TAT_ITEM_ENTRY(_name, _cost, _category, _unlock_type, _unlock_key, _slot_group) list("name" = (_name), "cost" = (_cost), "category" = (_category), "unlock_type" = (_unlock_type), "unlock_key" = (_unlock_key), "slot_group" = (_slot_group))
#define TAT_ITEM_ENTRY_REQUIRES_TRAIT(_name, _cost, _category, _unlock_type, _unlock_key, _slot_group, _required_trait) list("name" = (_name), "cost" = (_cost), "category" = (_category), "unlock_type" = (_unlock_type), "unlock_key" = (_unlock_key), "slot_group" = (_slot_group), "required_trait" = (_required_trait))
#define TAT_DONATION_ITEM_ENTRY_EX(_name, _cost, _category, _unlock_type, _unlock_key, _slot_group, _donat_tier, _donat_ignore) list("name" = (_name), "cost" = (_cost), "category" = (_category), "unlock_type" = (_unlock_type), "unlock_key" = (_unlock_key), "slot_group" = (_slot_group), "donat_tier" = (_donat_tier), "donat_ignore" = (_donat_ignore))
#define TAT_DONATION_ITEM_ENTRY(_name, _cost, _category, _unlock_type, _unlock_key, _slot_group, _donat_tier) list("name" = (_name), "cost" = (_cost), "category" = (_category), "unlock_type" = (_unlock_type), "unlock_key" = (_unlock_key), "slot_group" = (_slot_group), "donat_tier" = (_donat_tier), "donat_ignore" = null)

#define TAT_SLOT_COUNT 9

#define TAT_ROLE_BUCKET_TOWNER "towner"
#define TAT_ROLE_BUCKET_TRADER "trader"
#define TAT_ROLE_BUCKET_ADVENTURER "adventurer"
#define TAT_ROLE_BUCKET_WRETCH "wretch"

#define TAT_SQL_ROLE_TOWNER "TAT Towner"
#define TAT_SQL_ROLE_TRADER "TAT Trader"
#define TAT_SQL_ROLE_ADVENTURER "TAT Adventurer"
#define TAT_SQL_ROLE_WRETCH "TAT Wretch"
#define TAT_SQL_ROLE_SYSTEM "TAT System"

#define TAT_BAN_DEFAULT_REASON "TAT system access revoked."
#define TAT_ROLE_LOCK_DEFAULT_REASON "TAT role access revoked."
#define TAT_ROLE_LOCK_DEFAULT_SEVERITY "Medium"
#define TAT_ROLE_LOCK_DEFAULT_DURATION 10080
#define TAT_ROLE_LOCK_DEFAULT_INTERVAL "MINUTE"

GLOBAL_LIST_EMPTY(tat_skill_entry_cache)
GLOBAL_VAR_INIT(tat_skill_entry_cache_ready, FALSE)
