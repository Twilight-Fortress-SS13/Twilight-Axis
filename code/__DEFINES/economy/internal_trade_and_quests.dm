#define TRADE_CATEGORY_BASIC_MINERAL "basic_mineral"
#define TRADE_CATEGORY_RARE_METAL "rare_metal"
#define TRADE_CATEGORY_PRECIOUS_METAL "precious_metal"
#define TRADE_CATEGORY_INTERMEDIARY "intermediary"
#define TRADE_CATEGORY_GRAIN "grain"
#define TRADE_CATEGORY_FRUIT "fruit"
#define TRADE_CATEGORY_VEGETABLE "vegetable"
#define TRADE_CATEGORY_ANIMAL "animal"
#define TRADE_CATEGORY_SEAFOOD "seafood"
#define TRADE_CATEGORY_CLOTH "cloth"
#define TRADE_CATEGORY_ARTISAN "artisan"
#define TRADE_CATEGORY_GEM_COMMON "gem_common"
#define TRADE_CATEGORY_GEM_RARE "gem_rare"
#define TRADE_CATEGORY_GEM_LEGENDARY "gem_legendary"
#define TRADE_CATEGORY_POTION "potion"

#define TRADE_BEHAVIOR_RAW "raw"
#define TRADE_BEHAVIOR_INTERMEDIARY "intermediary"
#define TRADE_BEHAVIOR_GEM "gem"
// Finished equipment. Fulfilled via warehouse tiles, not stockpile deposits.
#define TRADE_BEHAVIOR_EQUIPMENT "equipment"
// Finished potions. Fulfilled via warehouse tiles by reagent + volume, any container.
#define TRADE_BEHAVIOR_POTION "potion"

#define TRADE_REGION_KINGSFIELD "kingsfield"
#define TRADE_REGION_ROSAWOOD "rosawood"
#define TRADE_REGION_ROCKHILL "rockhill"
#define TRADE_REGION_DAFTSMARCH "daftsmarch"
#define TRADE_REGION_BLACKHOLT "blackholt"
#define TRADE_REGION_SALTWICK "saltwick"
#define TRADE_REGION_BLEAKCOAST "bleakcoast"
#define TRADE_REGION_NORTHFORT "northfort"
#define TRADE_REGION_HEARTFELT "heartfelt"
#define TRADE_REGION_HAGENWALD "hagenwald"
#define TRADE_REGION_AL_ASHUR_OASIS "al_ashur_oasis" // TA EDIT START
#define TRADE_REGION_AL_ASHUR_CARAVAN_ROAD "al_ashur_caravan_road"
#define TRADE_REGION_AL_ASHUR_SPICE_DUNES "al_ashur_spice_dunes"
#define TRADE_REGION_AL_ASHUR_GIZA_ROUTE "al_ashur_giza_route"
#define TRADE_REGION_AL_ASHUR_SUNKEN_RUINS "al_ashur_sunken_ruins" // TA EDIT END

#define STANDING_ORDER_DURATION 2
#define URGENT_ORDER_DURATION 1

// Order SIZE is not scaled but 
#define STANDING_ORDERS_BASE_PER_DAY 4
#define STANDING_ORDERS_PER_ACTIVE_PLAYER 0.05
#define STANDING_ORDERS_MAX_PER_DAY 13
#define STANDING_ORDERS_POOL_CAP 13
#define STANDING_ORDERS_MAX_PER_REGION 3
// Avoid spamming too many urgent orders
#define STANDING_ORDERS_MAX_URGENT 2

// Old defines for scaling order SIZE with pop. No longer used in favor of just adding more raw orders.
#define STANDING_ORDER_POP_SCALE_PER_PLAYER 0
#define STANDING_ORDER_POP_SCALE_MAX 3.0

#define STANDING_ORDER_BASE_BONUS 1.0

// Partial Fulfillment: Let players fulfill an order with 50% by VALUE for 85% payout
// So that steward / towners are still soft encouraged to fulfill the whole order
// But don't feel ripped off because they cannot fetch everything at once
#define STANDING_ORDER_PARTIAL_THRESHOLD 0.50
#define STANDING_ORDER_PARTIAL_PAYOUT_MULT 0.85
// Anti lag spam because every click would do a sweep and that could potentially get expensive
#define STANDING_ORDER_FULFILL_RETRY_COOLDOWN (2 SECONDS)
#define STANDING_ORDER_FULFILL_NEEDS_PARTIAL_PROMPT "needs_partial_prompt"



// Trade Escalation slope is the rate at which prices increase / decrease as it is oversold / overbought. Import / Export spread is an enforced differences between Buy / Sell price. By design, goods price is global for AP's internal regions, representing supply and demand and also preventing any same day arbitrage profit which does not generate meaningful gameplay but just reward you for reading and clicking the same damn buttons. 
#define TRADE_ESCALATION_SLOPE 1.0
#define IMPORT_EXPORT_SPREAD 0.25

#define TRADE_MAX_BULK_UNITS 50

// Blockade region are tradeable but at a punitive rate.
#define BLOCKADE_IMPORT_MULT 2.0
#define BLOCKADE_EXPORT_MULT 0.5

#define TRADE_STOCKPILE_BUY_DISCOUNT 0.75

#define STOCKPILE_AUTO_LIMIT_DAYS 2
#define STOCKPILE_LIMIT_MIN 5
#define STOCKPILE_LIMIT_MAX 40

// Buying the same import = escalating price
#define CROWN_IMPORT_ELASTICITY 0.25

#define REGION_POP_SCALE_PER_PLAYER 0.025
#define REGION_POP_SCALE_MAX 3.0


#define ECON_EVENT_DURATION 2
#define ECON_EVENT_SHORTAGE "shortage"
#define ECON_EVENT_OVERSUPPLY "oversupply"
#define ECON_EVENT_NARRATIVE "narrative"
#define ECON_EVENT_TARGET_COUNT 5
#define ECON_EVENT_ROUNDSTART_COUNT 3
#define ECON_EVENT_SATURATION_MULT 0.5
#define ECON_EVENT_SATURATION_MIN 5
#define ECON_EVENT_SATURATION_MAX 40
#define ECON_EVENT_REROLL_COOLDOWN_DAYS 7

#define ECON_SHORTAGE_MINOR   2.00
#define ECON_SHORTAGE_NORMAL  2.25
#define ECON_SHORTAGE_MAJOR   2.5
#define ECON_SHORTAGE_SEVERE  2.75
#define ECON_SHORTAGE_CRISIS  3.00

#define ECON_OVERSUPPLY_MINOR  0.70
#define ECON_OVERSUPPLY_NORMAL 0.65
#define ECON_OVERSUPPLY_MAJOR  0.60
#define ECON_OVERSUPPLY_SEVERE 0.55
#define ECON_OVERSUPPLY_GLUT   0.50

// Temp consequences for bnaditry
#define BANDITRY_DRAIN_DANGEROUS_FLAT 40
#define BANDITRY_DRAIN_BLEAK_FLAT 80
#define BANDITRY_DRAIN_DANGEROUS_PER_PLAYER 1
#define BANDITRY_DRAIN_BLEAK_PER_PLAYER 2
// 500 above the default purse floor so that banditry won't tank econ on its own
#define BANDITRY_DEBT_FLOOR 1500


#define BLOCKADE_ROUNDSTART_COUNT_MIN 2
#define BLOCKADE_ROUNDSTART_COUNT_MAX 3
#define BLOCKADE_RECLEAR_COOLDOWN 1
#define BLOCKADE_SCROLL_PLEDGE_COST 500
#define BLOCKADE_SCROLL_REWARD 500

#define BLOCKADE_REPLENISH_FLOOR 1
#define BLOCKADE_REPLENISH_BUDGET_BASE 1
#define BLOCKADE_REPLENISH_BUDGET_PER_PLAYER 0.02  // +1 per 50 active players
#define BLOCKADE_REPLENISH_BUDGET_MAX 2
#define BLOCKADE_REPLENISH_FIRST_DAY 2
#define BLOCKADE_REPLENISH_LAST_DAY 5 // No last minute blockade
#define BLOCKADE_REPLENISH_DAILY_CHANCE 50 // Chance to fire on an eligible day

#define COMMISSION_BONUS_PAY_NONE 0
#define COMMISSION_BONUS_PAY_LIGHT 1
#define COMMISSION_BONUS_PAY_FULL 2
#define COMMISSION_BONUS_PAY_LIGHT_MULT 1.25
#define COMMISSION_BONUS_PAY_MULT 1.5

#define PETITIONS_PER_DAY 3
#define PETITION_TAX_MULT 0.80
#define PETITION_BLOCKADE_RECOVERY_DAYS 2

#define PETITION_CATEGORY_PROVISIONS "provisions"
#define PETITION_CATEGORY_MATERIALS "materials"
#define PETITION_CATEGORY_ARMS "arms"
#define PETITION_CATEGORY_LUXURIES "luxuries"
#define PETITION_CATEGORY_ALCHEMY "alchemy"
#define PETITION_CATEGORY_MASTERWORK "masterwork"

#define PETITION_COST_PROVISIONS 200
#define PETITION_COST_MATERIALS 250
#define PETITION_COST_ARMS 300
#define PETITION_COST_LUXURIES 350
#define PETITION_COST_ALCHEMY 350
#define PETITION_COST_MASTERWORK 400

/proc/ta_economy_realm_name()
	var/realm = SSmapping?.map_adjustment?.realm_name
	if(!realm)
		return "Azuria"
	return realm

/proc/ta_economy_map_name()
	return SSmapping?.config?.map_name || ""

/proc/ta_economy_realm_type()
	var/realm_type = SSmapping?.map_adjustment?.realm_type
	if(!realm_type)
		return "Crown"
	return realm_type

/proc/ta_economy_default_azurian_labels()
	var/realm = lowertext("[ta_economy_realm_name()]")
	return (!realm || realm == "azuria" || realm == "azure peak")

/proc/ta_economy_al_ashur_labels()
	return lowertext("[ta_economy_realm_name()]") == "al-ashur"

/proc/ta_economy_rockhill_labels()
	var/map_name = lowertext("[ta_economy_map_name()]")
	var/realm = lowertext("[ta_economy_realm_name()]")
	return (map_name == "rockhill" || realm == "enigma")

/proc/ta_economy_authority_noun()
	if(ta_economy_default_azurian_labels())
		return "Crown"
	return ta_economy_realm_type()

/proc/ta_economy_authority_capital()
	if(ta_economy_default_azurian_labels())
		return "The Crown"
	return "The [ta_economy_realm_type()]"

/proc/ta_economy_authority_lower()
	if(ta_economy_default_azurian_labels())
		return "the Crown"
	return "the [ta_economy_realm_type()]"

/proc/ta_economy_authority_possessive()
	if(ta_economy_default_azurian_labels())
		return "Crown's"
	return "[ta_economy_realm_type()]'s"

/proc/ta_economy_authority_possessive_lower()
	if(ta_economy_default_azurian_labels())
		return "the Crown's"
	return "the [ta_economy_realm_type()]'s"

/proc/ta_economy_authority_purse()
	return "[ta_economy_authority_possessive()] Purse"

/proc/ta_economy_trade_company()
	if(ta_economy_default_azurian_labels())
		return "Azurian Trading Company"
	if(ta_economy_al_ashur_labels())
		return "Ashurian Trading Company"
	return "[ta_economy_realm_name()] Trading Company"

/proc/ta_economy_trade_company_the()
	return "the [ta_economy_trade_company()]"

/proc/ta_economy_burghers_lower()
	if(ta_economy_default_azurian_labels())
		return "the Burghers of Azuria"
	if(ta_economy_al_ashur_labels())
		return "the merchants of Al-Ashur"
	return "the burghers of [ta_economy_realm_name()]"

/proc/ta_economy_burghers_capital()
	if(ta_economy_default_azurian_labels())
		return "The Burghers of Azuria"
	if(ta_economy_al_ashur_labels())
		return "The merchants of Al-Ashur"
	return "The burghers of [ta_economy_realm_name()]"

/proc/ta_economy_pledge_capital()
	if(ta_economy_al_ashur_labels())
		return "Merchant Pledge"
	return "Burgher Pledge"

/proc/ta_economy_pledge_lower()
	if(ta_economy_al_ashur_labels())
		return "the Merchant Pledge"
	return "the Burgher Pledge"

/proc/ta_economy_pledge_grace_capital()
	if(ta_economy_al_ashur_labels())
		return "The merchants' grace"
	if(ta_economy_default_azurian_labels())
		return "The Burghers' grace"
	return "The burghers' grace"

/proc/ta_economy_company_patron_gods()
	if(ta_economy_default_azurian_labels())
		return "Malum the Worker and Abyssor the Dreamer"
	if(ta_economy_al_ashur_labels())
		return "the patrons of caravan and counting-house"
	return "the patrons of commerce"

/proc/ta_economy_ruler_title()
	if(ta_economy_default_azurian_labels())
		return "Lord"
	if(ta_economy_al_ashur_labels())
		return "Sultan"
	if(ta_economy_realm_type() == "Kingdom")
		return "Monarch"
	return "Ruler"

/proc/ta_economy_loan_settled_title()
	if(ta_economy_default_azurian_labels())
		return "ATC LOAN SETTLED"
	return "COMPANY LOAN SETTLED"

/proc/ta_economy_borrows_title()
	return "[uppertext(ta_economy_authority_capital())] BORROWS"

/proc/ta_economy_burghers_lend_title()
	if(ta_economy_default_azurian_labels())
		return "THE BURGHERS LEND"
	return "THE MERCHANTS LEND"

/proc/ta_economy_burghers_paid_title()
	if(ta_economy_default_azurian_labels())
		return "THE BURGHERS PAID"
	return "THE MERCHANTS PAID"

/proc/ta_economy_church_label()
	if(ta_economy_default_azurian_labels())
		return "the Church of Azuria"
	if(ta_economy_al_ashur_labels())
		return "the Temple of Al-Ashur"
	return "the Church of [ta_economy_realm_name()]"

/proc/ta_economy_seizure_inventory()
	if(ta_economy_default_azurian_labels())
		return GLOB.atc_seizure_inventory.Copy()
	if(ta_economy_al_ashur_labels())
		return list(
			"a gilded basin from the palace baths",
			"three sealed jars of oasis saffron",
			"a pearl-inlaid counting chest from the bazaar",
			"two silk awnings taken down from the Sultan's court",
			"a jeweled astrolabe from the palace observatory",
			"the Vizier's reserve of cinnamon and myrrh",
			"a lacquered chest of caravan toll seals",
			"four bolts of Gizan silk",
			"a pair of trained saigaks from the royal stables",
			"a crate of glassware from the desert furnaces",
			"a cedar writing desk from the scribal hall",
			"a sealed coffer marked PROPERTY OF THE SULTANATE",
		)
	return list(
		"three sealed coffers from the treasury",
		"a gilded ceremonial basin",
		"a brace of falcons from the ruler's mews",
		"the Steward's reserve of spices",
		"a brocaded canopy bed, taken down with great difficulty",
		"a chest of stamped toll seals",
		"a silvered court mirror",
		"a set of ceremonial parade harnesses",
		"a parcel of foreign silk",
		"a sealed coffer marked PROPERTY OF [uppertext(ta_economy_realm_name())]",
	)

/proc/ta_economy_realm_labels_payload()
	return list(
		"authority_noun" = ta_economy_authority_noun(),
		"authority_capital" = ta_economy_authority_capital(),
		"authority_lower" = ta_economy_authority_lower(),
		"authority_possessive" = ta_economy_authority_possessive(),
		"authority_possessive_lower" = ta_economy_authority_possessive_lower(),
		"authority_purse" = ta_economy_authority_purse(),
		"trade_company" = ta_economy_trade_company(),
		"trade_company_the" = ta_economy_trade_company_the(),
		"burghers_capital" = ta_economy_burghers_capital(),
		"burghers_lower" = ta_economy_burghers_lower(),
		"pledge_capital" = ta_economy_pledge_capital(),
		"pledge_lower" = ta_economy_pledge_lower(),
		"pledge_grace_capital" = ta_economy_pledge_grace_capital(),
	)

