/obj/item/signal_horna
	name = "signal horn"
	desc = "Используется для сбора войск и подачи сигналов тревоги."
	icon = 'modular_twilight_axis/icons/roguetown/items/misc.dmi'
	icon_state = "signal_horn"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	var/last_horn


	grid_height = 32
	grid_width = 64

/obj/item/signal_horna/attack_self(mob/living/user)
	. = ..()
	if(world.time < last_horn + 30 SECONDS)
		to_chat(user, "Мои легкие должны отдохнуть, прежде чем я смогу дуть в [src.name]!")
		return
	user.visible_message("<span class='warning'>[capitalize(user.name)] вот-вот дунет в [src.name]!</span>")
	if(do_after(user, 15))
		last_horn = world.time
		sound_horn(user)

/obj/item/signal_horna/proc/sound_horn(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/signalhorn.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/signalhorn.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу рёв сигнального рога где-то[disttext][dirtext]!</span>")

/datum/intent/rally
	name = "Сигнал сбора"
	desc = "Услышав одиночный рев рога, все подчиненные должны явиться для построения."
	icon_state = "inrally"
	no_attack = TRUE
	candodge = TRUE
	canparry = TRUE

/datum/intent/alert
	name = "Сигнал тревоги"
	desc = "Услышав двойной рев рога, все подчиненные должны как можно скорее прибыть при оружии."
	icon_state = "inalert"
	no_attack = TRUE
	candodge = TRUE
	canparry = TRUE

/datum/intent/alarm
	name = "Сигнал полной тревоги"
	desc = "Услышав тройной рев рога, все подчиненные обязаны бросить все текущие дела и прийти на выручку."
	icon_state = "inalarm"
	no_attack = TRUE
	candodge = TRUE
	canparry = TRUE

/obj/item/signal_hornn/red
	name = "sergeant's horn"
	desc = "Используется для сбора войск и подачи сигналов тревоги."
	possible_item_intents = list(/datum/intent/rally, /datum/intent/alert, /datum/intent/alarm)
	icon = 'modular_twilight_axis/icons/roguetown/items/misc.dmi'
	icon_state = "signal_horn_red"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	var/last_horn


	grid_height = 32
	grid_width = 64

/obj/item/signal_hornn/red/attack_self(mob/living/user)
	. = ..()
	if(world.time < last_horn + 30 SECONDS)
		to_chat(user, "Мои легкие должны отдохнуть, прежде чем я смогу дуть в [src.name]!")
		return
	user.visible_message("<span class='warning'>[capitalize(user.name)] вот-вот дунет в [src.name]!</span>")
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/rally)
		last_horn = world.time
		sound_horn_rally_red(user)
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/alert)
		last_horn = world.time
		sound_horn_alert_red(user)
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/alarm)
		last_horn = world.time
		sound_horn_alarm_red(user)

/obj/item/signal_hornn/red/proc/sound_horn_rally_red(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог гвардии!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/rallyRetinue.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/rallyRetinue.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу созыв сбора при помощи сигнального рога гвардии где-то[disttext][dirtext]!</span>")

/obj/item/signal_hornn/red/proc/sound_horn_alert_red(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог гвардии!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/AlertRetinue.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/AlertRetinue.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу объявление тревоги при помощи сигнального рога гвардии где-то[disttext][dirtext]!</span>")

/obj/item/signal_hornn/red/proc/sound_horn_alarm_red(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог гвардии!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/FullAlertRetinue.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/FullAlertRetinue.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу объявление полной тревоги при помощи сигнального рога гвардии где-то[disttext][dirtext]!</span>")

/obj/item/signal_hornn/blue
	name = "town guard horn"
	desc = "Используется для сбора войск и подачи сигналов тревоги."
	icon = 'modular_twilight_axis/icons/roguetown/items/misc.dmi'
	icon_state = "signal_horn_blue"
	possible_item_intents = list(/datum/intent/rally, /datum/intent/alert, /datum/intent/alarm)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	var/last_horn


	grid_height = 32
	grid_width = 64

/obj/item/signal_hornn/blue/attack_self(mob/living/user)
	. = ..()
	if(world.time < last_horn + 30 SECONDS)
		to_chat(user, "Мои легкие должны отдохнуть, прежде чем я смогу дуть в [src.name]!")
		return
	user.visible_message("<span class='warning'>[capitalize(user.name)] вот-вот дунет в [src.name]!</span>")
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/rally)
		last_horn = world.time
		sound_horn_rally_blue(user)
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/alert)
		last_horn = world.time
		sound_horn_alert_blue(user)
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/alarm)
		last_horn = world.time
		sound_horn_alarm_blue(user)

/obj/item/signal_hornn/blue/proc/sound_horn_rally_blue(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог дозора!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/rallyWatchmen.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/rallyWatchmen.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу созыв сбора при помощи сигнального рога дозора где-то[disttext][dirtext]!</span>")

/obj/item/signal_hornn/blue/proc/sound_horn_alert_blue(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог дозора!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/AlertWatchmen.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/AlertWatchmen.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу объявление тревоги при помощи сигнального рога дозора где-то[disttext][dirtext]!</span>")

/obj/item/signal_hornn/blue/proc/sound_horn_alarm_blue(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог дозора!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/FullAlertWatchmen.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/FullAlertWatchmen.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу объявление полной тревоги при помощи сигнального рога дозора где-то[disttext][dirtext]!</span>")

/obj/item/signal_hornn/green
	name = "vanguard's horn"
	desc = "Используется для сбора войск и подачи сигналов тревоги."
	icon = 'modular_twilight_axis/icons/roguetown/items/misc.dmi'
	icon_state = "signal_horn_green"
	possible_item_intents = list(/datum/intent/rally, /datum/intent/alert, /datum/intent/alarm)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	var/last_horn


	grid_height = 32
	grid_width = 64

/obj/item/signal_hornn/green/attack_self(mob/living/user)
	. = ..()
	if(world.time < last_horn + 30 SECONDS)
		to_chat(user, "Мои легкие должны отдохнуть, прежде чем я смогу дуть в [src.name]!")
		return
	user.visible_message("<span class='warning'>[capitalize(user.name)] вот-вот дунет в [src.name]!</span>")
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/rally)
		last_horn = world.time
		sound_horn_rally_green(user)
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/alert)
		last_horn = world.time
		sound_horn_alert_green(user)
	if(do_after(user, 15) && user.used_intent.type == /datum/intent/alarm)
		last_horn = world.time
		sound_horn_alarm_green(user)

/obj/item/signal_hornn/green/proc/sound_horn_rally_green(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог авангарда!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/rallyVanguard.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/rallyVanguard.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу созыв сбора при помощи сигнального рога авангарда где-то[disttext][dirtext]!</span>")

/obj/item/signal_hornn/green/proc/sound_horn_alert_green(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог авангарда!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/AlertVanguard.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/AlertVanguard.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу объявление тревоги при помощи сигнального рога авангарда где-то[disttext][dirtext]!</span>")

/obj/item/signal_hornn/green/proc/sound_horn_alarm_green(mob/living/user)
	user.visible_message("<span class='warning'>[capitalize(user.name)] дует в рог авангарда!</span>")
	playsound(src, 'modular_twilight_axis/sound/items/horn/FullAlertVanguard.ogg', 100, TRUE)
	var/turf/origin_turf = get_turf(src)

	for(var/mob/living/player in GLOB.player_list)
		if(player.stat == DEAD)
			continue
		if(isbrain(player))
			continue

		var/distance = get_dist(player, origin_turf)
		if(distance <= 7)
			continue
		var/dirtext = " к "
		var/direction = angle2dir(Get_Angle(player, origin_turf))
		switch(direction)
			if(NORTH)
				dirtext += "северу"
			if(SOUTH)
				dirtext += "югу"
			if(EAST)
				dirtext += "востоку"
			if(WEST)
				dirtext += "западу"
			if(NORTHWEST)
				dirtext += "северо-западу"
			if(NORTHEAST)
				dirtext += "северо-востоку"
			if(SOUTHWEST)
				dirtext += "юго-западу"
			if(SOUTHEAST)
				dirtext += "юго-востоку"
			else //Where ARE you.
				dirtext = ", но я не могу определить, откуда он раздался"
		var/disttext
		switch(distance)
			if(0 to 20)
				disttext = " очень близко"
			if(20 to 40)
				disttext = " близко"
			if(40 to 80)
				disttext = ""
			if(80 to 160)
				disttext = " далеко"
			else
				disttext = " очень далеко"

		//sound played for other players
		player.playsound_local(get_turf(player), 'modular_twilight_axis/sound/items/horn/FullAlertVanguard.ogg', 35, FALSE, pressure_affected = FALSE)
		to_chat(player, "<span class='warning'>Я слышу объявление полной тревоги при помощи сигнального рога авангарда где-то[disttext][dirtext]!</span>")
