#define ARMOR_STONESKIN list("blunt" = DR_MEDIUM, "slash" = DBLOCK_HEAVY, "stab" = DBLOCK_HEAVY, "piercing" = DBLOCK_MEDIUM, "fire" = DR_SUPER, "acid" = DR_SUPER)

/obj/structure/alch_prop
	name = "suspicious object"
	desc = "Something about this doesn't look right."
	icon = 'icons/roguetown/items/misc.dmi' 
	icon_state = "woodbucket" 
	density = TRUE
	anchored = TRUE

/datum/reagent/advanced
	name = "Advanced Reagent"
	metabolization_rate = 0.4

/datum/reagent/advanced/growth
	name = "Giant's Might"
	description = "A thick, muddy-brown liquid that feels unnaturally heavy. The bottle seems to pull down on your hand with significant weight."
	color = "#5a3a22"
	taste_description = "earth and raw iron"
	metabolization_rate = REAGENTS_METABOLISM * 0.1

/datum/reagent/advanced/growth/on_mob_add(mob/living/carbon/human/M)
	if(istype(M))
		M.dna.features["body_size"] = 1.5
		M.dna.update_body_size()
		ADD_TRAIT(M, TRAIT_BIGGUY, src)
/datum/reagent/advanced/growth/on_mob_delete(mob/living/carbon/human/M)
	if(istype(M))
		M.dna.features["body_size"] = 1.0
		M.dna.update_body_size()
		REMOVE_TRAIT(M, TRAIT_BIGGUY, src)

/datum/reagent/advanced/invisible
	name = "Void Essence"
	description = "A liquid that isn't just black—it actively devours the light around it. The container appears as a literal hole in space."
	color = "#29293f"
	taste_description = "the absolute void"
	metabolization_rate = REAGENTS_METABOLISM * 0.3

/datum/reagent/advanced/invisible/on_mob_life(mob/living/M)
	M.alpha = 0
	M.invisibility = 60
	..()

/datum/reagent/advanced/invisible/on_mob_delete(mob/living/M)
	M.alpha = 255
	M.invisibility = 0

/datum/reagent/advanced/paralysis
	name = "Spider's Kiss"
	description = "A viscous, dark purple syrup. It leaves thick, web-like trails against the glass that move on their own."
	color = "#4b0082"
	taste_description = "cloying bitterness"
	metabolization_rate = REAGENTS_METABOLISM * 0.6

/datum/reagent/advanced/paralysis/on_mob_life(mob/living/M)
	M.Paralyze(40)
	..()


/datum/reagent/advanced/sleep
	name = "Morpheus Draught"
	description = "A pale blue liquid with a faint, swirling white vapor constantly dancing over its surface."
	color = "#add8e6"
	taste_description = "honey and poppies"
	metabolization_rate = REAGENTS_METABOLISM * 0.6

/datum/reagent/advanced/sleep/on_mob_life(mob/living/M)
	M.Sleeping(150)
	..()

/datum/reagent/advanced/grace
	name = "Cat's Grace"
	description = "A shimmering golden oil that feels impossibly slippery. The container feels like it could slide from your hand at any moment."
	color = "#ffd700"
	taste_description = "creamy butter"
	metabolization_rate = REAGENTS_METABOLISM * 0.01

/datum/reagent/advanced/grace/on_mob_life(mob/living/M)
	ADD_TRAIT(M, TRAIT_NOFALLDAMAGE2, src)
	..()
/datum/reagent/advanced/grace/on_mob_delete(mob/living/M)
	REMOVE_TRAIT(M, TRAIT_NOFALLDAMAGE2, src)


/datum/reagent/advanced/speed
	name = "Swift Feet"
	description = "A crackling yellow liquid resembling captured lightning. It vibrates with intense, suppressed energy."
	color = "#ffff00"
	taste_description = "citric acid"
	metabolization_rate = REAGENTS_METABOLISM * 0.2

/datum/reagent/advanced/speed/on_mob_add(mob/living/M)
	M.add_movespeed_modifier("swift_feet", multiplicative_slowdown = -1.5)
	M.AddComponent(/datum/component/after_image)

/datum/reagent/advanced/speed/on_mob_delete(mob/living/M)
	M.remove_movespeed_modifier("swift_feet")
	qdel(M.GetComponent(/datum/component/after_image))

/datum/reagent/advanced/elixir_of_life
	name = "Elixir of Life"
	description = "A shimmering, pearlescent liquid that seems to pulse with a golden light. It represents the ultimate harmony of body and soul."
	reagent_state = LIQUID
	color = "#ffd788" 
	taste_description = "eternal youth and fresh honey"
	scent_description = "morning dew"
	metabolization_rate = REAGENTS_METABOLISM * 0.7

/datum/reagent/advanced/elixir_of_life/on_mob_life(mob/living/carbon/M)
	if(!istype(M)) return ..()

	if(volume >= 60)
		M.reagents.remove_reagent(type, 2)

	if(!HAS_TRAIT(M, TRAIT_INFINITE_STAMINA))
		M.energy_add(120)

	if(volume > 0.99)
		M.stamina_add(-50)

	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume + 50, BLOOD_VOLUME_NORMAL)

	M.heal_wounds(15) 

	if(volume > 0.99)
		M.adjustBruteLoss(-6  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-6  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-5, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-6  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -2.5 * REAGENTS_EFFECT_MULTIPLIER)

	..()
	return 1

/datum/reagent/advanced/lycanthropy
	name = "Moon-Cursed Blood"
	description = "A thick, silver-tinted liquid that pulses with an inner ferocity. Coarse, dark hairs float within the solution, dissolving and reforming constantly."
	reagent_state = LIQUID
	color = "#c0c0c0"
	taste_description = "raw meat and cold iron"
	scent_description = "a wild beast in the rain"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/advanced/lycanthropy/on_mob_life(mob/living/carbon/human/M)
	if(!istype(M) || M.stat == DEAD) return ..()

	var/datum/antagonist/werewolf/W = M.werewolf_infect_attempt()
	
	if(W)
		to_chat(M, span_userdanger("Вы чувствуете, как дикая ярость вскипает в вашей крови!"))
		holder.del_reagent(type)
	else
		if(prob(5))
			to_chat(M, span_warning("Ваша кровь отвергает серебристую примесь..."))
	
	..()
	return 1

/datum/reagent/advanced/night_vision
	name = "Night-Owl Fluid"
	description = "A toxic-green phosphorescent fluid. It pulses rhythmically, as if mimicking the beat of a distant heart."
	reagent_state = LIQUID
	color = "#00ff44"
	taste_description = "burning mint"
	metabolization_rate = REAGENTS_METABOLISM * 0.01

/datum/reagent/advanced/night_vision/on_mob_life(mob/living/carbon/human/M)
	if(!istype(M)) return ..()

	var/obj/item/organ/eyes/E = M.getorganslot(ORGAN_SLOT_EYES)
	if(E)
		E.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
		E.see_in_dark = 15
		E.sight_flags |= SEE_BLACKNESS
	

	M.lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	M.see_in_dark = 15
	M.sight |= (SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_BLACKNESS)

	if(M.client && M.hud_used)
		var/atom/movable/screen/plane_master/lighting_plane = M.hud_used.plane_masters["[LIGHTING_PLANE]"]
		if(lighting_plane)
			lighting_plane.alpha = 0
			
		var/atom/movable/screen/plane_master/weather_plane = M.hud_used.plane_masters["[WEATHER_EFFECT_PLANE]"]
		if(weather_plane)
			weather_plane.alpha = 0

	M.update_sight()
	..()
	return 1

/datum/reagent/advanced/night_vision/on_mob_delete(mob/living/carbon/human/M)
	if(!istype(M)) return ..()

	var/obj/item/organ/eyes/E = M.getorganslot(ORGAN_SLOT_EYES)
	if(E)
		E.lighting_alpha = initial(E.lighting_alpha)
		E.see_in_dark = initial(E.see_in_dark)
		E.sight_flags &= ~SEE_BLACKNESS
	
	M.lighting_alpha = initial(M.lighting_alpha)
	M.see_in_dark = initial(M.see_in_dark)
	M.sight &= ~(SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_BLACKNESS)

	if(M.client && M.hud_used)
		var/atom/movable/screen/plane_master/lighting_plane = M.hud_used.plane_masters["[LIGHTING_PLANE]"]
		if(lighting_plane)
			lighting_plane.alpha = 255
			
		var/atom/movable/screen/plane_master/weather_plane = M.hud_used.plane_masters["[WEATHER_EFFECT_PLANE]"]
		if(weather_plane)
			weather_plane.alpha = 255

	M.update_sight()
	..()


/datum/reagent/advanced/vampirism
	name = "Essence of the Night"
	reagent_state = LIQUID
	color = "#310000"
	description = "An incredibly thick, dark crimson liquid. It represents the ultimate curse of immortality."
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/advanced/vampirism/on_mob_life(mob/living/carbon/human/M)
	if(!istype(M) || !M.mind || M.stat == DEAD)
		return ..()

	if(M.mind.has_antag_datum(/datum/antagonist/vampire) || M.mind.has_antag_datum(/datum/antagonist/werewolf))
		holder.del_reagent(type)
		return ..()

	if(!length(GLOB.vampire_clans))
		for(var/clan_type in subtypesof(/datum/clan))
			var/datum/clan/clan_obj = new clan_type
			GLOB.vampire_clans[clan_type] = clan_obj
		sortList(GLOB.vampire_clans)

	var/datum/clan/target_clan = GLOB.vampire_clans[/datum/clan]
	if(!target_clan)
		target_clan = GLOB.vampire_clans[GLOB.vampire_clans[1]]

	var/datum/antagonist/vampire/ancillae/new_vamp = new /datum/antagonist/vampire/ancillae(
		incoming_clan = target_clan,
		forced_clan = TRUE,
		generation = GENERATION_ANCILLAE
	)

	if(M.mind.add_antag_datum(new_vamp))
		to_chat(M, span_userdanger("Вы чувствуете, как ваше сердце делает последний, мучительный удар и останавливается..."))
		M.visible_message(span_danger("Кожа [M] становится мертвенно-бледной!"))
		M.playsound_local(get_turf(M), 'sound/music/vampintro.ogg', 80, FALSE)
		
		ADD_TRAIT(M, TRAIT_DNR, "vampire_potion")

		holder.del_reagent(type)
	else
		qdel(new_vamp)
		holder.remove_reagent(type, 1)

	..()
	return 1

/datum/reagent/advanced/titan_strength
	name = "Destroyer's Brew"
	description = "A viscous, dark orange liquid that smells of wet iron and adrenaline. Your muscles ripple and harden just by holding the container."
	reagent_state = LIQUID
	color = "#d35400"
	metabolization_rate = REAGENTS_METABOLISM * 0.3

/datum/reagent/advanced/titan_strength/on_mob_add(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.apply_status_effect(/datum/status_effect/titan_frenzy)

/datum/reagent/advanced/titan_strength/on_mob_delete(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.remove_status_effect(/datum/status_effect/titan_frenzy)

/datum/status_effect/titan_frenzy
	id = "titan_frenzy"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/strengthpot

/datum/status_effect/titan_frenzy/on_apply()
	RegisterSignal(owner, COMSIG_MOB_KICK_ATTACK, PROC_REF(handle_titan_kick))
	RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(handle_titan_punch))
	RegisterSignal(owner, COMSIG_MOB_TWIST_LIMB, PROC_REF(handle_titan_rip))
	
	ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, "titan_frenzy")
	ADD_TRAIT(owner, TRAIT_STRONGKICK, "titan_frenzy")
	owner.STASTR += 10
	owner.update_body()
	return ..()

/datum/status_effect/titan_frenzy/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_KICK_ATTACK, COMSIG_MOB_ATTACK_HAND, COMSIG_MOB_TWIST_LIMB))
	REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, "titan_frenzy")
	REMOVE_TRAIT(owner, TRAIT_STRONGKICK, "titan_frenzy")
	owner.STASTR -= 10
	owner.update_body()
	return ..()

/datum/status_effect/titan_frenzy/proc/handle_titan_rip(mob/living/carbon/human/source_obj, mob/living/carbon/human/user, obj/item/grabbing/G, mob/living/carbon/target)
	SIGNAL_HANDLER
	
	if(user.STASTR < 15 || !G || !target) return

	spawn(0)
		var/obj/item/bodypart/limb = G.limb_grabbed
		if(!limb) return

		user.visible_message(span_userdanger("[user] сжимает свои руки на [target] и начинает отрывать [limb.name]!"))
		
		var/rip_time = (limb.body_zone == BODY_ZONE_HEAD) ? 60 : 40
		
		if(do_after(user, rip_time, target = target))
			if(!G || !target || G.limb_grabbed != limb) return

			var/result = limb.dismember(BRUTE, BCLASS_TWIST, user, G.sublimb_grabbed, 0, TRUE, TRUE)
			
			if(result)
				if(limb.body_zone == BODY_ZONE_HEAD)
					ADD_TRAIT(target, TRAIT_DNR, "ripped_by_titan")
				user.stamina_add(50)
				if(G) qdel(G)

	return COMPONENT_CANCEL_TWIST

/datum/status_effect/titan_frenzy/proc/handle_titan_kick(mob/living/carbon/human/source_obj, mob/living/target)
	SIGNAL_HANDLER
	if(!source_obj || !target || source_obj == target) return
	
	spawn(0)
		var/dir_to_throw = get_dir(source_obj, target)
		target.throw_at(get_edge_target_turf(target, dir_to_throw), 7, 2, source_obj)
		playsound(target, 'sound/combat/hits/blunt/genblunt (2).ogg', 100, TRUE)

/datum/status_effect/titan_frenzy/proc/handle_titan_punch(mob/living/carbon/human/source_obj, mob/living/carbon/human/attacker, mob/living/carbon/human/target, attacker_style)
	SIGNAL_HANDLER
	if(!source_obj || !target || source_obj == target) return
	
	if(istype(source_obj.used_intent, /datum/intent/unarmed/punch))
		spawn(0)
			if(!source_obj || !target) return
			var/dir_to_throw = get_dir(source_obj, target)
			target.visible_message(span_userdanger("[source_obj.name] отправляет в полет [target.name] ударом!"))
			target.throw_at(get_edge_target_turf(target, dir_to_throw), 4, 1, source_obj)
			target.Knockdown(20)
			playsound(target.loc, 'sound/combat/hits/blunt/genblunt (2).ogg', 100, TRUE)

/datum/reagent/advanced/mist_form
	name = "Vapor of the Void"
	description = "A swirling, semi-transparent liquid that feels like it's not even there. Holding it gives a strange sensation of weightlessness."
	reagent_state = LIQUID
	color = "#dcdcdc"
	alpha = 150
	metabolization_rate = REAGENTS_METABOLISM * 0.8
	taste_description = "butter"

/datum/reagent/advanced/mist_form/on_mob_add(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.apply_status_effect(/datum/status_effect/buff/mist_form)
	to_chat(M, span_purple("Ваше тело теряет плотность и превращается в холодный, зыбкий туман..."))
	playsound(M.loc, 'sound/effects/hood_ignite.ogg', 50, TRUE)

/datum/reagent/advanced/mist_form/on_mob_delete(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.remove_status_effect(/datum/status_effect/buff/mist_form)
	to_chat(M, span_notice("Ваша плоть снова обретает тяжесть и форму."))

/datum/status_effect/mirror_reflection
	id = "mirror_reflection"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/mirror_reflection

/datum/status_effect/mirror_reflection/on_apply()

	RegisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(handle_mirror_item))
	RegisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(handle_mirror_hand))
	RegisterSignal(owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(handle_mirror_bullet))

	to_chat(owner, span_purple("Ваше тело становится зеркальной гладью!"))
	return ..()

/datum/status_effect/mirror_reflection/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_BEING_ATTACKED, COMSIG_MOB_ATTACKED_BY_HAND, COMSIG_ATOM_BULLET_ACT))
	return ..()

/datum/status_effect/mirror_reflection/proc/handle_mirror_item(datum/source, mob/living/victim, mob/living/attacker, obj/item/I)
	SIGNAL_HANDLER
	if(!attacker || attacker == victim) return

	if(attacker.has_status_effect(/datum/status_effect/mirror_reflection))
		return

	spawn(0)
		if(attacker && I && !QDELETED(attacker))
			attacker.visible_message(span_userdanger("Удар [attacker] отражается от зеркального тела [victim] и бьет по самому [attacker]!"))

			I.attack(attacker, attacker) 

			victim.flash_fullscreen("whiteflash", 1)
			var/datum/effect_system/spark_spread/S = new()
			S.set_up(2, 1, victim.loc)
			S.start()

	return COMPONENT_ITEM_NO_ATTACK


/datum/status_effect/mirror_reflection/proc/handle_mirror_hand(datum/source, mob/living/attacker, mob/living/victim, style)
	SIGNAL_HANDLER
	if(!attacker || attacker == victim) return
	if(attacker.has_status_effect(/datum/status_effect/mirror_reflection)) return

	spawn(0)
		if(attacker && !QDELETED(attacker))
			attacker.visible_message(span_userdanger("[attacker] бьет по зеркалу [victim] и ломает собственные руки!"))
			attacker.apply_damage(attacker.get_punch_dmg(), BRUTE, attacker.zone_selected, forced = TRUE)

	return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/mirror_reflection/proc/handle_mirror_bullet(datum/source, obj/projectile/P)
	SIGNAL_HANDLER
	if(!P || P.firer == owner) return

	spawn(0)
		if(P && owner)
			owner.visible_message(span_userdanger("Снаряд [P.name] отскакивает от зеркальной кожи [owner]!"))
			P.reflect_back(owner)

	return COMPONENT_ATOM_BLOCK_BULLET

/atom/movable/screen/alert/status_effect/buff/alch/mirror_reflection
	name = "Зеркальное Отражение"
	desc = "Вы абсолютно неуязвимы к физическим атакам. Любой удар перенаправляется на врага."
	icon_state = "buff"


/datum/reagent/advanced/mirror_potion
	name = "Liquid Reflection"
	description = "A shimmering, silver liquid that perfectly reflects everything around it."
	reagent_state = LIQUID
	color = "#E5E4E2"
	metabolization_rate = REAGENTS_METABOLISM * 0.8
	taste_description = "cream"

/datum/reagent/advanced/mirror_potion/on_mob_add(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.apply_status_effect(/datum/status_effect/mirror_reflection)

/datum/reagent/advanced/mirror_potion/on_mob_delete(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.remove_status_effect(/datum/status_effect/mirror_reflection)

/datum/reagent/advanced/levitation
	name = "Aether Essence"
	description = "A cloud-like, swirling gas trapped in liquid form. It is so light that the bottle almost floats out of your hand."
	reagent_state = LIQUID
	color = "#add8e6"
	metabolization_rate = REAGENTS_METABOLISM * 0.3
	taste_description = "cloud"

/datum/reagent/advanced/levitation/on_mob_add(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.apply_status_effect(/datum/status_effect/levitation)

/datum/reagent/advanced/levitation/on_mob_delete(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.remove_status_effect(/datum/status_effect/levitation)

/datum/status_effect/levitation
	id = "levitation"
	alert_type = /atom/movable/screen/alert/status_effect

/datum/status_effect/levitation/on_apply()
	if(!ishuman(owner)) return FALSE
	var/mob/living/carbon/human/H = owner
	
	H.movement_type |= FLYING
	H.verbs += list(/mob/living/carbon/human/proc/levitation_up, /mob/living/carbon/human/proc/levitation_down)
	
	to_chat(H, span_purple("Ваше тело теряет плотность, вы плавно отрываетесь от земли..."))
	
	addtimer(CALLBACK(src, PROC_REF(start_float_animation), H), 3)
	
	return ..()

/datum/status_effect/levitation/on_remove()
	if(!ishuman(owner)) return
	var/mob/living/carbon/human/H = owner
	
	H.movement_type &= ~FLYING
	H.verbs -= list(/mob/living/carbon/human/proc/levitation_up, /mob/living/carbon/human/proc/levitation_down)

	animate(H)

	animate(H, pixel_z = 0, pixel_x = 0, time = 5, easing = EASE_OUT)

	addtimer(CALLBACK(H, /mob/living/proc/set_mob_offsets, "levitation", 0, 0), 6)
	
	to_chat(H, span_notice("Гравитация вновь обретает власть над вашим телом."))
	
	var/turf/T = get_turf(H)
	if(istype(T, /turf/open/transparent/openspace))
		to_chat(H, span_userdanger("Под ногами лишь пустота!"))
	..()

/datum/status_effect/levitation/proc/start_float_animation(mob/living/M)
	if(!M || QDELETED(M)) return

	animate(M) 

	animate(M, pixel_z = 6, pixel_x = 2, time = 15, loop = -1, easing = EASE_IN | EASE_OUT)
	animate(pixel_z = 8, pixel_x = 0, time = 15, easing = EASE_IN | EASE_OUT)
	animate(pixel_z = 4, pixel_x = -2, time = 15, easing = EASE_IN | EASE_OUT)
	animate(pixel_z = 6, pixel_x = 0, time = 15, easing = EASE_IN | EASE_OUT)

/mob/living/carbon/human/proc/levitation_up()
	set category = "Alchemy"
	set name = "Левитация: Вверх"
	set desc = "Использовать магическую легкость, чтобы взлететь выше."

	if(src.stat != CONSCIOUS) return
	if(src.pulledby)
		to_chat(src, span_warning("Вас кто-то держит! Вы не можете взлететь."))
		return

	src.visible_message(span_notice("[src] плавно взмывает вверх!"), span_notice("Я концентрируюсь на своей легкости и взлетаю..."))

	if(do_after(src, 20, target = src))
		if(!src.pulledby && (src.movement_type & FLYING))
			if(src.zMove(UP, TRUE))
				to_chat(src, span_notice("Я взлетел на уровень выше."))
			else
				to_chat(src, span_warning("Там нет свободного пространства!"))

/mob/living/carbon/human/proc/levitation_down()
	set category = "Alchemy"
	set name = "Левитация: Вниз"
	set desc = "Использовать магическую легкость, чтобы плавно опуститься ниже."

	if(src.stat != CONSCIOUS) return
	if(src.pulledby)
		to_chat(src, span_warning("Вас кто-то держит! Вы не можете спуститься."))
		return

	src.visible_message(span_notice("[src] плавно опускается вниз!"), span_notice("Я позволяю гравитации слегка потянуть меня вниз..."))
	
	if(do_after(src, 20, target = src))
		if(!src.pulledby && (src.movement_type & FLYING))
			if(src.zMove(DOWN, TRUE))
				to_chat(src, span_notice("Я спустился на уровень ниже."))
			else
				to_chat(src, span_warning("Я не могу спуститься туда!"))

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/stoneskin
	name = "каменная кожа"
	desc = "Алхимически закаленная плоть, твердая как гранит."
	icon_state = null
	item_state = null
	slot_flags = null
	
	body_parts_covered = COVERAGE_FULL_BODY_ACTUAL
	body_parts_inherent = COVERAGE_FULL_BODY_ACTUAL
	
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_STONESKIN
	max_integrity = 1000
	blocksound = PLATEHIT
	blade_dulling = DULLING_BASHCHOP
	
	item_flags = DROPDEL
	sewrepair = FALSE
	resistance_flags = FIRE_PROOF | ACID_PROOF

	auto_repair_mode = TRUE
	auto_repair_mode_base = 50
	auto_repair_mode_time = 5 SECONDS

	interrupt_damount = 15 

	repairmsg_begin = "Каменная крошка начинает притягиваться к трещинам на вашей коже..."
	repairmsg_continue = "Ваш гранитный панцирь медленно зарастает..."
	repairmsg_stop = "Тяжелый удар откалывает куски камня, прерывая восстановление!"
	repairmsg_end = "Ваша каменная кожа вновь монолитна."

/datum/status_effect/stoneskin_potion
	id = "stoneskin_potion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/stoneskin
	var/obj/item/clothing/suit/old_skin

/datum/status_effect/stoneskin_potion/on_apply()
	var/mob/living/carbon/human/H = owner
	if(!istype(H)) return FALSE
	
	if(H.skin_armor)
		old_skin = H.skin_armor

	H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/stoneskin(H)
	H.color = "#A9A9A9"
	to_chat(H, span_boldnotice("Ваша плоть тяжелеет, превращаясь в живой гранит!"))
	
	H.update_inv_armor()
	return ..()

/datum/status_effect/stoneskin_potion/on_remove()
	var/mob/living/carbon/human/H = owner
	if(!istype(H)) return

	if(H.skin_armor && istype(H.skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/stoneskin))
		qdel(H.skin_armor)
		H.skin_armor = null

	if(old_skin)
		H.skin_armor = old_skin
		
	H.color = initial(H.color)
	
	to_chat(H, span_warning("Ваша каменная броня трескается и осыпается мелкой пылью."))
	
	H.update_inv_armor()
	..()

/atom/movable/screen/alert/status_effect/buff/alch/stoneskin
	name = "Каменная Кожа"
	desc = "Вы покрыты толстым слоем алхимического камня."
	icon_state = "buff"

/datum/reagent/advanced/stoneskin
	name = "Elixir of Ironskin"
	description = "A heavy, grey suspension that looks like liquid concrete."
	reagent_state = LIQUID
	color = "#808080"
	metabolization_rate = REAGENTS_METABOLISM * 0.1
	taste_description = "dirt"

/datum/reagent/advanced/stoneskin/on_mob_add(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.apply_status_effect(/datum/status_effect/stoneskin_potion)

/datum/reagent/advanced/stoneskin/on_mob_delete(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.remove_status_effect(/datum/status_effect/stoneskin_potion)

/datum/reagent/advanced/bloodhound
	name = "Bloodhound's Brew"
	description = "A murky, brownish liquid that smells overpowering. Just a whiff of it clears your sinuses completely."
	reagent_state = LIQUID
	color = "#8B4513"
	metabolization_rate = REAGENTS_METABOLISM * 0.1
	taste_description = "iron"

/datum/reagent/advanced/bloodhound/on_mob_add(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.apply_status_effect(/datum/status_effect/bloodhound_scent)

/datum/reagent/advanced/bloodhound/on_mob_delete(mob/living/carbon/human/M)
	if(!istype(M)) return
	M.remove_status_effect(/datum/status_effect/bloodhound_scent)

/datum/action/bloodhound_scent
	name = "Взять след"
	desc = "Позволяет вам почувствовать запах знакомого человека и определить его местоположение."
	button_icon_state = "wolf_head"
	var/mob/living/carbon/human/tracked_target = null
	var/cooldown_time = 0

/datum/action/bloodhound_scent/Trigger(trigger_flags)
	if(!isliving(owner)) return
	var/mob/living/carbon/human/user = owner

	if(user.stat != CONSCIOUS) return
	if(world.time < cooldown_time)
		to_chat(user, span_warning("Вы слишком часто принюхиваетесь. Дайте носу отдохнуть."))
		return

	if(!user.mind || !length(user.mind.known_people))
		to_chat(user, span_warning("Вы не знаете ничьих запахов, чтобы взять след."))
		return


	var/list/people_names = list()
	for(var/person_name in user.mind.known_people)
		people_names += person_name


	var/input = tgui_input_list(user, "Чей запах вы ищете?", "Идеальный Нюх", people_names)
	if(!input) return


	var/mob/living/carbon/human/target = null
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.real_name == input)
			target = HL
			break

	if(!target)
		to_chat(user, span_warning("Этот запах давно развеялся. Вы не чувствуете его в этом мире."))
		return

	if(HAS_TRAIT(target, TRAIT_ANTISCRYING))
		to_chat(user, span_warning("Запах [input] скрыт какой-то магией."))
		return

	user.visible_message(span_notice("[user] глубоко втягивает носом воздух..."), \
						span_notice("Вы закрываете глаза и концентрируетесь на запахе [input]..."))
	
	cooldown_time = world.time + 100

	if(!do_after(user, 30, target = user))
		to_chat(user, span_warning("Вы сбились со следа!"))
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(target)
	
	if(!target_turf || !user_turf) return

	var/z_hint = ""
	if(target_turf.z != user_turf.z)
		var/z_diff = abs(target_turf.z - user_turf.z)
		z_hint = (target_turf.z > user_turf.z) ? " [z_diff] уровней выше." : " [z_diff] уровней ниже."
	else
		z_hint = " на вашем уровне."

	var/dx = target_turf.x - user_turf.x
	var/dy = target_turf.y - user_turf.y
	var/distance = sqrt(dx*dx + dy*dy)

	if(distance <= 7 && target_turf.z == user_turf.z)
		to_chat(user, span_boldnotice("Запах очень сильный! [target.real_name] находится прямо здесь, рядом с вами!"))
		return

	var/dir_text = get_precise_direction_between(user_turf, target_turf)
	if(!dir_text) dir_text = "в неизвестном направлении"

	var/dist_text = ""
	switch(distance)
		if(0 to 14) dist_text = "Совсем близко"
		if(15 to 40) dist_text = "Недалеко"
		if(41 to 100) dist_text = "Довольно далеко"
		if(101 to INFINITY) dist_text = "Очень далеко"

	to_chat(user, span_boldnotice("Ваш нос ловит знакомый след... [target.real_name] находится [dir_text]. Это [dist_text], [z_hint]"))

/datum/status_effect/bloodhound_scent
	id = "bloodhound_scent"
	alert_type = /atom/movable/screen/alert/status_effect/buff/alch/bloodhound
	var/datum/action/bloodhound_scent/scent_action

/datum/status_effect/bloodhound_scent/on_apply()
	if(!isliving(owner)) return FALSE

	scent_action = new()
	scent_action.Grant(owner)
	
	to_chat(owner, span_purple("Ваши чувства обостряются. Вы чувствуете запахи каждого существа вокруг..."))
	return ..()

/datum/status_effect/bloodhound_scent/on_remove()
	if(scent_action)
		scent_action.Remove(owner)
		qdel(scent_action)
	
	to_chat(owner, span_notice("Ваш нюх возвращается в норму. Мир больше не пахнет так резко."))
	return ..()

/atom/movable/screen/alert/status_effect/buff/alch/bloodhound
	name = "Идеальный Нюх"
	desc = "Вы можете выслеживать знакомых людей по их запаху."
	icon_state = "coke"
