/// Глобальный реестр квот PQ для профессий. Формат: "Имя Роли" = list(Тип_предмета, Награда_PQ, Квота)
GLOBAL_LIST_INIT(pq_sell_quotas, list(
	"Miner" = list(/obj/item/rogueore, PQ_GAIN_STOCKPILE_SELL, PQ_SELL_QUOTA),
	"Woodworker" = list(/obj/item/grown/log/tree/small, PQ_GAIN_STOCKPILE_SELL, PQ_SELL_QUOTA * 3),
	"Soilson" = list(/obj/item/reagent_containers/food/snacks, PQ_GAIN_STOCKPILE_SELL, PQ_SELL_QUOTA * 2),
	"Farmer" = list(/obj/item/reagent_containers/food/snacks, PQ_GAIN_STOCKPILE_SELL, PQ_SELL_QUOTA * 2),
	"Fisher" = list(/obj/item/reagent_containers/food/snacks, PQ_GAIN_STOCKPILE_SELL, PQ_SELL_QUOTA),
	"Bow-Hunter" = list(/obj/item/reagent_containers/food/snacks, PQ_GAIN_STOCKPILE_SELL, PQ_SELL_QUOTA),
	"Spear-Hunter" = list(/obj/item/reagent_containers/food/snacks, PQ_GAIN_STOCKPILE_SELL, PQ_SELL_QUOTA)
))

/// Вспомогательный класс для отслеживания прогресса PQ для каждого игрока
/datum/pq_user_progress
	var/accumulated_items = 0
	var/pending_pq = 0
	var/log_name
	var/log_name_admin
	var/quota_size = 0
	var/pending_quotas = 0
	var/current_role

/// Компонент, который выдает PQ за сдачу предметов в стокпайл партиями (квотами)
/datum/component/pq_seller
	var/list/user_progress // ckey -> /datum/pq_user_progress
	var/flush_timer_id

/datum/component/pq_seller/Initialize()
	user_progress = list()
	RegisterSignal(parent, COMSIG_MOB_SOLD_TO_STOCKPILE, PROC_REF(on_sold))

/datum/component/pq_seller/Destroy()
	if(flush_timer_id)
		deltimer(flush_timer_id)
		flush_timer_id = null
	flush_pq() // Спасаем очки ТОЛЬКО ПОСЛЕ удаления таймера, иначе deltimer не сработает
	for(var/ckey in user_progress)
		qdel(user_progress[ckey])
	user_progress.Cut()
	return ..()

/datum/component/pq_seller/proc/on_sold(mob/living/user, obj/item/sold_item)
	SIGNAL_HANDLER
	
	if(!user || !user.client || !user.mind || !sold_item)
		return

	// Динамически получаем текущую роль или подкласс игрока именно в момент продажи
	var/adv_name
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		adv_name = H.advjob
	if(!adv_name && user.mind.picked_advclass)
		var/datum/advclass/AC = user.mind.picked_advclass
		adv_name = AC.name
	if(!adv_name)
		adv_name = user.mind.assigned_role

	var/list/quota = GLOB.pq_sell_quotas[adv_name]
	if(!quota)
		return // Для текущей роли нет квоты, игнорируем
		
	var/accepted_types = quota[1]
	var/pq_reward = quota[2]
	var/items_quota = quota[3]
	
	if(!islist(accepted_types))
		accepted_types = list(accepted_types)

	var/amount_sold = 0

	// Если это бандл (связка), проверяем его содержимое через stacktype
	if(istype(sold_item, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = sold_item
		for(var/type in accepted_types)
			if(ispath(B.stacktype, type)) // ispath потому что stacktype это путь
				amount_sold = B.amount
				break
	else
		// Иначе проверяем сам предмет напрямую
		for(var/type in accepted_types)
			if(istype(sold_item, type))
				amount_sold = 1
				break

	if(amount_sold > 0 && items_quota > 0)
		var/ckey = user.ckey
		var/datum/pq_user_progress/progress = user_progress[ckey]
		if(!progress)
			progress = new()
			user_progress[ckey] = progress

		// Защита от абуза смены роли: сбрасываем прогресс, если игрок сменил профессию
		if(progress.current_role != adv_name)
			progress.accumulated_items = 0
			progress.current_role = adv_name

		progress.accumulated_items += amount_sold
		
		// Проверяем, выполнена ли норма
		if(progress.accumulated_items >= items_quota)
			var/quotas_met = floor(progress.accumulated_items / items_quota)
			progress.accumulated_items -= (quotas_met * items_quota) // Оставляем остаток на следующую норму
			progress.pending_pq += (quotas_met * pq_reward)
			progress.pending_quotas += quotas_met

			// Сохраняем данные для лога
			progress.log_name = key_name(user)
			progress.log_name_admin = key_name_admin(user)
			progress.quota_size = items_quota
			
			to_chat(user, span_notice("<b>Астрата</b> рада соблюдению удела. Ты явно заслуживаешь награды."))
			
			if(!flush_timer_id)
				flush_timer_id = addtimer(CALLBACK(src, PROC_REF(flush_pq)), 2 SECONDS, TIMER_STOPPABLE)

/datum/component/pq_seller/proc/flush_pq()
	flush_timer_id = null
	if(!user_progress || !user_progress.len)
		return

	for(var/ckey in user_progress)
		var/datum/pq_user_progress/progress = user_progress[ckey]
		if(!progress || progress.pending_pq <= 0)
			continue

		var/to_give = round(progress.pending_pq, 0.001)
		if(to_give > 0)
			log_admin("PQ_SELLER: [progress.log_name] выполнил квоту ([progress.quota_size] шт.) [progress.pending_quotas] раз(а) и получил за это [to_give] PQ.")
			message_admins("PQ_SELLER: [progress.log_name_admin] выполнил квоту ([progress.quota_size] шт.) [progress.pending_quotas] раз(а) и получил за это [to_give] PQ.") 
			adjust_playerquality(to_give, ckey)

		progress.pending_pq = 0 // Сбрасываем выданные очки, но сохраняем накопленный остаток
		progress.pending_quotas = 0
