/datum/decree/noc_pestra_covenant
	id = DECREE_NOC_PESTRA_COVENANT
	name = "Завет Нок и Пестры"
	category = DECREE_CATEGORY_NEW
	mechanical_text = "Устанавливает верхний предел подушной подати для представителей Университета и Апотекарской палаты, а также минимальный уровень их заработной платы: придворный маг — 40 м, архивариус — 20 м, арканный маг — 10 м, главный лекарь — 80 м, апотекарий — 40 м."
	/// Jobs covered by the scholarly half of the covenant (Noc's mantle).
	var/static/list/university_jobs = list(
		"Court Magician",
		"Archivist",
		"Magicians Associate",
	)
	/// Jobs covered by the healing half of the covenant (Pestra's mantle).
	var/static/list/apothecary_jobs = list(
		"Apothecary",
		"Head Physician",
	)
	var/static/list/wage_floors = list(
		"Court Magician" = 40,
		"Archivist" = 20,
		"Magicians Associate" = 10,
		"Head Physician" = 80,
		"Apothecary" = 40,
	)
	flavor_text = {"Настоящий Завет, заключённый под бдительным взором Нок и милостивой рукой Пестры, свидетельствует о том, что ученые умы Университета и целители Апотекарской палаты не будут нести никакого обременения, кроме наименьших из возможных податей, и будут получать из казны Короны честный минимум того, что им причитается, пока действует настоящий Завет.

Взамен, лицензированные ученые умы Университета обязуются будут хранить знания и мудрость сиих щемель, сохранять их и преподавать достойным и светлым умам, ибо Нок даровала людям дар арканы и мудрости, чтобы мы могли распространять и преумножать их. А дипломированные целители Апотекарской палаты, посланники Пестры, принимают обязательство лечить раны каждого подданного Короны, пришедшего к их порогу, будь то нищий или горожанин, и никогда не откажут раненому из-за недостатка монет, ибо Пестра милосердна и научила нас медицине, чтобы мы могли заботиться друг о друге.

Заверено печатью Короны, милостью Нок и Пестры."}
	revoke_text = "Правитель сиих земель прекратил действие Завета Нок и Пестры. Представители Университета и Апотекарской палаты теперь облагаются налогами и податями в полном объеме. Сколь долго продержится милость Нок и Пестры, ежели слуги их будут возносить молитвы о тягости их бытия?"
	restore_text = "Правитель сиих земель восстановил Завет Нок и Пестры. Представители Университета и Апотекарской палаты вновь обрели свой защищенный статус, дабы торжествовали на землях под властью Короны мудрость и милосердие."

/datum/decree/noc_pestra_covenant/roll_initial_year()
	return CALENDAR_EPOCH_YEAR - rand(20, 60)

/// Returns TRUE if the payer is a member of one of the two chartered rosters.
/datum/decree/noc_pestra_covenant/proc/is_protected(mob/living/payer)
	if(!active || !payer)
		return FALSE
	if(HAS_TRAIT(payer, TRAIT_OUTLAW))
		return FALSE
	if(payer.job in university_jobs)
		return TRUE
	if(payer.job in apothecary_jobs)
		return TRUE
	return FALSE

/datum/decree/noc_pestra_covenant/apply_poll_tax_cap(mob/living/payer, poll_category, current_rate)
	if(!is_protected(payer))
		return current_rate
	return min(current_rate, NOC_PESTRA_POLL_CAP)

/datum/decree/noc_pestra_covenant/apply_wage_floor(job_title, current_floor)
	var/mandated = wage_floors[job_title] || 0
	return max(current_floor, mandated)

/datum/decree/noc_pestra_covenant/wage_floored_jobs()
	return wage_floors

/datum/decree/noc_pestra_covenant/on_restore()
	. = ..()
	SStreasury.steward_machine?.enforce_wage_floors()
