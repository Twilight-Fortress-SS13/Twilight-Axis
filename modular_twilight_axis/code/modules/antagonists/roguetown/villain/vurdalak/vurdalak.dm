/mob/living/carbon/human
	var/vurdalak_str_mod = 0
	var/vurdalak_spd_mod = 0
	var/vurdalak_con_mod = 0
	var/vurdalak_per_mod = 0
	var/vurdalak_wil_mod = 0
	var/meat_lux_charge = FALSE
	var/vurdalak_is_big = FALSE
	var/vurdalak_corpses_devoured = 0
	var/vurdalak_ascended = FALSE
	var/vurdalak_in_sun = FALSE


/mob/living/carbon/human/proc/is_in_vurdalak_zone(area/check_area)
	var/area/A = check_area || get_area(src)
	if(!A)
		return FALSE
	if(istype(A, /area/rogue/outdoors/bog) || \
	   istype(A, /area/rogue/outdoors/bograt) || \
	   istype(A, /area/rogue/indoors/shelter/bog) || \
	   istype(A, /area/rogue/indoors/shelter/bograt) || \
	   istype(A, /area/rogue/indoors/shelter/bog_hag) || \
	   istype(A, /area/rogue/under/cavewet) || \
	   istype(A, /area/rogue/under/cave))
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_exposed_to_daylight()
	if(GLOB.tod != "day" && GLOB.tod != "dusk")
		return FALSE
	var/area/A = get_area(src)
	if(!A)
		return FALSE
	if(A.fog_protected || A.plane == INDOOR_PLANE)
		return FALSE
	if(istype(A, /area/rogue))
		var/area/rogue/R = A
		if(R.ceiling_protected)
			return FALSE
	return TRUE

/mob/living/carbon/human/proc/check_vurdalak_ascension()
	if(vurdalak_ascended || vurdalak_corpses_devoured < 3)
		return

	vurdalak_ascended = TRUE
	vurdalak_is_big = TRUE

	if(dna?.species)
		dna.species.custom_base_icon = "vurdalak_big"
	update_body_parts(TRUE)

	if(skin_armor)
		skin_armor.icon_state = "vurdalak_big"
		skin_armor.max_integrity = round(skin_armor.max_integrity * 1.5)
		skin_armor.obj_integrity = skin_armor.max_integrity
		update_inv_armor_special()

	ADD_TRAIT(src, TRAIT_ZJUMP, "vurdalak_ascension")
	ADD_TRAIT(src, TRAIT_STRENGTH_UNCAPPED, "vurdalak_ascension")
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, "vurdalak_ascension_2")
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, "nofalldamage1")

	var/datum/action/cooldown/spell/vurdalak_claws/C = locate(/datum/action/cooldown/spell/vurdalak_claws) in actions
	if(C)
		C.claw_type = /obj/item/rogueweapon/werewolf_claw/vurdalak/ascended

	var/datum/action/cooldown/spell/vurdalak_roar/R = new(src)
	R.Grant(src)

	to_chat(src, "<span class='userdanger'>ПОГЛОЩЕННЫЕ ДУШИ НАПИТАЛИ ВАС ДРЕВНЕЙ СИЛОЙ!</span>")
	playsound(src, 'sound/effects/werewolf_sounds/wscream5.ogg', 100, FALSE)

	regenerate_icons()

/mob/living/carbon/human/species/vurdalak
	race = /datum/species/vurdalak
	footstep_type = FOOTSTEP_MOB_HEAVY
	pixel_x = -8
	base_pixel_x = -8
	pixel_y = -4
	base_pixel_y = -4

/mob/living/carbon/human/can_speak_in_language(datum/language/dt)
	if(dna?.species?.id == "vurdalak")
		return (dt == /datum/language/vurdalak || istype(dt, /datum/language/vurdalak))
	return ..()

/mob/living/carbon/human/get_standard_pixel_x_offset()
	if(dna?.species?.id == "vurdalak")
		return vurdalak_is_big ? -10 : -8
	return ..()


/mob/living/carbon/human/get_standard_pixel_y_offset(lying_level = 0)
	if(dna?.species?.id == "vurdalak")
		return vurdalak_is_big ? 0 : -4
	return ..()

/mob/living/carbon/human/species/vurdalak/updatehealth()
	..()
	remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)
	remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN_FLYING)

/mob/living/carbon/human/species/vurdalak/death(gibbed, nocutscene = FALSE)
	. = ..(gibbed, nocutscene)

/mob/living/carbon/human/species/vurdalak/male
	gender = MALE

/mob/living/carbon/human/species/vurdalak/female
	gender = FEMALE


/datum/species/vurdalak
	name = "vurdalak"
	id = "vurdalak"
	custom_rotation_icon = TRUE
	custom_base_icon = "vurdalak"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES, NOBLOOD)
	inherent_traits = list(
		TRAIT_LONGSTRIDER,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_NOMOOD,
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
		TRAIT_IGNORESLOWDOWN,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_SHOCKIMMUNE,
		TRAIT_SILVER_WEAK,
		TRAIT_SPELLCOCKBLOCK,
		TRAIT_PIERCEIMMUNE,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOSTINK,
		TRAIT_NASTY_EATER,
		TRAIT_ORGAN_EATER,
		TRAIT_TOXIMMUNE,
		TRAIT_BREADY,
		TRAIT_STEELHEARTED,
		TRAIT_BASHDOORS,
		TRAIT_NOSLEEP,
		TRAIT_GRABIMMUNE,
		TRAIT_STRONGBITE,
		TRAIT_LYCANRESILENCE,
		TRAIT_GNARLYDIGITS,
		TRAIT_BOGWALKER,
		TRAIT_BLOODLOSS_IMMUNE,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	soundpack_m = /datum/voicepack/vurdalak
	soundpack_f = /datum/voicepack/vurdalak
	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/vurdalak,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision/werewolf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)
	languages = list(
		/datum/language/vurdalak
	)


/datum/species/vurdalak/spec_death(gibbed, mob/living/carbon/human/H)
	..()
	if(!gibbed && H && !QDELETED(H))
		replace_with_vurdalak_corpse(H)

/datum/species/vurdalak/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'modular_twilight_axis/icons/roguetown/mob/monster/vurdalak.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)

	var/is_big = H.vurdalak_is_big

	if(is_big)
		H.base_pixel_x = -10
		H.pixel_x = -10
		H.base_pixel_y = 0
		H.pixel_y = 0
	else
		H.base_pixel_x = -8
		H.pixel_x = -8
		H.base_pixel_y = -4
		H.pixel_y = -4

	var/target_state
	if(H.stat == DEAD || H.IsKnockdown() || H.IsParalyzed())
		target_state = is_big ? "vurdalak_big_down" : "vurdalak_down"
	else
		target_state = is_big ? "vurdalak_big" : "vurdalak"

	H.icon_state = target_state

	if(H.skin_armor)
		H.skin_armor.icon_state = target_state

	H.update_damage_overlays()
	H.update_inv_armor_special()
	return TRUE


/datum/species/vurdalak/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/vurdalak)

	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		var/obj/item/organ/taur_organ = H.getorganslot(ORGAN_SLOT_TAUR_BODY)
		if(taur_organ)
			qdel(taur_organ)

		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_TAUR || istype(BP, /obj/item/bodypart/taur))
				H.bodyparts -= BP
				qdel(BP)

		H.remove_overlay(BODYPARTS_LAYER)
		H.update_body_parts(TRUE)

	RegisterSignal(C, COMSIG_ENTER_AREA, PROC_REF(on_enter_area))

	if(ishuman(C))
		check_area_buff(C, get_area(C))

/datum/species/vurdalak/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_ENTER_AREA)
	if(ishuman(C))
		remove_bog_buff(C)

/datum/species/vurdalak/proc/check_area_buff(mob/living/carbon/human/H, area/A)
	if(!A)
		remove_bog_buff(H)
		return

	if(H.is_in_vurdalak_zone(A))
		apply_bog_buff(H)
	else
		remove_bog_buff(H)

/datum/species/vurdalak/proc/on_enter_area(mob/living/carbon/human/H, area/new_area)
	SIGNAL_HANDLER
	if(!istype(H) || H.stat == DEAD)
		return
	check_area_buff(H, new_area)

/datum/species/vurdalak/proc/apply_bog_buff(mob/living/carbon/human/H)
	if(H.vurdalak_str_mod > 0)
		return

	var/buff_amount = 3
	H.STASTR += buff_amount
	H.STASPD += buff_amount
	H.STACON += buff_amount
	H.STAPER += buff_amount
	H.STAWIL += buff_amount

	H.vurdalak_str_mod = buff_amount
	to_chat(H, span_notice("Вы чувствуете силу родных болот! Ваши мышцы наполняются яростью."))

/datum/species/vurdalak/proc/remove_bog_buff(mob/living/carbon/human/H)
	if(H.vurdalak_str_mod <= 0)
		return

	var/buff_amount = H.vurdalak_str_mod
	H.STASTR -= buff_amount
	H.STASPD -= buff_amount
	H.STACON -= buff_amount
	H.STAPER -= buff_amount
	H.STAWIL -= buff_amount

	H.vurdalak_str_mod = 0
	to_chat(H, span_warning("Вы покинули родные топи... Сила болот покидает ваше тело."))

/datum/species/vurdalak/get_taur_list()
	return list()

/datum/species/vurdalak/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

/datum/species/vurdalak/random_name(gender,unique,lastname)
	return "Vurdalak"

/datum/species/vurdalak/spec_life(mob/living/carbon/human/H)
	..()
	if(H.stat == DEAD)
		return
	var/is_exposed = H.is_exposed_to_daylight()

	if(is_exposed && !H.vurdalak_in_sun)
		H.vurdalak_in_sun = TRUE
		H.STASTR -= 5
		H.STASPD -= 5
		H.STACON -= 5
		H.STAPER -= 5
		H.STAWIL -= 5
		to_chat(H, span_userdanger("Солнечный свет давит на вас! Ваши силы тают!"))

	else if(!is_exposed && H.vurdalak_in_sun)
		H.vurdalak_in_sun = FALSE
		H.STASTR += 5
		H.STASPD += 5
		H.STACON += 5
		H.STAPER += 5
		H.STAWIL += 5
		to_chat(H, span_notice("Тень укрывает вас... Силы возвращаются в норму."))

	if(!is_exposed)
		H.adjustBruteLoss(-0.4)
		H.adjustFireLoss(-0.4)
	else
		if(prob(4))
			to_chat(H, span_userdanger("Солнечный свет сжигает вашу проклятую кожу! Немедленно найдите тень!"))
			H.adjustFireLoss(1)


/obj/item/clothing/suit/roguetown/armor/regenerating/skin/vurdalak_skin
	slot_flags = null
	name = "vurdalak hide"
	desc = "Покрытая болотной тиной шкура вурдалака. Она невероятно прочная и гасит удары мечей и стрел."
	mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/mob/monster/vurdalak.dmi'
	icon = 'modular_twilight_axis/icons/roguetown/mob/monster/vurdalak.dmi'
	icon_state = "vurdalak"
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_GNOLL_STANDARD
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 350
	item_flags = DROPDEL
	species_exception = list(/datum/species/vurdalak)

	auto_repair_mode = TRUE
	auto_repair_mode_base = 100
	auto_repair_mode_time = 15 SECONDS
	interrupt_damount = 15
	blue_to_integ_ratio = 0.6


/datum/antagonist/vurdalak
	name = "Vurdalak"
	roundend_category = "Vurdalaks"
	antagpanel_category = "Vurdalak"
	job_rank = ROLE_VURDALAK
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	rogue_enabled = TRUE
	has_tempo = FALSE

/datum/antagonist/vurdalak/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		owner.special_role = name
		H.set_patron(/datum/patron/divine/undivided)

		H.faction |= "undead"
		H.faction |= "zombie"
		H.faction |= "skeleton"
		H.faction |= "dundead"
		H.faction |= "lich"

		H.STASTR = 7
		H.STAPER = 5
		H.STAINT = 3
		H.STAWIL = 9
		H.STACON = 7
		H.STASPD = 6
		H.STALUC = 10

		if(istype(H.dna?.species, /datum/species/dullahan))
			var/datum/species/dullahan/D = H.dna.species
			if(D.my_head)
				UnregisterSignal(D.my_head, COMSIG_QDELETING)
				D.my_head = null

		var/obj/item/bodypart/head/dullahan/DH = H.get_bodypart(BODY_ZONE_HEAD)
		if(istype(DH))
			UnregisterSignal(DH, COMSIG_QDELETING)

		H.status_flags |= GODMODE
		H.set_species(/datum/species/vurdalak)
		addtimer(CALLBACK(src, PROC_REF(remove_vurdalak_godmode), H), 2)

		H.fully_replace_character_name(H.real_name, "Vurdalak")
		H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_EXPERT, TRUE)
		add_verb(H, /mob/living/carbon/human/verb/vurdalak_inspect_pelt)

		var/list/spells_to_give = list(
			/datum/action/cooldown/spell/vurdalak_claws,
			/datum/action/cooldown/spell/vurdalak_seek_brain,
			/datum/action/cooldown/spell/vurdalak_ambush,
			/datum/action/cooldown/spell/vurdalak_devour,
			/datum/action/cooldown/spell/vurdalak_raise_kin,
			/datum/action/cooldown/spell/vurdalak_gnaw
		)
		for(var/spell_type in spells_to_give)
			var/datum/action/cooldown/spell/S = new spell_type(H)
			S.Grant(H)

		var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/vurdalak_skin/hide = new(H)
		H.skin_armor = hide
		H.update_inv_armor_special()
		addtimer(CALLBACK(src, PROC_REF(purge_and_set_vurdalak_language), H), 1 SECONDS)
		greet(H)

/datum/antagonist/vurdalak/proc/remove_vurdalak_godmode(mob/living/carbon/human/H)
	if(H && !QDELETED(H))
		H.status_flags &= ~GODMODE

/datum/antagonist/vurdalak/greet(mob/living/carbon/human/H)
	if(!H || !H.client)
		return

	H.playsound_local(get_turf(H), 'sound/vo/mobs/vurdalak/vurdalak_spawn_near.ogg', 100, FALSE)

	to_chat(H, {"<div style='border: 2px solid #551a1a; background-color: #1a0808; color: #d1b8b8; padding: 8px; margin: 4px 0; font-size: 12px; line-height: 1.3;'><div style='color: #df1919; font-weight: bold; font-size: 14px; text-align: center; margin: 0 0 4px 0;'>ВЫ — БОЛОТНЫЙ ВУРДАЛАК</div><div style='font-style: italic; margin: 0 0 6px 0;'>Проклятые топи болот ужаса исторгли вас обратно в мир живых. Вы — вечно голодный мертвец, движимый жаждой плоти и жизненной силы. Для вас нет союзников кроме таких же вурдалаков.</div><hr style='border: 0; border-top: 1px solid #551a1a; margin: 4px 0;'><div style='color: #ff6666; font-weight: bold; margin: 4px 0 2px 0;'>ОСОБЕННОСТИ И СЛАБОСТИ:</div><div style='margin: 0 0 2px 0;'>• <b>Дневной свет опаляет:</b> Прячьтесь в тени, домах и пещерах. Солнце лишает сил и обжигает вас.</div><div style='margin: 0 0 2px 0;'>• <b>Неутолимый голод:</b>Вы способны пожирать органы с земли (СКМ с интентом BITE) получая регенерацию. А так же при укусе у вас есть шанс восстановить здоровье.</div><div style='margin: 0 0 2px 0;'>• <b>Пожирание Люкса:</b> Терзайте Люкс из трупов (<i>Devour Lux</i>). Пожрав 3 люкса, вы Возвыситесь до великого вурдалака.</div><div style='margin: 0 0 2px 0;'>• <b>Охота и засада:</b> Ищите живых (Seek Brain) и закапывайтесь в землю (Ambush) для внезапного удара.</div><div style='margin: 0 0 2px 0;'>• <b>Размножение:</b> Закапывайте Люкс в ямы грязи (Animate Corpse), чтобы болота породили нового вурдалака для жаждущего крови призрака.</div><hr style='border: 0; border-top: 1px solid #551a1a; margin: 4px 0;'><div style='text-align: center; color: #ff4444; font-weight: bold; margin: 4px 0 0 0;'>Проклятый неутолимым голодом, вечно скитайся в поисках живых..</div></div>"})

/datum/antagonist/vurdalak/on_removal()
	if(owner)
		owner.special_role = null
	return ..()

/datum/antagonist/vurdalak/proc/purge_and_set_vurdalak_language(mob/living/carbon/human/H)
	if(!istype(H) || QDELETED(H))
		return
	for(var/lang in GLOB.all_languages)
		H.remove_language(lang)
	H.grant_language(/datum/language/vurdalak)
	if(H.language_holder)
		H.language_holder.selected_default_language = /datum/language/vurdalak

	if(H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/vurdalak()
		H.dna.species.soundpack_f = new /datum/voicepack/vurdalak()
	H.voice_type = null

/mob/living/simple_animal/hostile/retaliate/rogue/vurdalak_corpse
	name = "dead vurdalak"
	desc = "Сраженное тело болотного вурдалака. Его можно разделать ножом"
	icon = 'modular_twilight_axis/icons/roguetown/mob/monster/vurdalak.dmi'
	icon_state = "vurdalak_down"
	icon_living = "vurdalak_down"
	icon_dead = "vurdalak_down"
	gender = MALE
	stat = DEAD
	density = FALSE
	anchored = FALSE
	health = 100
	maxHealth = 100
	var/is_big_corpse = FALSE


	butcher_results = list(
		/obj/item/vurdalak_head = 1,
		/obj/item/organ/heart/vurdalak = 1,
		/obj/item/natural/bone = 3
	)
	guaranteed_butcher_results = list()
	botched_butcher_results = list()
	perfect_butcher_results = list()


/proc/replace_with_vurdalak_corpse(mob/living/carbon/human/H)
	if(!H || QDELETED(H) || H.loc == null)
		return
	var/turf/T = get_turf(H)
	if(!T)
		return

	var/mob/living/simple_animal/hostile/retaliate/rogue/vurdalak_corpse/C = new(T)

	if(H.vurdalak_is_big)
		C.is_big_corpse = TRUE
		C.icon_state = "vurdalak_big_down"
		C.icon_living = "vurdalak_big_down"
		C.icon_dead = "vurdalak_big_down"
		C.name = "dead great vurdalak"
		C.butcher_results = list(
			/obj/item/vurdalak_head/big = 1,
			/obj/item/organ/heart/vurdalak = 1,
			/obj/item/natural/bone = 5
		)

	H.visible_message(span_userdanger("Вурдалак с тяжелым стоном валится замертво!"))

	H.moveToNullspace()
	H.alpha = 0
	qdel(H)


/obj/item/vurdalak_head
	name = "severed vurdalak head"
	desc = "Отрезанная голова болотного вурдалака. Ее глаза все еще слабо светятся проклятым огнем."
	icon = 'modular_twilight_axis/icons/roguetown/mob/monster/vurdalak.dmi'
	icon_state = "vurdalak_head"
	w_class = WEIGHT_CLASS_NORMAL
	sellprice = 300

/obj/item/vurdalak_head/Initialize(mapload)
	. = ..()
	sellprice = rand(250, 350)

/obj/item/vurdalak_head/big
	name = "severed great vurdalak head"
	desc = "Огромная отрезанная голова возвышенного вурдалака. Охотники отдадут за нее целое состояние."
	sellprice = 600

/obj/item/vurdalak_head/big/Initialize(mapload)
	. = ..()
	sellprice = rand(550, 650)


/obj/item/organ/heart/vurdalak
	name = "vurdalak's heart"
	desc = "Почерневшее болотное сердце, покрытое странными венами. Оно до сих пор бьется медленным, тяжелым ритмом."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cursedheart-on"
	sellprice = 50

/datum/job/roguetown/vurdalak
	title = "Vurdalak"
	display_title = "Vurdalak"
	faction = "Station"
	selection_color = "#df1919"
	department_flag = ANTAGONIST
	antag_job = TRUE
	display_order = JDO_VURD
	announce_latejoin = FALSE
	total_positions = 4
	spawn_positions = 4
	min_pq = 0
	max_pq = null
	bypass_jobban = FALSE
	always_show_on_latechoices = TRUE
	advclass_cat_rolls = list("vurdalak" = 20)
	job_subclasses = list(
		/datum/advclass/vurdalak
	)

/datum/job/roguetown/vurdalak/New()
	..()
	GLOB.antagonist_positions |= title

/datum/advclass/vurdalak
	name = "Vurdalak"
	tutorial = "Вы — проклятое болотное чудовище, жаждущее людской плоти и Люкса."
	category_tags = list("vurdalak")

/datum/job/roguetown/vurdalak/equip(mob/living/carbon/human/H, visualsOnly = FALSE, announce = TRUE, latejoin = FALSE, datum/outfit/outfit_override = null, client/preference_source)
	. = ..()
	if(visualsOnly)
		return

	GLOB.vurdalak_consumed_slots++
	H.mind.add_antag_datum(/datum/antagonist/vurdalak)

	var/obj/structure/vurdalak_ambush_mound/target_grave = null
	for(var/obj/structure/vurdalak_ambush_mound/M in GLOB.vurdalak_animated_graves)
		if(M.vurdalak_animated && M.vurdalak_slot_ready)
			target_grave = M
			break

	if(target_grave)
		GLOB.vurdalak_animated_graves -= target_grave
		target_grave.vurdalak_animated = FALSE
		target_grave.vurdalak_slot_ready = FALSE

		H.alpha = 0
		H.forceMove(target_grave)
		to_chat(H, span_userdanger("Вы восстали в оскверненной яме под землей! Выбирайтесь на поверхность!"))

		INVOKE_ASYNC(target_grave, TYPE_PROC_REF(/obj/structure/vurdalak_ambush_mound, vurdalak_emerge_sequence), H)

/datum/job/roguetown/vurdalak/after_spawn(mob/living/H, mob/M, latejoin = FALSE)
	. = ..()
	if(ishuman(H))
		var/mob/living/carbon/human/vurd = H
		if(vurd.dna?.species)
			vurd.dna.species.soundpack_m = new /datum/voicepack/vurdalak()
			vurd.dna.species.soundpack_f = new /datum/voicepack/vurdalak()
		vurd.voice_type = null

/datum/job/roguetown/vurdalak/override_latejoin_spawn(mob/living/carbon/human/H)
	if(istype(H.loc, /obj/structure/vurdalak_ambush_mound) || istype(H.loc, /obj/structure/closet/dirthole))
		return TRUE

	var/turf/spawn_turf = get_vurdalak_spawn_location()
	if(spawn_turf)
		H.forceMove(spawn_turf)

	return TRUE

/mob/living/carbon/human/proc/vurdalak_feed(mob/living/carbon/human/target, healing_amount = 25)
	if(!istype(target))
		return
	if(target.mind)
		if(target.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(src, span_warning("Я не должен питаться гнилой плотью."))
			return
		if(target.mind.has_antag_datum(/datum/antagonist/vurdalak))
			to_chat(src, span_warning("Я не должен питаться плотью сородичей."))
			return

	to_chat(src, span_notice("Вы впиваетесь зубами в теплую плоть! Ваше здоровье и шкура восстанавливаются."))
	heal_bodypart_damage(healing_amount, healing_amount)
	apply_status_effect(/datum/status_effect/buff/healing, 10)

	if(skin_armor)
		skin_armor.obj_integrity = min(skin_armor.max_integrity, skin_armor.obj_integrity + 30)
		update_inv_armor_special()

/obj/item/organ/onbite(mob/living/carbon/human/user)
	if(istype(user) && istype(user.dna?.species, /datum/species/vurdalak))
		user.visible_message(span_danger("[user] с омерзительным хрустом заглатывает и сжирает [src]!"), span_boldnotice("Вы жадно заглатываете [src], леча свои раны и шкуру!"))
		playsound(user, 'sound/surgery/organ1.ogg', 80, TRUE)

		user.heal_bodypart_damage(40, 40)
		user.apply_status_effect(/datum/status_effect/buff/healing, 15)
		user.setStaminaLoss(0)

		if(user.skin_armor)
			user.skin_armor.obj_integrity = min(user.skin_armor.max_integrity, user.skin_armor.obj_integrity + 50)
			user.update_inv_armor_special()
		qdel(src)
		return TRUE
	return ..()

/mob/living/carbon/human/verb/vurdalak_inspect_pelt()
	set name = "Inspect Pelt"
	set category = "RoleUnique"
	set desc = "Проверить целостность своей шкуры."

	if(dna?.species?.id != "vurdalak" || !skin_armor)
		return

	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/vurdalak_skin/S = skin_armor
	if(istype(S))
		var/pct = round((S.obj_integrity / S.max_integrity) * 100)
		var/msg = "Она держится на честном слове!"
		if(pct >= 90) msg = "Она в идеальном состоянии."
		else if(pct >= 50) msg = "Она немного потрепана."
		else if(pct >= 25) msg = "Она сильно повреждена!"

		to_chat(src, span_notice("<b>Состояние шкуры:</b> [S.obj_integrity] / [S.max_integrity] HP ([pct]%). [msg]"))

/datum/language/vurdalak
	name = "Vurdalak"
	desc = "Древний проклятый говор болотных вурдалаков, состоящий из глухого рыка, шипения и отрывистых горловых звуков."
	speech_verb = "рычит"
	ask_verb = "хрипит"
	exclaim_verb = "ревет"
	whisper_verb = "шипит"
	flags = TONGUELESS_SPEECH
	key = "v"
	default_priority = 100
	space_chance = 45
	sentence_chance = 10
	icon_state = "abyssal"

	syllables = list(
		"грр", " рр", "шкк", "к г", "ррх", "ссш", "ффх", "врр",
		"гх", "кх", "шш", "сс", "гр", "хр", "мн", "гн",
		"агг", "у р", "ыхх", "о р", "эшш", "икк", "уфф", "арх"
	)
