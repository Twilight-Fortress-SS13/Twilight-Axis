/datum/species/ooze
	name = "Murkling"
	id = "ooze"
	desc_title = "Мерклинг"
	desc = "Мало кому известно истинное происхождение Мерклингов. Древние летописи гласят что они зародились в глубоких, холодных пещерах Подземья. \
	где первозданная слизь заполняла туннели, яростно защищая свои «ямы рождения» — места, где она порождала жизнь. \
	На протяжении веков, Темные Эльфы и Дворфы-рудокопы изолировали эти области, стараясь не тревожить эту живую субстанцию. \
	Лишь в последнее столетие слизь начала меняться. \
	Из неё возникли грубые гуманоидные фигуры, наделенные зачатками разума. \
	Теперь они обрели облик людей: передвигаются на двух ногах, способны говорить и проявляют пугающее, чрезмерное любопытство. Бывшая некогда бездумной массой, эта субстанция превратилась в нечто совершенно иное. \
	Когда их «бассейны рождения» иссякли — подобно тому, как отпускают своих детей в самостоятельную жизнь — Мерклинги начали создавать собственные колонии. \
	Закаленные суровыми условиями глубин, они остаются крайне переменчивыми и наивными, пытаясь постичь мир на поверхности, где их зачастую считают чудовищами. \
	Следуя своей природе, Мерклинги стремительно приспосабливаются к окружающей среде: их тела меняют форму, подстраиваясь под земли, в которых они обитают. \
	Однако эта адаптивность — своего рода проклятие: их тела впитывают не только внешние очертания. \
	Пыль, духи или дым могут изменить их до неузноваемости, порождая сильную зависимость: \
	поглотив достаточное количество того или иного вещества, Мерклинги начинают вырабатывать его сами — оно становится для них источником существования. \
	Оказавшись вовлеченными в конфликты между королевствами и верованиями поверхности, Мерклинги ищут смысл жизни, отличный от того, что был заложен их изначальными «матерями». \
	Они обращаются к богам — ведь они весьма восприимчивы к вере, которая помогает заполнить пустоту, оставшуюся после исчезновения их «инкубаторов» — другие же полностью их отвергают\
	И всё же в каждом из них живет память о глубинах: о той безмолвной, всеобъемлющей любви и воле, из которых они когда-то появились на свет."
	blood_color = "#00FFFF" //Defaults to blue, but we recolor this later to match the slime person's body color.
	origin_default = /datum/virtue/origin/racial/underdark
	base_name = "Ooze"
	origin = "Underdark"
	default_color = "79F299"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS)
	restricted_virtues = list(/datum/virtue/utility/feral_appetite, /datum/virtue/utility/noble)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = FALSE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	allowed_body_builds = STANDARD_BODY_BUILDS
	default_body_build_m = BODY_BUILD_BULKY
	default_body_build_f = BODY_BUILD_SLIM
	race_bonus = list(STAT_CONSTITUTION = 1, STAT_INTELLIGENCE = 1)
	inherent_traits = list(
						TRAIT_NASTY_EATER,
						TRAIT_EASYDISMEMBER,
						TRAIT_REGROW_LIMBS,
						TRAIT_ZOMBIE_IMMUNE,
						TRAIT_WATERBREATHING,
						)
	enflamed_icon = "widefire"
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid/slime,
		/datum/customizer/bodypart_feature/hair/facial/humanoid/slime,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
		/datum/customizer/organ/snout/anthro/slime,
		/datum/customizer/organ/tail/slime,
		/datum/customizer/organ/ears/slime,
		/datum/customizer/organ/wings/slime,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/waist,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/ooze,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/ooze,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/ooze,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/ooze,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue/ooze,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/ooze,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/ooze,
		)

	mechanics_explanations = list("Бескостный — нечему ломаться. Однако при получении тупой травмы или в случае, если конечность должна была быть сломана, она плавится. Утраченные конечности точно так же плавятся ",
		"Могут восстанавливать утраченные конечности во время сна — ценой значительного истощения организма.",
		"Обладают кровью необычного цвета, которая совпадает с их цветом тела.")

////// ORGAN SPRITES, provided by VelSlime
/obj/item/organ/brain/ooze
	name = "Ooze Neural Core"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC
	decoy_override = TRUE

/obj/item/organ/lungs/ooze
	name = "Ooze Breathing Sac"
	icon = 'icons/obj/velslime.dmi'
	icon_state = "liver" //No lungs sprite, re-using the liver sprite instead.
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/heart/ooze
	name = "Ooze Fluid Pump"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/eyes/ooze
	name = "Ooze Ocular Sensors"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/tongue/wild_tongue/ooze
	name = "Ooze Taste Buds"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/stomach/ooze
	name = "Ooze Digestive Chamber"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/liver/ooze
	name = "Ooze Detoxification Organelle"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/datum/species/ooze/check_roundstart_eligible()
	return TRUE

//Set slime blood color to match body color.
/datum/species/ooze/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	blood_color = C.dna.features["mcolor"]
	blood_color = "#[blood_color]"

/datum/species/ooze/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/oozem.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/oozef.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/other/oozem.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/other/oozef.txt") )
	return randname

/datum/species/ooze/random_surname()
	return
