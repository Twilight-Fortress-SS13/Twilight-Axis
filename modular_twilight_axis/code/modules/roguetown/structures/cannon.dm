#define CANNON_POWDER_COST 10

/datum/anvil_recipe/weapons/steel/cannon
	name = "Cannon"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/ingot/blacksteel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small,)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/structure/cannon
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = 5

/datum/anvil_recipe/weapons/steel/cannon_zizo
	name = "Cannon"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel, /obj/item/grown/log/tree/small, /obj/item/grown/log/tree/small,)
	req_bar = 	/obj/item/ingot/steel/zizo
	created_item = /obj/structure/cannon
	display_category = ITEM_CAT_WEAPONS_SWORDS
	craftdiff = 3

/datum/anvil_recipe/weapons/steel/cannonball
	name = "Cannon Ball"
	additional_items = list(/obj/item/ingot/steel, /obj/item/ingot/steel)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/cannon_shell/cannonball
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/anvil_recipe/weapons/steel/grapeshot
	name = "Grapeshot Cannon"
	additional_items = list(/obj/item/ingot/steel)
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/cannon_shell/grapeshot
	display_category = ITEM_CAT_WEAPONS_AMMO

/datum/crafting_recipe/roguetown/survival/fiberfuse
	name = "fiber fuse"
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	result = /obj/item/cannon_fuse/fiber
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/parchmentfuse
	name = "parchment fuse"
	display_category = ITEM_CAT_TOOLS_WORKSHOP
	result = /obj/item/cannon_fuse/parchment
	reqs = list(
		/obj/item/paper = 2,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		)
	craftdiff = 1

/obj/item/cannon_fuse
	name = "fuse"
	desc = "Фитиль для пушки."
	icon = 'modular_twilight_axis/icons/obj/structures/siege/cannon/cannon_fuse.dmi'
	icon_state = "fiber_fuse"
	w_class = WEIGHT_CLASS_SMALL
	var/burn_time = 3 SECONDS
	var/lit = FALSE
	var/icon_state_lit = "fiber_fuse_lit"

/obj/item/cannon_fuse/fiber
	name = "fiber fuse"
	desc = "Стандартный плетеный фитиль обмазанный жиром. Горит относительно медленно, давая расчету время отойти на безопасное расстояние."
	icon_state = "fiber_fuse"
	icon_state_lit = "fiber_fuse_lit"
	burn_time = 3 SECONDS

/obj/item/cannon_fuse/parchment
	name = "parchment fuse"
	desc = "Пропитанный жиром бумажный фитиль. Сгорает почти мгновенно, обеспечивая быстрый выстрел."
	icon_state = "parchment_fuse"
	icon_state_lit = "parchment_fuse_lit"
	burn_time = 1 SECONDS



/obj/item/cannon_shell
	name = "cannon shell"
	desc = "Снаряд для пушки."
	icon = 'modular_twilight_axis/icons/obj/structures/siege/cannon/cannon.dmi'
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/cannon_shell/cannonball
	name = "cannonball"
	desc = "Тяжелое стальное ядро для пушки."
	icon_state = "cannonball"

/obj/item/cannon_shell/grapeshot
	name = "grapeshot"
	desc = "Снаряд, наполненный десятками мелких пуль."
	icon_state = "grapeshot"

/obj/projectile/bullet/cannon_debris
	name = "flying debris"
	desc = "Куски земли и камня."
	icon = 'icons/effects/debris.dmi'
	icon_state = "shards"
	color = "#5c544d"
	damage = 0
	nodamage = TRUE
	flag = "blunt"
	speed = 1.0
	pass_flags = PASSTABLE | PASSMOB

/obj/projectile/bullet/cannon_debris/on_hit(atom/target, blocked = 0)
	var/turf/T = get_turf(target)
	if(T && !istype(target, /mob/living))
		new /obj/effect/particle_effect/smoke/arquebus(T)
	qdel(src)
	return BULLET_ACT_HIT

/obj/projectile/bullet/cannonball_straight
	name = "cannonball"
	desc = "Свинцовое ядро"
	icon = 'modular_twilight_axis/icons/obj/structures/siege/cannon/cannonball.dmi'
	icon_state = "ball"
	damage = 110
	damage_type = BRUTE
	flag = "bullet"
	speed = 2.5
	var/pierces_left = 3

/obj/projectile/bullet/cannonball_straight/on_hit(atom/target, blocked = 0)
	. = ..()
	var/turf/T = get_turf(target)
	if(!T)
		qdel(src)
		return

	if(isliving(target))
		var/mob/living/L = target

		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			var/list/valid_limbs = list()
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(BP.body_zone != BODY_ZONE_CHEST && BP.body_zone != BODY_ZONE_HEAD)
					valid_limbs += BP

			var/limbs_to_lose = rand(1, 3)
			for(var/i in 1 to limbs_to_lose)
				if(!length(valid_limbs))
					break
				var/obj/item/bodypart/lost_limb = pick(valid_limbs)
				valid_limbs -= lost_limb
				lost_limb.dismember(BRUTE, BCLASS_CHOP, null, lost_limb.body_zone, 110, TRUE, TRUE)

			for(var/obj/item/bodypart/remaining_limb in H.bodyparts)
				H.apply_damage(100, BRUTE, remaining_limb.body_zone)
		else
			L.adjustBruteLoss(400)

		var/throw_dir = turn(dir, pick(-90, 90))
		var/turf/throw_turf = get_ranged_target_turf(L, throw_dir, rand(2, 4))
		if(throw_turf)
			L.throw_at(throw_turf, 4, 2, null, FALSE, FALSE, null, MOVE_FORCE_STRONG)

		L.Knockdown(60)
		L.Paralyze(40)

	else if(istype(target, /turf/closed) || istype(target, /obj/structure) || istype(target, /obj/machinery))
		target.ex_act(EXPLODE_DEVASTATE)
		new /obj/effect/particle_effect/smoke/arquebus(T)

	pierces_left--

	if(pierces_left > 0)
		temporary_unstoppable_movement = TRUE
		movement_type |= UNSTOPPABLE
		return BULLET_ACT_FORCE_PIERCE

	else
		T.visible_message(span_danger("Пушечное ядро с грохотом разрывается!"))

		for(var/mob/living/M in range(4, T))
			if(!M.mind || istype(M, /mob/living/simple_animal))
				if(get_dist(T, M) <= 3)
					M.adjustBruteLoss(300)
				else
					M.adjustBruteLoss(200)

			if(M != target)
				var/blast_dir = get_dir(T, M)
				if(blast_dir == 0)
					blast_dir = pick(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)

				var/turf/blast_turf = get_ranged_target_turf(M, blast_dir, rand(2, 4))
				if(blast_turf)
					M.throw_at(blast_turf, 4, 2, null, FALSE, FALSE, null, MOVE_FORCE_STRONG)

				M.Knockdown(60)
				M.Paralyze(40)
				M.adjustBruteLoss(rand(40, 80))
				M.visible_message(span_warning("[M] сбивает с ног мощной ударной волной!"))

		var/shrapnel_count = rand(6, 12)
		var/list/all_dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		for(var/i in 1 to shrapnel_count)
			var/obj/projectile/bullet/grapeshot_pellet/S = new(T)
			var/shoot_dir = pick(all_dirs)
			var/turf/shrapnel_target = get_ranged_target_turf(T, shoot_dir, rand(4, 7))

			if(shrapnel_target)
				shrapnel_target = locate(shrapnel_target.x + rand(-2, 2), shrapnel_target.y + rand(-2, 2), shrapnel_target.z)

			S.preparePixelProjectile(shrapnel_target, src, null, rand(-30, 30))
			S.p_x = 16
			S.p_y = 16
			S.fire()

		for(var/i in 1 to 16)
			var/obj/projectile/bullet/cannon_debris/D = new(T)
			var/shoot_dir = pick(all_dirs)
			var/turf/debris_target = get_ranged_target_turf(T, shoot_dir, rand(5, 9))

			if(debris_target)
				debris_target = locate(debris_target.x + rand(-3, 3), debris_target.y + rand(-3, 3), debris_target.z)

			D.preparePixelProjectile(debris_target, src, null, rand(-45, 45))
			D.p_x = 16
			D.p_y = 16
			D.fire()

		explosion(T, devastation_range = 0, heavy_impact_range = 3, light_impact_range = 6, flame_range = 0, smoke = TRUE, soundin = pick('sound/misc/explode/bottlebomb (1).ogg','sound/misc/explode/bottlebomb (2).ogg'))

		qdel(src)
		return BULLET_ACT_HIT

/obj/projectile/bullet/grapeshot_pellet
	name = "shrapnel"
	icon = 'modular_twilight_axis/firearms/icons/ammo.dmi'
	icon_state = "musketball"
	damage = 90
	damage_type = BRUTE
	flag = "piercing"
	armor_penetration = PEN_BSTEEL
	speed = 2.0
	woundclass = BCLASS_PIERCE
	embedchance = 100
	intdamfactor = 2

/obj/projectile/bullet/grapeshot_pellet/prehit(atom/target)
	if(isliving(target))
		temporary_unstoppable_movement = TRUE
		if(prob(50))
			return FALSE
	return ..()

/obj/structure/cannon
	name = "Cannon"
	desc = "Тяжелое пороховое оружие на колесном лафете. Стреляет разрушительными снарядами."
	icon = 'modular_twilight_axis/icons/obj/structures/siege/cannon/cannon.dmi'
	icon_state = "cannon"
	density = TRUE
	anchored = FALSE
	max_integrity = 2000

	pixel_x = -16
	pixel_y = -16

	var/powder_loaded = FALSE
	var/obj/item/cannon_shell/bullet_loaded = null
	var/rammed = FALSE
	var/obj/item/cannon_fuse/inserted_fuse = null
	var/fuse_burning = FALSE

	var/barrel_integrity = 15
	var/last_fired = 0
	var/cooldown = 10 SECONDS

/obj/structure/cannon/Initialize()
	. = ..()
	dir = NORTH
	update_icon()

/obj/structure/cannon/Destroy()
	if(bullet_loaded)
		qdel(bullet_loaded)
		bullet_loaded = null
	if(inserted_fuse)
		qdel(inserted_fuse)
		inserted_fuse = null
	return ..()

/obj/structure/cannon/update_icon()
	. = ..()
	cut_overlays()

	if(!inserted_fuse)
		icon_state = "cannon"
	else if(fuse_burning)
		icon_state = "cannon_lit"
	else
		icon_state = "cannon_fib"

/obj/structure/cannon/examine(mob/user)
	. = ..()
	if((world.time - last_fired) < cooldown)
		. += span_warning("Ствол пушки горячий от недавнего выстрела!")
	else
		. += span_info("Ствол холодный, пушка готова к перезарядке.")

	if(fuse_burning)
		. += span_bold("ФИТИЛЬ ГОРИТ И ИСКРИТ! СЕЙЧАС БУДЕТ ВЫСТРЕЛ!")
		return

	if(!powder_loaded)
		. += span_info("Дуло пустое. Нужно засыпать порох.")
	else if(!bullet_loaded)
		. += span_info("Пороховой заряд засыпан, но снаряд отсутствует.")
	else if(!rammed)
		. += span_warning("Порох и снаряд внутри ствола, но заряд еще не уплотнен шомполом!")
	else if(!inserted_fuse)
		. += span_notice("Орудие готово и уплотнено. В запальное отверстие нужно вставить фитиль.")
	else
		. += span_bold("В запале установлен фитиль. Поджгите его, чтобы произвести выстрел!")

/obj/structure/cannon/fire_act()
	if(inserted_fuse && !fuse_burning)
		light_fuse()

/obj/structure/cannon/spark_act()
	if(inserted_fuse && !fuse_burning)
		light_fuse()

/obj/structure/cannon/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(fuse_burning)
		to_chat(user, span_warning("Фитиль горит! Не трогайте пушку!"))
		return

	dir = turn(dir, -90)
	user.visible_message(span_notice("[user] разворачивает [src.name]."), span_notice("Вы развернули пушку на [dir2text(dir)]."))
	playsound(src, 'modular_twilight_axis/awful_artillery/sound/anglecorrection.ogg', 100, TRUE)

/obj/structure/cannon/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/twilight_powderflask))
		var/obj/item/twilight_powderflask/P = used_item
		if(powder_loaded)
			to_chat(user, span_warning("В пушку уже засыпан порох!"))
			return
		if(P.charges < CANNON_POWDER_COST)
			to_chat(user, span_warning("В пороховнице слишком мало пороха для такой пушки! Нужно хотя бы 10 зарядов."))
			return
		user.visible_message(span_notice("[user] начинает засыпать порох в дуло [src.name]..."))
		playsound(src, 'modular_twilight_axis/awful_artillery/sound/powder.ogg', 100, TRUE)
		if(do_after(user, 3 SECONDS, src))
			if(QDELETED(P) || QDELETED(src))
				return
			if(P.charges < CANNON_POWDER_COST)
				to_chat(user, span_warning("В пороховнице уже недостаточно пороха!"))
				return
			P.charges -= CANNON_POWDER_COST
			powder_loaded = TRUE
			to_chat(user, span_notice("Вы засыпали порох в ствол."))
			if(P.charges <= 0)
				qdel(P)
				var/obj/item/twilight_powderflask_empty/E = new (user.loc)
				user.put_in_hands(E)
		return

	if(istype(used_item, /obj/item/cannon_shell))
		if(!powder_loaded)
			to_chat(user, span_warning("Сначала нужно засыпать порох!"))
			return
		if(bullet_loaded)
			to_chat(user, span_warning("В стволе уже есть снаряд!"))
			return

		if(user.transferItemToLoc(used_item, src))
			bullet_loaded = used_item
			user.visible_message(span_notice("[user] помещает снаряд в дуло [src.name]."))
			playsound(src, 'modular_twilight_axis/awful_artillery/sound/loading.ogg', 100, TRUE)
		return

	if(istype(used_item, /obj/item/twilight_ramrod))
		if(!powder_loaded || !bullet_loaded)
			to_chat(user, span_warning("Вам нечего уплотнять! Зарядите сначала порох и снаряд."))
			return
		if(rammed)
			to_chat(user, span_warning("Заряд в пушке уже уплотнен!"))
			return
		user.visible_message(span_notice("[user] начинает уплотнять заряд в стволе [src.name] шомполом..."))
		playsound(src, 'modular_twilight_axis/firearms/sound/ramrod.ogg', 100, TRUE)
		if(do_after(user, 4 SECONDS, src))
			rammed = TRUE
			user.visible_message(span_notice("[user] уплотнил заряд шомполом. Теперь пушка готова к выстрелу."))
		return

	if(istype(used_item, /obj/item/cannon_fuse) || istype(used_item, /obj/item/natural/fibers) || istype(used_item, /obj/item/natural/bundle/fibers))
		if(inserted_fuse)
			to_chat(user, span_warning("В запальном отверстии пушки уже есть фитиль!"))
			return
		if(!rammed)
			to_chat(user, span_warning("Перед установкой фитиля уплотните порох и снаряд шомполом!"))
			return

		if(istype(used_item, /obj/item/natural/fibers) || istype(used_item, /obj/item/natural/bundle/fibers))
			inserted_fuse = new /obj/item/cannon_fuse/fiber(src)
			if(istype(used_item, /obj/item/natural/bundle/fibers))
				var/obj/item/natural/bundle/fibers/B = used_item
				B.amount--
				if(B.amount <= 0)
					qdel(B)
			else
				qdel(used_item)
		else
			if(user.transferItemToLoc(used_item, src))
				inserted_fuse = used_item

		user.visible_message(span_notice("[user] вставляет фитиль в запальное отверстие [src.name]."))
		playsound(src, 'sound/foley/bandage.ogg', 100, FALSE)
		update_icon()
		return

	var/ignition_msg = used_item.ignition_effect(src, user)
	if(ignition_msg)
		if(inserted_fuse && !fuse_burning)
			visible_message(ignition_msg)
			light_fuse(user)
		return TRUE

	return ..()

/obj/structure/cannon/proc/light_fuse(mob/user)
	if(!inserted_fuse || fuse_burning)
		return

	fuse_burning = TRUE
	inserted_fuse.lit = TRUE
	inserted_fuse.icon_state = inserted_fuse.icon_state_lit
	update_icon()

	if(user)
		user.visible_message(span_danger("[user] поджигает фитиль у [src.name]! Она сейчас выстрелит!"))
	else
		visible_message(span_danger("Фитиль у [src.name] начинает угрожающе искрить! Она сейчас выстрелит!"))

	playsound(src, 'modular_twilight_axis/firearms/sound/fuse.ogg', 100, FALSE)

	addtimer(CALLBACK(src, PROC_REF(detonate_fuse), user), inserted_fuse.burn_time)

/obj/structure/cannon/proc/detonate_fuse(mob/user)
	fuse_burning = FALSE
	if(!inserted_fuse)
		return
	qdel(inserted_fuse)
	inserted_fuse = null
	update_icon()

	fire_cannon(user)

/obj/structure/cannon/proc/fire_cannon(mob/user)
	if(!powder_loaded || !bullet_loaded || !rammed)
		return

	var/turf/start_turf = get_step(src, dir)
	if(!start_turf)
		return

	for(var/mob/M in range(7, src))
		if(M.client)
			shake_camera(M, 4, 2)

	playsound(src, 'modular_twilight_axis/awful_artillery/sound/launch.ogg', 100, 0, 20, 1, null, null, FALSE, TRUE)

	for(var/turf/AT in get_adjacent_turfs(src.loc))
		new /obj/effect/particle_effect/smoke/arquebus(AT)
		if(prob(40))
			for(var/turf/BT in get_adjacent_turfs(AT))
				new /obj/effect/particle_effect/smoke/arquebus(BT)

	var/turf/target_turf = get_ranged_target_turf(src, dir, 16)

	if(istype(bullet_loaded, /obj/item/cannon_shell/grapeshot))
		var/pellet_count = 30
		var/shoot_dir = dir
		for(var/i in 1 to pellet_count)
			var/obj/projectile/bullet/grapeshot_pellet/S = new(start_turf)
			S.def_zone = pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
			var/turf/pellet_target = get_ranged_target_turf(start_turf, shoot_dir, 8)

			if(pellet_target)
				S.preparePixelProjectile(pellet_target, src, null, rand(-20, 20))

			S.p_x = 16
			S.p_y = 16
			S.fire()
	else
		var/obj/projectile/bullet/cannonball_straight/P = new(start_turf)
		if(target_turf)
			P.preparePixelProjectile(target_turf, src)

		P.p_x = 16
		P.p_y = 16
		P.fire()

	var/user_name = user ? "[user]" : "Unknown (Auto-ignite)"
	log_game("[user_name] выстрелил из пушки в направлении [dir2text(dir)] на ([x], [y], [z])")
	message_admins("Пушка выстрелила, поджег был сделан игроком [user_name] на [ADMIN_VERBOSEJMP(src.loc)]")
	qdel(bullet_loaded)
	bullet_loaded = null
	powder_loaded = FALSE
	rammed = FALSE

	var/skill = 0
	if(user && isliving(user))
		var/mob/living/L = user
		skill = L.get_skill_level(/datum/skill/combat/twilight_firearms)

	var/misfire_chance = max(0, 25 - (skill * 5))

	if(prob(misfire_chance))
		src.visible_message(span_danger("[src] разрывается на части!"))
		explosion(get_turf(src), 1, 2, 4, 0, TRUE, FALSE, 2)
		qdel(src)
		return

	if((world.time - last_fired) < cooldown)
		barrel_integrity -= 2
	else
		barrel_integrity--
	last_fired = world.time

	if(barrel_integrity <= 0)
		src.visible_message(span_danger("[src] разрывается на части из-за критического износа ствола!"))
		explosion(get_turf(src), 1, 2, 4, 0, TRUE, FALSE, 2)
		qdel(src)
#undef CANNON_POWDER_COST
