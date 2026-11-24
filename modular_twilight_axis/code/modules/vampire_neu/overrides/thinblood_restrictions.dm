/*
 * Custom-clan discipline restriction adapted from
 * Scarlet-Reach/Scarlet-Reach#1616.
 */

/proc/ta_custom_clan_coven_count(generation, default_count)
	switch(generation)
		if(GENERATION_NEONATE)
			return COVENS_PER_WRETCH_CLAN
		if(GENERATION_THINBLOOD)
			return 0
		if(GENERATION_THINNERBLOOD)
			return COVENS_PER_VAGABOND
	return default_count

/datum/antagonist/vampire/create_custom_clan(mob/living/carbon/human/vampdude, custom_name = null)
	if(clan_selected || QDELETED(src) || QDELETED(vampdude) || owner?.current != vampdude)
		return
	clan_selected = TRUE
	custom_clan_name = ta_plain_text(custom_name, MAX_NAME_LEN) || "Пользовательский клан"

	var/datum/clan/custom/new_clan = new /datum/clan/custom()
	new_clan.name = custom_clan_name
	new_clan.covens_to_select = ta_custom_clan_coven_count(vampdude.get_vampire_generation(), new_clan.covens_to_select)

	vampdude.set_clan_direct(new_clan)
	after_gain()

	to_chat(vampdude, span_notice("Теперь я принадлежу клану «[custom_clan_name]». Доступно дисциплин: [new_clan.covens_to_select]."))
