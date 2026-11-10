#define IMPLEMENT_REFUND_AMETHYST 0.45
#define IMPLEMENT_REFUND_TOPER 0.48
#define IMPLEMENT_REFUND_GEMERALD 0.53
#define IMPLEMENT_REFUND_SAFFIRA 0.56
#define IMPLEMENT_REFUND_BLORTZ 0.59
#define IMPLEMENT_REFUND_RONTZ 0.62
#define IMPLEMENT_REFUND_DORPEL 0.65
#define IMPLEMENT_REFUND_RIDDLE 0.70

#define IMPLEMENT_CAST_SPEED_AMETHYST 0.05
#define IMPLEMENT_CAST_SPEED_TOPER 0.08
#define IMPLEMENT_CAST_SPEED_GEMERALD 0.13
#define IMPLEMENT_CAST_SPEED_SAFFIRA 0.16
#define IMPLEMENT_CAST_SPEED_BLORTZ 0.19
#define IMPLEMENT_CAST_SPEED_RONTZ 0.22
#define IMPLEMENT_CAST_SPEED_DORPEL 0.25
#define IMPLEMENT_CAST_SPEED_RIDDLE 0.30

// implement_cast_speed никогда не должен превышать 0.35, это значение здесь лишь для подстраховки
#define IMPLEMENT_CAST_SPEED_MAX 0.95

/obj/item/rogueweapon
	// Время на каст умножается на (1 - implement_cast_speed).
	var/implement_cast_speed = 0

/mob/living/carbon/human/proc/get_held_cast_speed_implement()
	var/obj/item/rogueweapon/best
	for(var/obj/item/rogueweapon/held in held_items)
		if(held.implement_cast_speed > best?.implement_cast_speed)
			best = held
	return best

// Донатерские морфы сохранют силу гема
// TODO: убедиться, что они будут работать с новой системой рескинов/гемов
/obj/item/rogueweapon/transfer_implement_state(obj/item/rogueweapon/morphed, mob/user)
	if(!implement_refund && !implement_cast_speed)
		return
	morphed.implement_refund = implement_refund
	morphed.implement_cast_speed = implement_cast_speed
	morphed.implement_tier = implement_tier

// Возвращает модификатор времени каста заклинаний.
/datum/action/cooldown/spell/proc/get_implement_charge_mult()
	if(!ishuman(owner))
		return 1

	var/mob/living/carbon/human/H = owner

	var/obj/item/rogueweapon/implement = H.get_held_cast_speed_implement()
	if(!implement)
		return 1

	return 1 - clamp(implement.implement_cast_speed, 0, IMPLEMENT_CAST_SPEED_MAX)

// Этот оверрайд нужен исключительно для косметического свечения и переименования томов ("Amythorz tome of Flame").
/datum/action/cooldown/spell/get_held_implement(mob/user)
	. = ..()
	if(. || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	return H.get_held_cast_speed_implement()
