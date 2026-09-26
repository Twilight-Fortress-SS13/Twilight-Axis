/datum/erp_action_editor_schema

/// Exports editor UI field descriptors for this action (schema + current values + options).
/datum/erp_action_editor_schema/proc/export_editor_fields(datum/erp_action/A)
	. = list()
	. += list(_make_field("action_scope", "Направление действия", "enum", A.action_scope, "ОСНОВНОЕ", null, null, null, _scope_options(), "Это влияет на список доступных действий и фильтрацию.", null))
	. += list(_make_field("required_init_organ", "Орган инициатора (init)", "enum", A.required_init_organ, "ОРГАНЫ", null, null, null, _organ_options()))
	. += list(_make_field("required_target_organ", "Орган цели (target)", "enum", A.required_target_organ, "ОРГАНЫ", null, null, null, _organ_options()))
	. += list(_make_field("reserve_target_organ", "Резервировать орган цели", "bool", A.reserve_target_organ, "ОРГАНЫ"))
	. += list(_make_field("active_arousal_coeff", "Возбуждение инициатора", "number", A.active_arousal_coeff,  "ЭФФЕКТЫ", 0, 10, 0.1))
	. += list(_make_field("passive_arousal_coeff", "Возбуждение цели", "number", A.passive_arousal_coeff, "ЭФФЕКТЫ", 0, 10, 0.1))
	. += list(_make_field("active_pain_coeff", "Боль инициатора", "number", A.active_pain_coeff,     "ЭФФЕКТЫ", 0, 10, 0.1))
	. += list(_make_field("passive_pain_coeff", "Боль цели", "number", A.passive_pain_coeff,    "ЭФФЕКТЫ", 0, 10, 0.1))
	. += list(_make_field("inject_timing", "Инъекция: когда", "enum", A.inject_timing, "ИНЪЕКЦИЯ", null, null, null, _inject_timing_options()))
	. += list(_make_field("inject_source", "Инъекция: источник", "enum", A.inject_source, "ИНЪЕКЦИЯ", null, null, null, _inject_source_options()))
	. += list(_make_field("inject_target_mode", "Инъекция: цель", "enum", A.inject_target_mode, "ИНЪЕКЦИЯ", null, null, null, _inject_target_mode_options()))
	. += list(_make_field("require_same_tile", "Только с одного тайла", "bool", A.require_same_tile, "ОГРАНИЧЕНИЯ"))
	. += list(_make_field("allow_when_restrained", "Можно в оковах", "bool", A.allow_when_restrained, "ОГРАНИЧЕНИЯ"))
	. += list(_make_field("require_grab", "Нужен граб", "bool", A.require_grab, "ОГРАНИЧЕНИЯ"))
	. += list(_make_field("required_item_tags", "Нужные теги предмета", "string_list", A.required_item_tags, "ТЕГИ", null, null, null, null, "Напр: dildo. Если список не пуст — действие потребует предмет с одним из тегов. Имя предмета тоже является тегом.", "tag"))
	. += list(_make_field("action_tags", "Теги действия", "string_list", A.action_tags, "ТЕГИ", null, null, null, null, "Напр: spanking, testicles. Для фильтров/логики/совместимости.", "tag"))
	. += list(_make_field("message_start", "Сообщение: старт", "text", A.message_start, "СООБЩЕНИЯ"))
	. += list(_make_field("message_tick", "Сообщение: процесс", "text", A.message_tick, "СООБЩЕНИЯ"))
	. += list(_make_field("message_finish", "Сообщение: финиш", "text", A.message_finish, "СООБЩЕНИЯ"))
	. += list(_make_field("message_climax_active", "Оргазм: инициатор", "text", A.message_climax_active, "СООБЩЕНИЯ"))
	. += list(_make_field("message_climax_passive", "Оргазм: цель", "text", A.message_climax_passive, "СООБЩЕНИЯ"))

/// Creates a single editor field descriptor.
/datum/erp_action_editor_schema/proc/_make_field(id, label, type, value, section, min=null, max=null, step=null, options=null, desc=null, placeholder=null)
	var/list/F = list(
		"id" = id,
		"label" = label,
		"type" = type,
		"value" = value,
		"section" = section
	)

	if(!isnull(min))
		F["min"] = min
	if(!isnull(max))
		F["max"] = max
	if(!isnull(step))
		F["step"] = step
	if(islist(options))
		F["options"] = options
	if(!isnull(desc))
		F["desc"] = desc
	if(!isnull(placeholder))
		F["placeholder"] = placeholder

	return F

/// Converts ticks to seconds (UI/editor convenience).
/datum/erp_action_editor_schema/proc/_ticks_to_seconds(ticks)
	if(!isnum(ticks))
		return 0
	return ticks / 10

/// Creates an enum option entry for editor schemas.
/datum/erp_action_editor_schema/proc/_opt(value, name)
	return list("value" = value, "name" = name)

/// Builds organ enum options for editor schemas.
/datum/erp_action_editor_schema/proc/_organ_options()
	. = list()
	. += list(_opt(null, "—"))
	. += list(_opt(SEX_ORGAN_PENIS, "Член"))
	. += list(_opt(SEX_ORGAN_VAGINA, "Вагина"))
	. += list(_opt(SEX_ORGAN_ANUS, "Анус"))
	. += list(_opt(SEX_ORGAN_MOUTH, "Рот"))
	. += list(_opt(SEX_ORGAN_BREASTS, "Грудь"))
	. += list(_opt(SEX_ORGAN_HANDS, "Руки"))
	. += list(_opt(SEX_ORGAN_LEGS, "Ноги"))
	. += list(_opt(SEX_ORGAN_TAIL, "Хвост"))
	. += list(_opt(SEX_ORGAN_BODY, "Тело"))

/// Builds inject timing enum options for editor schemas.
/datum/erp_action_editor_schema/proc/_inject_timing_options()
	. = list()
	. += list(_opt(INJECT_NONE, "Нет"))
	. += list(_opt(INJECT_CONTINUOUS, "В процессе"))
	. += list(_opt(INJECT_ON_FINISH, "На финише"))

/// Builds inject source enum options for editor schemas.
/datum/erp_action_editor_schema/proc/_inject_source_options()
	. = list()
	. += list(_opt(INJECT_FROM_ACTIVE, "От актёра"))
	. += list(_opt(INJECT_FROM_PASSIVE, "От цели"))

/// Builds inject target mode enum options for editor schemas.
/datum/erp_action_editor_schema/proc/_inject_target_mode_options()
	. = list()
	. += list(_opt(INJECT_ORGAN, "В выбранный орган"))
	. += list(_opt(INJECT_CONTAINER, "В контейнер"))
	. += list(_opt(INJECT_GROUND, "на пол"))

/// Builds action scope enum options for editor schemas.
/datum/erp_action_editor_schema/proc/_scope_options()
	. = list()
	. += list(_opt(ERP_SCOPE_OTHER, "Партнёр"))
	. += list(_opt(ERP_SCOPE_SELF,  "Соло"))
