// code/modules/mob/living/carbon/human/morph_cache.dm
//
// Кеш морфов для авто-подгонки одежды (breasts/belly/butt).
//
// ВАЖНО: этот файл НЕ лезет в ваши базовые апдейты.
// Ты сам подключишь вызовы в нужных местах (см. блок "ИНТЕГРАЦИЯ" внизу).
//
// Зависимости:
// - ORGAN_SLOT_BREASTS / ORGAN_SLOT_BELLY / ORGAN_SLOT_BUTT (если другие — поправь)
// - слои: BODYPARTS_LAYER, BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER, BODY_LAYER (если нет — убери)
// - helpers: icon_build_delta_mask(), icon_apply_delta_to_clothing(), flat_from_overlays() (ниже)

#define MORPH_DIRS list(SOUTH, NORTH, EAST, WEST)
#define MORPH_SAFE(v, d) (isnull(v) ? (d) : (v))

/mob/living/carbon/human
	var/tmp/icon/morph_full_icons[4]
	var/tmp/icon/morph_base_icons[4]
	var/tmp/icon/morph_delta_masks[4]
	var/tmp/morph_cache_key = null
	var/tmp/morph_building = FALSE

	/// тумблеры на будущее
	var/tmp/morph_enable = TRUE
	var/tmp/morph_debug_red = FALSE

/// Источники размеров = ОРГАНЫ, потому что belly/butt у вас sprite_accessory читают organ vars.
/mob/living/carbon/human/proc/get_morph_cache_key()
	var/species_type = dna?.species?.type || "nospecies"
	var/g = gender || "nogender"

	var/boob = 0
	var/obj/item/organ/breasts/B = getorganslot(ORGAN_SLOT_BREASTS)
	if(B)
		boob = B.breast_size

	var/belly = 0
	var/obj/item/organ/belly/BE = getorganslot(ORGAN_SLOT_BELLY)
	if(BE)
		belly = BE.belly_size

	var/butt = 1
	var/obj/item/organ/butt/BU = getorganslot(ORGAN_SLOT_BUTT)
	if(BU)
		butt = BU.butt_size

	return "[g]|[species_type]|b[MORPH_SAFE(boob,0)]|be[MORPH_SAFE(belly,0)]|bu[MORPH_SAFE(butt,1)]"

/// Собрать overlays_standing по конкретным слоям в плоский список.
/mob/living/carbon/human/proc/_morph_collect_layers(list/layers)
	var/list/out = list()
	if(!islist(layers) || !length(layers))
		return out

	for(var/L in layers)
		var/v = overlays_standing[L]
		if(!v)
			continue
		if(islist(v))
			out += v
		else
			out += v
	return out

/// Временное "обнуление" морф-органов. Возвращает list с сохранёнными значениями.
/mob/living/carbon/human/proc/_morph_temp_disable()
	var/list/saved = list()

	var/obj/item/organ/breasts/B = getorganslot(ORGAN_SLOT_BREASTS)
	if(B)
		saved["boob"] = B.breast_size
		B.breast_size = 0

	var/obj/item/organ/belly/BE = getorganslot(ORGAN_SLOT_BELLY)
	if(BE)
		saved["belly"] = BE.belly_size
		BE.belly_size = 0

	var/obj/item/organ/butt/BU = getorganslot(ORGAN_SLOT_BUTT)
	if(BU)
		saved["butt"] = BU.butt_size
		BU.butt_size = 1 // базовый (т.к. get_icon_state = (size-1))

	return saved

/mob/living/carbon/human/proc/_morph_temp_restore(list/saved)
	if(!islist(saved))
		return

	var/obj/item/organ/breasts/B = getorganslot(ORGAN_SLOT_BREASTS)
	if(B && !isnull(saved["boob"]))
		B.breast_size = saved["boob"]

	var/obj/item/organ/belly/BE = getorganslot(ORGAN_SLOT_BELLY)
	if(BE && !isnull(saved["belly"]))
		BE.belly_size = saved["belly"]

	var/obj/item/organ/butt/BU = getorganslot(ORGAN_SLOT_BUTT)
	if(BU && !isnull(saved["butt"]))
		BU.butt_size = saved["butt"]

/// Основная сборка кеша из текущих overlays_standing.
/// Делает FULL, затем временно выключает органы -> пересобирает внешку -> BASE -> строит DELTA.
/mob/living/carbon/human/proc/rebuild_morph_cache_from_current()
	if(!morph_enable)
		return
	if(morph_building)
		return

	morph_building = TRUE

	var/key = get_morph_cache_key()
	if(morph_cache_key == key && morph_delta_masks[1])
		morph_building = FALSE
		return
	morph_cache_key = key

	// Какие слои считаем "силуэтом"
	// BODY_LAYER тут опциональный: если у вас грудь/часть тела рисуется через body overlay.
	var/list/WANTED = list(BODY_LAYER, BODYPARTS_LAYER, BODY_ADJ_LAYER, FRONT_MUTATIONS_LAYER)

	// FULL (текущие оверлеи)
	var/list/full_overlays = _morph_collect_layers(WANTED)

	// BASE (вырубили органы -> пересобрали внешний вид -> сняли оверлеи)
	var/list/saved = _morph_temp_disable()

	// ВАЖНО: тут нужен “форс” пересборки, иначе overlays_standing не обновятся.
	// Эти вызовы ты НЕ обязан держать именно так — но они обычно достаточны.
	update_body()
	update_body_parts(TRUE)

	var/list/base_overlays = _morph_collect_layers(WANTED)

	_morph_temp_restore(saved)

	// Возвращаем оригинальные оверлеи
	update_body()
	update_body_parts(TRUE)

	// Flat + delta
	for(var/i in 1 to 4)
		var/d = MORPH_DIRS[i]
		morph_full_icons[i] = flat_from_overlays(full_overlays, d)
		morph_base_icons[i] = flat_from_overlays(base_overlays, d)
		morph_delta_masks[i] = icon_build_delta_mask(morph_full_icons[i], morph_base_icons[i])

	if(morph_debug_red)
		world.log << "MORPH: key=[morph_cache_key] delta_south=[morph_delta_masks[1]]"

	morph_building = FALSE

/// Получить delta-иконку под конкретный dir.
/mob/living/carbon/human/proc/get_morph_delta_for_dir(dir)
	rebuild_morph_cache_from_current()

	var/idx = (dir == SOUTH) ? 1 : (dir == NORTH) ? 2 : (dir == EAST) ? 3 : 4
	return morph_delta_masks[idx]

/// Собрать мульти-dir иконку одежды с автоподгонкой.
/// icon_state должен быть УЖЕ финальным (с _f, _custom и т.д.), dir-сборка делается тут.
/mob/living/carbon/human/proc/autofit_worn_icon(icon_file, icon_state, sleeveindex)
	if(!morph_enable)
		return null

	rebuild_morph_cache_from_current()

	var/icon/out = icon('icons/blanks/32x32.dmi', "nothing")

	for(var/i in 1 to 4)
		var/d = MORPH_DIRS[i]

		// Берём исходную иконку одежды для конкретного направления
		var/icon/base = icon(icon_file, icon_state, d)

		var/icon/delta = morph_delta_masks[i]
		if(delta)
			base = icon_apply_delta_to_clothing(base, delta, radius = 3, keep_alpha_from_delta = TRUE, debug_red = morph_debug_red)

		out.Insert(base, dir = d)

	return out

/// Собрать /icon из списка overlays (mutable_appearance) в конкретном dir.
/proc/flat_from_overlays(list/overlays, dir)
	if(!islist(overlays) || !length(overlays))
		return icon('icons/blanks/32x32.dmi', "nothing")

	var/image/dummy = image('icons/blanks/32x32.dmi', "nothing")
	dummy.dir = dir
	dummy.overlays = overlays

	return getFlatIcon(dummy, defdir = dir, no_anim = TRUE)

#undef MORPH_DIRS
#undef MORPH_SAFE

/*
=====================
ИНТЕГРАЦИЯ (коротко)
=====================

1) В /obj/item/proc/build_worn_icon(...) — там где ты уже вставил:
    if(!isinhands && ishuman(loc))
        var/mob/living/carbon/human/H = loc
        var/icon/fitted = H.autofit_worn_icon(file2use, t_state, sleeveindex)
        if(fitted)
            standing.icon = fitted
            standing.icon_state = ""
            standing.dir = SOUTH

2) Нужно гарантировать, что кеш пересобирается когда меняются морфы:
   Самый простой (и точный) вариант:
     - вызывать H.rebuild_morph_cache_from_current() после обновления тела/аксессуаров,
       например в конце update_body() (или в тех местах где вы меняете boob/belly/butt size).

   Я сознательно НЕ вставляю это в базовые апдейты в этом файле.
*/
