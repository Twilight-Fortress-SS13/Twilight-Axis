#define SEX_ORGAN_HANDS (1<<0)
#define SEX_ORGAN_LEGS (1<<1)
#define SEX_ORGAN_TAIL (1<<2)
#define SEX_ORGAN_MOUTH (1<<3)
#define SEX_ORGAN_ANUS (1<<4)
#define SEX_ORGAN_BREASTS (1<<5)
#define SEX_ORGAN_VAGINA (1<<6)
#define SEX_ORGAN_PENIS (1<<7)

#define SEX_POSE_BOTH_STANDING "both_standing"
#define SEX_POSE_USER_LYING    "user_lying"
#define SEX_POSE_TARGET_LYING  "target_lying"
#define SEX_POSE_BOTH_LYING    "both_lying"

#define ORG_KEY_NONE "none"
#define SEX_ORGAN_FILTER_MOUTH "mouth"
#define SEX_ORGAN_FILTER_LHAND "left_hand"
#define SEX_ORGAN_FILTER_RHAND "right_hand"
#define SEX_ORGAN_FILTER_HANDS "hands"
#define SEX_ORGAN_FILTER_LEGS "legs"
#define SEX_ORGAN_FILTER_TAIL "tail"
#define SEX_ORGAN_FILTER_BREASTS "breasts"
#define SEX_ORGAN_FILTER_VAGINA "genital_v"
#define SEX_ORGAN_FILTER_PENIS "genital_p"
#define SEX_ORGAN_FILTER_ANUS "genital_a"
#define SEX_ORGAN_FILTER_GENITAL "genital"
#define SEX_ORGAN_FILTER_BODY "body"
#define SEX_ORGAN_FILTER_ALL "all"

#define SEX_NODE_ALL     "all"
#define SEX_NODE_BODY    "body"
#define SEX_NODE_MOUTH   "mouth"
#define SEX_NODE_LHAND   "left_hand"
#define SEX_NODE_RHAND   "right_hand"
#define SEX_NODE_LEGS    "legs"
#define SEX_NODE_TAIL    "tail"
#define SEX_NODE_BREASTS "breasts"
#define SEX_NODE_VAGINA  "genital_v"
#define SEX_NODE_PENIS   "genital_p"
#define SEX_NODE_ANUS    "genital_a"

#define MOUTH_MAX_UNITS 10
#define VAGINA_MAX_UNITS 20
#define ANUS_MAX_UNITS 30

#define ERP_UI_MAX_AROUSAL 100

#define MILKING_BREAST_PROBABILITY 66

#define PENIS_MIN_EJAC_FRACTION 0.25
#define PENIS_MIN_EJAC_ABSOLUTE 1

#define SEX_MIN_REAGENT_QUANT	0.1
#define SEX_SENSITIVITY_MAX		2

#define COMSIG_SEX_MODIFY_EFFECT "sex_modify_effect"

var/global/regex/SEX_REGEX_DULLAHAN  = regex(@"\{dullahan\?([^:}]*):([^}]*)\}", "g")
var/global/regex/SEX_REGEX_AGGR      = regex(@"\{aggr\?([^:}]*):([^}]*)\}", "g")
var/global/regex/SEX_REGEX_BIGBREAST = regex(@"\{bigbreast\?([^:}]*):([^}]*)\}", "g")
var/global/list/GLOB_erp_recent_sensitive_turf_tick = list()
var/global/list/GLOB_erp_recent_sensitive_mob_tick  = list()

GLOBAL_VAR_INIT(sex_custom_action_seq, 0)
GLOBAL_LIST_INIT(sex_panel_actions, build_sex_panel_actions())
GLOBAL_LIST_INIT(erp_proxies_by_part, list())
GLOBAL_LIST_INIT(sex_node_defs, build_sex_node_defs())
GLOBAL_LIST_INIT(available_kinks, generate_kink_list())

#define SEX_PANEL_ACTION(sex_action_type) (GLOB.sex_panel_actions[sex_action_type])

/proc/build_sex_panel_actions()
	var/list/L = list()
	for(var/path in subtypesof(/datum/sex_panel_action))
		if(is_abstract(path))
			continue

		var/datum/sex_panel_action/A = new path()
		var/key = "[path]"
		L[key] = A

	return L

/proc/is_sex_toy(obj/item/I)
	if(!I)
		return FALSE

	if(istype(I, /obj/item/dildo))
		return TRUE

	return FALSE

/proc/get_speed_multiplier(s)
	switch(s)
		if(SEX_SPEED_LOW) return 1.0
		if(SEX_SPEED_MID) return 1.5
		if(SEX_SPEED_HIGH) return 2.0
		if(SEX_SPEED_EXTREME) return 2.5
	return 1.0

/proc/get_stamina_cost_multiplier(f)
	switch(f)
		if(SEX_FORCE_LOW) return 1.0
		if(SEX_FORCE_MID) return 1.5
		if(SEX_FORCE_HIGH) return 2.0
		if(SEX_FORCE_EXTREME) return 2.5
	return 1.0


/proc/build_sex_node_defs()
	var/list/L = list()
	L[SEX_NODE_ALL]     = list("name"="Все",        "organ_type"=null, "category"="filter")
	L[SEX_NODE_BODY]    = list("name"="Тело",       "organ_type"=null, "category"="body")
	L[SEX_NODE_MOUTH]   = list("name"="Рот",        "organ_type"=SEX_ORGAN_MOUTH,   "category"=SEX_NODE_MOUTH)
	L[SEX_NODE_LHAND]   = list("name"="Левая рука", "organ_type"=SEX_ORGAN_HANDS,  "category"=SEX_NODE_LHAND)
	L[SEX_NODE_RHAND]   = list("name"="Правая рука","organ_type"=SEX_ORGAN_HANDS,  "category"=SEX_NODE_RHAND)
	L[SEX_NODE_LEGS]    = list("name"="Ноги",       "organ_type"=SEX_ORGAN_LEGS,   "category"=SEX_NODE_LEGS)
	L[SEX_NODE_TAIL]    = list("name"="Хвост",      "organ_type"=SEX_ORGAN_TAIL,   "category"=SEX_NODE_TAIL)
	L[SEX_NODE_BREASTS] = list("name"="Грудь",      "organ_type"=SEX_ORGAN_BREASTS,"category"=SEX_NODE_BREASTS)
	L[SEX_NODE_VAGINA]  = list("name"="Вагина",     "organ_type"=SEX_ORGAN_VAGINA, "category"=SEX_ORGAN_FILTER_GENITAL)
	L[SEX_NODE_PENIS]   = list("name"="Член",       "organ_type"=SEX_ORGAN_PENIS,  "category"=SEX_ORGAN_FILTER_GENITAL)
	L[SEX_NODE_ANUS]    = list("name"="Анус",       "organ_type"=SEX_ORGAN_ANUS,   "category"=SEX_ORGAN_FILTER_GENITAL)
	return L

/proc/sex_next_time(delay)
	var/d = max(1, round(delay))
	return world.time + d

/proc/get_erp_proxies_for_part(obj/item/bodypart/part)
	if(!part)
		return null

	var/list/L = GLOB.erp_proxies_by_part[REF(part)]
	if(!islist(L) || !L.len)
		return null

	var/list/out = list()
	for(var/mob/living/carbon/human/erp_proxy/P in L)
		if(P && !QDELETED(P))
			out += P
	return out

/proc/generate_kink_list()
	var/list/kinks = list()
	for(var/datum/kink/K as anything in subtypesof(/datum/kink))
		if(is_abstract(K))
			continue
		kinks[initial(K.type)] = new K
	return kinks
