/datum/erp_action_context
	var/mob/living/actor_mob
	var/mob/living/partner_mob

	var/turf/tA
	var/turf/tB

	var/distance = 999
	var/same_tile = FALSE

	var/grabstate = 0
	var/has_passive_grab = FALSE
	var/has_aggressive_grab = FALSE

	var/list/self_access
	var/list/other_access

	var/has_container = FALSE

/datum/erp_controller_actions/proc/build_action_context()
	var/datum/erp_action_context/ctx = new

	if(!controller.active_partner)
		return ctx

	ctx.actor_mob = controller.owner?.get_mob()
	ctx.partner_mob = controller.active_partner?.get_mob()

	ctx.tA = ctx.actor_mob ? get_turf(ctx.actor_mob) : controller.owner.get_actor_turf()
	ctx.tB = ctx.partner_mob ? get_turf(ctx.partner_mob) : controller.active_partner.get_actor_turf()

	if(ctx.tA && ctx.tB)
		ctx.distance = get_dist(ctx.tA, ctx.tB)
		ctx.same_tile = (ctx.tA == ctx.tB)

	ctx.grabstate = controller.owner.get_highest_grab_state_on(controller.active_partner)
	ctx.has_passive_grab = (ctx.grabstate >= GRAB_PASSIVE)
	ctx.has_aggressive_grab = (ctx.grabstate >= GRAB_AGGRESSIVE)

	ctx.self_access = list()
	ctx.other_access = list()

	ctx.has_container = controller._has_nearby_container_for_action()

	return ctx
