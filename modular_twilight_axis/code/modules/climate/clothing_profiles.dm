/obj/item/clothing
	var/ta_climate_thermal_explicit = FALSE

/proc/ta_climate_apply_thermal_profile(obj/item/clothing/C)
	if(!C || C.ta_climate_thermal_explicit)
		return
	var/covered = C.body_parts_covered & (HEAD | CHEST | GROIN | LEG_LEFT | LEG_RIGHT | FOOT_LEFT | FOOT_RIGHT | ARM_LEFT | ARM_RIGHT | HAND_LEFT | HAND_RIGHT)
	var/path_name = lowertext("[C.type]")
	var/display_name = lowertext(C.name)
	var/salvage_name = lowertext("[C.salvage_result]")
	var/fur = findtext(path_name, "fur") || findtext(path_name, "winter") || findtext(display_name, "fur ") || findtext(display_name, "мех") || findtext(salvage_name, "/fur")
	var/padded = findtext(path_name, "gambeson") || findtext(path_name, "padded") || findtext(path_name, "quilt") || findtext(path_name, "wool") || findtext(display_name, "шерст") || findtext(display_name, "утеплен")
	var/metal = findtext(path_name, "plate") || findtext(path_name, "chainmail") || findtext(path_name, "blacksteel") || findtext(path_name, "helmet") || findtext(path_name, "steel") || findtext(path_name, "brigandine") || findtext(path_name, "cuirass") || findtext(path_name, "sabatons") || findtext(path_name, "gauntlet")
	var/leather = findtext(path_name, "leather") || findtext(salvage_name, "/hide")
	var/summer = findtext(path_name, "summer") || findtext(path_name, "desert") || findtext(path_name, "silk") || findtext(path_name, "linen") || findtext(path_name, "sandals") || findtext(display_name, "лёгк") || findtext(display_name, "шелк")
	if(istype(C, /obj/item/clothing/cloak/tabard) || istype(C, /obj/item/clothing/ring) || istype(C, /obj/item/clothing/mask/cigarette))
		return
	if(istype(C, /obj/item/clothing/neck))
		if(!findtext(path_name, "scarf") && !findtext(path_name, "muffler") && !findtext(display_name, "шарф"))
			return
	if(!covered)
		if(istype(C, /obj/item/clothing/head))
			covered = HEAD
		else if(istype(C, /obj/item/clothing/gloves))
			covered = HAND_LEFT | HAND_RIGHT
		else if(istype(C, /obj/item/clothing/shoes))
			covered = FOOT_LEFT | FOOT_RIGHT
		else if(istype(C, /obj/item/clothing/cloak))
			covered = CHEST | ARM_LEFT | ARM_RIGHT
		else if(istype(C, /obj/item/clothing/neck))
			covered = HEAD
		else
			return
	if(!covered)
		return
	if(metal && !padded && !fur)
		return
	var/allow_cold = !summer
	var/allow_heat = summer || (!fur && !padded && !leather && !metal)
	if(istype(C, /obj/item/clothing/shoes) || istype(C, /obj/item/clothing/gloves))
		allow_heat = summer
	if(istype(C, /obj/item/clothing/cloak) && !summer)
		allow_heat = FALSE
	if(!allow_cold && !allow_heat)
		return
	if(allow_cold)
		if(istype(C, /obj/item/clothing/cloak) && (fur || padded))
			C.cold_protection = covered
		else if(!C.cold_protection)
			C.cold_protection = covered
		if(!C.min_cold_protection_temperature || ((fur || padded) && C.min_cold_protection_temperature > 50))
			C.min_cold_protection_temperature = (fur || padded) ? 50 : BODYTEMP_COLD_LEVEL_ONE_MAX
	if(istype(C, /obj/item/clothing/cloak) && (fur || padded) && !summer)
		C.heat_protection = 0
		C.max_heat_protection_temperature = BODYTEMP_NORMAL_MAX
	if(allow_heat)
		if(!C.heat_protection)
			C.heat_protection = covered
		if(!C.max_heat_protection_temperature)
			C.max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak
	ta_climate_thermal_explicit = FALSE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/absolutionistrobe
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/apron
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/cape
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/cape/fur
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = 50

/obj/item/clothing/cloak/cape/blkknight
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/captain
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/darkcloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/darkcloak/bear
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/duelcape
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/cloak/forrestercloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/forrestercloak/snow
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/cloak/graggar
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/half
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/cloak/heartfelt
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/lordcloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/lordcloak/ladycloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/cloak/matron
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/ordinatorcape
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/psyaltrist
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/raincloak/furcloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/shadowcloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/cloak/stole
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/tabard
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/templar/astratan
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/templar/eoran
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/templar/malumite
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/templar/necran
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/templar/pestran
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/templar/undivided
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/templar/xylixian
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/tribal
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/volfmantle
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/wardencloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/wickercloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/angle
	ta_climate_thermal_explicit = TRUE
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	ta_climate_thermal_explicit = TRUE
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = 600

/obj/item/clothing/gloves/roguetown/angle/gronn
	ta_climate_thermal_explicit = TRUE
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/gloves/roguetown/angle/gronnfur
	ta_climate_thermal_explicit = TRUE
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/gloves/roguetown/bandages
	ta_climate_thermal_explicit = TRUE
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/elven_gloves
	ta_climate_thermal_explicit = TRUE
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
	ta_climate_thermal_explicit = TRUE
	heat_protection = HAND_LEFT | HAND_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/leather
	ta_climate_thermal_explicit = TRUE
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/otavan
	ta_climate_thermal_explicit = TRUE
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/hooded/rainhood
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/hooded/rainhood/furhood
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/head/roguetown/antlerhood
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/armingcap
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/bardhat
	ta_climate_thermal_explicit = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/beekeeper
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/brimmed
	ta_climate_thermal_explicit = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/dendormask
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/fisherhat
	ta_climate_thermal_explicit = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/flathat
	ta_climate_thermal_explicit = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/grenzelhofthat
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/hatblu
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/hatfur
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/helmet/leather
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/inqhat
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/knitcap
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/menacing
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/menacing/bandit
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/necrahood
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/necramask
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/necromhood
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/papakha
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/head/roguetown/puritan/armored
	ta_climate_thermal_explicit = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/roguehood
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/roguehood/nochood
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/head/roguetown/roguehood/shalal
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = HEAD
	max_heat_protection_temperature = 600

/obj/item/clothing/head/roguetown/roguehood/shalal/heavyhood
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/head/roguetown/spellcasterhat
	ta_climate_thermal_explicit = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/head/roguetown/strawhat
	ta_climate_thermal_explicit = TRUE
	heat_protection = HEAD
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/mask/rogue/sack
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/neck/roguetown/coif
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/shoes/roguetown/anklets
	ta_climate_thermal_explicit = TRUE
	heat_protection = FOOT_LEFT | FOOT_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/shoes/roguetown/boots
	ta_climate_thermal_explicit = TRUE
	cold_protection = FOOT_LEFT | FOOT_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/shoes/roguetown/boots/armor
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN

/obj/item/clothing/shoes/roguetown/boots/furlinedboots
	ta_climate_thermal_explicit = TRUE
	cold_protection = FOOT_LEFT | FOOT_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	ta_climate_thermal_explicit = TRUE
	cold_protection = FOOT_LEFT | FOOT_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/shoes/roguetown/boots/maille
	ta_climate_thermal_explicit = TRUE
	cold_protection = FOOT_LEFT | FOOT_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/shoes/roguetown/shalal
	ta_climate_thermal_explicit = TRUE
	heat_protection = FOOT_LEFT | FOOT_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/gambeson/lord
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/heavy
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	ta_climate_thermal_explicit = TRUE
	heat_protection = CHEST
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/hide
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | VITALS
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/studded/warden
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/vest/sailor/nightman
	ta_climate_thermal_explicit = TRUE
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/leather/vest/winterjacket
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/armor/longcoat
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/plate/scale/inqcoat
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/silkcoat
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/workervest
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/dress/gown/summergown
	ta_climate_thermal_explicit = TRUE
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/dress/gown/wintergown
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/dress/silkdress
	ta_climate_thermal_explicit = TRUE
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/tunic/thinwinterdress
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/freifechter
	ta_climate_thermal_explicit = TRUE
	cold_protection = 10
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/robe
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/robe/hierophant
	ta_climate_thermal_explicit = TRUE
	heat_protection = CHEST | GROIN
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/robe/pointfex
	ta_climate_thermal_explicit = TRUE
	heat_protection = CHEST | GROIN | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX
	heat_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/shadowshirt
	ta_climate_thermal_explicit = TRUE
	heat_protection = CHEST | ARM_RIGHT | ARM_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/heavy_leather_pants
	ta_climate_thermal_explicit = TRUE
	cold_protection = LEG_RIGHT | LEG_LEFT | GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = 50

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	ta_climate_thermal_explicit = TRUE
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
	ta_climate_thermal_explicit = TRUE
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = 600

/obj/item/clothing/under/roguetown/heavy_leather_pants/shorts
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/trou
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN | LEG_RIGHT | LEG_LEFT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/trou/leather/gronn
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN
	min_cold_protection_temperature = 50

/obj/item/clothing/under/roguetown/trou/leather/pontifex
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/trou/shadowpants
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/wrists/roguetown/bracers/cloth
	ta_climate_thermal_explicit = TRUE
	cold_protection = ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/wrists/roguetown/bracers/leather
	ta_climate_thermal_explicit = TRUE
	cold_protection = ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	ta_climate_thermal_explicit = TRUE
	cold_protection = ARM_RIGHT | ARM_LEFT
	min_cold_protection_temperature = 50


/obj/item/clothing/mask/rogue/spectacles/goggles
	name = "sand goggles"
	desc = "Protective goggles that shield the eyes from blowing sand."
	icon_state = "goggles"
	max_integrity = 35
	integrity_failure = 0.5
	resistance_flags = FIRE_PROOF
	body_parts_covered = EYES
	anvilrepair = /datum/skill/craft/armorsmithing

/obj/item/clothing/mask/rogue/spectacles/goggles/equipped(mob/user, slot)
	. = ..()
	if(user && (slot == SLOT_WEAR_MASK || slot == SLOT_HEAD))
		user.update_fov_angles()

/obj/item/clothing/mask/rogue/spectacles/goggles/dropped(mob/user)
	. = ..()
	if(user)
		user.update_fov_angles()

/datum/crafting_recipe/roguetown/sewing/ta_climate_sand_goggles
	name = "sand goggles"
	result = list(/obj/item/clothing/mask/rogue/spectacles/goggles)
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1
	)
	craftdiff = 3

/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
	ta_climate_thermal_explicit = TRUE
	heat_protection = GROIN | LEG_RIGHT | LEG_LEFT
	max_heat_protection_temperature = BODYTEMP_HEAT_LEVEL_ONE_MAX

/obj/item/clothing/cloak/lepoardcloak
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/cloak/furcloak/woodland
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = 50
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/gloves/roguetown/cloth
	ta_climate_thermal_explicit = TRUE
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/gloves/roguetown/leather/ponyhooves
	ta_climate_thermal_explicit = TRUE
	cold_protection = HAND_LEFT | HAND_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/gambeson
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN | LEG_LEFT | LEG_RIGHT | FOOT_LEFT | FOOT_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/under/roguetown/skirt/gambeson
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN | LEG_LEFT | LEG_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/under/roguetown/skirt/gambeson/light
	ta_climate_thermal_explicit = TRUE
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/tights/clothlegs
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN | LEG_LEFT | LEG_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/under/roguetown/tights/shalwar
	ta_climate_thermal_explicit = TRUE
	cold_protection = GROIN | LEG_LEFT | LEG_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/robe/heavy
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT | LEG_LEFT | LEG_RIGHT
	min_cold_protection_temperature = 50

/obj/item/clothing/suit/roguetown/shirt/twilight_hammerhold/dress/robe/light
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT | LEG_LEFT | LEG_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/cloak/bandolier
	ta_climate_thermal_explicit = TRUE
	cold_protection = 0
	min_cold_protection_temperature = BODYTEMP_NORMAL_MIN
	heat_protection = 0
	max_heat_protection_temperature = BODYTEMP_NORMAL_MAX

/obj/item/clothing/neck/roguetown/collar/woolen
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/neck/roguetown/collar/fur
	ta_climate_thermal_explicit = TRUE
	cold_protection = HEAD
	min_cold_protection_temperature = 50

/obj/item/clothing/mask/rogue/facemask/padded
	ta_climate_thermal_explicit = TRUE

/obj/item/clothing/suit/roguetown/armor/brigandine
	ta_climate_thermal_explicit = TRUE
	cold_protection = CHEST | GROIN | ARM_LEFT | ARM_RIGHT
	min_cold_protection_temperature = BODYTEMP_COLD_LEVEL_ONE_MAX

/obj/item/clothing/suit/roguetown/armor/brigandine/light
	cold_protection = CHEST | GROIN
