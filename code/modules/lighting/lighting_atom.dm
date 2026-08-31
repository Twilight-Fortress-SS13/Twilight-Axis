// The proc you should always use to set the light of this atom.
/atom/proc/set_light(l_range, l_power, l_color = NONSENSICAL_VALUE, l_angle, l_dir, l_height, l_on)
	// We null everything but l_dir, because we don't want to allow for modifications while frozen
	if(light_flags & LIGHT_FROZEN)
		l_range = null
		l_power = null
		l_color = null
		l_on = null
		l_angle = null
		l_height = null

	if(l_range > 0 && l_range < MINIMUM_USEFUL_LIGHT_RANGE)
		l_range = MINIMUM_USEFUL_LIGHT_RANGE //Brings the range up to 1.4, which is just barely brighter than the soft lighting that surrounds players.

	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT, l_range, l_power, l_color, l_on) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return

	if(!isnull(l_power))
		set_light_power(l_power)

	if(!isnull(l_range))
		set_light_range(l_range)

	if(l_color != NONSENSICAL_VALUE)
		set_light_color(l_color)

	if(!isnull(l_angle))
		set_light_angle(l_angle)

	if(!isnull(l_dir))
		set_light_dir(l_dir)

	if(!isnull(l_on))
		set_light_on(l_on)

	if(!isnull(l_height))
		set_light_height(l_height)

	update_light()

/// Will update the light (duh).
/// Creates or destroys it if needed, makes it update values, makes sure it's got the correct source turf...
/atom/proc/update_light()
	SHOULD_NOT_SLEEP(TRUE)

	if(light_system != COMPLEX_LIGHT)
		CRASH("update_light() for [src] with following light_system value: [light_system]")

	if (!light_power || !light_range || !light_on) // We won't emit light anyways, destroy the light source.
		QDEL_NULL(light)
	else
		if (!ismovable(loc)) // We choose what atom should be the top atom of the light here.
			. = src
		else
			. = loc

		if (light) // Update the light or create it if it does not exist.
			light.update(.)
		else
			light = new/datum/light_source(src, .)
		return .

// Should always be used to change the opacity of an atom.
// It notifies (potentially) affected light sources so they can update (if needed).
/atom/proc/set_opacity(new_opacity)
	if (new_opacity == opacity || light_flags & LIGHT_FROZEN)
		return

	opacity = new_opacity
	var/turf/T = isturf(src) ? src : loc
	if (!isturf(T))
		return

	if (new_opacity)
		T.opaque_atom_count++
	else
		T.opaque_atom_count--
	T.reconsider_lights()

// If we have opacity, make sure to tell (potentially) affected light sources.
/atom/movable/Destroy()
	var/turf/T = loc
	. = ..()
	if (opacity && istype(T))
		T.opaque_atom_count--
		T.reconsider_lights()

// No /atom/movable/Moved override here, that's handled by a signal now.

/atom/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("light_range")
			set_light(l_range=var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

		if ("light_power")
			set_light(l_power=var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

		if ("light_color")
			set_light(l_color=var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

	return ..()

/// Setter for the light power of this atom.
/atom/proc/set_light_power(new_power)
	if(new_power == light_power || light_flags & LIGHT_FROZEN)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_POWER, new_power) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_power
	light_power = new_power
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_POWER, .)
	return .

/// Setter for the light range of this atom.
/atom/proc/set_light_range(new_range)
	if(new_range == light_range || light_flags & LIGHT_FROZEN)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_RANGE, new_range) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_range
	light_range = new_range
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_RANGE, .)
	return .

/// Setter for the light color of this atom.
/atom/proc/set_light_color(new_color)
	if(new_color == light_color || light_flags & LIGHT_FROZEN)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_COLOR, new_color) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_color
	light_color = new_color
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_COLOR, .)
	return .

/// Setter for whether or not this atom's light is on.
/atom/proc/set_light_on(new_value)
	if(new_value == light_on || light_flags & LIGHT_FROZEN)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_ON, new_value) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_on
	light_on = new_value
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_ON, .)
	return .

/// Setter for the light flags of this atom.
/atom/proc/set_light_flags(new_value)
	if(new_value == light_flags || (light_flags & LIGHT_FROZEN && new_value & LIGHT_FROZEN))
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_FLAGS, new_value) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_flags
	light_flags = new_value
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_FLAGS, .)
	return .

// procs that only apply to OVERLAY_LIGHT

/// Setter for an optional render_source to apply to this atom's light overlay
/atom/proc/set_light_render_source(new_source)
	if(new_source == light_render_source || light_flags & LIGHT_FROZEN)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_RENDER_SOURCE, new_source) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_render_source
	light_render_source = new_source
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_RENDER_SOURCE, .)
	return .

// procs that only apply to COMPLEX_LIGHT

/// Setter for the light angle of this atom
/atom/proc/set_light_angle(new_value)
	if(new_value == light_angle || light_flags & LIGHT_FROZEN)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_ANGLE, new_value) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_angle
	light_angle = new_value
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_ANGLE, .)
	return .

/// Setter for the light direction of this atom
/atom/proc/set_light_dir(new_value)
	// No frozen check here because we allow direction changes in a freeze
	if(new_value == light_dir)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_DIR, new_value) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_dir
	light_dir = new_value
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_DIR, .)
	return .

/// Setter for the height of our light
/atom/proc/set_light_height(new_value)
	if(new_value == light_height || light_flags & LIGHT_FROZEN)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_HEIGHT, new_value) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_height
	light_height = new_value
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_HEIGHT, .)
	return .


/atom/proc/get_light_offset()
	return list(0, 0)

/// Returns a list of x and y offsets to apply to our visual lighting position
/proc/calculate_light_offset(atom/get_offset)
	var/list/hand_back
	if(!(get_offset.light_flags & LIGHT_IGNORE_OFFSET))
		hand_back = get_visual_offset(get_offset)
		hand_back[1] = -hand_back[1] / ICON_SIZE_X
		hand_back[2] = -hand_back[2] / ICON_SIZE_Y
	else
		hand_back = list(0, 0)

	var/list/atoms_opinion = get_offset.get_light_offset()
	hand_back[1] += atoms_opinion[1]
	hand_back[2] += atoms_opinion[2]
	return hand_back

/atom/proc/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	return

/turf/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	if(!_duration)
		stack_trace("Lighting FX obj created on a turf without a duration")
	new /obj/effect/dummy/lighting_obj (src, _color, _range, _power, _duration)

/obj/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	var/temp_color
	var/temp_power
	var/temp_range
	if(!_reset_lighting) //incase the obj already has a lighting color that you don't want cleared out after, ie computer monitors.
		temp_color = light_color
		temp_power = light_power
		temp_range = light_range
	set_light(_range, _power, _color)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, set_light), _reset_lighting ? initial(light_range) : temp_range, _reset_lighting ? initial(light_power) : temp_power, _reset_lighting ? initial(light_color) : temp_color), _duration, TIMER_OVERRIDE|TIMER_UNIQUE)

/mob/living/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	mob_light(_color, _range, _power, _duration)

/mob/living/proc/mob_light(_color, _range, _power, _duration)
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj = new (src, _color, _range, _power, _duration)
	return mob_light_obj
