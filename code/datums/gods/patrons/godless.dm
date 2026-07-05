/datum/patron/godless
	name = "Godless"
	rusgodnames = list(
		"Безбожие", "Безбожия", "Безбожию", "Безбожие", "Безбожием", "Безбожии"
	)
	domain = "Humanity"
	desc = "Боги существуют, но ты либо не знаешь их, либо не поклоняешься им. Ты следуешь своим инстинктам или разуму."
	worshippers = "Звери, неспособные мыслить, и истинные циники."
	associated_faith = /datum/faith/godless
	preference_accessible = FALSE
	undead_hater = FALSE
	confess_lines = list(
		"БОГИ НИЧТОЖНЫ!",
		"МНЕ НЕ НУЖНЫ БОГИ!",
		"НЕТ БОГОВ — НЕТ ХОЗЯЕВ!",
	)

/datum/patron/godless/can_pray(mob/living/follower)
	. = ..()
	to_chat(follower, span_danger("Ты не поклоняешься богам. Кому ты молишься?"))
	return FALSE

/datum/patron/godless/on_lesser_heal(
	mob/living/user,
	mob/living/target,
	message_out,
	message_self,
	conditional_buff,
	situational_bonus
)
	*message_out = span_info("Без какой-либо причины [target] исцеляется!")
	*message_self = span_notice("Мои раны закрываются без всякой причины.")