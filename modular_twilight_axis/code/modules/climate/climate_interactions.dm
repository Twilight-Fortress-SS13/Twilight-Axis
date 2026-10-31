/datum/controller/subsystem/ta_climate_weather
	var/list/ta_climate_barometers = list()

/obj/item/barometer
	name = "barometer"
	desc = "Простой прибор для предсказания приближающейся непогоды."
	icon = 'modular_twilight_axis/icons/obj/barometer.dmi'
	icon_state = "barometer"
	grid_width = 32
	grid_height = 64

/obj/item/barometer/Initialize(mapload)
	. = ..()
	if(SSta_climate_weather)
		SSta_climate_weather.ta_climate_barometers |= src

/obj/item/barometer/Destroy()
	if(SSta_climate_weather)
		SSta_climate_weather.ta_climate_barometers -= src
	return ..()

/obj/item/barometer/proc/on_weather_queued(weather_path)
	if(!weather_path)
		return
	visible_message(span_notice("[src] тихо щёлкает: жидкость в колбе смещается."))

/obj/item/barometer/attack_self(mob/user)
	. = ..()
	if(!user)
		return
	user.visible_message(span_notice("[user] изучает показания [src]."))
	if(!do_after(user, 5 SECONDS, target = src))
		return
	var/datum/particle_weather/W = SSParticleWeather?.runningWeather
	if(W)
		if(W.running && W.severity > 0)
			to_chat(user, span_notice("Прибор показывает текущую погоду: [W.name]."))
		else if(W.running)
			to_chat(user, span_notice("Прибор показывает, что погода стихает: [W.name]."))
		else
			to_chat(user, span_notice("Прибор указывает на приближение погоды: [W.name]."))
		return
	if(SSta_climate_weather?.weather_queued && SSta_climate_weather.queued_weather_type && !GLOB.todoverride && world.time <= SSta_climate_weather.queued_weather_expiration)
		var/datum/particle_weather/weather_type = SSta_climate_weather.queued_weather_type
		var/weather_name = initial(weather_type.name)
		to_chat(user, span_notice("Прибор предсказывает скорую смену погоды: [weather_name]."))
		return
	to_chat(user, span_notice("Колба неподвижна: в ближайшее время перемен погоды не ожидается."))

/datum/status_effect/buff/alch/temperaturepot
	id = "temppot"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/temperaturepot
	duration = 15 SECONDS

/datum/status_effect/buff/alch/temperaturepot/on_creation(mob/living/new_owner, added_duration = 15 SECONDS)
	duration = min(added_duration, 15 MINUTES)
	return ..()

/datum/status_effect/buff/alch/temperaturepot/refresh(mob/living/new_owner, added_duration = 15 SECONDS)
	duration = min(duration + added_duration, world.time + 15 MINUTES)

/datum/status_effect/buff/alch/temperaturepot/tick()
	. = ..()
	if(!owner || QDELETED(owner) || owner.stat == DEAD)
		return
	if(owner.bodytemperature > BODYTEMP_NORMAL_MAX)
		owner.adjust_bodytemperature(-min(5, owner.bodytemperature - BODYTEMP_NORMAL_MAX))
	else if(owner.bodytemperature < BODYTEMP_NORMAL_MIN)
		owner.adjust_bodytemperature(min(5, BODYTEMP_NORMAL_MIN - owner.bodytemperature))

/atom/movable/screen/alert/status_effect/buff/alch/temperaturepot
	name = "Temperature Equilibrium"
	desc = "Алхимия постепенно возвращает температуру тела к норме."
	icon_state = "buff"

/datum/reagent/buff/temperature_normalize
	name = "temperature equilibrium"
	color = "#ff9000"
	taste_description = "вода"
	buff_type = /datum/status_effect/buff/alch/temperaturepot
	duration_per_unit = 15 SECONDS


