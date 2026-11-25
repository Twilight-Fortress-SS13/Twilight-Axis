#define TRAIT_BROTHERHOOD_MEMBER "brotherhood_member"

/datum/advclass/mercenary/twilight_republican_comendant
	name = "Republican Comendant"
	tutorial = "Regardless of your past whether you’re a marshal who turned down his titles or a guardsman who rose through the ranks on his own. From now on, you’ll earn your living by leading others."
	outfit = /datum/outfit/job/roguetown/mercenary/twilight_republican_comendant
	traits_applied = list(TRAIT_STEELHEARTED)
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	maximum_possible_slots = 1
	origin_limits = list(/datum/virtue/origin/heartfelt)
	allowed_patrons = list(/datum/patron/divine/undivided, /datum/patron/divine/noc, /datum/patron/divine/dendor, /datum/patron/divine/abyssor, /datum/patron/divine/ravox, /datum/patron/divine/necra, /datum/patron/divine/xylix, /datum/patron/divine/pestra, /datum/patron/divine/malum, /datum/patron/divine/eora, /datum/patron/old_god, /datum/patron/inhumen/graggar, /datum/patron/inhumen/matthios, /datum/patron/inhumen/baotha)
	class_select_category = CLASS_CAT_HEARTFELT
	extra_context = "Выбирая путь Сержанта, вы получите прибавку к силе и интелекту, вместе с возможностью носить среднюю броню и топор. Оратор в свою очередь, уворотлив и более смышленен в драке с мечами и арбалетами."
	subclass_languages = list(/datum/language/etruscan)
	cmode_music = sound("modular_twilight_axis/sound/music/republicantroublemaker.ogg")

	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN

	)

/datum/outfit/job/roguetown/mercenary/twilight_republican_comendant/pre_equip(mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/proc/haltyell)
	add_verb(H, list(/mob/living/carbon/human/mind/proc/setorders))
	head = /obj/item/clothing/head/roguetown/duelhat/hrthat
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/hrtpants
	cloak = /obj/item/clothing/cloak/hrtcape
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	belt = /obj/item/storage/belt/rogue/leather/tossbelt/smoke
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/roguekey/mercenary = 1,
	)

	if(H.mind)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/brotherhood_order/move)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/brotherhood_order/take_aim)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/brotherhood_order/hold)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/brotherhood_order/on_feet)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood_mercenary)
	var/class = list("Sergeant", "Orator")
	var/class_choice = input(H, "Choose your path.", "CHOOSE YOUR STORY.") as anything in class
	switch(class_choice)
		if ("Sergeant")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick/plagua
			shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter/hrtshirt
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			beltr = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/iron/snouted
			H.change_stat(STATKEY_INT, 1)
			H.change_stat(STATKEY_STR, 2)
		if ("Orator")
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/sword/rapier/vaquero
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow
			beltl = /obj/item/rogueweapon/scabbard/sword
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/hrtcoat
			shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/hrtboots
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/light
			beltr = /obj/item/clothing/head/roguetown/helmet/skullcap
			backl = /obj/item/quiver/bolt/light
			H.change_stat(STATKEY_PER, 1)
			H.change_stat(STATKEY_SPD, 2)

//копия способностей лично для коменданта, чтобы не менять файлы от оффов
/datum/action/cooldown/spell/brotherhood_order
	name = ""
	background_icon = 'icons/mob/actions/orders.dmi'
	button_icon = 'icons/mob/actions/orders.dmi'
	sound = 'sound/magic/inspire_02.ogg'
	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SURGE + 15
	invocation_type = INVOCATION_NONE
	charge_required = TRUE
	charge_time = 1.5 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	cooldown_time = 2 MINUTES
	shared_cooldown = LEADERSHIP_ORDER_SHARED_COOLDOWN
	ignore_armor_penalty = TRUE
	associated_stat = null
	associated_skill = /datum/skill/misc/athletics
	spell_tier = 0
	point_cost = 0
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	var/subordinate_job = "Coup"
	var/buff_given
	var/single_target = FALSE

/datum/action/cooldown/spell/brotherhood_order/proc/get_order_text()
	return null

/datum/action/cooldown/spell/brotherhood_order/proc/cast_single(atom/cast_on)
	return FALSE

/datum/action/cooldown/spell/brotherhood_order/cast(atom/cast_on)
	. = ..()
	if(single_target)
		return cast_single(cast_on)
	var/msg = get_order_text()
	if(!msg)
		to_chat(owner, span_alert("I must say something to give an order!"))
		return FALSE
	var/list/targets = list()
	for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
		if(target != owner && is_subordinate(target))
			targets += target
	if(!length(targets))
		to_chat(owner, span_alert("There are no subordinates close enough to hear my orders!"))
		return FALSE
	owner.say("[msg]", language = /datum/language/common)
	for(var/mob/living/carbon/target in targets)
		target.apply_status_effect(buff_given)
	return TRUE

/datum/action/cooldown/spell/brotherhood_order/move
	name = "Order: Move"
	desc = "Orders your brothers to move faster. +2 Speed."
	button_icon_state = "move"
	buff_given = /datum/status_effect/buff/order/movemovemove

/datum/action/cooldown/spell/brotherhood_order/move/get_order_text()
	return owner.mind?.movemovemovetext

/datum/action/cooldown/spell/brotherhood_order/take_aim
	name = "Order: Take Aim"
	desc = "Orders your brothers to be more precise. +2 Perception."
	button_icon_state = "target"
	buff_given = /datum/status_effect/buff/order/takeaim

/datum/action/cooldown/spell/brotherhood_order/take_aim/get_order_text()
	return owner.mind?.takeaimtext

/datum/action/cooldown/spell/brotherhood_order/hold
	name = "Order: Hold"
	desc = "Orders your brothers to Endure. +1 Willpower and Constitution."
	button_icon_state = "hold"
	buff_given = /datum/status_effect/buff/order/hold

/datum/action/cooldown/spell/brotherhood_order/hold/get_order_text()
	return owner.mind?.holdtext

/datum/action/cooldown/spell/brotherhood_order/on_feet
	name = "Order: On your feet"
	desc = "Orders a brother to stand up and fight without fear or pain."
	button_icon_state = "onfeet"
	click_to_activate = TRUE
	single_target = TRUE
	buff_given = /datum/status_effect/buff/order/onfeet

/datum/action/cooldown/spell/brotherhood_order/on_feet/get_order_text()
	return owner.mind?.onfeettext

/datum/action/cooldown/spell/brotherhood_order/on_feet/cast_single(atom/cast_on)
	var/mob/living/target = cast_on
	if(!isliving(target) || target == owner)
		to_chat(owner, span_alert("I cannot order myself!"))
		return FALSE
	if(!is_subordinate(target))
		to_chat(owner, span_alert("I cannot order one not of the brotherhood cause!"))
		return FALSE
	var/msg = get_order_text()
	if(!msg)
		to_chat(owner, span_alert("I must say something to give an order!"))
		return FALSE
	owner.say("[msg]", language = /datum/language/common)
	target.apply_status_effect(buff_given)
	if(!(target.mobility_flags & MOBILITY_STAND))
		target.SetUnconscious(0)
		target.SetSleeping(0)
		target.SetParalyzed(0)
		target.SetImmobilized(0)
		target.SetStun(0)
		target.SetKnockdown(0)
		target.set_resting(FALSE)
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/brotherhood_mercenary
	name = "Recruit to the Coup"
	overlay_state = "recruit_brotherhood"
	new_role = null
	recruitment_faction = "Coup"
	recruitment_message = "Fight beside the Coup, %RECRUIT!"
	accept_message = "For the coin and the Coup!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/brotherhood_mercenary/can_convert(mob/living/carbon/human/recruit)
	if(QDELETED(recruit) || !recruit.mind || recruit.cmode || !recruit.get_face_name(null))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_BROTHERHOOD_MEMBER))
		return FALSE
	if(recruit.job == "Mercenary")
		return TRUE
	return ..()

/obj/effect/proc_holder/spell/self/convertrole/brotherhood_mercenary/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	ADD_TRAIT(recruit, TRAIT_BROTHERHOOD_MEMBER, JOB_TRAIT)

/datum/action/cooldown/spell/brotherhood_order/proc/is_subordinate(mob/living/M)
	return M.job == subordinate_job || HAS_TRAIT(M, TRAIT_BROTHERHOOD_MEMBER)
