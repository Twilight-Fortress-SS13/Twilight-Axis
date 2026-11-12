/datum/erp_ui_catalog

/// Returns organ type options for UI dropdowns.
/datum/erp_ui_catalog/proc/get_organ_type_options_ui()
	return list(
		list("value" = SEX_ORGAN_PENIS, "name" = "Член"),
		list("value" = SEX_ORGAN_HANDS, "name" = "Руки"),
		list("value" = SEX_ORGAN_LEGS, "name" = "Ноги"),
		list("value" = SEX_ORGAN_TAIL, "name" = "Хвост"),
		list("value" = SEX_ORGAN_BODY, "name" = "Тело"),
		list("value" = SEX_ORGAN_MOUTH, "name" = "Рот"),
		list("value" = SEX_ORGAN_ANUS, "name" = "Анус"),
		list("value" = SEX_ORGAN_BREASTS, "name" = "Грудь"),
		list("value" = SEX_ORGAN_VAGINA, "name" = "Вагина"),
	)
