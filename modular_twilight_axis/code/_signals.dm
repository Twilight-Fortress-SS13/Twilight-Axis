//COMBO-CORE - BEGIN//
/// External entrypoint: push an input.
/// Args: (skill_id, mob/living/target, zone, extra)
#define COMSIG_COMBO_CORE_REGISTER_INPUT "combo_core_register_input"

/// External entrypoint: clear history.
/// Args: none
#define COMSIG_COMBO_CORE_CLEAR "combo_core_clear"

/// Consume prepared attack on swing attempt
/// Args: (mob/living/target_or_null, zone)
#define COMSIG_ATTACK_TRY_CONSUME "try_consume_attack"
#define COMPONENT_ATTACK_CONSUMED (1<<0)
//COMBO-CORE - END //

//SOUNDBREAKER - BEGIN//
/// Successful defense hook (Riff stance)
/// Args: none
#define COMSIG_SOUNDBREAKER_RIFF_DEFENSE_SUCCESS "soundbreaker_riff_defense_success"

/// Projectile note hit
/// Args: (mob/living/target, damage_mult, damage_type, zone)
#define COMSIG_SOUNDBREAKER_NOTE_PROJECTILE_HIT "soundbreaker_note_projectile_hit"

/// Combo cleared event (status effect removed etc)
/// Args: none
/// already have COMSIG_SOUNDBREAKER_COMBO_CLEARED in your defines.dm; re-use if present
#define COMSIG_SOUNDBREAKER_COMBO_CLEARED "soundbreaker_combo_cleared"

/// Prime prepared note
/// Args: (note_id, damage_mult, damage_type, note_name)
#define COMSIG_SOUNDBREAKER_PRIME_NOTE "soundbreaker_prime_note"
#define COMPONENT_SOUNDBREAKER_PRIMED (1<<0)
//SOUNDBREAKER - BEGIN//
