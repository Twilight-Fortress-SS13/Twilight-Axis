/*
 * Custom-clan discipline restriction adapted from
 * Scarlet-Reach/Scarlet-Reach#1616.
 */

/datum/antagonist/vampire/create_custom_clan(mob/living/carbon/human/vampdude, custom_name = null)
	custom_clan_name = (istext(custom_name) && length(custom_name)) ? custom_name : "Пользовательский клан"

	var/datum/clan/custom/new_clan = new /datum/clan/custom()
	new_clan.name = custom_clan_name

	switch(vampdude.get_vampire_generation())
		if(GENERATION_NEONATE)
			new_clan.covens_to_select = COVENS_PER_WRETCH_CLAN
		if(GENERATION_THINBLOOD)
			new_clan.covens_to_select = 0
		if(GENERATION_THINNERBLOOD)
			new_clan.covens_to_select = COVENS_PER_VAGABOND

	vampdude.set_clan_direct(new_clan)
	clan_selected = TRUE
	after_gain()

	to_chat(vampdude, span_notice("Теперь я принадлежу клану «[custom_clan_name]». Доступно дисциплин: [length(selected_covens)]."))
