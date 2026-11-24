/obj/structure/vampire/bloodpool
	var/ascensions = 0
	var/summoning_role

/obj/structure/vampire/bloodpool/Initialize(mapload)
	. = ..()
	available_project_types |= list(
		/datum/vampire_project/gate_amulet,
		/datum/vampire_project/vitae_collar,
	)

/obj/structure/vampire/bloodpool/Destroy()
	QDEL_LIST_ASSOC_VAL(active_projects)
	return ..()

/obj/structure/vampire/bloodpool/examine(mob/user)
	. = ..()
	. += span_notice("Чаша вмещает до [get_cup_capacity()] витэ.")

/obj/structure/vampire/bloodpool/attack_hand(mob/living/user)
	if(!istype(user))
		return
	if(!is_crucible_vampire(user) && !can_offer_blood(user))
		return
	ui_interact(user)

/obj/structure/vampire/bloodpool/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/vampire/bloodpool/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrimsonCrucible", "Багровый Тигель")
		ui.open()

/obj/structure/vampire/bloodpool/ui_static_data(mob/user)
	var/list/data = list()
	var/list/projects = list()
	var/ascension_total = 0
	for(var/project_type in subtypesof(/datum/vampire_project))
		var/datum/vampire_project/project = get_project_prototype(project_type)
		if(!project.category)
			continue
		if(project.ascension_rite)
			ascension_total++
		UNTYPED_LIST_ADD(projects, list(
			"type" = "[project_type]",
			"name" = project.display_name,
			"description" = project.description,
			"mechanics" = project.mechanics_description,
			"category" = project.category,
			"cost" = project.total_cost,
		))

	var/datum/vampire_project/servant/servant_t1/personal_servant = get_project_prototype(/datum/vampire_project/servant/servant_t1)
	data["projects"] = projects
	data["personalServant"] = list(
		"name" = "Личный слуга",
		"description" = personal_servant.description,
		"mechanics" = personal_servant.mechanics_description,
		"cost" = personal_servant.total_cost,
	)
	data["ascensionTotal"] = ascension_total
	data["capacityPerAscension"] = TA_CRUCIBLE_CAPACITY_PER_ASCENSION
	data["vitaeReserve"] = TA_CRUCIBLE_VITAE_RESERVE
	data["minDonation"] = TA_CRUCIBLE_MIN_DONATION
	data["donationVitae"] = TA_CRUCIBLE_DONATION_VITAE
	data["donationBlood"] = TA_CRUCIBLE_DONATION_BLOOD
	data["bloodNormal"] = BLOOD_VOLUME_NORMAL
	return data

/obj/structure/vampire/bloodpool/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/living_user = user
	if(!istype(living_user))
		return data

	data["cup"] = current
	data["cupCapacity"] = get_cup_capacity()
	data["isVampire"] = is_crucible_vampire(living_user)
	if(!data["isVampire"])
		data["blood"] = living_user.blood_volume
		data["vitae"] = living_user.bloodpool * CLIENT_VITAE_MULTIPLIER
		data["maxVitae"] = living_user.maxbloodpool * CLIENT_VITAE_MULTIPLIER
		data["maxGive"] = get_max_blood_gift(living_user)
		return data

	var/is_lord = is_crucible_lord(living_user)
	var/list/active_project_data = list()
	for(var/project_type in active_projects)
		var/datum/vampire_project/project = active_projects[project_type]
		var/list/contributor_data = list()
		for(var/mob/living/contributor as anything in project.contributors)
			UNTYPED_LIST_ADD(contributor_data, list(
				"name" = contributor.real_name,
				"amount" = project.contributors[contributor],
			))
		UNTYPED_LIST_ADD(active_project_data, list(
			"type" = "[project_type]",
			"paid" = project.paid_amount,
			"fromCup" = project.cup_paid_amount,
			"maxContribution" = get_project_max_contribution(project, living_user),
			"lockedReason" = project.get_contribution_lock_reason(),
			"contributors" = contributor_data,
		))

	var/list/available_project_data = list()
	if(is_lord)
		for(var/project_type in available_project_types)
			if(active_projects[project_type])
				continue
			var/datum/vampire_project/project = get_project_prototype(project_type)
			UNTYPED_LIST_ADD(available_project_data, list(
				"type" = "[project_type]",
				"lockedReason" = project.get_start_lock_reason(living_user, src),
			))

	var/datum/antagonist/vampire/vampire = get_crucible_vampire(living_user)
	data["isLord"] = is_lord
	data["vitae"] = living_user.bloodpool
	data["maxVitae"] = living_user.maxbloodpool
	data["maxPour"] = get_max_pour(living_user)
	data["summoning"] = summoning_role
	data["ascensions"] = ascensions
	data["sunStolen"] = SSticker.sunstolen
	data["sunRiteDone"] = sunstolen
	data["activeProjects"] = active_project_data
	data["availableProjects"] = available_project_data
	data["hasPersonalCall"] = !vampire.ta_personal_servant_blocked()
	data["personalCallLock"] = get_personal_servant_locked_reason(living_user)
	return data

/obj/structure/vampire/bloodpool/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/static/list/crucible_actions = list("give_blood", "pour_vitae", "call_servant", "begin_rite", "feed_rite", "cancel_rite")
	if(!(action in crucible_actions))
		return FALSE
	. = ..()
	if(. || ui.status != UI_INTERACTIVE)
		return

	var/mob/living/user = ui.user
	if(!istype(user))
		return
	if(action == "give_blood")
		return can_offer_blood(user) && give_blood(user)
	if(!is_crucible_vampire(user))
		return

	switch(action)
		if("pour_vitae")
			return pour_vitae(user)
		if("call_servant")
			return summon_personal_servant(user)
		if("begin_rite")
			return begin_rite(get_project_type(params["type"]), user)
		if("feed_rite")
			return contribute_to_project(active_projects[get_project_type(params["type"])], user)
		if("cancel_rite")
			return ask_cancel_rite(get_project_type(params["type"]), user)

/obj/structure/vampire/bloodpool/remember_nonvampire_vitae(mob/living/user)
	return

/obj/structure/vampire/bloodpool/proc/get_project_type(type_text)
	if(!istext(type_text))
		return null
	var/project_type = text2path(type_text)
	return ispath(project_type, /datum/vampire_project) ? project_type : null

/obj/structure/vampire/bloodpool/proc/get_project_prototype(project_type)
	var/static/list/prototypes = list()
	var/datum/vampire_project/prototype = prototypes[project_type]
	if(!prototype)
		prototype = new project_type()
		prototypes[project_type] = prototype
	return prototype

/obj/structure/vampire/bloodpool/proc/get_cup_capacity()
	return TA_CRUCIBLE_BASE_CAPACITY + ascensions * TA_CRUCIBLE_CAPACITY_PER_ASCENSION

/obj/structure/vampire/bloodpool/get_cup_space()
	return max(get_cup_capacity() - current, 0)

/obj/structure/vampire/bloodpool/get_vampire_personal_vitae_for_crucible(mob/living/user)
	if(!istype(user))
		return 0
	return max(user.bloodpool - TA_CRUCIBLE_VITAE_RESERVE, 0)

/obj/structure/vampire/bloodpool/proc/receive_vitae(amount)
	amount = min(round(amount), get_cup_space())
	if(amount <= 0)
		return
	current += amount
	SStgui.update_uis(src)

/obj/structure/vampire/bloodpool/proc/can_still_use(mob/living/user)
	if(QDELETED(src) || QDELETED(user))
		return FALSE
	if(user.incapacitated() || get_dist(user, src) > 1)
		to_chat(user, span_warning("Мне нужно быть рядом с тиглем."))
		return FALSE
	return TRUE

/obj/structure/vampire/bloodpool/proc/get_max_pour(mob/living/user)
	return min(get_vampire_personal_vitae_for_crucible(user), get_cup_space())

/obj/structure/vampire/bloodpool/proc/pour_vitae(mob/living/user)
	var/max_pour = get_max_pour(user)
	if(max_pour < 1)
		if(get_cup_space() <= 0)
			to_chat(user, span_warning("Чаша уже полна."))
		else
			to_chat(user, span_warning("Последние [TA_CRUCIBLE_VITAE_RESERVE] витэ останутся со мной."))
		return FALSE

	var/amount = tgui_input_number(user, "Сколько витэ влить в чашу? Можно до [max_pour].", "Багровый Тигель", max_pour, max_pour, 1)
	if(!amount || !can_still_use(user) || !is_crucible_vampire(user))
		return FALSE

	max_pour = get_max_pour(user)
	if(max_pour < 1)
		to_chat(user, span_warning("Чаша больше не примет моей витэ."))
		return FALSE

	amount = clamp(round(amount), 1, max_pour)
	user.adjust_bloodpool(-amount)
	current += amount
	to_chat(user, span_greentext("Я вливаю в чашу [amount] витэ. ([current]/[get_cup_capacity()])"))
	return TRUE

/obj/structure/vampire/bloodpool/proc/can_offer_blood(mob/living/user)
	var/mob/living/carbon/human/donor = user
	if(!istype(donor) || is_crucible_vampire(donor))
		return FALSE
	return !(NOBLOOD in donor.dna?.species?.species_traits)

/obj/structure/vampire/bloodpool/proc/get_max_blood_gift(mob/living/user)
	var/vitae_in_blood = FLOOR((user.blood_volume - TA_CRUCIBLE_MIN_DONOR_BLOOD) * TA_CRUCIBLE_DONATION_VITAE / TA_CRUCIBLE_DONATION_BLOOD, 1)
	var/gift = min(user.bloodpool * CLIENT_VITAE_MULTIPLIER, vitae_in_blood, get_cup_space())
	if(gift < TA_CRUCIBLE_MIN_DONATION)
		return 0
	return gift

/obj/structure/vampire/bloodpool/proc/give_blood(mob/living/user)
	var/max_gift = get_max_blood_gift(user)
	if(max_gift <= 0)
		if(get_cup_space() < TA_CRUCIBLE_MIN_DONATION)
			to_chat(user, span_warning("Чаша уже полна."))
		else
			to_chat(user, span_warning("Тигель берёт не меньше [TA_CRUCIBLE_MIN_DONATION] витэ, а у меня столько нет."))
		return FALSE

	var/amount = tgui_input_number(user, "Сколько витэ отдать? Каждые [TA_CRUCIBLE_DONATION_VITAE] витэ стоят [TA_CRUCIBLE_DONATION_BLOOD] крови. Можно до [max_gift].", "Багровый Тигель", max_gift, max_gift, TA_CRUCIBLE_MIN_DONATION)
	if(!amount || !can_still_use(user) || !can_offer_blood(user))
		return FALSE

	max_gift = get_max_blood_gift(user)
	if(max_gift <= 0)
		to_chat(user, span_warning("Тигель больше не примет моей крови."))
		return FALSE

	amount = clamp(round(amount), TA_CRUCIBLE_MIN_DONATION, max_gift)
	user.adjust_bloodpool(-CEILING(amount / CLIENT_VITAE_MULTIPLIER, 1))
	user.blood_volume = max(user.blood_volume - CEILING(amount * TA_CRUCIBLE_DONATION_BLOOD / TA_CRUCIBLE_DONATION_VITAE, 1), TA_CRUCIBLE_MIN_DONOR_BLOOD)
	current += amount
	to_chat(user, span_userdanger("Проклятая магия вытягивает мои силы."))
	to_chat(user, span_notice("Чаша выпивает из моей крови [amount] витэ. ([current]/[get_cup_capacity()])"))
	return TRUE

/obj/structure/vampire/bloodpool/proc/begin_rite(project_type, mob/living/carbon/human/user)
	if(!project_type || !is_crucible_lord(user) || !(project_type in available_project_types) || active_projects[project_type])
		return FALSE

	var/datum/vampire_project/prototype = get_project_prototype(project_type)
	var/lock_reason = prototype.get_start_lock_reason(user, src)
	if(lock_reason)
		to_chat(user, span_warning(lock_reason))
		return FALSE

	var/datum/vampire_project/project = new project_type()
	project.bloodpool = src
	project.initiator = user
	project.initiator_clan = user.clan
	project.track_participant(user)
	project.on_start(user)
	active_projects[project_type] = project
	to_chat(user, span_greentext("Ритуал «[project.display_name]» начат. Тигель жаждет витэ."))
	return TRUE

/obj/structure/vampire/bloodpool/get_project_max_contribution(datum/vampire_project/project, mob/living/user)
	if(!project || !is_crucible_lord(user))
		return 0
	var/available_vitae = current + get_vampire_personal_vitae_for_crucible(user)
	return max(round(min(available_vitae, project.total_cost - project.paid_amount)), 0)

/obj/structure/vampire/bloodpool/contribute_to_project(datum/vampire_project/project, mob/living/user)
	if(!project || !is_crucible_lord(user))
		return FALSE

	var/lock_reason = project.get_contribution_lock_reason()
	if(lock_reason)
		to_chat(user, span_warning(lock_reason))
		return FALSE

	var/max_contribution = get_project_max_contribution(project, user)
	if(max_contribution < 1)
		to_chat(user, span_warning("Мне нечего отдать этому ритуалу."))
		return FALSE

	var/contribution = tgui_input_number(user, "Сколько витэ направить в ритуал «[project.display_name]»? Можно до [max_contribution].", "Багровый Тигель", max_contribution, max_contribution, 1)
	if(!contribution || !can_still_use(user) || !is_crucible_lord(user))
		return FALSE

	if(QDELETED(project) || active_projects[project.type] != project)
		to_chat(user, span_warning("Этот ритуал уже не идёт."))
		return FALSE
	lock_reason = project.get_contribution_lock_reason()
	if(lock_reason)
		to_chat(user, span_warning(lock_reason))
		return FALSE
	max_contribution = get_project_max_contribution(project, user)
	if(max_contribution < 1)
		to_chat(user, span_warning("Мне нечего отдать этому ритуалу."))
		return FALSE

	contribution = clamp(round(contribution), 1, max_contribution)
	var/cup_part = min(current, contribution)
	var/personal_part = contribution - cup_part
	current -= cup_part
	project.cup_paid_amount += cup_part
	if(personal_part > 0)
		user.adjust_bloodpool(-personal_part)
		project.track_participant(user)
		project.contributors[user] += personal_part
	project.paid_amount += contribution
	to_chat(user, span_greentext("Я направляю [contribution] витэ в ритуал «[project.display_name]». Из чаши: [cup_part], из моей крови: [personal_part]. ([project.paid_amount]/[project.total_cost])"))

	if(project.paid_amount >= project.total_cost)
		complete_project(project.type)
	return TRUE

/obj/structure/vampire/bloodpool/proc/ask_cancel_rite(project_type, mob/living/user)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project || !is_crucible_lord(user))
		return FALSE
	if(tgui_alert(user, "Отменить ритуал «[project.display_name]»? Вложенная витэ вернётся участникам и в чашу.", "Багровый Тигель", list("Отменить ритуал", "Назад")) != "Отменить ритуал")
		return FALSE
	if(!can_still_use(user) || !is_crucible_lord(user) || active_projects[project_type] != project)
		return FALSE
	cancel_project(project_type)
	return TRUE

/obj/structure/vampire/bloodpool/complete_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project)
		return

	active_projects -= project_type

	var/list/witnesses = list()
	for(var/mob/living/contributor as anything in project.contributors)
		witnesses |= contributor
	if(project.initiator)
		witnesses |= project.initiator
	for(var/mob/living/witness as anything in witnesses)
		to_chat(witness, span_boldannounce("Ритуал «[project.display_name]» завершён!"))
		witness.playsound_local(get_turf(src), project.completion_sound, 100, FALSE, pressure_affected = FALSE)

	project.on_complete(src)

	if(project.ascension_rite && !(project_type in available_project_types))
		ascensions++
		if(project.category == TA_CRUCIBLE_CATEGORY_SUN)
			sunstolen = TRUE
	qdel(project)

/obj/structure/vampire/bloodpool/cancel_project(project_type)
	var/datum/vampire_project/project = active_projects[project_type]
	if(!project)
		return
	active_projects -= project_type
	project.on_cancel()
	qdel(project)

/obj/structure/vampire/bloodpool/get_personal_servant_locked_reason(mob/living/user)
	var/datum/antagonist/vampire/vampire = get_crucible_vampire(user)
	if(!vampire)
		return "На этот зов способны ответить только каиниты."
	if(GLOB.crimson_crucible_personal_servant_summons[REF(vampire)])
		return "Этот зов уже был услышан."
	if(!user.clan)
		return "Тигель не свяжет слугу, пока не избрана моя кровь."
	if(HAS_TRAIT(user, TRAIT_NOVAMPMITOSIS))
		return "Моя кровь слишком жидка для этого зова."
	var/servant_cost = /datum/vampire_project/servant/servant_t1::total_cost
	if(current < servant_cost)
		return "Чаше требуется [servant_cost] витэ."
	return get_summon_lock_reason()

/obj/structure/vampire/bloodpool/proc/get_summon_lock_reason()
	if(!summoning_role)
		return null
	return "Тигель уже зовёт из-за грани: [summoning_role]. Придётся дождаться ответа."

/obj/structure/vampire/bloodpool/summon_personal_servant(mob/living/user)
	var/locked_reason = get_personal_servant_locked_reason(user)
	if(locked_reason)
		to_chat(user, span_warning(locked_reason))
		return FALSE

	var/vampire_ref = REF(get_crucible_vampire(user))
	var/servant_cost = /datum/vampire_project/servant/servant_t1::total_cost
	var/datum/vampire_project/servant/servant_t1/project = new()
	project.bloodpool = src
	project.initiator = user
	project.initiator_clan = user.clan
	project.track_participant(user)
	current -= servant_cost
	GLOB.crimson_crucible_personal_servant_summons[vampire_ref] = TRUE

	var/summoned = project.summon("Vampire Servant", src, "Багровый Тигель зовёт личного слугу вампира. Откликнуться на зов?")
	qdel(project)
	if(!summoned)
		GLOB.crimson_crucible_personal_servant_summons -= vampire_ref
		if(!QDELETED(src))
			current += servant_cost
	else if(!QDELETED(user))
		to_chat(user, span_greentext("Тигель отвечает на мой зов. Мой единственный личный слуга восстаёт из крови."))
	return TRUE

/datum/vampire_project
	start_failure_message = "Этот ритуал не может быть начат."
	var/category
	var/ascension_rite = FALSE

/datum/vampire_project/Destroy()
	bloodpool = null
	initiator = null
	initiator_clan = null
	contributors.Cut()
	return ..()

/datum/vampire_project/proc/track_participant(mob/living/participant)
	RegisterSignal(participant, COMSIG_PARENT_QDELETING, PROC_REF(on_participant_deleted), override = TRUE)

/datum/vampire_project/proc/on_participant_deleted(datum/source)
	SIGNAL_HANDLER
	contributors -= source
	if(initiator == source)
		initiator = null

/datum/vampire_project/proc/get_start_lock_reason(mob/living/carbon/human/user, obj/structure/vampire/bloodpool/pool)
	if(!can_start(user, pool, TRUE))
		return start_failure_message
	return null

/datum/vampire_project/proc/get_contribution_lock_reason()
	return null

/datum/vampire_project/on_cancel()
	for(var/mob/living/contributor as anything in contributors)
		var/refund = contributors[contributor]
		if(refund <= 0)
			continue
		contributor.adjust_bloodpool(refund)
		to_chat(contributor, span_notice("Ритуал «[display_name]» прерван. Ко мне вернулось [refund] витэ."))
	contributors.Cut()
	if(cup_paid_amount > 0 && !QDELETED(bloodpool))
		bloodpool.current += cup_paid_amount
	cup_paid_amount = 0
	paid_amount = 0

/datum/vampire_project/power_growth
	display_name = "Обряд пробуждения"
	description = "Древняя кровь вновь шевелится. Забытый шёпот отзывается в костях земли."
	mechanics_description = "+2 ко всем Атрибутам Мафусаила; +1000 к запасу витэ."
	start_failure_message = "Обряд доступен лишь Мафусаилу, ещё не достигшему вершины."
	category = TA_CRUCIBLE_CATEGORY_ASCENSION
	ascension_rite = TRUE

/datum/vampire_project/power_growth_2
	display_name = "Обряд возвращения"
	description = "Долго скованная сила возвращается. Земля, камень и тени снова склоняются перед истинным владыкой."
	mechanics_description = "+2 ко всем Атрибутам Мафусаила; +1000 к запасу витэ; открывает ритуал доспехов."
	category = TA_CRUCIBLE_CATEGORY_ASCENSION
	ascension_rite = TRUE

/datum/vampire_project/power_growth_3
	display_name = "Обряд владычества"
	description = "Мафусаил вновь цел. Древняя сила проходит через каждый камень и каждую вену: Земля и владыка становятся едины."
	mechanics_description = "+2 ко всем Атрибутам Мафусаила; +1000 к запасу витэ; неиссякаемая выносливость и невосприимчивость к шоку. Гасит Солнце и возвещает о восхождении владыки."
	category = TA_CRUCIBLE_CATEGORY_SUN
	ascension_rite = TRUE

/datum/vampire_project/power_growth_3/on_complete(obj/structure/vampire/bloodpool/creation_point)
	. = ..()
	if(!(type in bloodpool.available_project_types) && !SSticker.sunstolen && !SSticker.sunsteal(initiator))
		SSticker.sunsteal(ta_get_vampire_lord_body())

/datum/vampire_project/armor_crafting
	display_name = "Проклятые латы"
	description = "Полный комплект вампирских лат, выкованных из кристаллизованной крови. Ни сталь, ни серебро, ни мольбы о спасении не остановят волю Мафусаила."
	mechanics_description = "Ритуал можно провести только один раз."
	category = TA_CRUCIBLE_CATEGORY_SUMMONING

/datum/vampire_project/gate_amulet
	display_name = "Якорь мира"
	description = "Амулет врат из кристаллизованной крови. Надетый на шею, он позволяет Вратам разлома вернуть домой хозяина и того, кого тот несёт на плече."
	mechanics_description = "Куёт амулет врат с ограниченным запасом возвращений. Разлом можно открыть и рядом с самим амулетом."
	category = TA_CRUCIBLE_CATEGORY_SUMMONING
	total_cost = TA_CRUCIBLE_GATE_AMULET_COST
	completion_sound = 'sound/misc/vcraft.ogg'

/datum/vampire_project/gate_amulet/on_complete(obj/structure/vampire/bloodpool/creation_point)
	new /obj/item/clothing/neck/portalamulet(get_turf(creation_point))
	creation_point.visible_message(span_notice("В багровом тигле сгущается амулет врат."))

/datum/vampire_project/servant
	category = TA_CRUCIBLE_CATEGORY_SUMMONING
	var/summon_label = "слуга"

/datum/vampire_project/servant/servant_t1
	display_name = "Призвать каинита-слугу"
	description = "Верный слуга, которому можно доверить низкие труды твоего домена: от подземных горнов до забот о поместье."
	mechanics_description = "Поколение: малокровка. Может породить 1 тонкокровного. 9 RP."

/datum/vampire_project/servant/servant_t2
	display_name = "Призвать каинита-стража"
	description = "Верный страж, способный сражаться за твой домен или держать оборону поместья: сталью, стрелой, хитростью или кровавым искусством."
	mechanics_description = "Поколение: малокровка. Может породить 1 тонкокровного. 9 RP."
	summon_label = "страж"

/datum/vampire_project/servant/servant_t3
	display_name = "Призвать каинита-поборника"
	description = "Одарённый и опасный поборник: глашатай тёмного воинства или тень, подтачивающая смертных изнутри."
	mechanics_description = "Поколение: анцилла. Может породить 5 малокровок. 17 RP."
	summon_label = "поборник"

/datum/vampire_project/servant/get_start_lock_reason(mob/living/carbon/human/user, obj/structure/vampire/bloodpool/pool)
	return pool?.get_summon_lock_reason() || ..()

/datum/vampire_project/servant/get_contribution_lock_reason()
	return bloodpool?.get_summon_lock_reason()

/datum/vampire_project/servant/proc/pick_summon_candidate(list/candidates)
	for(var/mob/dead/candidate in shuffle(candidates))
		if(QDELETED(candidate) || !candidate.client || !candidate.key)
			continue
		if(isnewplayer(candidate))
			var/mob/dead/new_player/lobby_player = candidate
			if(lobby_player.spawning)
				continue
		return candidate
	return null

/datum/vampire_project/servant/summon(role_type, atom/feedback_atom, poll_prompt)
	var/obj/structure/vampire/bloodpool/pool = bloodpool
	if(QDELETED(pool) || QDELETED(feedback_atom) || pool.summoning_role)
		return FALSE

	var/datum/antagonist/vampire/summoner_antag = initiator?.mind?.has_antag_datum(/datum/antagonist/vampire)
	var/inherited_flags = istype(summoner_antag) ? (summoner_antag.antag_flags & FLAG_ANTAG_CAP_IGNORE) : NONE

	feedback_atom.visible_message(span_warning("Тигель оживает, призывая слугу из-за грани..."))
	pool.summoning_role = summon_label
	SStgui.update_uis(pool)
	var/list/candidates = pollGhostCandidates(poll_prompt || "Багровый Тигель вампира зовёт: [summon_label]. Откликнуться на зов?", ROLE_VAMPIRE_SUMMON, null, null, TA_CRUCIBLE_SUMMON_POLL_TIME, POLL_IGNORE_VL_SERVANT)
	pool.summoning_role = null
	if(QDELETED(feedback_atom))
		return FALSE

	var/mob/dead/candidate = pick_summon_candidate(candidates)
	if(!candidate)
		feedback_atom.visible_message(span_warning("Увы, глубины пусты..."))
		return FALSE

	if(isnewplayer(candidate))
		var/mob/dead/new_player/lobby_player = candidate
		lobby_player.close_spawn_windows()

	var/mob/living/carbon/human/species/human/northern/target = new /mob/living/carbon/human/species/human/northern(get_turf(feedback_atom))
	target.key = candidate.key
	target.visible_message(span_warning("[target] восстаёт из багрового тигля, преклонив колено."))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, load_char_or_namechoice)), 3 SECONDS)
	SSjob.EquipRank(target, role_type, TRUE)
	var/servant_generation = (role_type == "Vampire Spawn") ? GENERATION_ANCILLAE : GENERATION_NEONATE
	var/datum/antagonist/vampire/servant_antag = new /datum/antagonist/vampire(incoming_clan = initiator_clan, forced_clan = TRUE, generation = servant_generation)
	if(ta_vampire_lord_expansion_active())
		servant_antag.antag_flags |= inherited_flags
	target.mind.add_antag_datum(servant_antag)
	if(servant_generation == GENERATION_NEONATE)
		ADD_TRAIT(target, TRAIT_NOVAMPMITOSIS, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_QUICKSILVERRESISTANT, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_DUSTABLE, TRAIT_GENERIC)
	return TRUE
