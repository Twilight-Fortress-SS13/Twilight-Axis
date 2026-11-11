/obj/structure/roguemachine/mail/any_additional_mail(
	obj/item/roguemachine/mastermail/M,
	mob/living/carbon/human/H
)
	if(taHasEstateMail(H))
		return TRUE
	return ..()

/obj/structure/roguemachine/mail/proc/taHasEstateMail(
	mob/living/carbon/human/recipient
)
	return !!length(recipient.mind?.manor_packages)

/obj/structure/roguemachine/mail/proc/taDeliverEstateMail(
	mob/living/carbon/human/recipient
)
	if(!taHasEstateMail(recipient))
		return null
	var/obj/item/delivery = recipient.mind.manor_packages[1]
	recipient.mind.manor_packages.Cut(1, 2)
	recipient.put_in_hands(delivery)
	return delivery

/obj/structure/roguemachine/mail/proc/taUpdateEstateMailAlert(
	mob/living/carbon/human/recipient,
	obj/item/estate_mail,
	received_regular
)
	var/obj/item/roguemachine/mastermail/master = SSroguemachine.hermailermaster
	if(any_additional_mail(master, recipient))
		return
	if(
		master \
		&& !estate_mail \
		&& !received_regular \
		&& recipient.has_status_effect(/datum/status_effect/ugotmail)
	)
		to_chat(
			recipient,
			span_notice( \
				"I look inside the machine and find no letter, how strange." \
			)
		)
	recipient.remove_status_effect(/datum/status_effect/ugotmail)
