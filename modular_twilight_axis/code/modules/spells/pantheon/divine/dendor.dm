/datum/action/cooldown/spell/conjure_arcyne_ward/druid
	name = "Conjure vine armor"
	button_icon_state = "tamebeast"
	spell_color = GLOW_COLOR_EARTHEN
	invocations = list("Threefather! Give me your protect!")
	dismiss_invocation = ""
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/druid

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/druid
	name = "vine armor"
	desc = "An holy vine's armor."
	ward_color = GLOW_COLOR_EARTHEN

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/druid/setup_ward(mob/living/carbon/human/user)
	. = ..()
	user.apply_status_effect(/datum/status_effect/buff/vinearmour)
	
/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/druid/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/vinearmour)
	
	return ..()

/datum/status_effect/buff/vinearmour
	id = "vinearmour"
	alert_type = /atom/movable/screen/alert/status_effect/buff/vinearmour
	duration = -1
	examine_text = "<font color='green'>SUBJECTPRONOUN is covered in vines!</font>"
	var/outline_colour = "#042013"
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = -1, STATKEY_SPD = -1)

/atom/movable/screen/alert/status_effect/buff/vinearmour
	name = "Vinearmour"
	desc = "The vines hirt you, but protects!"

/datum/intent/simple/beast_claws/slash
	name = "Рассекающий удар"
	desc = "Звериные когти помогают рвать свою добычу, заставляя её истекать кровью."
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = "genslash"
	miss_sound = "bluntwoosh"
	item_d_type = "slash"
	penfactor = PEN_LIGHT
	item_d_type = "cut"
	icon_state = "inchop"
// - - -

/obj/item/rogueweapon/beast_claws
	name = "Beast claws"
	gender = PLURAL
	max_blade_int = INFINITY
	max_integrity = INFINITY
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	sharpness = IS_SHARP_ACCURATE
	item_flags = DROPDEL
	possible_item_intents = list(/datum/intent/simple/beast_claws/slash)
	can_parry = TRUE
	wdefense = 7
	// Временная замена до момента появления спрайтера. Увы.
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "claw_r"
	force = 20

/obj/item/rogueweapon/beast_claws/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// - - -

/obj/effect/proc_holder/spell/self/beast_claws
	name = "Когти зверя"
	desc = "Вытянутые когти подобные острым лезвиям, способным как резать так и колоть. \
	Старшие друиды рассказывают легенду, согласно которым Дендор использовал свои зверские когти, \
	когда повздорил с Равоксом, богом войны. \
	Их битва длилась три дэя, во время которых в леса было страшно даже заглядывать. \
	Однако, на четвертый дэй все стихло, боги помирились."
	overlay_state = "dendor"
	req_items = /obj/item/clothing/neck/roguetown/psicross/dendor
	antimagic_allowed = TRUE
	miracle = TRUE

/obj/effect/proc_holder/spell/self/beast_claws/cast(mob/living/user = usr)
	. = ..()

	var/is_ability_activated = FALSE

	var/obj/item/active_hand_item = user.get_active_held_item()

	// Предовтращение манипуляций с когтями оборотня.
	if(istype(active_hand_item, /obj/item/rogueweapon/werewolf_claw))
		revert_cast()
		return FALSE

	if(istype(active_hand_item, /obj/item/rogueweapon/beast_claws))
		is_ability_activated = TRUE

	user.dropItemToGround(active_hand_item, TRUE)

	if(is_ability_activated)
		qdel(active_hand_item)
		return TRUE

	user.put_in_hands(new /obj/item/rogueweapon/beast_claws(user), TRUE, FALSE, TRUE)

// -- Debuff

/atom/movable/screen/alert/status_effect/debuff/beast_rage
	name = "Уставший зверь"
	desc = "Мой внутренний зверь устал, как и я."
	icon_state = "debuff"

/datum/status_effect/debuff/beast_rage_weakness
	id = "beast_rage_weakness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/beast_rage
	effectedstats = list(
		"speed" = -2,
		"strength" = -2,
		"willpower" = -2,
	)
	duration = 1 MINUTES

// -- Buff

/atom/movable/screen/alert/status_effect/buff/beast_rage
	name = "Буйствующий зверь"
	desc = "Мой внутренний зверь буйствует! Силы переполняют меня, но мой разум гаснет!"
	icon_state = "buff"

/datum/status_effect/buff/beast_rage
	id = "beast_rage"
	alert_type = /atom/movable/screen/alert/status_effect/buff/beast_rage
	effectedstats = list(
		"speed" = 2,
		"strength" = 2,
		"willpower" = 2,
		"intelligence" = -5,
	)
	duration = 1 MINUTES

/datum/status_effect/buff/beast_rage/on_remove()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/debuff/beast_rage_weakness)
	owner.clear_fullscreen("beast_mode")

// -- Spell

/obj/effect/proc_holder/spell/self/beast_rage
	name = "Буйство зверя"
	desc = ""
	overlay_state = "dendor"
	recharge_time = 3 MINUTES
	req_items = /obj/item/clothing/neck/roguetown/psicross/dendor
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/druidic
	invocations = list("Вот она! Ярость дикого сердца!")
	invocation_type = "shout" //can be none, whisper, emote and shout
	miracle = TRUE
	devotion_cost = 125

/obj/effect/proc_holder/spell/self/beast_rage/cast(mob/living/user = usr)
	. = ..()
	user.apply_status_effect(/datum/status_effect/buff/beast_rage)
	user.overlay_fullscreen("beast_mode", /atom/movable/screen/fullscreen/color_vision/red)
	user.Dizzy(10)

/obj/effect/proc_holder/spell/targeted/create_seed
	name = "Чудо создания семян"
	range = -1
	overlay_state = "blesscrop"
	releasedrain = 30
	recharge_time = 15 MINUTES
	req_items = /obj/item/clothing/neck/roguetown/psicross/dendor
	cast_without_targets = TRUE
	sound = 'sound/magic/churn.ogg'
	associated_skill = /datum/skill/magic/druidic
	miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/targeted/create_seed/proc/get_seeds_dict()
	var/list/allowed_seeds = list()

	allowed_seeds["Болотная трава"] = /obj/item/seeds/swampweed
	allowed_seeds["Табак"] = /obj/item/seeds/pipeweed
	allowed_seeds["Капуста"] = /obj/item/seeds/cabbage
	allowed_seeds["Картофель"] = /obj/item/seeds/potato
	allowed_seeds["Лук"] = /obj/item/seeds/onion
	allowed_seeds["Овес"] = /obj/item/seeds/wheat/oat
	allowed_seeds["Пшеница"] = /obj/item/seeds/wheat
	allowed_seeds["Чай"] = /obj/item/seeds/tea
	allowed_seeds["Яблоня"] = /obj/item/seeds/apple
	allowed_seeds["Ягодный куст (ядовитый)"] = /obj/item/seeds/berryrogue/poison
	allowed_seeds["Ягодный куст"] = /obj/item/seeds/berryrogue

	return allowed_seeds

/obj/effect/proc_holder/spell/targeted/create_seed/cast(list/targets, mob/user = usr)
	. = ..()

	var/list/seeds_dict = get_seeds_dict()

	var/selected_option = input(
		user,
		"Семена какого растения вы хотите сотворить?",
		"Создание семян"
	) as null | anything in seeds_dict

	if(!selected_option)
		revert_cast()
		return FALSE

	var/obj/item/seeds/seed_to_create = seeds_dict[selected_option]
	user.put_in_hands(new seed_to_create(get_turf(user)))
	return TRUE
