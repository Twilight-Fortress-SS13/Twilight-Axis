#define CHAINWHOOSH         list('modular_twilight_axis/sound/combat/chainwoosh.ogg','modular_twilight_axis/sound/combat/chainhit.ogg')
//Интенты

/datum/intent/whip/chain_lash
    name = "chain lash"
    desc = "Lash the heavy chain against a target from afar. Deals blunt trauma and deep gouges."
    blade_class = BCLASS_BLUNT
    attack_verb = list("lashes", "whips", "strikes")
    hitsound = 'sound/combat/hits/blunt/flailhit.ogg'
    chargetime = 0
    recovery = 7
    penfactor = PEN_LIGHT
    reach = 3
    icon_state = "inlash"
    item_d_type = "blunt"
    effective_range = 1
    effective_range_type = EFF_RANGE_ABOVE
    intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/whip/chain_dart
    name = "dart thrust"
    desc = "Propel the weighted metal dart forward with snap force to pierce through some armor."
    blade_class = BCLASS_STAB
    attack_verb = list("pierces", "thrusts", "impales")
    hitsound = 'sound/combat/hits/blunt/flailhit.ogg'
    chargetime = 0
    recovery = 9
    damfactor = 1.25
    penfactor = PEN_MEDIUM
    reach = 2
    icon_state = "instab"
    item_d_type = "stab"
    effective_range = 2
    effective_range_type = EFF_RANGE_EXACT

/datum/intent/flail/smash/witcher
    name = "swinging slash"
    desc = "Wind up the chain to deliver a brutal horizontal sweep, tearing open flesh and punching through heavy armor on impact."
    blade_class = BCLASS_CUT
    attack_verb = list("lashes", "whips", "strikes")
    hitsound = 'sound/combat/hits/blunt/flailhit.ogg'
    chargetime = 1 SECONDS
    clickcd = CLICK_CD_HEAVY
    chargedrain = 1.3
    damfactor = 1.45
    penfactor = PEN_MEDIUM
    icon_state = "incut"
    item_d_type = "slash"

// --- Сам предмет ---

/obj/item/rogueweapon/whip/witcher_chain
    name = "battle chain"
    desc = "A tempered steel chain balanced with a faceted piercing dart. Deceptively fast, it can ensnare distant foes and drag them into lethal range."
    icon_state = "witcher_chain"
    icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
    force = 25
    sharpness = IS_SHARP
    wlength = WLENGTH_GREAT
    w_class = WEIGHT_CLASS_SMALL
    slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT
    associated_skill = /datum/skill/combat/whipsflails
    sewrepair = FALSE
    parrysound = list('sound/combat/parry/parrygen.ogg')
    swingsound = CHAINWHOOSH
    max_blade_int = 300
    max_integrity = 300
    throwforce = 12
    wdefense = 6
    minstr = 8
    anvilrepair = /datum/skill/craft/weaponsmithing
    smeltresult = /obj/item/ingot/steel
    grid_width = 32
    grid_height = 64
    var/is_being_thrown_by_special = FALSE
    var/transform_type = /obj/item/clothing/wrists/roguetown/bracers/witcher
    possible_item_intents = list(
        /datum/intent/whip/chain_lash,
        /datum/intent/whip/chain_dart,
        /datum/intent/whip/crack/blunt,
        /datum/intent/flail/smash/witcher
    )
    special = /datum/special_intent/witcher_chain_hook

/obj/item/rogueweapon/whip/witcher_chain/silver
    name = "silver battle chain"
    desc = "A tempered silver chain balanced with a faceted piercing dart. Deceptively fast, it can ensnare distant foes and drag them into lethal range."
    icon_state = "silver_witcher_chain"
    icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
    force = 24
    sharpness = IS_SHARP
    wlength = WLENGTH_GREAT
    w_class = WEIGHT_CLASS_NORMAL
    slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT
    associated_skill = /datum/skill/combat/whipsflails
    sewrepair = FALSE
    parrysound = list('sound/combat/parry/parrygen.ogg')
    swingsound = CHAINWHOOSH
    max_blade_int = 250
    max_integrity = 250
    throwforce = 12
    wdefense = 6
    is_silver = TRUE
    minstr = 8
    anvilrepair = /datum/skill/craft/weaponsmithing
    smeltresult = /obj/item/ingot/silver
    grid_width = 32
    grid_height = 64
    transform_type = /obj/item/clothing/wrists/roguetown/bracers/witcher/silver

/obj/item/rogueweapon/whip/witcher_chain/silver/ComponentInitialize()
    AddComponent(\
        /datum/component/silverbless,\
        pre_blessed = BLESSING_NONE,\
        silver_type = SILVER_TENNITE,\
        added_force = 0,\
        added_blade_int = 0,\
        added_int = 50,\
        added_def = 0,\
    )

/obj/item/rogueweapon/whip/witcher_chain/bronze
    name = "bronze battle chain"
    desc = "A crude bronze chain balanced with a piercing dart. Softer than steel, it holds an edge poorly and bends easily under strain."
    icon_state = "bronze_witcher_chain"
    icon = 'modular_twilight_axis/icons/roguetown/weapons/32.dmi'
    force = 24
    sharpness = IS_SHARP
    wlength = WLENGTH_GREAT
    w_class = WEIGHT_CLASS_NORMAL
    slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BELT
    associated_skill = /datum/skill/combat/whipsflails
    sewrepair = FALSE
    parrysound = list('sound/combat/parry/parrygen.ogg')
    swingsound = CHAINWHOOSH
    max_blade_int = 200
    max_integrity = 200
    throwforce = 10
    wdefense = 5
    minstr = 8
    anvilrepair = /datum/skill/craft/weaponsmithing
    smeltresult = /obj/item/ingot/bronze
    grid_width = 32
    grid_height = 64
    transform_type = /obj/item/clothing/wrists/roguetown/bracers/witcher/bronze

/obj/item/rogueweapon/whip/witcher_chain/attack(mob/living/target, mob/living/user)
    if(is_being_thrown_by_special)
        return FALSE
    return ..()

/obj/item/rogueweapon/whip/witcher_chain/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
    if(is_being_thrown_by_special)
        return FALSE
    return ..()

/obj/item/rogueweapon/whip/witcher_chain/attack_self(mob/user)
    if(is_being_thrown_by_special)
        return FALSE
    return ..()

/obj/item/rogueweapon/whip/witcher_chain/getonmobprop(tag)
    . = ..()
    if(tag)
        switch(tag)
            if("gen")
                return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -2,"wx" = -7,"wy" = -3,"ex" = 3,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 22,"sturn" = -23,"wturn" = -23,"eturn" = 29,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
            if("onbelt")
                return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/clothing/wrists/roguetown/bracers/witcher
    name = "steel battle chain bracers"
    desc = "A pair of steel chain bracers, protecting the arms from blows-most-foul."
    body_parts_covered = ARMS
    icon = 'modular_twilight_axis/icons/roguetown/clothing/wrists.dmi'
    mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/wrists.dmi'
    sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/wrists.dmi'
    icon_state = "witcherchainarm"
    item_state = "witcherchainarm"
    armor = ARMOR_PLATE
    anvilrepair = /datum/skill/craft/weaponsmithing
    smeltresult = /obj/item/ingot/steel
    var/stored_blade_int
    var/transform_type = /obj/item/rogueweapon/whip/witcher_chain

/obj/item/clothing/wrists/roguetown/bracers/witcher/silver
    name = "silver battle chain bracers"
    desc = "A pair of silver chain bracers, protecting the arms from blows-most-foul."
    body_parts_covered = ARMS
    icon = 'modular_twilight_axis/icons/roguetown/clothing/wrists.dmi'
    mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/wrists.dmi'
    sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/wrists.dmi'
    icon_state = "silverwitcherchainarm"
    item_state = "silverwitcherchainarm"
    armor = ARMOR_PLATE
    anvilrepair = /datum/skill/craft/weaponsmithing
    smeltresult = /obj/item/ingot/silver
    is_silver = TRUE
    transform_type = /obj/item/rogueweapon/whip/witcher_chain/silver

/obj/item/clothing/wrists/roguetown/bracers/witcher/bronze
    name = "bronze battle chain bracers"
    desc = "A pair of bronze chain bracers, protecting the arms from blows-most-foul. Softer than steel, they wear down faster."
    body_parts_covered = ARMS
    icon = 'modular_twilight_axis/icons/roguetown/clothing/wrists.dmi'
    mob_overlay_icon = 'modular_twilight_axis/icons/roguetown/clothing/onmob/wrists.dmi'
    sleeved = 'modular_twilight_axis/icons/roguetown/clothing/onmob/wrists.dmi'
    icon_state = "bronzewitcherchainarm"
    item_state = "bronzewitcherchainarm"
    armor = ARMOR_BRONZE
    anvilrepair = /datum/skill/craft/weaponsmithing
    smeltresult = /obj/item/ingot/bronze
    max_integrity = 200
    transform_type = /obj/item/rogueweapon/whip/witcher_chain/bronze

/obj/item/clothing/wrists/roguetown/bracers/witcher/ComponentInitialize()
    AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)

/obj/item/clothing/wrists/roguetown/bracers/witcher/attack_right(mob/user)
    if(do_after(user,3 SECONDS, TRUE, src, allow_movement = TRUE))
        var/create_type = transform_type || /obj/item/rogueweapon/whip/witcher_chain
        var/obj/item/rogueweapon/whip/witcher_chain/W = new create_type(get_turf(src))
        var/integrity_fraction = max_integrity ? (obj_integrity / max_integrity) : 1
        W.obj_integrity = round(W.max_integrity * integrity_fraction)
        W.blade_int = stored_blade_int
        W.update_icon()
        var/was_held = user.is_holding(src)
        user.dropItemToGround(src)
        qdel(src)
        if(was_held)
            user.put_in_hands(W)
        playsound(user, 'sound/misc/chains.ogg', 20, TRUE)
    . = ..()

/obj/item/rogueweapon/whip/witcher_chain/attack_right(mob/user)
    if(do_after(user,3 SECONDS, TRUE, src, allow_movement = TRUE))
        var/create_type = transform_type || /obj/item/clothing/wrists/roguetown/bracers/witcher
        var/obj/item/clothing/wrists/roguetown/bracers/witcher/B = new create_type(get_turf(src))
        var/integrity_fraction = max_integrity ? (obj_integrity / max_integrity) : 1
        B.obj_integrity = round(B.max_integrity * integrity_fraction)
        B.stored_blade_int = blade_int
        B.update_icon()
        var/was_held = user.is_holding(src)
        user.dropItemToGround(src)
        qdel(src)
        if(was_held)
            user.put_in_hands(B)
        playsound(user, 'sound/misc/chains.ogg', 20, TRUE)
    . = ..()

/datum/anvil_recipe/weapons/steel/witcher_chain
	name = "Steel Battle Chain"
	req_bar = /obj/item/ingot/steel
	created_item = /obj/item/rogueweapon/whip/witcher_chain
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/silver/witcher_chain
	name = "Silver Battle Chain"
	req_bar = /obj/item/ingot/silver
	created_item = /obj/item/rogueweapon/whip/witcher_chain/silver
	display_category = ITEM_CAT_WEAPONS_FLAILS

/datum/anvil_recipe/weapons/bronze/witcher_chain
	name = "Bronze Battle Chain"
	req_bar = /obj/item/ingot/bronze
	created_item = /obj/item/rogueweapon/whip/witcher_chain/bronze
	display_category = ITEM_CAT_WEAPONS_FLAILS
//SPECIAL

// --- Визуальные эффекты полета и натяжения ---

/obj/effect/temp_visual/chain_trail
    icon = 'icons/effects/effects.dmi'
    icon_state = "srike"
    layer = BELOW_MOB_LAYER
    duration = 0.25 SECONDS
    alpha = 230

/obj/effect/temp_visual/chain_impact
    icon = 'icons/effects/effects.dmi'
    icon_state = "srike"
    layer = ABOVE_MOB_LAYER
    duration = 0.4 SECONDS
    alpha = 255

/obj/effect/temp_visual/chain_finish_strike
    icon = 'icons/effects/effects.dmi'
    icon_state = "cut"
    layer = ABOVE_MOB_LAYER
    duration = 0.4 SECONDS
    alpha = 255

/obj/effect/witcher_chain_flight
    name = "flying dart"
    anchored = TRUE
    density = FALSE
    mouse_opacity = FALSE
    layer = ABOVE_MOB_LAYER
    pixel_x = -16
    pixel_y = -16

// --- Логика спешиала ---

/datum/special_intent/witcher_chain_hook
    name = "Chain Ensnare"
    desc = "Hurl the weighted dart of the chain toward a target. The tip pierces armor, wraps around the victim, and forcefully drags them into melee range for a finishing blow."
    use_clickloc = TRUE
    respect_adjacency = FALSE
    respect_dir = FALSE
    cooldown = 20 SECONDS
    stamcost = 18
    range = 5

    var/hook_damage = 0
    var/final_damage = 0
    var/flight_delay = 1
    var/reel_delay = 1
    var/max_range = 5
    var/active_cast = FALSE

    var/mob/living/hooked_target
    var/obj/effect/witcher_chain_flight/flight_fx

    var/saved_alpha = 255
    var/saved_invisibility = 0
    var/original_slot = null
    var/turf/throw_target

/datum/special_intent/witcher_chain_hook/_reset()
    active_cast = FALSE
    hooked_target = null
    original_slot = null
    throw_target = null

    if(flight_fx)
        qdel(flight_fx)
        flight_fx = null

    saved_alpha = 255
    saved_invisibility = 0
    hook_damage = 5
    final_damage = 5
    . = ..()

/datum/special_intent/witcher_chain_hook/process_attack()
    SHOULD_CALL_PARENT(FALSE)

    if(!howner || !iparent)
        return

    if(active_cast)
        return

    if(!(howner.mobility_flags & MOBILITY_STAND))
        to_chat(howner, span_warning("You must be on your feet to throw the chain!"))
        return

    if(!click_loc)
        return

    if(!check_range(howner, click_loc))
        return

    if(!_do_after())
        return

    if(!apply_cost(howner))
        return

    var/turf/start_turf = get_turf(howner)
    if(!start_turf)
        return

    _reset()

    throw_target = click_loc
    if(!throw_target)
        return

    var/obj/item/rogueweapon/W = iparent
    var/scalemod = max(((howner.STASTR + howner.STASPD) / 20), 1)

    hook_damage = (W.force_dynamic * scalemod * 0.55)
    final_damage = (W.force_dynamic * scalemod * 1.2)

    _add_log()
    active_cast = TRUE

    howner.setDir(get_dir(start_turf, throw_target))

    spawn_flight_visual()
    hide_weapon()

    playsound(howner, 'modular_twilight_axis/sound/combat/chainwoosh.ogg', 80, TRUE)
    playsound(howner, 'sound/combat/parry/parrygen.ogg', 50, TRUE)

    apply_cooldown(cooldown)
    continue_outbound(start_turf, max_range)

/datum/special_intent/witcher_chain_hook/proc/hide_weapon()
    var/obj/item/rogueweapon/whip/witcher_chain/W = iparent
    if(!W || !flight_fx || !howner)
        return

    saved_alpha = W.alpha
    saved_invisibility = W.invisibility

    if(length(howner.held_items) >= 1 && howner.held_items[1] == W)
        original_slot = 1
    else if(length(howner.held_items) >= 2 && howner.held_items[2] == W)
        original_slot = 2
    else
        original_slot = null
    W.is_being_thrown_by_special = TRUE
    howner.temporarilyRemoveItemFromInventory(W, TRUE)
    W.forceMove(flight_fx)
    W.alpha = 0
    W.invisibility = INVISIBILITY_ABSTRACT
    howner.regenerate_icons()

/datum/special_intent/witcher_chain_hook/proc/restore_weapon()
    var/obj/item/rogueweapon/whip/witcher_chain/W = iparent
    if(!W)
        return

    W.alpha = saved_alpha
    W.invisibility = saved_invisibility
    W.is_being_thrown_by_special = FALSE
    if(howner && !QDELETED(howner))
        W.forceMove(get_turf(howner))
        if(!howner.put_in_hands(W))
            W.forceMove(get_turf(howner))
    else if(flight_fx && !QDELETED(flight_fx))
        W.forceMove(get_turf(flight_fx))

    if(howner)
        howner.regenerate_icons()

/datum/special_intent/witcher_chain_hook/proc/spawn_flight_visual()
    var/obj/item/rogueweapon/W = iparent
    var/turf/T = get_turf(howner)
    if(!W || !T)
        return

    flight_fx = new /obj/effect/witcher_chain_flight(T)
    flight_fx.icon = W.icon
    flight_fx.icon_state = W.icon_state
    flight_fx.dir = throw_target ? get_dir(T, throw_target) : howner.dir

/datum/special_intent/witcher_chain_hook/proc/continue_outbound(turf/current_turf, remaining_range)
    if(!active_cast || !howner || QDELETED(howner))
        cleanup_cast()
        return

    if(!current_turf || remaining_range <= 0 || current_turf == throw_target)
        begin_return()
        return

    var/turf/next_turf = get_step_towards(current_turf, throw_target)
    if(!next_turf || next_turf == current_turf)
        begin_return()
        return

    new /obj/effect/temp_visual/chain_trail(next_turf)

    if(flight_fx)
        flight_fx.forceMove(next_turf)
        flight_fx.dir = get_dir(current_turf, next_turf)

    var/mob/living/found_target = null
    for(var/mob/living/L in next_turf)
        if(L == howner || QDELETED(L))
            continue
        found_target = L
        break

    if(found_target)
        hooked_target = found_target
        on_hook_target()
        return

    if(next_turf.density)
        playsound(next_turf, 'sound/combat/parry/parrygen.ogg', 70, TRUE)
        begin_return()
        return

    addtimer(CALLBACK(src, PROC_REF(continue_outbound), next_turf, remaining_range - 1), flight_delay)

/datum/special_intent/witcher_chain_hook/proc/on_hook_target()
    if(!hooked_target || QDELETED(hooked_target))
        begin_return()
        return

    var/turf/target_turf = get_turf(hooked_target)
    if(!target_turf)
        begin_return()
        return

    if(flight_fx)
        flight_fx.forceMove(target_turf)

    new /obj/effect/temp_visual/chain_impact(target_turf)

    message_admins("hook target's path: [hooked_target.type]")
    if(!istype(hooked_target,/mob/living/simple_animal))
        var/armor_block = hooked_target.run_armor_check(BODY_ZONE_CHEST, "stab", blade_dulling = BCLASS_PICK, armor_penetration = PEN_LIGHT, damage = hook_damage, used_weapon = iparent)
        if(!(hooked_target.apply_damage(25, BRUTE, BODY_ZONE_CHEST, armor_block)))
            hooked_target.visible_message(span_warning("The tip bounces off [hooked_target]'s armor, unable to hook!"))
            begin_return()
            return

    hooked_target.visible_message(
        span_warning("[hooked_target] is pierced by the chain's tip and caught by the links!"),
        span_userdanger("The sharp tip of the chain pierces me, the links lash out and wrap around my body!")
    )

    // Урон при контакте наконечника (колющий с хорошим бронепробитием)
    if(hooked_target.mobility_flags & MOBILITY_STAND)
        apply_generic_weapon_damage(hooked_target, hook_damage, "stab", BODY_ZONE_CHEST, bclass = BCLASS_STAB)

    hooked_target.stamina_add(15)
    hooked_target.Immobilize(0.5 SECONDS)

    playsound(target_turf, 'modular_twilight_axis/sound/combat/chainhit.ogg', 90, TRUE)

    continue_reel_target()

/datum/special_intent/witcher_chain_hook/proc/continue_reel_target()
    if(!active_cast || !howner || QDELETED(howner))
        cleanup_cast()
        return

    if(!hooked_target || QDELETED(hooked_target))
        begin_return()
        return

    var/turf/owner_turf = get_turf(howner)
    var/turf/target_turf = get_turf(hooked_target)

    if(!owner_turf || !target_turf || target_turf.z != owner_turf.z)
        begin_return()
        return

    if(get_dist(hooked_target, howner) <= 1)
        finish_reel()
        return

    var/turf/next_turf = get_step_towards(target_turf, owner_turf)
    if(!next_turf || next_turf == target_turf || next_turf.density)
        finish_reel()
        return

    for(var/mob/living/L in next_turf)
        if(L != hooked_target && L != howner && !QDELETED(L))
            finish_reel()
            return

    new /obj/effect/temp_visual/chain_trail(next_turf)

    hooked_target.forceMove(next_turf)
    hooked_target.Immobilize(0.2 SECONDS)

    if(flight_fx)
        flight_fx.forceMove(next_turf)
        flight_fx.dir = get_dir(target_turf, next_turf)

    addtimer(CALLBACK(src, PROC_REF(continue_reel_target)), reel_delay)

/datum/special_intent/witcher_chain_hook/proc/finish_reel()
    if(!active_cast)
        return
    if(!howner || QDELETED(howner))
        cleanup_cast()
        return

    if(hooked_target && !QDELETED(hooked_target) && get_dist(hooked_target, howner) <= 1)
        var/turf/target_turf = get_turf(hooked_target)
        new /obj/effect/temp_visual/chain_finish_strike(target_turf)

        hooked_target.apply_status_effect(/datum/status_effect/debuff/vulnerable, 2 SECONDS)
        hooked_target.OffBalance(3 SECONDS)

        // Завершающий удар наотмашь тяжелой петлей
        apply_generic_weapon_damage(hooked_target, final_damage, "blunt", BODY_ZONE_CHEST, bclass = BCLASS_BLUNT)

        playsound(target_turf, 'sound/combat/hits/blunt/flailhit.ogg', 100, TRUE)
        hooked_target.visible_message(
            span_danger("[howner] forcefully jerks the chain, knocking [hooked_target] off their feet with a crushing blow!"),
            span_userdanger("[howner] jerks the chain toward them, knocking me off my feet!")
        )

    cleanup_cast()

/datum/special_intent/witcher_chain_hook/proc/begin_return()
    if(!active_cast || !flight_fx || !howner || QDELETED(howner))
        cleanup_cast()
        return
    continue_return()

/datum/special_intent/witcher_chain_hook/proc/continue_return()
    if(!active_cast || !howner || QDELETED(howner) || !flight_fx)
        cleanup_cast()
        return

    var/turf/current_turf = get_turf(flight_fx)
    var/turf/owner_turf = get_turf(howner)

    if(!current_turf || !owner_turf || current_turf == owner_turf)
        cleanup_cast()
        return

    var/turf/next_turf = get_step_towards(current_turf, owner_turf)
    if(!next_turf || next_turf == current_turf)
        cleanup_cast()
        return

    new /obj/effect/temp_visual/chain_trail(next_turf)

    if(flight_fx)
        flight_fx.forceMove(next_turf)
        flight_fx.dir = get_dir(current_turf, next_turf)

    if(!hooked_target)
        for(var/mob/living/L in next_turf)
            if(L != howner && !QDELETED(L))
                hooked_target = L
                on_hook_target()
                return

    if(next_turf == owner_turf)
        cleanup_cast()
        return

    addtimer(CALLBACK(src, PROC_REF(continue_return)), flight_delay)

/datum/special_intent/witcher_chain_hook/proc/cleanup_cast()
    restore_weapon()
    if(flight_fx)
        qdel(flight_fx)
        flight_fx = null

    hooked_target = null
    active_cast = FALSE
    original_slot = null
    throw_target = null
